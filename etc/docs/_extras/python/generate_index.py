#!/usr/bin/env python3
# encoding: utf-8

import os
import re
import subprocess
from shutil import copyfile

"""
generate_index.py is the script that performs all the necessary adjustments to
the homepage file of the QuNex Wiki (Home.md) in order to prepare the
index file for the public GitHub QuNex documentation website.

* Search for HARDCODED to find what is hardcoded and should be inspected and
  modified every time there is a major change in the format of the Wiki.
"""

# Hardcoded values
top_line_padding = 4


def get_image_block(lines):
    """
    Return a list of two lines in the Sphinx RST format, converted from the list
    of strings (lines). The last line having a markdown image format is
    converted and returned, while previous lines are overwritten.

    HARDCODED -> it works fine as long as the homepage contains a single image.
    """
    for i in range(len(lines)):
        if lines[i][0] == "!":
            img_path = re.search("\(([^)]+)\)", lines[i]).group(0)
            img_path = img_path[1:-1]
            img_line_1 = ".. image:: " + prefix_wiki(img_path)
            img_line_2 = "   :align: center\n"
            return [img_line_1, img_line_2]


def prefix_wiki(path_string):
    """
    Prefixes the input string with "wiki/".
    """
    return "wiki/" + path_string


def append_html(path_string):
    """
    Appends ".html" to the input string.
    """
    return path_string + ".html"


def restructure_home_menu(file_lines):
    """
    Restructures a list of lines from the home page. Specifically, it prepends
    wiki/ to all the internal paths.
    """

    for i in range(len(file_lines)):
        matched_path = re.search(r"(?<=<)[^hb].+?(?=>)", file_lines[i])
        if matched_path:
            new_path = prefix_wiki(matched_path.group(0))
            new_path = append_html(new_path)
            file_lines[i] = re.sub("(?<=<)[^hb].+?(?=>)", new_path, file_lines[i])

            if (i + 1) < len(file_lines) and re.findall("^-+\n", file_lines[i + 1]):
                # add the missing dashes because "wiki/" and ".html" have been added
                file_lines[i + 1] = f'{"-" * 20}{file_lines[i+1]}'

    return file_lines


def export_file(file_name, file_lines, new_line=False):
    """
    Exports a file from the file_lines parameter.

    Parameters:
        file_name:
           File name (include the extension).

        file_lines:
            A list of strings, each corresponding to a line.

        new_line:
            A boolean indicating whether to insert a newline character after
            every line.
    """
    line_separator = "%s"

    if new_line:
        line_separator += " \n"

    with open(file_name, "w") as filehandle:
        for current_line in file_lines:
            filehandle.write(line_separator % current_line)


def get_captions_line_indices(lines, captions):
    """
    Returns a dictionary with indices of the lines that match each element in
    the input argument (list) captions.

    Parameters:
        lines:
            A list of strings corresponding to file lines in which to search for
            the patterns passed with captions.

        captions:
            A list of strings, patterns to search for in the lines list.
    """
    caption_indices = {}
    for i in range(len(captions)):
        for j in range(len(lines)):
            m = re.search("^## \[*" + captions[i], lines[j])
            if m:
                caption_indices[captions[i]] = j
    return caption_indices


def get_toc_tree_structure(caption):
    """
    Returns a list of strings corresponding to lines of the toctree header for
    the desired toctree caption.
    """
    return [
        "\n.. toctree::",
        "   :maxdepth: 2",
        "   :caption: " + caption,
        "   :hidden:\n",
    ]


