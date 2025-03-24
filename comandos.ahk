;* NOTA: Las teclas en AutoHotkey son:
;* ^ = Ctrl
;* + = Shift
;* ! = Alt
;* # = Tecla Windows

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
^!f::Run, https://platform.openai.com/api-keys
+^v::Run, https://chatgpt.com/
+^2::Run, https://www.youtube.com/

#|::Reload ; Recarga este script

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones Locales
; ============================================

^!a::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk"
^!5::Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Aplicaciones de Chrome\Odoo.lnk"
#+4::Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Vysor Inc\Vysor.lnk"
#+5::Run, "C:\Apporisong\GeneratedExcels"
#+6::Run, "C:\Users\jewc2\OneDrive\Documentos\Importación de zapatillas\Segundo viaje a China"
#y::Run, "D:\Scripts\scripts\turbo2.bat"
^!t::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" --new-window --command="terminal"

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones
; ============================================
#!t::Run, *RunAs "D:\Warp\warp.exe"

; ============================================
; Atajos de Teclado para Ejecutar Comandos (En Shells Específicos)
; ============================================
; CMD (Command Prompt) en modo administrador
^!c::Run, *RunAs %ComSpec% /c "ipconfig",, Hide

; PowerShell en modo administrador - Lanza Cursor IDE
^!p::Run, *RunAs powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process 'C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe'",, Hide

; PowerShell Core (si lo tienes instalado) en modo administrador
^!w::Run, *RunAs pwsh.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Get-Date",, Hide

; Bash (Windows Subsystem for Linux - WSL) en modo administrador
^!b::Run, *RunAs wsl.exe -e bash -c "ls -la",, Hide

; Python en modo administrador
^!y::Run, *RunAs python.exe -c "print('Ejecutado con éxito desde AutoHotkey')",, Hide


