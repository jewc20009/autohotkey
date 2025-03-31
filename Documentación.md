# Documentación de AutoHotkey

## Modificadores de Teclas
- `<` = Usar tecla izquierda específicamente (e.g., `<^a` es Ctrl izquierdo + a)
- `>` = Usar tecla derecha específicamente (e.g., `>!a` es Alt derecho + a)
- `~` = La tecla original mantiene su función además de activar el hotkey
- `$` = Fuerza el uso del hook de tecla (útil para evitar recursión en hotkeys)
- `*` = Comodín (la tecla se activa incluso si se mantienen otras teclas modificadoras)
- `UP` = Se activa al soltar la tecla en lugar de al presionarla (e.g., `a UP::`)

## Símbolos Especiales
- `::` = Define un hotkey/hotstring (e.g., `^c::` para Ctrl+C)
- `return` = Termina un bloque de código y evita que la ejecución continúe

## Teclas Modificadoras
- `^` = Ctrl
- `+` = Shift
- `!` = Alt
- `#` = Tecla Windows

## Comandos Comunes
- `SetWorkingDir` = Establece el directorio de trabajo para el script
- `#SingleInstance force` = Permite solo una instancia del script, reemplazando la anterior
- `#NoEnv` = Desactiva el uso de variables de entorno para mayor compatibilidad
- `SendMode Input` = Establece el modo más rápido y confiable para enviar pulsaciones de teclas
- `SetWorkingDir %A_ScriptDir%` = Establece el directorio de trabajo al directorio del script
- `Run` = Ejecuta un programa, documento o URL (e.g., `Run, notepad.exe`)
- `Send/SendInput` = Envía pulsaciones de teclas simuladas al programa activo
- `MsgBox` = Muestra un cuadro de mensaje con texto personalizable
- `Sleep` = Pausa la ejecución del script por un número específico de milisegundos
- `KeyWait` = Espera a que se suelte una tecla específica antes de continuar
- `WinActivate` = Activa (trae al frente) una ventana específica
- `WinWaitActive` = Pausa el script hasta que una ventana específica esté activa