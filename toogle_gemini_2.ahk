; Script con funciones reutilizables para PWAs y Apps Normales (AHK v2.0)

#Requires AutoHotkey v2.0

; Auto-copy script to Startup folder on load/reload
CopyToStartup()

; Función para copiar el script a la carpeta de inicio
CopyToStartup() {
    startupPath := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\comandos.ahk"
    
    ; Copia el script actual a la carpeta de inicio
    try {
        FileCopy(A_ScriptFullPath, startupPath, true)  ; true es para sobrescribir
    } catch Error as e {
        MsgBox("Error al copiar el archivo: " . e.Message)
        return
    }
    
    ; Si el script en ejecución no es el de desarrollo, recarga el de la carpeta de inicio
    if (A_ScriptFullPath != startupPath) {
        ; Intenta recargar el script de la carpeta de inicio si está en ejecución
        DetectHiddenWindows(true)
        scriptPID := WinExist("ahk_class AutoHotkey ahk_exe AutoHotkey.exe")
        if (scriptPID) {
            ; Envía un mensaje WM_COMMAND con el comando de recarga (65303)
            PostMessage(0x111, 65303, 0, , "ahk_id " scriptPID)
        }
    }
}


#|:: { ;* Atajo para copiar el script a la carpeta de StartUp y recargar
    CopyToStartup()
    Reload  ; Recarga este script
}

; ================================================================
; Función Reutilizable "TogglePWA" (PARA PWAs - sin cambios)
; ================================================================
TogglePWA(WindowTitle, AppID, BrowserPath, BrowserProfile, BrowserExeName)
{
    WindowCriteria := WindowTitle . " ahk_exe " . BrowserExeName
    SetTitleMatchMode(2)
    TargetHWND := WinExist(WindowCriteria)
    if (TargetHWND) {
        if WinActive("ahk_id " . TargetHWND) {
            WinMinimize("ahk_id " . TargetHWND)
        } else {
            WinActivate("ahk_id " . TargetHWND)
        }
        Return true
    } else {
        RunCommand := '"' . BrowserPath . '" --app-id=' . AppID . ' --profile-directory=' . BrowserProfile
        Try {
            Run("*RunAs " . RunCommand)
            Return true
        } Catch Error as e {
            MsgBox("Error al lanzar la PWA: " . WindowTitle . "`nComando: " . RunCommand . "`nError: " . e.Message, "Error de Lanzamiento", 16)
            Return false
        }
    }
}

; ================================================================
; Función Reutilizable "ToggleApp" (PARA APPS NORMALES)
; ================================================================
ToggleApp(WindowTitle, AppExePath, AppExeName)
{
    WindowCriteria := WindowTitle . " ahk_exe " . AppExeName
    
    SetTitleMatchMode(2) ; Busca el título en cualquier parte
    TargetHWND := WinExist(WindowCriteria) ; Intenta encontrar la ventana

    if (TargetHWND) ; Si la ventana existe
    {
        if WinActive("ahk_id " . TargetHWND) ; Si la ventana encontrada ya está activa
        {
            WinMinimize("ahk_id " . TargetHWND) ; La minimiza
        }
        else
        {
            WinActivate("ahk_id " . TargetHWND) ; Si existe pero no está activa, la activa (trae al frente)
        }
        Return true ; Indica que se encontró/gestionó la ventana existente
    }
    else ; Si no existe ninguna ventana de la aplicación
    {
        ; Verifica si la ruta al ejecutable existe antes de intentar lanzarlo
        if !FileExist(AppExePath) {
            MsgBox("No se encontró el archivo ejecutable:`n" . AppExePath, "Error de Ruta", 16)
            Return false
        }
        
        ; Construye el comando para lanzar la aplicación estándar
        RunCommand := '"' . AppExePath . '"' ; Solo necesita la ruta al .exe entre comillas
        
        Try ; Intenta ejecutar el comando Run
        {
            Run("*RunAs " . RunCommand)
            Return true ; Indica que se intentó lanzar
        }
        Catch Error as e
        {
            MsgBox("Error al lanzar la aplicación: " . WindowTitle . "`nComando: " . RunCommand . "`nError: " . e.Message, "Error de Lanzamiento", 16)
            Return false ; Indica que hubo un error al lanzar
        }
    }
}

; ================================================================
; Definición de Atajos de Teclado (Hotkeys)
; ================================================================

; --- Atajo para Gemini PWA (usando TogglePWA) ---
^!g:: ; Ctrl+Alt+G
{
    TogglePWA(
        "Gemini",                                       ; 1. WindowTitle
        "gdfaincndogidkdcdkhapmbffkckdkhn",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}

; --- Ejemplo: Atajo para Notepad (usando ToggleApp) ---
+!r:: ;* Shift+Alt+R
{
    ToggleApp(
        "Obsidian",                                ; 1. WindowTitle (o "Notepad" si tu sistema está en inglés) ¡VERIFICAR!
        "C:\Users\jewc2\AppData\Local\Programs\Obsidian\Obsidian.exe",              ; 2. AppExePath (Ruta estándar, usualmente correcta)
        "Obsidian.exe"                                   ; 3. AppExeName
    )
}

#t:: ;
{
    ToggleApp(
        "Warp Terminal",  ; Cambiado de "Warp" a "Warp Terminal" que es el título exacto de la ventana
        "D:\Warp\warp.exe",
        "warp.exe"
    )
}

#y:: ; Atajo para ejecutar turbo2.bat en modo administrador
{
    Run("*RunAs D:\Scripts\scripts\turbo2.bat", , "RunAs")
}
; --- Ejemplo: Atajo para Calculadora (usando ToggleApp) ---
;^!c:: ; Ctrl+Alt+C
;{
;    ToggleApp(
;        "Calculadora",                                  ; 1. WindowTitle ¡VERIFICAR!
;        "C:\Windows\System32\calc.exe",                 ; 2. AppExePath (Ruta estándar, usualmente correcta)
;        "calc.exe"                                      ; 3. AppExeName
;    )
;}

; ============================================
; Atajos de Teclado para Abrir Sitios Web
; ============================================
^!f::
{
    Run("*RunAs https://platform.openai.com/api-keys")
}

^!v::
{
    Run("*RunAs https://chatgpt.com/")
}

^!2::
{
    Run("*RunAs https://www.youtube.com/")
}

!g:: ;* Atajo para abrir la documentación de LangChain en el navegador
{
    Run("*RunAs https://python.langchain.com/docs/introduction/")
}

#j::
{
    Run("*RunAs https://langchain-ai.github.io/langgraph/")
}

+!3::
{
    Run("*RunAs https://gemini.google.com/app")
}

^!r::
{
    Run("*RunAs https://www.rappi.com.pe/tiendas/54165-rappi-market-nc")
}
