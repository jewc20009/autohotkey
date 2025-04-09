; Script para lanzar/activar/minimizar Gemini PWA (Edge) con Ctrl+Alt+G (Versión AHK v2.0)

#Requires AutoHotkey v2.0 ; Asegura que se ejecute con v2

^!g:: ; Define el atajo: ^ es Ctrl, ! es Alt, g es la tecla G
{
    static TargetWindowTitle := "Gemini" ; Define el título a buscar (¡ASEGÚRATE DE QUE COINCIDA!)
    static TargetAppID := "gdfaincndogidkdcdkhapmbffkckdkhn" ; El ID de tu PWA de Edge
    static EdgePath := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" ; Ruta a Edge (¡VERIFICA ESTO!)
    static EdgeProfile := "Default" ; Perfil de Edge (puede ser "Profile 1", etc.)
    
    ; Criterio para encontrar la ventana (usa el App ID si es posible para más precisión)
    ; A veces las PWAs tienen títulos predecibles, otras veces es mejor usar ahk_exe msedge.exe y filtrar por título o AppID si AHK lo permite fácilmente.
    ; Por simplicidad, seguimos buscando por título "Gemini", pero tenlo en cuenta.
    SetTitleMatchMode(2) ; Busca el título en cualquier parte
    TargetHWND := WinExist(TargetWindowTitle . " ahk_exe msedge.exe") ; Busca ventana con "Gemini" cuyo ejecutable sea msedge.exe

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
    }
    else ; Si no existe ninguna ventana de Gemini PWA
    {
        ; --- ESTA ES LA LÍNEA CLAVE ACTUALIZADA ---
        Run('"' . EdgePath . '" --app-id=' . TargetAppID . ' --profile-directory=' . EdgeProfile)
        ; --- FIN DE LA LÍNEA ACTUALIZADA ---
    }
}