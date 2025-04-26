; Script con funciones reutilizables para PWAs y Apps Normales (AHK v2.0)

#Requires AutoHotkey v2.0

; Verificar y solicitar privilegios de administrador si no los tiene
if (!A_IsAdmin) {
    Run("*RunAs " . A_ScriptFullPath)
    ExitApp
}

; ============================================================
;  Ejecución automática de ExportHotkeysToJSON al inicio (una sola vez)
; ============================================================
; Ejecutar exportación de hotkeys una sola vez al iniciar el script
outFile := A_ScriptDir "\hotkeys.json"
ExportHotkeysToJSON(outFile)  ; Ejecución directa sin temporizador

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
^!s:: ; Ctrl+Alt+G
{
    TogglePWA(
        "Gemini",                                       ; 1. WindowTitle
        "gdfaincndogidkdcdkhapmbffkckdkhn",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}
^!d:: ; Ctrl+Alt+G
{
    TogglePWA(
        "Gemini1-Gemini",                                       ; 1. WindowTitle
        "gbpghmjlagojpokaelpobjahbmcjdcen",             ; 2. AppID (Edge PWA)
        "C:\Users\jewc2\AppData\Local\Google\Chrome Dev\Application\chrome.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "chrome.exe"                                    ; 5. BrowserExeName
    )
}


^!9:: ; Ctrl+Alt+G
{
    TogglePWA(
        "pgAdmin",                                       ; 1. WindowTitle
        "mmcjlcggalaplmfidacllgaceebonibm",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}


; --- Atajo para Gemini PWA (usando TogglePWA) ---
^!f:: ; Ctrl+Alt+D
{
    TogglePWA(
        "ChatGPT",                                       ; 1. WindowTitle
        "cadlkienfkclaiaibeoongdcgmdikeeg",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}
; --- Atajo para Gemini PWA (usando TogglePWA) ---
^+g:: ; ctrl+shift+G
{
    TogglePWA(
        "GitHub",                                       ; 1. WindowTitle
        "mjoklplbddabcmpepnokjaffbmgbkkgg",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath (¡VERIFICAR!)
        "Default",                                      ; 4. BrowserProfile (¡VERIFICAR!)
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}


; Atajo para abrir WebUI usando TogglePWA
^!t:: ; Ctrl+Alt+T
{
    TogglePWA(
        "WebUI",                                        ; 1. WindowTitle
        "diedjfkbcajlkdddmgifccngafkagghl",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath
        "Default",                                      ; 4. BrowserProfile
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}
; Atajo para abrir WebUI usando TogglePWA
^#!x:: ; Ctrl+Alt+T
{
    TogglePWA(
        "3000",                                        ; 1. WindowTitle
        "ogekleedodoolciidllfomibdjippjna",             ; 2. AppID (Edge PWA)
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", ; 3. BrowserPath
        "Default",                                      ; 4. BrowserProfile
        "msedge.exe"                                    ; 5. BrowserExeName
    )
}
; --- Ejemplo: Atajo para Notepad (usando ToggleApp) ---
+!r:: ;* Shift+Alt+R
{
    ; Código para abrir Obsidian con argumentos específicos
    ObsidianPath := "C:\Users\jewc2\AppData\Local\Programs\Obsidian\Obsidian.exe"
    ObsidianArgs := "--vault=MiVault --open-vault --no-gpu"
    
    ; Verifica si Obsidian está abierto para alternar
    WindowCriteria := "Obsidian ahk_exe Obsidian.exe"
    SetTitleMatchMode(2)
    TargetHWND := WinExist(WindowCriteria)
    
    if (TargetHWND) {
        if WinActive("ahk_id " . TargetHWND) {
            WinMinimize("ahk_id " . TargetHWND)
        } else {
            WinActivate("ahk_id " . TargetHWND)
        }
    } else {
        ; Abre Obsidian con argumentos
        Run('"' . ObsidianPath . '" ' . ObsidianArgs)
    }
}
; ===============================================================
; Ctrl+Alt+A → Abre o alterna la ventana de Cursor IDE
; ===============================================================
; ------------------------------------------------------------
; Atajo   : Ctrl + Alt + A
; Función :  
;   1. Si Cursor no está abierto → lo inicia con el directorio deseado.  
;   2. Si la ventana está activa → la minimiza.  
;   3. Si la ventana existe en segundo plano → la enfoca.  
; Nota    : Siempre se pasa el directorio «ProyectoDir» para que Cursor
;           no reabra la última carpeta usada.
; ------------------------------------------------------------
;----------------------------------------------------------
; Función: CursorToggle(Dir)
; Descripción: Alterna la ventana de Cursor usando el identificador de proceso
;----------------------------------------------------------
CursorToggle(Dir) {
    static CursorPath := "C:\Users\jewc2\AppData\Local\Programs\cursor\cursor.exe"
    
    ; Verificar si el directorio existe
    if !DirExist(Dir) {
        MsgBox("El directorio no existe:`n" . Dir, "Error", 16)
        return
    }
    
    ; Buscar la ventana de Cursor por su proceso
    hwnd := WinExist("ahk_exe cursor.exe")

    if (hwnd) {
        if WinActive("ahk_id " . hwnd) {
            WinMinimize("ahk_id " . hwnd)
        } else {
            WinActivate("ahk_id " . hwnd)
        }
    } else {
        ; Si no existe, abrir Cursor en el directorio especificado
        if DirExist(Dir) {
            Run('"' . CursorPath . '" "' . Dir . '"', Dir)
        }
    }
}

;----------------------------------------------------------
; Función: OpenCursor(Dir)
; Descripción: Abre Cursor en el directorio especificado
;----------------------------------------------------------
OpenCursor(Dir) {
    static CursorPath := "C:\Users\jewc2\AppData\Local\Programs\cursor\cursor.exe"
    
    ; Verificar si el directorio existe
    if !DirExist(Dir) {
        MsgBox("El directorio no existe:`n" . Dir, "Error", 16)
        return
    }
    
    ; Abrir Cursor en el directorio especificado
    Run('"' . CursorPath . '" "' . Dir . '"', Dir)
}

;--- Atajos ------------------------------------------------
^!a::
{
    OpenCursor("D:\Users\autohotkey")
    CursorToggle("D:\Users\autohotkey")        ; Ctrl+Alt+A
}
^!w::
{
    OpenCursor("D:\Users\whatsapp_flask")
    CursorToggle("D:\Users\whatsapp_flask")
}
^!e::
{
    OpenCursor("D:\Users\once-ui-design-for-nextjs")
    CursorToggle("D:\Users\once-ui-design-for-nextjs")
}
!+s:: ; Ctrl+Shift+E
{
    OpenCursor("D:\Users\Originsong-1.3")
    CursorToggle("D:\Users\Originsong-1.3")
}
!+d:: ; Ctrl+Shift+E
{
    OpenCursor("D:\Scripts")
    CursorToggle("D:\Scripts")
}

; Bueno, acá debería haber una función que básicamente mapee eh el atajo y hacia dónde me está llevando, ¿okay?
   
#t:: ;
{
    ToggleApp(
        "Warp",  ; Cambiado de "Warp" a "Warp Terminal" que es el título exacto de la ventana
        "D:\Warp\warp.exe",
        "warp.exe"
    )
}

; Atajo para YouTube Music (usando ToggleApp)
^!y:: ; Ctrl+Alt+Y
{
    ToggleApp(
        "YouTube Music",                                ; 1. WindowTitle
        "C:\Users\jewc2\AppData\Local\Programs\youtube-music\YouTube Music.exe", ; 2. AppExePath
        "YouTube Music.exe"                             ; 3. AppExeName
    )
}

#u:: ;
{
    ToggleApp(
        "ChatGPT",  ; Cambiado de "Warp" a "Warp Terminal" que es el título exacto de la ventana
        "C:\Program Files\WindowsApps\OpenAI.ChatGPT-Desktop_1.2025.90.0_x64__2pzpsadc76e0y\app\ChatGPT.exe",
        "ChatGPT.exe"
    )
}

#o:: ;
{
    ToggleApp(
        "WhatsApp",  ; Cambiado de "Warp" a "Warp Terminal" que es el título exacto de la ventana
        "C:\Program Files\WindowsApps\5319275A.51895FA4EA97F_2.2516.2.0_x64__cv1g1gvanyjgm\WhatsApp.exe",
        "WhatsApp.exe"
    )
} 
^#3:: ;
{
    ToggleApp(
        "VYSOR",  ; Cambiado de "Warp" a "Warp Terminal" que es el título exacto de la ventana
        "C:\Users\jewc2\AppData\Local\vysor\Vysor.exe",
        "Vysor.exe"
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


^!v::
{
    Run("*RunAs https://chatgpt.com/")
}

^!2::
{
    Run("*RunAs https://www.youtube.com/")
}

^!3::
{
    Run("*RunAs https://notebooklm.google.com/?_gl=1*179eob1*_ga*MTQ0MzYzMzg4Mi4xNzQ1MTE4NjEw*_ga_W0LDH41ZCB*MTc0NTMxODg1OS4zLjAuMTc0NTMxODg1OS42MC4wLjA.")
}

^!4::
{
    Run("*RunAs https://colab.research.google.com/#create=true")
}

^!#r::
{
    Run("*RunAs https://www.pedidosya.com.pe/")
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

^+!r::
{
    Run("*RunAs https://www.rappi.com.pe/tiendas/54165-rappi-market-nc")
}




^+1:: SendInput(".\venv\Scripts\activate")

















#|::
{
    Reload()
}

; ============================================================
;  Función: ExportHotkeysToJSON
;  ------------------------------------------------------------
;  Descripción (español)
;     • Lee este mismo script (.ahk) y detecta todas las líneas
;       que definen un atajo de teclado ►  «ALGO::»
;     • Construye un JSON estructurado con información detallada
;     • Incluye representación legible de teclas y descripción
;     • Si se pasa una ruta de salida, guarda el archivo JSON.
;     • Retorna el string JSON y lo deja en la variable global
;       LastHotkeysJSON para consultas posteriores.
; ============================================================
ExportHotkeysToJSON(OutputPath := "")
{
    ; 1) Leer el contenido del script
    local script := FileRead(A_ScriptFullPath, "UTF-8")
    
    ; 2) Array donde almacenaremos los atajos detectados con su información
    local hotkeyInfoArr := []
    
    ; 3) Dividir el script en líneas para analizar comentarios
    local scriptLines := StrSplit(script, "`n", "`r")
    local numLines := scriptLines.Length
    
    ; 4) Buscar hotkeys y extraer información relevante
    local i := 1
    while (i <= numLines)
    {
        local line := scriptLines[i]
        local hotkeyMatch := RegExMatch(line, "^[\t ]*([^\s;\/][^:\r\n]+)::", &m)
        
        if (hotkeyMatch)
        {
            local hk := Trim(m[1])
            if (hk = "")  ; Evitar cadenas vacías
            {
                i++
                continue
            }
            
            ; Información básica del hotkey
            local hotkeyInfo := Map()
            hotkeyInfo["hotkey"] := hk
            hotkeyInfo["readable"] := ConvertHotkeyToReadable(hk)
            
            ; Buscar descripción en comentarios previos (hasta 5 líneas anteriores)
            local desc := ""
            local j := Max(1, i - 5)
            while (j < i)
            {
                local prevLine := scriptLines[j]
                if (RegExMatch(prevLine, "^\s*;(.+)$", &comment))
                {
                    desc .= Trim(comment[1]) . " "
                }
                j++
            }
            hotkeyInfo["description"] := Trim(desc)
            
            ; Buscar acción (siguiente línea no vacía después del hotkey)
            local action := ""
            local k := i + 1
            while (k <= numLines && action = "")
            {
                local nextLine := Trim(scriptLines[k])
                if (nextLine != "" && !RegExMatch(nextLine, "^\s*;"))
                {
                    if (RegExMatch(nextLine, "TogglePWA\((.+)", &pwa))
                        action := "Abre PWA"
                    else if (RegExMatch(nextLine, "ToggleApp\((.+)", &app))
                        action := "Abre aplicación"
                    else if (RegExMatch(nextLine, "Run\((.+)", &run))
                        action := "Ejecuta comando"
                    else
                        action := "Acción personalizada"
                }
                k++
            }
            hotkeyInfo["action"] := action
            
            ; Agregar al array
            hotkeyInfoArr.Push(hotkeyInfo)
        }
        i++
    }
    
    ; 5) Convertir a JSON (usando formato más estructurado)
    local json := "["
    for idx, info in hotkeyInfoArr
    {
        json .= "`r`n    {`r`n"
        json .= "        `"hotkey`": `"" . info["hotkey"] . "`",`r`n"
        json .= "        `"readable`": `"" . info["readable"] . "`",`r`n"
        json .= "        `"description`": `"" . info["description"] . "`",`r`n"
        json .= "        `"action`": `"" . info["action"] . "`"`r`n"
        json .= "    }"
        
        if (idx < hotkeyInfoArr.Length)
            json .= ","
    }
    json .= "`r`n]"
    
    ; 6) Guardar a disco si el usuario lo solicitó
    if (OutputPath != "")
    {
        try FileDelete(OutputPath)  ; Ignorar error si no existe
        FileAppend(json, OutputPath, "UTF-8")
    }
    
    global LastHotkeysJSON := json
    return json
}

; ============================================================
;  Función: ConvertHotkeyToReadable
;  ------------------------------------------------------------
;  Convierte la notación de teclas de AHK a formato legible
;  Ejemplo: ^!h -> Ctrl+Alt+H
; ============================================================
ConvertHotkeyToReadable(hotkeyStr)
{
    local result := ""
    local i := 1
    local len := StrLen(hotkeyStr)
    
    while (i <= len)
    {
        local char := SubStr(hotkeyStr, i, 1)
        
        ; Prefijos de modificadores
        if (char = "^")
            result .= "Ctrl+"
        else if (char = "!")
            result .= "Alt+"
        else if (char = "+")
            result .= "Shift+"
        else if (char = "#")
            result .= "Win+"
        else if (char = "*")
            result .= "Cualquier modificador+"
        else if (char = "~")
            result .= "Pasar a través+"
        else if (char = "$")
            result .= "Forzar uso de hook+"
        else if (char = "<^>!")
            result .= "AltGr+"
        else if (char = ">")
            result .= "Derecha+"
        else if (char = "<")
            result .= "Izquierda+"
        else
        {
            ; Teclas especiales
            if (SubStr(hotkeyStr, i) = "Space")
                result .= "Espacio"
            else if (SubStr(hotkeyStr, i) = "Tab")
                result .= "Tab"
            else if (SubStr(hotkeyStr, i) = "Enter")
                result .= "Enter"
            else if (SubStr(hotkeyStr, i) = "Escape" || SubStr(hotkeyStr, i) = "Esc")
                result .= "Escape"
            else if (SubStr(hotkeyStr, i) = "BS" || SubStr(hotkeyStr, i) = "Backspace")
                result .= "Retroceso"
            else if (SubStr(hotkeyStr, i) = "Del" || SubStr(hotkeyStr, i) = "Delete")
                result .= "Suprimir"
            else if (SubStr(hotkeyStr, i) = "Ins" || SubStr(hotkeyStr, i) = "Insert")
                result .= "Insertar"
            else if (SubStr(hotkeyStr, i) = "Home")
                result .= "Inicio"
            else if (SubStr(hotkeyStr, i) = "End")
                result .= "Fin"
            else if (SubStr(hotkeyStr, i) = "PgUp")
                result .= "RePág"
            else if (SubStr(hotkeyStr, i) = "PgDn")
                result .= "AvPág"
            else if (SubStr(hotkeyStr, i) = "CapsLock")
                result .= "Bloq Mayús"
            else if (RegExMatch(SubStr(hotkeyStr, i), "^F(\d+)", &match))
            {
                result .= "F" . match[1]
                i += StrLen(match[0]) - 1
            }
            else
            {
                ; Carácter normal
                result .= Format("{:U}", SubStr(hotkeyStr, i, 1))
            }
            
            ; Si encontramos una tecla, ya no procesamos más caracteres
            break
        }
        
        i++
    }
    
    return result
}

; ------------------------------------------------------------
;  Hotkey:  Ctrl + Alt + H
;  Genera/actualiza «hotkeys.json» en la carpeta del script y
;  muestra el JSON resultante en un MsgBox.|
; ------------------------------------------------------------
^!h::
{
    local outFile := A_ScriptDir "\hotkeys.json"
    local result := ExportHotkeysToJSON(outFile)
    MsgBox("Hotkeys exportados a:`n" . outFile "`n`n" . result, "ExportHotkeysToJSON", 64)
}
; ============================================================
