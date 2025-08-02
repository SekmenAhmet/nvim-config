// Fichier de test complet pour auditer la config Rust
use std::collections::HashMap;

// Test 1: Auto-import - ces types devraient être auto-complétés
fn test_auto_import() {
    // Vec devrait proposer std::vec::Vec
    let mut vec = Vec::new();
    vec.push(1);

    // HashMap devrait proposer std::collections::HashMap
    let mut map = HashMap::new();
    map.insert("key", "value");

    // BTreeMap devrait proposer std::collections::BTreeMap
    // let btree = BTreeMap::new();

    println!("Vec: {:?}, Map: {:?}", vec, map);
}

// Test 2: Erreurs intentionnelles pour diagnostics
fn test_errors() {
    let x = 5; // Variable inutilisée -> warning
    let y: i32 = "string"; // Type mismatch -> erreur

    // Fonction inexistante -> erreur
    // unknown_function();

    // Borrow checker -> erreur
    let mut s = String::from("hello");
    let r1 = &s;
    let r2 = &mut s; // Erreur
    println!("{} {}", r1, r2);
}

// Test 3: Types complexes pour inlay hints
fn test_inlay_hints() -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let items = vec!["a", "b", "c"].iter().map(|s| s.to_string()).collect();

    Ok(items)
}

// Test 4: Struct avec derives pour auto-completion
#[derive(Debug, Clone, PartialEq)]
struct TestStruct {
    field1: String,
    field2: i32,
    field3: Option<bool>,
}

impl TestStruct {
    fn new(field1: String, field2: i32) -> Self {
        Self {
            field1,
            field2,
            field3: None,
        }
    }

    fn process(&self) -> String {
        format!("{}: {}", self.field1, self.field2)
    }
}

// Test 5: Async/await pour rust-analyzer avancé
async fn test_async() -> Result<String, Box<dyn std::error::Error>> {
    // Tokio devrait être auto-importé
    tokio::time::sleep(std::time::Duration::from_millis(100)).await;
    Ok("Async test completed".to_string())
}

// Test 6: Macros et attributs
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_struct_creation() {
        let ts = TestStruct::new("test".to_string(), 42);
        assert_eq!(ts.field2, 42);
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("🦀 Rust Config Audit Test");

    test_auto_import();
    test_errors();

    let result = test_inlay_hints()?;
    println!("Inlay hints test: {:?}", result);

    let async_result = test_async().await?;
    println!("Async test: {}", async_result);

    let test_struct = TestStruct::new("audit".to_string(), 123);
    println!("Struct test: {}", test_struct.process());

    Ok(())
}

