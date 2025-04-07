;* NOTA: Las teclas en AutoHotkey son:
;* ^ = Ctrl
;* + = Shift
;* ! = Alt
;* # = Tecla Windows

#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Auto-copy script to Startup folder on load/reload
CopyToStartup()

; Función para copiar el script a la carpeta de inicio
CopyToStartup() {
    startupPath := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk"
    
    ; Copia el script actual a la carpeta de inicio
    FileCopy, %A_ScriptFullPath%, %startupPath%, 1
    
    ; Si el script en ejecución no es el de desarrollo, recarga el de la carpeta de inicio
    if (A_ScriptFullPath != startupPath) {
        ; Intenta recargar el script de la carpeta de inicio si está en ejecución
        DetectHiddenWindows, On
        scriptPID := WinExist("ahk_class AutoHotkey ahk_exe AutoHotkey.exe")
        if (scriptPID) {
            ; Envía un mensaje WM_COMMAND con el comando de recarga (65303)
            PostMessage, 0x111, 65303, 0, , ahk_id %scriptPID%
        }
    }
    return
}

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
    Run, https://platform.openai.com/api-keys
return

^!v::
    Run, https://chatgpt.com/
return

^!2::
    Run, https://www.youtube.com/
return

!g:: ;* Atajo para abrir la documentación de LangChain en el navegador
    Run, https://python.langchain.com/docs/introduction/
return

#j::
    Run, https://langchain-ai.github.io/langgraph/
return

+!3::
    Run, https://gemini.google.com/app
return

^!r::
    Run, https://www.rappi.com.pe/tiendas/54165-rappi-market-nc
return



#|:: ;* Atajo para copiar el script a la carpeta de StartUp y recargar
    CopyToStartup()
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
    
    FileDelete, %A_Temp%\project_root.txt
    return projectRoot
}

; Guardar la ruta raíz en una variable global
global PROJECT_ROOT := GetProjectRoot()

^!e:: ;* Atajo para abrir el directorio de StartUp
    RunCursor(PROJECT_ROOT)
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
    RunCursor("D:\Users\Originsong-1.3")
return

#t:: ;* Atajo para abrir Warp
    RunWarp()
return

+!4:: ;* Atajo para abrir el directorio de comandos.ahk
    RunCursor("D:\Users\autohotkey")    
return

#4:: ;* Atajo para abrir Vysor
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
            action := RegExReplace(Trim(match2), "return$", "")  ; Obtiene la acción asociada y quita "return" si existe
            action := Trim(action)  ; Elimina espacios en blanco sobrantes
            
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
    
    ; Crear array de atajos en formato JSON
    jsonShortcuts := "["
    
    For index, shortcut in shortcuts {
        ; Escapar caracteres especiales en la descripción
        description := RegExReplace(shortcut[2], """", "\\""")
        description := RegExReplace(description, "\r|\n", " ")  ; Reemplazar saltos de línea por espacios
        
        ; Parsear las teclas
        keyArray := StrSplit(shortcut[1], "+")
        keysJson := ""
        For i, key in keyArray {
            key := Trim(key)
            If (keysJson != "")
                keysJson .= ","
            keysJson .= """" . key . """"
        }
        
        ; Agregar el atajo al JSON
        jsonShortcuts .= "{"
        jsonShortcuts .= """keys"": [" . keysJson . "],"
        jsonShortcuts .= """description"": """ . description . """"
        jsonShortcuts .= "}"
        
        ; Agregar coma si no es el último elemento
        If (index < shortcuts.Length())
            jsonShortcuts .= ","
    }
    
    jsonShortcuts .= "]"
    
    ; Guardar JSON en un archivo
    visualizerDir := A_ScriptDir . "\keyboard_visualizer"
    If (!FileExist(visualizerDir))
        FileCreateDir, %visualizerDir%
    
    jsonFile := visualizerDir . "\shortcuts.json"
    FileDelete, %jsonFile%
    FileAppend, %jsonShortcuts%, %jsonFile%
    
    ; Abrir el visualizador HTML en el navegador predeterminado
    Run, %visualizerDir%\index.html
}

; Llama a la función para imprimir los atajos dinámicamente con Win+M
#m::
    MapShortcuts()
return