// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

// Estructura para los atajos de teclado
#[derive(serde::Serialize, Debug)]
struct Shortcut {
    keys: Vec<String>,
    description: String,
}

// Comando para obtener atajos (versión simplificada sin BD)
#[tauri::command]
fn get_shortcuts() -> Vec<Shortcut> {
    // Datos de ejemplo
    vec![
        Shortcut {
            keys: vec!["Ctrl".into(), "Alt".into(), "G".into()],
            description: "Abrir Gemini".into(),
        },
        Shortcut {
            keys: vec!["Ctrl".into(), "S".into()],
            description: "Guardar".into(),
        },
        Shortcut {
            keys: vec!["Ctrl".into(), "Alt".into(), "D".into()],
            description: "Abrir DevTools".into(),
        },
    ]
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![get_shortcuts])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
