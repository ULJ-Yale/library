#!/usr/bin/env python3
# encoding: utf-8

"""
Single source of truth for turning ``qx_commands.yaml`` entries into the
identifiers the documentation build needs.

Both ``generate_gmri_rsts.py`` and ``extract_unsupported_docstrings.py`` used to
depend on the dotted names in the (now removed) ``all_commands.py``. Those
dotted names baked the language into the identifier, e.g.
``qx_utilities.bash.dwi_bedpostx_gpu``, and encoded both the autodoc target and
where the extracted stub lived. The registry instead stores a filesystem-style
``path`` (``qx_utilities/dwi_bedpostx_gpu.sh``) plus a separate ``language``.

This module reconstructs the old contract from the new fields so nothing
downstream changes. Keeping the derivation here (not duplicated in two scripts)
means the two scripts cannot silently drift on the naming convention -- a drift
would produce broken autodoc links rather than an error.

Naming contract:

  language  source file        stub written to          autodoc target (dotted)
  python    real module        -- (real code)           path as-is (already dotted)
  matlab    matlab/<path>      -- (matlab domain)       path minus '.m', '/'->'.'
  bash      bash/<path>        python/<dir>/bash.py     <dir dotted>.bash.<stem>
  r         r/<path>           python/<dir>/r.py        <dir dotted>.r.<stem>
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator, List, Optional

import yaml

# Languages whose docstrings are extracted into synthetic Python stubs.
UNSUPPORTED_LANGUAGES = ("bash", "r")

# Core registry lives at the repository root, five levels above this file
# (_extras/python -> _extras -> docs -> etc -> qx_library -> repo root).
DEFAULT_REGISTRY_PATH = Path(__file__).resolve().parents[5] / "qx_commands.yaml"

# Path from the build cwd (docs/_extras/{bash,python}) to the repo root, used to
# build cwd-relative source paths matching the rest of the docs scripts.
REPO_ROOT_FROM_CWD = os.path.join("..", "..", "..", "..", "..")


@dataclass(frozen=True)
class DocCommand:
    name: str
    language: str
    description: Optional[str]
    function_name: str            # stem used for the .rst file name
    autodoc_target: str           # dotted target for (mat:)autofunction
    source_path: Optional[str]    # cwd-relative path to real source; bash/r only
    module_dir: Optional[str]     # '/'-separated dir for the stub; bash/r only


def _derive(name: str, path: str, language: str, description: Optional[str]) -> DocCommand:
    language = language.lower()

    if language == "python":
        return DocCommand(
            name=name,
            language=language,
            description=description,
            function_name=path.rsplit(".", 1)[-1],
            autodoc_target=path,
            source_path=None,
            module_dir=None,
        )

    if language == "matlab":
        stem = os.path.splitext(os.path.basename(path))[0]
        target = os.path.splitext(path)[0].replace("/", ".")
        return DocCommand(
            name=name,
            language=language,
            description=description,
            function_name=stem,
            autodoc_target=target,
            source_path=None,
            module_dir=None,
        )

    if language in UNSUPPORTED_LANGUAGES:
        module_dir = os.path.dirname(path)
        stem = os.path.splitext(os.path.basename(path))[0]
        target_prefix = module_dir.replace("/", ".")
        target = f"{target_prefix + '.' if target_prefix else ''}{language}.{stem}"
        return DocCommand(
            name=name,
            language=language,
            description=description,
            function_name=stem,
            autodoc_target=target,
            source_path=os.path.join(REPO_ROOT_FROM_CWD, language, path),
            module_dir=module_dir,
        )

    raise ValueError(f"Language '{language}' is not supported (command '{name}').")


def load_doc_commands(registry_path: Path = DEFAULT_REGISTRY_PATH) -> List[DocCommand]:
    """Load the core registry and return normalized documentation records."""
    data = yaml.safe_load(Path(registry_path).read_text(encoding="utf-8"))
    return [
        _derive(c["name"], c["path"], c.get("language", "python"), c.get("description"))
        for c in data.get("commands", [])
    ]


def iter_doc_commands(registry_path: Path = DEFAULT_REGISTRY_PATH) -> Iterator[DocCommand]:
    yield from load_doc_commands(registry_path)


if __name__ == "__main__":
    # Self-check: every derived target/source is well formed and, for bash/r,
    # points at a source file that exists on disk (resolved from repo root, so
    # the check is independent of cwd).
    cmds = load_doc_commands()
    assert cmds, "registry produced no commands"

    repo_root = DEFAULT_REGISTRY_PATH.parent
    missing = []
    for c in cmds:
        assert c.autodoc_target and " " not in c.autodoc_target, c
        assert c.function_name and "/" not in c.function_name, c
        if c.language in UNSUPPORTED_LANGUAGES:
            assert c.source_path and c.module_dir is not None, c
            # source_path is cwd-relative; re-anchor on repo_root to verify.
            rel = c.source_path.split(REPO_ROOT_FROM_CWD + os.sep, 1)[-1]
            if not (repo_root / rel).is_file():
                missing.append((c.name, c.source_path))
        else:
            assert c.source_path is None and c.module_dir is None, c

    assert not missing, f"source files not found: {missing}"
    by_lang: dict[str, int] = {}
    for c in cmds:
        by_lang[c.language] = by_lang.get(c.language, 0) + 1
    print(f"OK: {len(cmds)} commands {by_lang}")
