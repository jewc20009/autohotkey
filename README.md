# Script AutoHotkey para Atajos de Teclado

Este repositorio contiene un script AutoHotkey (`comandos.ahk`) que proporciona múltiples atajos de teclado para mejorar la productividad en Windows.

## Características

- **Atajos para sitios web**: Abre rápidamente sitios web clave con combinaciones de teclas.
- **Lanzamiento de aplicaciones**: Inicia aplicaciones locales con atajos personalizados.
- **Ejecución de comandos con privilegios de administrador**: Ejecuta comandos en diferentes shells (CMD, PowerShell, WSL, Python) sin interfaz visible.

## Teclas modificadoras en AutoHotkey

- `^` = Ctrl
- `+` = Shift
- `!` = Alt
- `#` = Tecla Windows

## Atajos principales

### Sitios web
- `Ctrl+Alt+F`: Abre OpenAI API Keys
- `Shift+Ctrl+V`: Abre ChatGPT
- `Shift+Ctrl+2`: Abre YouTube

### Aplicaciones
- `Ctrl+Alt+A`: Abre Cursor IDE con este script
- `Ctrl+Alt+T`: Abre nueva terminal en Cursor
- `Win+Alt+T`: Abre Warp terminal

### Comandos con privilegios elevados
- `Ctrl+Alt+C`: Ejecuta ipconfig en CMD (administrador)
- `Ctrl+Alt+P`: Inicia Cursor IDE vía PowerShell (administrador)
- `Ctrl+Alt+W`: Muestra fecha actual en PowerShell Core (administrador)
- `Ctrl+Alt+B`: Lista archivos con ls -la en WSL (administrador)
- `Ctrl+Alt+Y`: Ejecuta código Python simple (administrador)

### Sistema
- `Win+|`: Recarga este script

## Mejoras realizadas

- Corrección de la documentación y referencia de teclas
- Optimización de los comandos para ejecución silenciosa
- Configuración de comandos para ejecución con privilegios de administrador
- Limpieza de código y comentarios innecesarios

## Ubicación del script

El script se carga automáticamente al inicio de Windows desde:
```
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk
```

## Cómo personalizar

Para añadir nuevos atajos, simplemente sigue el formato existente:

```ahk
^!x::Run, "C:\ruta\a\tu\programa.exe"  ; Ctrl+Alt+X para abrir un programa
#+y::Run, "https://ejemplo.com"         ; Win+Shift+Y para abrir una web
^!z::Run, *RunAs cmd.exe /c "tu_comando",, Hide  ; Ctrl+Alt+Z ejecuta comando en modo admin
``` 