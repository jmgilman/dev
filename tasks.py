import re
import invoke
import shutil
from math import log, floor


@invoke.task
def format(c):
    """Formats markdown files."""
    files = c.run('fd ".*\\.md"', hide="out").stdout.split("\n")[:-1]

    for file in files:
        with open(file, "r+") as f:
            contents = f.read()
            f.seek(0)
            f.write(convert_links(contents))

    c.run("poetry run mdformat --wrap 80 " + " ".join(files), hide="out")

    if shutil.which("mdl") is not None:
        result = c.run("mdl " + " ".join(files), hide="out")
        if result.exited != 0:
            print("The markdown linter failed after formatting")
            print(result.stdout + result.stderr)
            exit(1)


@invoke.task
def serve(c):
    """Serves the handbook locally at http://127.0.0.1:8000."""
    c.run("poetry run mkdocs serve --strict")


def convert_links(content: str) -> str:
    """Converts markdown in-line links to reference links.

    Args:
        content: The markdown contents to convert

    Returns:
        The formatted markdown content
    """
    MARKDOWN_LINK_PATTERN = r"\[\!\[([^\[]+?)\]\(([^\#].+?)\)\]\(([^\#].+?)\)|\[([^\[]+?)\]\(([^\#].+?)\)"  # noqa

    archors = []

    index = 0

    mdlinks = re.finditer(MARKDOWN_LINK_PATTERN, content)
    lst = list(mdlinks)
    size = len(lst)

    for i, link in enumerate(lst):
        index += 1
        pad = int(floor(log(max(size, 1), 10))) + 1

        if link.group(1):
            formattedArchorImageString = "[@{:0{pad}d}-img]: {}".format(
                index, link.group(2), pad=pad
            )
            formattedArchorLinkString = "[@{:0{pad}d}-url]: {}".format(
                index, link.group(3), pad=pad
            )

            archors.append(formattedArchorImageString)
            archors.append(formattedArchorLinkString)

            formattedString = (
                "[![{}][@{:0{pad}d}-img]][@{:0{pad}d}-url]".format(
                    link.group(1), index, index, pad=pad
                )
            )

        else:
            formattedArchorString = "[@{:0{pad}d}]: {}".format(
                index, link.group(5), pad=pad
            )
            archors.append(formattedArchorString)

            formattedString = "[{}][@{:0{pad}d}]".format(
                link.group(4), index, pad=pad
            )

        content = content.replace(link.group(0), formattedString)

    for a in archors:
        content += a + "\n"

    return content
