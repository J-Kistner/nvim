fn main() {
    let value = 12;
    let var = value;
    let _ = match value {
        var => print!("Match".to_string()),
        _ => {}
    }
}
