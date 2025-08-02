// Test avec erreurs ÉVIDENTES pour rust-analyzer
fn main() {
    let x = 5; // Variable inutilisée -> warning
    let y = "hello"  // Point-virgule manquant -> ERREUR
    
    // Fonction inexistante -> ERREUR
    this_function_does_not_exist();
    
    // Type incompatible -> ERREUR
    let number: i32 = "this is text";
    
    // Borrow checker -> ERREUR
    let mut data = String::from("hello");
    let r1 = &data;
    let r2 = &mut data;
    println!("{} {}", r1, r2);
}

// Fonction sans return -> ERREUR
fn returns_number() -> i32 {
    "text instead of number"
}