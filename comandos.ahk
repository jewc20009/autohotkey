;* NOTA: Las teclas en AutoHotkey son:
;* ^ = Ctrl
;* + = Shift
;* ! = Alt
;* # = Tecla Windows

#SingleInstance force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

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
    MsgBox, "Youtube abierto"
return

#|::
    Reload ; Recarga este script
return

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones Locales
; ============================================

^!a::
    Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk"
return

^!5::
    Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Aplicaciones de Chrome\Odoo.lnk"
return

#+4::
    Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Vysor Inc\Vysor.lnk"
return

#+5::
    Run, "C:\Apporisong\GeneratedExcels"
return

#+6::
    Run, "C:\Users\jewc2\OneDrive\Documentos\Importación de zapatillas\Segundo viaje a China"
return

#y::
    Run, "D:\Scripts\scripts\turbo2.bat"
return

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones
; ============================================
#t::
    ; Implementación usando variable global
    global toggleState
    if (toggleState = "")  ; Inicializar la primera vez
        toggleState := 0
    
    ; Verifica si la ventana ya existe
    DetectHiddenWindows, On
    if WinExist("ahk_exe warp.exe")
    {
        if (toggleState = 1)  ; Si está visible, ocultarla
        {
            WinMinimize, ahk_exe warp.exe
            toggleState := 0
        }
        else  ; Si está oculta, mostrarla
        {
            WinGet, estadoMin, MinMax, ahk_exe warp.exe
            if (estadoMin = -1)
                WinRestore, ahk_exe warp.exe
                
            WinActivate, ahk_exe warp.exe
            
            ; Forzar al frente
            WinSet, AlwaysOnTop, On, ahk_exe warp.exe
            Sleep, 10
            WinSet, AlwaysOnTop, Off, ahk_exe warp.exe
            
            toggleState := 1
        }
    }
    else  ; Si la aplicación no está en ejecución, iniciarla
    {
        Run, *RunAs "D:\Warp\warp.exe"
        WinWait, ahk_exe warp.exe,, 5
        if !ErrorLevel
        {
            WinActivate, ahk_exe warp.exe
            toggleState := 1
        }
    }
    DetectHiddenWindows, Off
return

; ============================================
; Atajos de Teclado para Ejecutar Comandos (En Shells Específicos)
; ============================================
; CMD (Command Prompt) en modo administrador
^!c::
    Run, *RunAs %ComSpec% /c "ipconfig",, Hide
return

; PowerShell en modo administrador - Lanza Cursor IDE
^!p::
    Run, *RunAs powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process 'C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe'",, Hide
return

; PowerShell Core (si lo tienes instalado) en modo administrador
^!w::
    Run, *RunAs pwsh.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Get-Date",, Hide
return

; Bash (Windows Subsystem for Linux - WSL) en modo administrador
^!b::
    Run, *RunAs wsl.exe -e bash -c "ls -la",, Hide
return

; Python en modo administrador
^!y::
    Run, *RunAs python.exe -c "print('Ejecutado con éxito desde AutoHotkey')",, Hide
return


