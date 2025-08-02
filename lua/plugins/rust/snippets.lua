-- Snippets Rust avancés et templates
return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local c = ls.choice_node
      local f = ls.function_node
      local fmt = require("luasnip.extras.fmt").fmt
      
      -- Snippets Rust personnalisés
      ls.add_snippets("rust", {
        -- === STRUCTURES DE BASE ===
        s("struct", fmt([[
          #[derive(Debug{derive})]
          {vis}struct {name} {{
              {fields}
          }}
        ]], {
          derive = c(1, {
            t(""),
            t(", Clone"),
            t(", Clone, PartialEq"),
            t(", Clone, PartialEq, Eq"),
            t(", Clone, PartialEq, Eq, Hash"),
            t(", Clone, PartialEq, Eq, Hash, serde::Serialize, serde::Deserialize"),
          }),
          vis = c(2, { t(""), t("pub ") }),
          name = i(3, "StructName"),
          fields = i(4, "field: Type,"),
        })),
        
        -- === ENUMS ===
        s("enum", fmt([[
          #[derive(Debug{derive})]
          {vis}enum {name} {{
              {variants}
          }}
        ]], {
          derive = c(1, {
            t(""),
            t(", Clone"),
            t(", Clone, PartialEq"),
            t(", Clone, PartialEq, Eq"),
            t(", Clone, Copy, PartialEq, Eq"),
          }),
          vis = c(2, { t(""), t("pub ") }),
          name = i(3, "EnumName"),
          variants = i(4, "Variant,"),
        })),
        
        -- === IMPL BLOCKS ===
        s("impl", fmt([[
          impl{trait_part} {name} {{
              {methods}
          }}
        ]], {
          trait_part = c(1, {
            t(""),
            fmt(" {trait} for", { trait = i(1, "Trait") }),
          }),
          name = i(2, "StructName"),
          methods = i(3, "// methods"),
        })),
        
        -- === FONCTIONS ===
        s("fn", fmt([[
          {vis}fn {name}({args}){ret} {{
              {body}
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "function_name"),
          args = i(3, ""),
          ret = c(4, {
            t(""),
            fmt(" -> {ret_type}", { ret_type = i(1, "RetType") }),
          }),
          body = i(5, "todo!()"),
        })),
        
        -- === ASYNC FUNCTION ===
        s("afn", fmt([[
          {vis}async fn {name}({args}){ret} {{
              {body}
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "async_function"),
          args = i(3, ""),
          ret = c(4, {
            t(""),
            fmt(" -> Result<{ok}, {err}>", { 
              ok = i(1, "T"), 
              err = i(2, "Box<dyn std::error::Error>") 
            }),
          }),
          body = i(5, "Ok(())"),
        })),
        
        -- === TESTS ===
        s("test", fmt([[
          #[test]
          fn test_{name}() {{
              {body}
          }}
        ]], {
          name = i(1, "function"),
          body = i(2, "assert_eq!(actual, expected);"),
        })),
        
        -- === ASYNC TEST ===
        s("atest", fmt([[
          #[tokio::test]
          async fn test_{name}() {{
              {body}
          }}
        ]], {
          name = i(1, "async_function"),
          body = i(2, "assert!(result.is_ok());"),
        })),
        
        -- === MACROS ===
        s("macro", fmt([[
          macro_rules! {name} {{
              ({pattern}) => {{
                  {body}
              }};
          }}
        ]], {
          name = i(1, "macro_name"),
          pattern = i(2, "$e:expr"),
          body = i(3, "$e"),
        })),
        
        -- === ERROR HANDLING ===
        s("err", fmt([[
          #[derive(Debug, thiserror::Error)]
          {vis}enum {name} {{
              #[error("{msg}")]
              {variant}{{
                  {fields}
              }},
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "Error"),
          msg = i(3, "error message"),
          variant = i(4, "Variant"),
          fields = i(5, "source: Box<dyn std::error::Error>,"),
        })),
        
        -- === SERDE ===
        s("serde", fmt([[
          use serde::{{Deserialize, Serialize}};
          
          #[derive(Debug, Clone, Serialize, Deserialize)]
          {vis}struct {name} {{
              {fields}
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "Data"),
          fields = i(3, "field: String,"),
        })),
        
        -- === MAIN FUNCTIONS ===
        s("main", fmt([[
          fn main() {{
              {body}
          }}
        ]], {
          body = i(1, 'println!("Hello, world!");'),
        })),
        
        s("amain", fmt([[
          #[tokio::main]
          async fn main() -> Result<(), Box<dyn std::error::Error>> {{
              {body}
              
              Ok(())
          }}
        ]], {
          body = i(1, 'println!("Hello, async world!");'),
        })),
        
        -- === RESULT PATTERN ===
        s("result", fmt([[
          Result<{ok}, {err}>
        ]], {
          ok = i(1, "T"),
          err = i(2, "Box<dyn std::error::Error>"),
        })),
        
        -- === OPTION PATTERN ===
        s("option", fmt([[
          Option<{inner}>
        ]], {
          inner = i(1, "T"),
        })),
        
        -- === MODULES ===
        s("mod", fmt([[
          {vis}mod {name} {{
              {content}
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "module_name"),
          content = i(3, "// module content"),
        })),
        
        -- === TRAIT DEFINITION ===
        s("trait", fmt([[
          {vis}trait {name} {{
              {methods}
          }}
        ]], {
          vis = c(1, { t(""), t("pub ") }),
          name = i(2, "TraitName"),
          methods = i(3, "fn method(&self);"),
        })),
        
        -- === MATCH EXPRESSIONS ===
        s("match", fmt([[
          match {expr} {{
              {patterns}
          }}
        ]], {
          expr = i(1, "value"),
          patterns = i(2, "Some(x) => x,\nNone => return,"),
        })),
        
        -- === CLOSURE ===
        s("closure", fmt([[
          |{args}| {body}
        ]], {
          args = i(1, "x"),
          body = i(2, "x + 1"),
        })),
      })
    end,
  },
}