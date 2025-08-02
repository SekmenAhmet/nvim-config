// Fichier test pour vérifier les diagnostics Rust
fn main() {
    let x = 5; // Variable non utilisée - devrait générer un warning
    let y = "hello"
    // Erreur de syntaxe - point-virgule manquant
    
    println!("Hello, world!");
    
    // Fonction inexistante - devrait générer une erreur
    non_existent_function();
}

// Fonction avec erreur de type
fn bad_function() -> i32 {
    "this is a string" // Erreur de type - retourne String au lieu de i32
}