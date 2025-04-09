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
    scriptFile := A_ScriptFullPath
    shortcuts := []
    FileRead, scriptContent, %scriptFile%
    
    ; Busca líneas que definan atajos (::)
    Loop, Parse, scriptContent, `n, `r
    {
        line := A_LoopField
        ; Ignora líneas de comentarios y líneas vacías
        if (RegExMatch(line, "^\s*;") || line = "" || !RegExMatch(line, "::"))
            continue
            
        ; Busca patrones de atajos válidos y extrae la descripción de los comentarios
        if (RegExMatch(line, "^([#!+^]*[a-zA-Z0-9|]*)::.*?;\*\s*(.+?)\s*$", match)) {
            hotkey := Trim(match1)
            description := Trim(match2)
            
            if (hotkey != "" && description != "") {
                ; Parsea la combinación de teclas
                keys := []
                
                ; Procesa los modificadores en el orden correcto
                if (InStr(hotkey, "^"))
                    keys.Push("Ctrl")
                if (InStr(hotkey, "+"))
                    keys.Push("Shift")
                if (InStr(hotkey, "!"))
                    keys.Push("Alt")
                if (InStr(hotkey, "#"))
                    keys.Push("Win")
                    
                ; Obtiene la tecla principal (última letra/número después de los modificadores)
                RegExMatch(hotkey, "[a-zA-Z0-9|]$", mainKey)
                if (mainKey) {
                    StringUpper, mainKey, mainKey
                    keys.Push(mainKey)
                }
                
                ; Solo agrega el atajo si tiene teclas válidas y una descripción
                if (keys.Length() > 0 && description != "")
                    shortcuts.Push({"keys": keys, "description": description})
            }
        }
    }
    
    ; Crear JSON
    jsonStr := "["
    for index, shortcut in shortcuts {
        if (index > 1)
            jsonStr .= ","
            
        ; Crear array de teclas
        keysJson := "["
        for i, key in shortcut.keys {
            if (i > 1)
                keysJson .= ","
            keysJson .= """" . key . """"
        }
        keysJson .= "]"
        
        ; Agregar el objeto de atajo
        jsonStr .= "{"
        jsonStr .= """keys"":" . keysJson . ","
        jsonStr .= """description"":""" . shortcut.description . """"
        jsonStr .= "}"
    }
    jsonStr .= "]"
    
    ; Guardar JSON en un archivo
    visualizerDir := A_ScriptDir . "\keyboard_visualizer"
    if (!FileExist(visualizerDir))
        FileCreateDir, %visualizerDir%
    
    jsonFile := visualizerDir . "\shortcuts.json"
    FileDelete, %jsonFile%
    FileAppend, %jsonStr%, %jsonFile%, UTF-8
    
    ; Intentar abrir diferentes versiones en orden de prioridad
    
    ; 1. Primero - Intenta abrir el visualizador nativo de AHK (más rápido)
    ahkVisualizer := visualizerDir . "\visualizer.ahk"
    if (FileExist(ahkVisualizer)) {
        Run, %ahkVisualizer%
        return
    }
    
    ; 2. Segundo - Intenta abrir el visualizador nativo compilado
    ahkVisualizer := visualizerDir . "\visualizer.exe"
    if (FileExist(ahkVisualizer)) {
        Run, %ahkVisualizer%
        return
    }
    
    ; 3. Tercero - Intenta abrir la versión compilada de Tauri
    tauriPath := visualizerDir . "\keyboard-visualizer.exe"
    if (FileExist(tauriPath)) {
        Run, %tauriPath%
        return
    }
    
    ; 4. Cuarto - Intenta usar Electron si está instalado
    electronPath := visualizerDir . "\node_modules\.bin\electron.cmd"
    if (FileExist(electronPath)) {
        Run, %ComSpec% /c cd "%visualizerDir%" && npm start, , Hide
        return
    }
    
    ; 5. Quinto - Usa el navegador como última opción
    Run, %visualizerDir%\index.html
}

; Llama a la función para mapear los atajos dinámicamente con Win+M
#m::
    MapShortcuts()
return