; ============================================
; Atajos de Teclado para Abrir Sitios Web
; ============================================
^+!1::Run, https://dayinco.en.alibaba.com/es_ES/company_profile/feedback.html?spm=a2700.supplier_search.0.0.5aa072640H7pvO
^!f::Run, https://platform.openai.com/api-keys
^!w::Run, https://business.facebook.com/billing_hub/payment_activity?asset_id=3501802166769630&business_id=&placement=ads_manager&date=1693008000_1695427200
^!v::Run, https://chat.openai.com/chat
^!z::Run, https://academy.langchain.com/courses/take/intro-to-langgraph/lessons/58239986-module-4-introduction
^!g::Run, https://gemini.google.com/app
^!x::Run, https://admin.shopify.com/store/5724fa
^!e::Run, https://admissions.emeritus.org/classroom/login
^!l::Run, https://business.facebook.com/commerce/catalogs/780959946846822/home?business_id=1330267117921522
^!#1::Run, https://www.facebook.com/marketplace/?ref=app_tab
^!6::Run, https://www.workana.com/my_projects?type_company=employer&ref=menu_user_projects
^!7::Run, https://www.tiktok.com/messages
^!8::Run, https://web.whatsapp.cgom/
^!k::Run, https://flowise-liy3.onrender.com
^!2::Run, https://www.youtube.com/
^!9::Run, https://www.appsheet.com/start/f6a3ac0e-e3e7-43a7-ab7b-10f6b32949c0?platform=desktop#viewStack[0][identifier][Type]=Control&viewStack[0][identifier][Name]=Gastos&appName=CantonFair-382915323
^!j::Run, https://dashboard.chatfuel.com/bot/64fdfe85f488632953f54c92/livechat?folder=all
^+1::Run, https://swift-ai-voice-assistant-quyh2kr94-jewc20009s-projects.vercel.app/openai
#^+j::Run, https://www.w3schools.com/js/js_intro.asp ; JAVASCRIPT
^+3::Run, https://nextui.org/docs/guide/introduction ; NexUi
#+l::Run, https://www.w3schools.com/python/python_intro.asp ; PYTHON
^+4::Run, https://www.w3schools.com/sql/sql_intro.asp ; SQL
^#r::Run, https://www.w3schools.com/js/js_reserved.asp ; Palabras reservadas
#+1::Run, https://platform.openai.com/settings/profile?tab=api-keys
#+j::Run, https://platform.openai.com/usage/activity
#+2::Run, https://tinyurl.com/25g2hwm6
^+j::SendInput, https://r.jina.ai/
#!v::Run, https://www.pinterest.com/pin/60376451247791711/
^!i::Run, https://us1.make.com/organization/1221534/dashboard
^!s::Run, https://e-menu.sunat.gob.pe/cl-ti-itmenu/MenuInternet.htm?pestana=*&agrupacion=*
^!n::Run, http://www.aduanet.gob.pe/itarancel/arancelS01Alias
^!y::Run, http://www.aduanet.gob.pe/cl-ad-itconsultadwh/ieITS01Alias?accion=consultar&CG_consulta=2
^!u::Run, http://www.aduanet.gob.pe/aduanas/informao/HR10Poliza.htm
^!m::Run, http://www.aduanet.gob.pe/cl-ad-itestadispartida/resumenPPaisS01Alias
^!0::
    KeyWait, 1, D
    Run, https://www.messenger.com/marketplace/t/100092880731300
return
^!3::Run, https://message.alibaba.com/message/messenger.htm?activeAccountId=251826360&activeAccountIdEncrypt=MC1IDX1hTK8iGcAG9N6MYHqdRLZAcvSwS--_dU9gXZxE2xCILy-OlEMEODFdscvip-j784i#/
#|::Reload ; Recarga este script

; ============================================
; Atajos de Teclado para Ejecutar Aplicaciones Locales
; ============================================

^!a::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Autohotkeyescritorio.ahk"
^!b::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "C:\Users\jewc2\2024_08_30_jdeepseek_end_point"
^!h::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "D:\Proyectos\assistant-principal"
^!1::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" -n "C:\Users\jewc2\renovado4"
^!c::Run, "C:\Program Files\Google\Chrome\Application\chrome.exe"
^!5::Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Aplicaciones de Chrome\Odoo.lnk"
^!space::Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk"
#+3::Run, "C:\Users\jewc2\Harmonykicks\Orisong"
#+4::Run, "C:\Users\jewc2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Vysor Inc\Vysor.lnk"
#+5::Run, "C:\Apporisong\GeneratedExcels"
#+6::Run, "C:\Users\jewc2\OneDrive\Documentos\Importación de zapatillas\Segundo viaje a China"
#!t::Run, "D:\Scripts\turbo.bat"
!+r::Run, "C:\Program Files\Obsidian\Obsidian.exe"
^!t::Run, "C:\Users\jewc2\AppData\Local\Programs\cursor\Cursor.exe" --new-window --command="terminal"

; ============================================
; Atajos de Teclado para Enviar Texto
; ============================================

#+7:: ; Ctrl + Shift + 7 para insertar la fecha actual
    FormatTime, TodayDate, , yyyy_MM_dd
    SendInput, %TodayDate%
return

#+|:: ; Ctrl + Shift + | para insertar la fecha y hora actuales
    FormatTime, TodayDateTime, , yyyy_MM_dd HH:mm:ss
    SendInput, %TodayDateTime%
return

; ============================================
; Atajo de Teclado para Copiar y Enviar Contenido al Navegador
; ============================================



; ============================================
; Atajos para Microsoft Edge con Configuraciones Específicas
; ============================================


^+e::Run, "C:\WINDOWS\system32\wsl.exe"

^+q::Run, "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.22.2912.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe"
return
; ... código existente ...

; En la sección de Aplicaciones Locales

; ... resto del código ...