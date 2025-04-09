// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

// --- AÑADE ESTOS USES ---
use dotenvy::dotenv;
use sqlx::postgres::PgPoolOptions;
use std::env;
// --- FIN DE USES ---

// --- AÑADE ESTA ESTRUCTURA --- 
#[derive(serde::Serialize, Debug)] // Serialize para enviar a JS
struct Shortcut {
    keys: Vec<String>,
    description: String,
}
// --- FIN DE ESTRUCTURA ---

// --- AÑADE ESTA ESTRUCTURA AUXILIAR PARA LA BD ---
#[derive(sqlx::FromRow, Debug)] // FromRow para mapear resultados de sqlx
struct DbShortcutRow {
    shortcut: String, // Ej: "Ctrl+Alt+f"
    description: String,
}
// --- FIN DE ESTRUCTURA AUXILIAR ---

// --- AÑADE ESTE COMANDO ---
#[tauri::command]
async fn get_shortcuts() -> Result<Vec<Shortcut>, String> {
    // Cargar variables de entorno desde .env
    dotenv().ok(); // Ignora si .env no existe

    // Obtener la URL de la base de datos desde la variable de entorno
    let database_url = env::var("DATABASE_URL")
        .map_err(|e| format!("Error al leer DATABASE_URL del entorno: {}. Asegúrate de que existe en .env", e))?;

    // Crear un pool de conexiones a PostgreSQL
    let pool = PgPoolOptions::new()
        .max_connections(5) // Configura según necesidad
        .connect(&database_url)
        .await
        .map_err(|e| format!("Error al conectar a la base de datos: {}", e))?;

    // Ejecutar la consulta SQL para obtener los atajos
    let db_rows = sqlx::query_as!(
        DbShortcutRow,
        "SELECT shortcut, description FROM shortcuts" // Asegúrate que la tabla se llame 'shortcuts'
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| format!("Error al consultar la base de datos: {}", e))?;

    // Mapear los resultados de la BD a la estructura que espera el frontend
    let shortcuts_for_frontend: Vec<Shortcut> = db_rows
        .into_iter()
        .map(|db_row| {
            // Parsea el string 'shortcut' (ej: "Ctrl+Alt+f") en un Vec<String>
            let keys: Vec<String> = db_row
                .shortcut
                .split('+') // Asume que '+' es el separador
                .map(String::from)
                .collect();

            Shortcut {
                keys,
                description: db_row.description,
            }
        })
        .collect();

    Ok(shortcuts_for_frontend)
}
// --- FIN DEL COMANDO ---

fn main() {
    tauri::Builder::default()
        // --- MODIFICA ESTA LÍNEA ---
        .invoke_handler(tauri::generate_handler![get_shortcuts]) // Registra el comando
        // --- FIN DE MODIFICACIÓN ---
        .run(tauri::generate_context!()) 
        .expect("error while running tauri application");
}
