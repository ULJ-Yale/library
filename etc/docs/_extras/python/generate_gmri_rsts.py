#!/usr/bin/env python3
# encoding: utf-8

"""
Automatically generates .rst files in docs/api/gmri directory, one per command.
Command identifiers come from the registry (qx_commands.yaml) via registry_docs.
"""
import os

from registry_docs import load_doc_commands

if __name__ == "__main__":
    print("---> Generating .rst files for individual commands")

    directory_path = os.path.join("..", "..", "api", "gmri")

    for cmd in load_doc_commands():
        heading = cmd.function_name
        file_content = f'{heading}\n{"=" * len(heading)}\n\n'
        directive = "mat:autofunction" if cmd.language == "matlab" else "autofunction"
        file_content += f".. {directive}:: {cmd.autodoc_target}\n"

        with open(os.path.join(directory_path, f"{cmd.function_name}.rst"), "w") as output_file:
            output_file.write(file_content)
