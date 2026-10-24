# Script to bold the typeclass names in the graphviz output

# While HTML-like labels could be used in dot files, this appears to create
# problems. Graphviz appears to always use text-anchor="start" when HTML labels
# are used. This makes the alignment of the image font dependent.

# So instead we just use normal labels in the dot files and post-process the
# SVG files to bold the first <text> element in each node.

from sys import argv
import xml.etree.ElementTree as ET

if len(argv) != 3:
    print("python bold.py <input.svg> <output.svg>")

ET.register_namespace("", "http://www.w3.org/2000/svg")

tree = ET.parse(argv[1])
svg = tree.getroot()
assert svg.tag == "{http://www.w3.org/2000/svg}svg"
g = svg[0]
assert g.tag == "{http://www.w3.org/2000/svg}g"

for child in g:
    if "class" in child.attrib and child.attrib["class"] == "node":
        text = child[2]
        assert text.tag == "{http://www.w3.org/2000/svg}text"
        text.attrib["font-weight"] = "bold"

tree.write(argv[2])
