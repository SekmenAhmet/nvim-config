-- Snippets C personnalisés
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Main function
  s("main", fmt([[
int main(int argc, char *argv[]) {{
    {}
    return 0;
}}
  ]], { i(1, "// code") })),

  -- Include
  s("inc", fmt([[
#include <{}>
  ]], { i(1, "stdio.h") })),

  -- Include local
  s("incl", fmt([[
#include "{}"
  ]], { i(1, "header.h") })),

  -- Function definition
  s("fn", fmt([[
{} {}({}) {{
    {}
}}
  ]], {
    i(1, "void"),
    i(2, "function_name"),
    i(3, "args"),
    i(4, "// code")
  })),

  -- For loop
  s("for", fmt([[
for (int {} = 0; {} < {}; {}++) {{
    {}
}}
  ]], {
    i(1, "i"),
    i(2, "i"),
    i(3, "n"),
    i(4, "i"),
    i(5, "// code")
  })),

  -- While loop
  s("while", fmt([[
while ({}) {{
    {}
}}
  ]], {
    i(1, "condition"),
    i(2, "// code")
  })),

  -- If statement
  s("if", fmt([[
if ({}) {{
    {}
}}
  ]], {
    i(1, "condition"),
    i(2, "// code")
  })),

  -- If-else
  s("ife", fmt([[
if ({}) {{
    {}
}} else {{
    {}
}}
  ]], {
    i(1, "condition"),
    i(2, "// true case"),
    i(3, "// false case")
  })),

  -- Switch
  s("switch", fmt([[
switch ({}) {{
    case {}:
        {}
        break;
    default:
        {}
        break;
}}
  ]], {
    i(1, "variable"),
    i(2, "value"),
    i(3, "// code"),
    i(4, "// default")
  })),

  -- Struct definition
  s("struct", fmt([[
typedef struct {{
    {}
}} {};
  ]], {
    i(1, "int field;"),
    i(2, "StructName")
  })),

  -- Printf
  s("printf", fmt([[
printf("{}\\n", {});
  ]], {
    i(1, "%d"),
    i(2, "var")
  })),

  -- Malloc
  s("malloc", fmt([[
{} *{} = ({} *)malloc(sizeof({}) * {});
if ({} == NULL) {{
    perror("malloc failed");
    return {};
}}
  ]], {
    i(1, "type"),
    i(2, "ptr"),
    i(3, "type"),
    i(4, "type"),
    i(5, "size"),
    i(6, "ptr"),
    i(7, "NULL")
  })),

  -- Header guard
  s("guard", fmt([[
#ifndef {}_H
#define {}_H

{}

#endif // {}_H
  ]], {
    i(1, "HEADER"),
    i(2, "HEADER"),
    i(3, "// declarations"),
    i(4, "HEADER")
  })),
}
