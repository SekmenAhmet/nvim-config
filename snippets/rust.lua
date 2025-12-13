-- Snippets Rust personnalisés
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Main function
  s("main", fmt([[
fn main() {{
    {}
}}
  ]], { i(1, "// code") })),

  -- Function definition
  s("fn", fmt([[
fn {}({}) -> {} {{
    {}
}}
  ]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "ReturnType"),
    i(4, "// code")
  })),

  -- Public function
  s("pfn", fmt([[
pub fn {}({}) -> {} {{
    {}
}}
  ]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "ReturnType"),
    i(4, "// code")
  })),

  -- Struct definition
  s("struct", fmt([[
struct {} {{
    {}
}}
  ]], {
    i(1, "StructName"),
    i(2, "field: Type,")
  })),

  -- Public struct
  s("pstruct", fmt([[
pub struct {} {{
    pub {}: {},
}}
  ]], {
    i(1, "StructName"),
    i(2, "field"),
    i(3, "Type")
  })),

  -- Enum definition
  s("enum", fmt([[
enum {} {{
    {},
}}
  ]], {
    i(1, "EnumName"),
    i(2, "Variant")
  })),

  -- Impl block
  s("impl", fmt([[
impl {} {{
    {}
}}
  ]], {
    i(1, "StructName"),
    i(2, "// methods")
  })),

  -- Impl trait
  s("implt", fmt([[
impl {} for {} {{
    {}
}}
  ]], {
    i(1, "Trait"),
    i(2, "Type"),
    i(3, "// implementation")
  })),

  -- Match expression
  s("match", fmt([[
match {} {{
    {} => {{}},
    _ => {{}},
}}
  ]], {
    i(1, "expression"),
    i(2, "pattern")
  })),

  -- If let
  s("ifl", fmt([[
if let {} = {} {{
    {}
}}
  ]], {
    i(1, "Some(x)"),
    i(2, "value"),
    i(3, "// code")
  })),

  -- For loop
  s("for", fmt([[
for {} in {} {{
    {}
}}
  ]], {
    i(1, "item"),
    i(2, "items"),
    i(3, "// code")
  })),

  -- Result return
  s("res", fmt([[
Result<{}, {}>
  ]], {
    i(1, "T"),
    i(2, "Error")
  })),

  -- Option return
  s("opt", fmt([[
Option<{}>
  ]], { i(1, "T") })),

  -- Derive
  s("derive", fmt([[
#[derive({})]
  ]], { i(1, "Debug, Clone") })),

  -- Test function
  s("test", fmt([[
#[test]
fn test_{}() {{
    {}
}}
  ]], {
    i(1, "function_name"),
    i(2, "assert_eq!(1, 1);")
  })),

  -- Async function
  s("async", fmt([[
async fn {}({}) -> {} {{
    {}
}}
  ]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "Result<T>"),
    i(4, "// async code")
  })),

  -- Unwrap or default
  s("unwrap", fmt([[
{}.unwrap_or({})
  ]], {
    i(1, "option"),
    i(2, "default")
  })),

  -- Box::new
  s("box", fmt([[
Box::new({})
  ]], { i(1, "value") })),

  -- Rc::new
  s("rc", fmt([[
Rc::new({})
  ]], { i(1, "value") })),

  -- Vec macro
  s("vec", fmt([[
vec![{}]
  ]], { i(1, "items") })),

  -- println debug
  s("pdbg", fmt([[
println!("{{:?}}", {});
  ]], { i(1, "variable") })),

  -- Error propagation
  s("try", fmt([[
{}?
  ]], { i(1, "expression") })),
}
