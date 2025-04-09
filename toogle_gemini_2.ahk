; Script con funciones reutilizables para PWAs y Apps Normales (AHK v2.0)

#Requires AutoHotkey v2.0

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
            Run(RunCommand)
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
            Run(RunCommand)
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
        "Bloc de notas",                                ; 1. WindowTitle (o "Notepad" si tu sistema está en inglés) ¡VERIFICAR!
        "C:\Users\jewc2\AppData\Local\Programs\Obsidian\Obsidian.exe",              ; 2. AppExePath (Ruta estándar, usualmente correcta)
        "Obsidian.exe"                                   ; 3. AppExeName
    )
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