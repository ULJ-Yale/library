#!/usr/bin/env python3
# encoding: utf-8

"""
Extracts docstrings from files in unsupported languages (Bash and R) to files
named ``<language>.py`` in subdirectories of the $QUNEXPATH/python/ folder, so
Sphinx autodoc can render them. Command identifiers come from the registry
(qx_commands.yaml) via registry_docs.
"""

import re
import sys
import os

sys.path.append("../..")  # for $QUNEXPATH/docs/conf.py import

from conf import napoleon_custom_sections
from registry_docs import UNSUPPORTED_LANGUAGES, load_doc_commands


def docstring_to_parameters(docstring, headings):
    """
    Extracts parameters to be included in Python function definition.
    """

    headings_string = "|".join(headings)

    sections = {}

    parameters = []

    sections["parameters"] = re.findall(
        r"(?i)(Parameters:[\s\S]*?(?:\n\n(?:" + headings_string + r"):|\Z))", docstring
    )

    for heading, section in sections.items():
        if sections[heading]:
            # parameters_section is list
            sections[heading] = sections[heading][0]
            if isinstance(sections[heading], tuple):
                sections[heading] = sections[heading][0]

    for heading, section in sections.items():
        if section:
            for result in re.findall(r"\n {4}--(\w+).*?(default .*)?\):", section):
                parameter = result[0]
                if result[1] not in ["", "default detailed below"]:
                    stripped = re.sub("^default ", "", result[1])
                    if stripped.lower() == "true":
                        stripped = "True"
                    elif stripped.lower() == "false":
                        stripped = "False"
                    parameter += f"={stripped}"
                    parameters.append((parameter, True))
                else:
                    parameters.append((parameter, False))

    # sort parameters - False first
    parameters.sort(key=lambda x: x[1])

    return [parameter for parameter, has_default_value in parameters]


def generate_heading_list():
    """
    Generate a list of all headings allowed by Sphinx Napoleon extension (as currently configured).
    """
    headings = [
        "args",
        "arguments",
        "attention",
        "attributes",
        "caution",
        "danger",
        "error",
        "example",
        "examples",
        "hint",
        "important",
        "keyword args",
        "keyword arguments",
        "methods",
        "note",
        "notes",
        "other parameters",
        "parameters",
        "return",
        "returns",
        "raise",
        "raises",
        "references",
        "see also",
        "tip",
        "todo",
        "warning",
        "warnings",
        "warn",
        "warns",
        "yield",
        "yields",
    ]
    # add custom headings from conf.py
    for heading in napoleon_custom_sections:
        if type(heading) is tuple:
            headings.append(heading[0])
        elif type(heading) is str:
            headings.append(heading)
    return headings


def extract_docstrings(commands):
    """
    Build synthetic Python stubs from the docstrings of bash/r commands.

    Returns a nested dict: {language: {module_dir: [stub_string, ...]}}.
    """
    all_headings = generate_heading_list()

    output_dict = {}
    for cmd in commands:
        lang = cmd.language
        function_name = cmd.function_name

        with open(cmd.source_path, "r") as file:
            if lang == "bash":
                docstring = re.findall(
                    r"usage\(\) \{\n *cat << EOF\n([\s\S]*?)\nEOF", file.read()
                )[0]
            elif lang == "r":
                docstring = re.findall(
                    r"\n# {3}``" + function_name + r"``\n(?:#.*\n)+", file.read()
                )[0]
                docstring = re.sub(r"(\n# {3}|\n#)", "\n", docstring)

        # add function name, parameters, indentation and comment docstring
        parameters = docstring_to_parameters(docstring, all_headings)
        docstring = "    " + "\n    ".join(docstring.split("\n"))
        # the stub docstring is raw, so RST escapes in the bash/R source (\*, \_)
        # stay literal instead of becoming invalid python escape sequences, which
        # python reports as a SyntaxWarning when it compiles the generated file
        docstring = f'def {function_name}({", ".join(parameters)}):\n    r"""\n{docstring}    """\n\n\n'

        output_dict.setdefault(lang, {}).setdefault(cmd.module_dir, []).append(docstring)
    return output_dict


def write_python_files(docstring_dict):
    for lang, inner_dict in docstring_dict.items():
        for module_path, functions in inner_dict.items():
            if len(functions) > 0:
                module_path = os.path.join(
                    "..", "..", "..", "..", "..", "python", module_path
                )
                os.makedirs(module_path, exist_ok=True)
                # create empty file __init__.py if it doesn't exist to mark
                # the directory as a module
                if not os.path.isfile(os.path.join(module_path, "__init__.py")):
                    with open(os.path.join(module_path, "__init__.py"), "w"):
                        pass
                output_file_path = os.path.join(module_path, lang + ".py")
                with open(output_file_path, "w") as output_file:
                    # hardcoded module description
                    output_file.write(
                        "#!/usr/bin/env python\n"
                        "# encoding: utf-8\n\n"
                        '"""\n'
                        "This file consists of docstrings extracted from functions in"
                        + lang
                        + ".\n"
                        '"""\n\n\n'
                    )
                    output_file.write("".join(functions).strip())


if __name__ == "__main__":
    print(
        "---> Generating Python-like docstrings from unsupported (bash and R) commands"
    )
    unsupported_commands = [
        cmd for cmd in load_doc_commands() if cmd.language in UNSUPPORTED_LANGUAGES
    ]

    docstrings = extract_docstrings(unsupported_commands)

    write_python_files(docstrings)
