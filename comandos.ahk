;* NOTA: Las teclas en AutoHotkey son:
;* ^ = Ctrl
;* + = Shift
;* ! = Alt
;* # = Tecla Windows

#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Variables globales
global CURSOR_PATH := "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe"
global VSCODE_PATH := "C:\Users\jewc2\AppData\Local\Programs\Microsoft VS Code\Code.exe"
global TRAE_PATH := "C:\Users\jewc2\AppData\Local\Programs\Trae\Trae.exe"
global WARP_PATH := "D:\Warp\warp.exe"

; Funciones
RunCursor(path := "") {
    global CURSOR_PATH
    if (path = "") {
        Run, *RunAs "%CURSOR_PATH%"
    } else {
        Run, *RunAs "%CURSOR_PATH%" -n "%path%"
    }
}

RunWarp(args := "") {
    global WARP_PATH
    if (args = "") {
        Run, *RunAs "%WARP_PATH%"
    } else {
        Run, *RunAs "%WARP_PATH%" %args%
    }
}

; ============================================
; Atajos de Teclado para Abrir Sitios Web
; ============================================
^!f::
    Run, *RunAs https://platform.openai.com/api-keys
return

^!v::
    Run, *RunAs https://chat.openai.com/chat
return
^!2::
    Run, *RunAs https://www.youtube.com/
return


!g:: ;* Atajo para abrir la documentación de LangChain en el navegador
    Run, https://python.langchain.com/docs/introduction/
return

#j::
    Run, *RunAs https://langchain-ai.github.io/langgraph/
return

+!3::
    Run, *RunAs https://gemini.google.com/app
return

^!r::
    Run, *RunAs https://www.rappi.com.pe/tiendas/54165-rappi-market-nc
return
#|:: ;* Atajo para copiar el script a la carpeta de StartUp
    FileCopy, %A_ScriptFullPath%, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk", 1
    Reload  ; Recarga este script
return

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones Locales
; ============================================
; ============================================
; Obtener la ruta raíz del proyecto
; ============================================
GetProjectRoot() {
    ; Intenta obtener la ruta raíz del proyecto
    ; Primero verifica si estamos en un repositorio Git
    RunWait, %ComSpec% /c "git rev-parse --show-toplevel > %A_Temp%\project_root.txt", , Hide
    FileRead, projectRoot, %A_Temp%\project_root.txt
    projectRoot := Trim(projectRoot)
    
    ; Si no estamos en un repositorio Git, usa el directorio actual
    if (ErrorLevel || projectRoot = "") {
        projectRoot := A_WorkingDir
    }
    
    return projectRoot
}

; Guardar la ruta raíz en una variable global
global PROJECT_ROOT := GetProjectRoot()

^!e:: ;* Atajo para abrir el directorio de StartUp
    RunCursor(%PROJECT_ROOT%)
return


^!y:: ;* Atajo para abrir YouTube Music
    Run, *RunAs "C:\Users\jewc2\AppData\Local\Programs\youtube-music\YouTube Music.exe"
return

#y:: ;* Atajo para ejecutar turbo2.bat
    Run, *RunAs "D:\Scripts\scripts\turbo2.bat"
return

+!o:: ;* Atajo para abrir el directorio de Origisong
    RunCursor("D:\RootDirectory\Origisong")
return

#+2:: ;* Atajo para abrir el directorio de Origisong
    RunCursor("D:\Users\Origis")
return

#t:: ;* Atajo para abrir Warp
    Run, *RunAs "D:\Warp\warp.exe"
return

+!4:: ;* Atajo para abrir el directorio de comandos.ahk
    RunCursor("D:\Users\autohotkey")    
return

#4:: ;* Atajo para abrir [Vysor] Windows + Shift + 4
    Run, *RunAs "C:\Users\jewc2\AppData\Local\vysor\Vysor.exe"
return




; Función para extraer los atajos dinámicamente del script
MapShortcuts() {
    scriptFile := A_ScriptFullPath  ; Obtiene la ruta completa del archivo de script actual
    shortcuts := []  ; Crea un array vacío para almacenar los atajos
    FileRead, scriptContent, %scriptFile%
    
    ; Busca líneas que definan atajos (: o ::)
    Loop, Parse, scriptContent, `n, `r
    {
        line := A_LoopField
        if (RegExMatch(line, "^(.*)::(.*)$", match)) {  ; Busca el patrón de "::"
            hotkey := Trim(match1)  ; Obtiene la combinación de teclas
            action := Trim(match2)  ; Obtiene la acción asociada
            if (hotkey != "" && action != "") {
                ; Convierte los símbolos de teclas a nombres legibles
                readableHotkey := hotkey
                readableHotkey := StrReplace(readableHotkey, "^", "Ctrl+")
                readableHotkey := StrReplace(readableHotkey, "+", "Shift+")
                readableHotkey := StrReplace(readableHotkey, "!", "Alt+")
                readableHotkey := StrReplace(readableHotkey, "#", "Win+")
                
                ; Elimina el "+" final si existe
                if (SubStr(readableHotkey, 0) = "+")
                    readableHotkey := SubStr(readableHotkey, 1, StrLen(readableHotkey)-1)
                
                shortcuts.Push([readableHotkey, action])  ; Guarda en el array
            }
        }
    }
    
    ; Construye una tabla HTML para mostrar los atajos
    html := "<html><head><style>"
    html .= "body { font-family: Arial, sans-serif; background-color: #f0f0f0; }"
    html .= "table { width: 90%; border-collapse: collapse; margin: 20px auto; background-color: white; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }"
    html .= "th { background-color: #4CAF50; color: white; text-align: left; padding: 12px; }"
    html .= "td { padding: 10px; border-bottom: 1px solid #ddd; }"
    html .= "tr:hover { background-color: #f5f5f5; }"
    html .= "h2 { text-align: center; color: #333; }"
    html .= ".key { background-color: #f1f1f1; padding: 4px 8px; border-radius: 4px; border: 1px solid #ddd; font-family: monospace; }"
    html .= "</style></head><body>"
    html .= "<h2>Atajos de Teclado Disponibles</h2>"
    html .= "<table><tr><th>Atajo</th><th>Acción</th></tr>"
    
    for index, shortcut in shortcuts {
        ; Estiliza mejor las teclas
        styledKey := RegExReplace(shortcut[1], "([A-Za-z0-9+]+)", "<span class='key'>$1</span>")
        html .= "<tr><td>" . styledKey . "</td><td>" . shortcut[2] . "</td></tr>"
    }
    
    html .= "</table></body></html>"
    
    ; Guarda el HTML en un archivo temporal
    htmlFile := A_Temp . "\shortcuts.html"
    FileDelete, %htmlFile%
    FileAppend, %html%, %htmlFile%
    
    ; Abre el archivo HTML en el navegador predeterminado
    Run, %htmlFile%
}

; Llama a la función para imprimir los atajos dinámicamente con Win+M
#m::
    MapShortcuts()
return