def get_toc_tree_content(lines):
    """
    Returns a list of string corresponding to lines of the toctree content. The
    passed list of strings (in Markdown) is converted to the required format for the toctree entries.

    Examples:
        ::

            lines = [
            "* [Installing from source and dependencies](Overview/Installation.md)",
            "\n",
            "* [QuNex container deployment](Overview/QuNexContainerUsage.md)",
            "\n",
            "* [QuNex commands and general usage overview](Overview/GeneralUse.md)"]

        is converted to::

            toc_tree_lines = [
            "Installing from source and dependencies <wiki/Overview/Installation.md>",
            "QuNex container deployment <wiki/Overview/QuNexContainerUsage.md>",
            "QuNex commands and general usage overview <wiki/Overview/GeneralUse.md>"]
    """
    toc_tree_lines = []
    for i in range(len(lines)):
        if lines[i][0] in ["*", "-"]:
            toc_caption = re.search(r"(?<=\[).+(?=\]\()", lines[i])
            toc_path = re.search(r"(?<=\]\()[A-Za-z].+(?=\))", lines[i])
            if toc_caption and toc_path:
                toc_tree_lines.append(
                    "   "
                    + toc_caption.group(0)
                    + " <"
                    + prefix_wiki(toc_path.group(0))
                    + ">"
                )
    return toc_tree_lines


if __name__ == "__main__":
    print("---> Converting Home.md to index.rst and HomeMenu.rst")

    # -- read Home.md file (Wiki homepage)
    with open("../../wiki/Home.md") as f:
        home_lines = f.readlines()

    # -- export HomeMenu.md file -> Home.md without first top_line_padding lines
    export_file("../../HomeMenu.md", home_lines[top_line_padding:])

    subprocess.run(
        "pandoc -f markdown -t rst ../../HomeMenu.md -o ../../HomeMenu.rst".split()
    )

    subprocess.run("rm ../../HomeMenu.md".split())

    # -- read HomeMenu.rst file (Wiki homepage converted to .rst)
    with open("../../HomeMenu.rst") as f:
        menu_lines = f.readlines()

    restructure_home_menu(menu_lines)

    # -- export HomeMenu.rst with fixed paths and file extensions
    export_file("../../HomeMenu.rst", menu_lines)

    # Description for Opengraph extension
    index_lines = [
        ":og:description: The Quantitative Neuroimaging Environment & Toolbox (QuNex) integrates several packages that support a flexible and extensible framework for data organization, preprocessing, quality assurance, and various analyses across neuroimaging modalities.",
        "",
    ]

    index_lines.extend(get_image_block(home_lines))
    index_lines.append("--------------")

    # HARDCODED -> below are the headings to be included in the toctree (side menu)
    list_of_headers = ["General overview", "User guides", "QuNex deployment in XNAT"]

    cap_ind = get_captions_line_indices(home_lines, list_of_headers)

    index_lines.extend(
        "\n.. toctree::\n   :maxdepth: 2\n   :hidden:\n\n   QuNex quick start <wiki/Overview/QuickStart.md>".split(
            "\n"
        )
    )

    index_lines.extend(get_toc_tree_structure("General overview"))
    index_lines.append("   Overview <wiki/Overview/Overview.md>")
    index_lines.extend(
        get_toc_tree_content(
            home_lines[cap_ind["General overview"] : cap_ind["User guides"]]
        )
    )

    index_lines.extend(get_toc_tree_structure("User guides"))
    index_lines.append("   Overview <wiki/UsageDocs/Overview.md>")
    index_lines.extend(
        get_toc_tree_content(
            home_lines[cap_ind["User guides"] : cap_ind["QuNex deployment in XNAT"]]
        )
    )

    index_lines.extend(get_toc_tree_structure("QuNex deployment in XNAT"))
    index_lines.extend(
        get_toc_tree_content(
            home_lines[cap_ind["QuNex deployment in XNAT"] : len(home_lines)]
        )
    )

    index_lines.append("\n.. toctree::")
    index_lines.append("   :maxdepth: 3")
    index_lines.append("   :caption: Specific command documentation")
    index_lines.append("   :hidden:\n")
    index_lines.append("   api/gmri")

    index_lines.append("\n.. include:: HomeMenu.rst\n")

    # -- export index.rst
    export_file("../../index.rst", index_lines, True)

    # remove Home.md file to avoid errors
    os.remove("../../wiki/Home.md")
