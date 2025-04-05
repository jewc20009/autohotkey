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

#h::
    Run, *RunAs https://python.langchain.com/docs
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

#|::
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

!g:: ;* Atajo para abrir la documentación de LangChain en el navegador
    Run, https://python.langchain.com/docs/introduction/
return

#+5:: ;* Atajo para abrir el directorio de GeneratedExcels
    Run, *RunAs "C:\Apporisong\GeneratedExcels"
return

#y:: ;* Atajo para ejecutar turbo2.bat
    Run, *RunAs "D:\Scripts\scripts\turbo2.bat"
return

#+2:: ;* Atajo para abrir el directorio de Origisong
    RunCursor("D:\Users\Origis")
return

#t:: ;* Atajo para abrir Warp
    Run, *RunAs "D:\Warp\warp.exe"
return

+!4:: ;* Atajo para abrir el directorio de Scripts
    RunCursor("D:\Users\autohotkey")
    MsgBox "comandos.ahk cargado..."
    
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
                shortcuts.Push(hotkey . " -> " . action)  ; Guarda en el array
            }
        }
    }
    
    ; Construye la salida para mostrarla
    output := "Lista Dinámica de Atajos:`n`n"
    for index, shortcut in shortcuts {
        output .= shortcut . "`n"
    }
    MsgBox, %output%  ; Muestra los atajos en un cuadro de mensaje
}

; Llama a la función para imprimir los atajos dinámicamente con Win+M
#m::
    MapShortcuts()
return