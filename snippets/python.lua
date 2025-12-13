-- Snippets Python personnalisés
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Main block
  s("main", fmt([[
if __name__ == "__main__":
    {}
  ]], { i(1, "pass") })),

  -- Function definition
  s("def", fmt([[
def {}({}):
    """{}"""
    {}
  ]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "Description"),
    i(4, "pass")
  })),

  -- Class definition
  s("class", fmt([[
class {}:
    """{}"""

    def __init__(self{}):
        {}
  ]], {
    i(1, "ClassName"),
    i(2, "Class description"),
    i(3, ", args"),
    i(4, "pass")
  })),

  -- Try/except
  s("try", fmt([[
try:
    {}
except {} as {}:
    {}
  ]], {
    i(1, "pass"),
    i(2, "Exception"),
    i(3, "e"),
    i(4, "print(e)")
  })),

  -- For loop
  s("for", fmt([[
for {} in {}:
    {}
  ]], {
    i(1, "item"),
    i(2, "items"),
    i(3, "pass")
  })),

  -- Docstring
  s("doc", fmt([[
"""
{}

Args:
    {}

Returns:
    {}
"""
  ]], {
    i(1, "Description"),
    i(2, "arg: description"),
    i(3, "return description")
  })),

  -- Type hint function
  s("deft", fmt([[
def {}({}) -> {}:
    """{}"""
    {}
  ]], {
    i(1, "function_name"),
    i(2, "arg: type"),
    i(3, "ReturnType"),
    i(4, "Description"),
    i(5, "pass")
  })),

  -- List comprehension
  s("lc", fmt([[
[{} for {} in {}]
  ]], {
    i(1, "x"),
    i(2, "x"),
    i(3, "items")
  })),

  -- Dictionary comprehension
  s("dc", fmt([[
{{{}: {} for {} in {}}}
  ]], {
    i(1, "k"),
    i(2, "v"),
    i(3, "item"),
    i(4, "items")
  })),

  -- Print debug
  s("pdb", fmt([[
print(f"{{{} = }}")
  ]], { i(1, "variable") })),

  -- Dataclass
  s("dataclass", fmt([[
from dataclasses import dataclass

@dataclass
class {}:
    {}: {}
  ]], {
    i(1, "ClassName"),
    i(2, "field"),
    i(3, "type")
  })),

  -- pytest test function
  s("test", fmt([[
def test_{}():
    """{}"""
    # Arrange
    {}

    # Act
    {}

    # Assert
    assert {}
  ]], {
    i(1, "function_name"),
    i(2, "Test description"),
    i(3, "# Setup"),
    i(4, "# Execute"),
    i(5, "True")
  })),
}
