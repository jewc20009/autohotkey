;* NOTA: Las teclas en AutoHotkey son:
;* ^ = Ctrl
;* + = Shift
;* ! = Alt
;* # = Tecla Windows

#SingleInstance force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Variables globales
global CURSOR_PATH := "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe"
VSCODE_PATH := "C:\Users\jewc2\AppData\Local\Programs\Microsoft VS Code\Code.exe"
TRAE_PATH := "C:\Users\jewc2\AppData\Local\Programs\Trae\Trae.exe"
WARP_PATH := "D:\Warp\warp.exe"
;* KeyWait = Espera a que se suelte la tecla
;* DOCUMENTACIÓN DE AUTOHOTKEY
;* < = Usar tecla izquierda específicamente (e.g., <^a es Ctrl izquierdo + a)
;* > = Usar tecla derecha específicamente
;* ~ = La tecla original mantiene su función
;* $ = Fuerza el uso del hook de teclado
;* * = Comodín (la tecla se activa incluso si se mantienen otras teclas)
;* UP = Se activa al soltar la tecla en lugar de al presionarla
;* :: = Define un hotkey/hotstring
;* return = Termina un bloque de código

;* SetWorkingDir = Establece el directorio de trabajo
;* #SingleInstance force = Permite solo una instancia del script
;* #NoEnv = Recomienda para compatibilidad
;* SendMode Input = Modo más rápido y confiable
;* SetWorkingDir %A_ScriptDir% = Asegura consistencia
;* Run = Ejecuta un programa o archivo
;* Send/SendInput = Envía teclas
;* MsgBox = Muestra un cuadro de mensaje
;* Sleep = Pausa el script
;* KeyWait = Espera a que se suelte una tecla
;* WinActivate = Activa una ventana
;* WinWaitActive = Espera a que una ventana esté activa

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
    MsgBox, "Youtube abierto"
return

#|::
    Reload  ; Recarga este script
return

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones Locales
; ============================================

^!e::
    RunCursor("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup")
return



#+5::
    Run, *RunAs "C:\Apporisong\GeneratedExcels"
return

#+6::
    Run, *RunAs "C:\Users\jewc2\OneDrive\Documentos\Importación de zapatillas\Segundo viaje a China"
return

#y::
    Run, *RunAs "D:\Scripts\scripts\turbo2.bat"
return


#+2::
    RunCursor("D:\RootDirectory\Origisong")
return

#+3::
    Run, *RunAs "D:\Warp\warp.exe"
return
