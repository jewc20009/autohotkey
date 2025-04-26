import os
import sys
import subprocess
import json
import ctypes
import threading
import time
import asyncio
import signal # For handling shutdown gracefully

# Third-party libraries (ensure installed: pip install pynput pygetwindow psutil)
try:
    from pynput import keyboard
    import pygetwindow
    import psutil
except ImportError as e:
    print(f"Error: Missing required library. Please install it: pip install {e.name}")
    sys.exit(1)

# ============================================================
#  Configuration de Hotkeys
# ============================================================
# Define aquí todos los hotkeys y sus acciones correspondientes.
HOTKEYS_CONFIG = [
    {
        "pynput_hotkey": "<ctrl>+<alt>+s",
        "readable": "Ctrl+Alt+S",
        "description": "Alternar PWA Gemini",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "Gemini",
            "app_id": "gdfaincndogidkdcdkhapmbffkckdkhn",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+9",
        "readable": "Ctrl+Alt+9",
        "description": "Alternar PWA pgAdmin",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "pgAdmin",
            "app_id": "mmcjlcggalaplmfidacllgaceebonibm",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+d",
        "readable": "Ctrl+Alt+D",
        "description": "Alternar PWA ChatGPT",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "ChatGPT",
            "app_id": "cadlkienfkclaiaibeoongdcgmdikeeg",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<shift>+g",
        "readable": "Ctrl+Shift+G",
        "description": "Alternar PWA GitHub",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "GitHub",
            "app_id": "mjoklplbddabcmpepnokjaffbmgbkkgg",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+t",
        "readable": "Ctrl+Alt+T",
        "description": "Alternar PWA WebUI",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "WebUI",
            "app_id": "diedjfkbcajlkdddmgifccngafkagghl",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+<shift>+x", # ^#!x -> Ctrl+Alt+Shift+X
        "readable": "Ctrl+Alt+Shift+X",
        "description": "Alternar PWA localhost:3000",
        "action_type": "toggle_pwa",
        "args": {
            "window_title": "3000", # Title might be different, adjust if needed
            "app_id": "ogekleedodoolciidllfomibdjippjna",
            "browser_path": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "browser_profile": "Default",
            "browser_exe_name": "msedge.exe"
        }
    },
     {
        "pynput_hotkey": "<shift>+<alt>+r",
        "readable": "Shift+Alt+R",
        "description": "Alternar Obsidian",
        "action_type": "toggle_app_with_args", # Usa la nueva lógica
        "args": {
            "window_title": "Obsidian",
            "app_exe_path": r"C:\Users\jewc2\AppData\Local\Programs\Obsidian\Obsidian.exe",
            "app_exe_name": "Obsidian.exe",
            "app_args": ["--vault=MiVault", "--open-vault", "--no-gpu"] # Arguments as a list
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+a",
        "readable": "Ctrl+Alt+A",
        "description": "Alternar Cursor IDE (autohotkey dir)",
        "action_type": "cursor_toggle", # Esta ya tenía la lógica de lanzar primero
        "args": {"dir": r"D:\Users\autohotkey"}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+w",
        "readable": "Ctrl+Alt+W",
        "description": "Alternar Cursor IDE (whatsapp_flask dir)",
        "action_type": "cursor_toggle", # Esta ya tenía la lógica de lanzar primero
        "args": {"dir": r"D:\Users\whatsapp_flask"}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+e",
        "readable": "Ctrl+Alt+E",
        "description": "Alternar Cursor IDE (cuaderno_pynput dir)",
        "action_type": "cursor_toggle", # Esta ya tenía la lógica de lanzar primero
        "args": {"dir": r"D:\Users\cuaderno_pynput"}
    },
    {
        "pynput_hotkey": "<alt>+<shift>+s", # !+s -> Alt+Shift+S
        "readable": "Alt+Shift+S",
        "description": "Alternar Cursor IDE (Originsong-1.3 dir)",
        "action_type": "cursor_toggle", # Esta ya tenía la lógica de lanzar primero
        "args": {"dir": r"D:\Users\Originsong-1.3"}
    },
    {
        "pynput_hotkey": "<cmd>+t", # #t -> Win+T
        "readable": "Win+T",
        "description": "Alternar Warp Terminal",
        "action_type": "toggle_app", # Usa la nueva lógica
        "args": {
            "window_title": "Warp", # Adjust if the title is different
            "app_exe_path": r"D:\Warp\warp.exe", # Assuming this is the correct path
            "app_exe_name": "warp.exe"
        }
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+y",
        "readable": "Ctrl+Alt+Y",
        "description": "Alternar YouTube Music",
        "action_type": "toggle_app", # Usa la nueva lógica
        "args": {
            "window_title": "YouTube Music",
            "app_exe_path": r"C:\Users\jewc2\AppData\Local\Programs\youtube-music\YouTube Music.exe",
            "app_exe_name": "YouTube Music.exe"
        }
    },
    {
        "pynput_hotkey": "<cmd>+u", # #u -> Win+U
        "readable": "Win+U",
        "description": "Alternar ChatGPT Desktop App",
        "action_type": "toggle_app", # Usa la nueva lógica
        "args": {
            "window_title": "ChatGPT", # Check exact window title
            "app_exe_path": r"C:\Program Files\WindowsApps\OpenAI.ChatGPT-Desktop_1.2025.90.0_x64__2pzpsadc76e0y\app\ChatGPT.exe", # Path might change/need adjustment
            "app_exe_name": "ChatGPT.exe" # Check process name in Task Manager
        }
    },
    {
        "pynput_hotkey": "<cmd>+o", # #o -> Win+O
        "readable": "Win+O",
        "description": "Alternar WhatsApp Desktop App",
        "action_type": "toggle_app", # Usa la nueva lógica
        "args": {
            "window_title": "WhatsApp", # Check exact window title
            "app_exe_path": r"C:\Program Files\WindowsApps\5319275A.51895FA4EA97F_2.2516.2.0_x64__cv1g1gvanyjgm\WhatsApp.exe", # Path might change/need adjustment
            "app_exe_name": "WhatsApp.exe" # Check process name in Task Manager
        }
    },
     {
        "pynput_hotkey": "<ctrl>+<cmd>+3", # ^#3 -> Ctrl+Win+3
        "readable": "Ctrl+Win+3",
        "description": "Alternar Vysor",
        "action_type": "toggle_app", # Usa la nueva lógica
        "args": {
            "window_title": "Vysor", # Check exact window title
            "app_exe_path": r"C:\Users\jewc2\AppData\Local\vysor\Vysor.exe",
            "app_exe_name": "Vysor.exe"
        }
    },
    {
        "pynput_hotkey": "<cmd>+y", # #y -> Win+Y
        "readable": "Win+Y",
        "description": "Ejecutar turbo2.bat como Admin",
        "action_type": "run_elevated",
        "args": {"command": r"D:\Scripts\scripts\turbo2.bat"}
    },
    # --- Web URLs (Estos solo abren, no alternan) ---
    {
        "pynput_hotkey": "<ctrl>+<alt>+f",
        "readable": "Ctrl+Alt+F",
        "description": "Abrir OpenAI API Keys",
        "action_type": "open_url",
        "args": {"url": "https://platform.openai.com/api-keys"}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+v",
        "readable": "Ctrl+Alt+V",
        "description": "Abrir ChatGPT Web",
        "action_type": "open_url",
        "args": {"url": "https://chatgpt.com/"}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+2",
        "readable": "Ctrl+Alt+2",
        "description": "Abrir Google User Content (YouTube?)",
        "action_type": "open_url",
        "args": {"url": "https://www.youtube.com/"} # Check this URL
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+3",
        "readable": "Ctrl+Alt+3",
        "description": "Abrir NotebookLM",
        "action_type": "open_url",
        "args": {"url": "https://notebooklm.google.com/"} # Simplified URL
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+4",
        "readable": "Ctrl+Alt+4",
        "description": "Abrir Google Colab (Nuevo)",
        "action_type": "open_url",
        "args": {"url": "https://colab.research.google.com/#create=true"}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+<cmd>+r", # ^!#r -> Ctrl+Alt+Win+R
        "readable": "Ctrl+Alt+Win+R",
        "description": "Abrir PedidosYa Perú",
        "action_type": "open_url",
        "args": {"url": "https://www.pedidosya.com.pe/"}
    },
    {
        "pynput_hotkey": "<alt>+g", # !g -> Alt+G
        "readable": "Alt+G",
        "description": "Abrir LangChain Docs",
        "action_type": "open_url",
        "args": {"url": "https://python.langchain.com/docs/introduction/"}
    },
    {
        "pynput_hotkey": "<cmd>+j", # #j -> Win+J
        "readable": "Win+J",
        "description": "Abrir LangGraph Docs",
        "action_type": "open_url",
        "args": {"url": "https://langchain-ai.github.io/langgraph/"}
    },
    {
        "pynput_hotkey": "<shift>+<alt>+3", # +!3 -> Shift+Alt+3
        "readable": "Shift+Alt+3",
        "description": "Abrir Gemini App",
        "action_type": "open_url",
        "args": {"url": "https://gemini.google.com/app"}
    },
    {
        "pynput_hotkey": "<ctrl>+<shift>+<alt>+r", # ^+!r -> Ctrl+Shift+Alt+R
        "readable": "Ctrl+Shift+Alt+R",
        "description": "Abrir Rappi Market",
        "action_type": "open_url",
        "args": {"url": "https://www.rappi.com.pe/tiendas/54165-rappi-market-nc"}
    },
    # --- Meta Actions ---
    {
        "pynput_hotkey": "<cmd>+\\", # #| -> Win+\ (Backslash often needs escaping)
        "readable": "Win+\\",
        "description": "Recargar Script (Simulado)",
        "action_type": "reload_script",
        "args": {}
    },
    {
        "pynput_hotkey": "<ctrl>+<alt>+h",
        "readable": "Ctrl+Alt+H",
        "description": "Exportar Hotkeys a JSON",
        "action_type": "export_hotkeys",
        "args": {"output_path": "hotkeys.json"}
    },
]

# Global variable to hold the listener instance and event loop reference
current_listener = None
main_loop = None
listener_thread = None
stop_event = asyncio.Event() # Used to signal shutdown

# ============================================================
#  Funciones Auxiliares (Administrador, Ventanas - Async Wrappers)
# ============================================================

def _is_admin_sync():
    """ Synchronous check for admin privileges. """
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False

async def is_admin():
    """ Async wrapper for admin check. """
    return await asyncio.to_thread(_is_admin_sync)

def _run_as_admin_sync():
    """ Synchronous relaunch as admin. """
    if sys.platform == 'win32':
        try:
            ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
            return True
        except Exception as e:
            print(f"Error al intentar elevar privilegios: {e}")
            return False
    else:
        print("La elevación de privilegios automática solo es compatible con Windows.")
        return False

async def run_as_admin():
    """ Async wrapper for relaunching as admin. """
    return await asyncio.to_thread(_run_as_admin_sync)


def _find_window_sync(title_part, exe_name, retry_delay=0.2, max_retries=3):
    """ Synchronous version of find_window. """
    target_exe_lower = exe_name.lower()
    for attempt in range(max_retries):
        try:
            # Prioritize finding by title + exe first
            potential_windows = pygetwindow.getWindowsWithTitle(title_part)
            if potential_windows:
                for window in potential_windows:
                    if not window.visible: continue
                    try:
                        hwnd = window._hWnd
                        pid = ctypes.c_ulong()
                        ctypes.windll.user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
                        if pid.value == 0: continue
                        process = psutil.Process(pid.value)
                        if process.name().lower() == target_exe_lower:
                            if window.width > 50 and window.height > 50:
                                return window # Found match by title + exe
                    except (psutil.NoSuchProcess, psutil.AccessDenied, pygetwindow.PyGetWindowException, AttributeError, Exception):
                        continue # Ignore errors for individual windows

            # Fallback: Find *any* visible window by exe name if title match failed
            all_windows = pygetwindow.getAllWindows()
            for window in all_windows:
                if not window.visible: continue
                try:
                    hwnd = window._hWnd
                    pid = ctypes.c_ulong()
                    ctypes.windll.user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
                    if pid.value == 0: continue
                    process = psutil.Process(pid.value)
                    if process.name().lower() == target_exe_lower:
                         if window.width > 50 and window.height > 50:
                            # Return the first visible, reasonably sized window matching the exe
                            return window
                except (psutil.NoSuchProcess, psutil.AccessDenied, pygetwindow.PyGetWindowException, AttributeError, Exception):
                    continue # Ignore errors for individual windows

            # If not found, wait and retry (synchronous sleep here)
            if attempt < max_retries - 1:
                time.sleep(retry_delay)

        except Exception as e:
            print(f"Error buscando ventana '{title_part}' ({exe_name}) en intento {attempt+1}: {e}")
            if attempt < max_retries - 1:
                time.sleep(retry_delay)

    print(f"Ventana '{title_part}' ({exe_name}) no encontrada después de {max_retries} intentos.")
    return None # No suitable window found after retries

async def find_window(title_part, exe_name, retry_delay=0.2, max_retries=3):
    """
    Async wrapper for finding a window. Uses asyncio.sleep for retries.
    Runs the blocking pygetwindow/psutil calls in a thread.
    """
    for attempt in range(max_retries):
        window = await asyncio.to_thread(_find_window_sync, title_part, exe_name, 0, 1) # No internal retry/sleep
        if window:
            return window
        if attempt < max_retries - 1:
            # print(f"Ventana '{title_part}' ({exe_name}) no encontrada, reintentando...")
            await asyncio.sleep(retry_delay) # Async sleep

    print(f"Ventana '{title_part}' ({exe_name}) no encontrada después de {max_retries} intentos (async).")
    return None


def _toggle_window_sync(window):
    """ Synchronous version of toggle_window. """
    if not window:
        print("Error: Se intentó alternar una ventana nula.")
        return
    try:
        # Check if the window handle is still valid before interacting
        if not ctypes.windll.user32.IsWindow(window._hWnd):
             print(f"Advertencia: La ventana '{getattr(window, 'title', 'Desconocido')}' ya no existe.")
             return

        # Check visibility again, might have closed between find and toggle
        # Need to re-fetch the window object potentially if state changed significantly
        # For simplicity, assume the handle is enough for basic checks/actions
        current_title = getattr(window, 'title', 'Desconocido') # Store title before potential error

        # Re-check visibility using the handle if possible
        is_visible = ctypes.windll.user32.IsWindowVisible(window._hWnd)
        if not is_visible:
            print(f"Advertencia: La ventana '{current_title}' ya no es visible (handle check).")
            return

        # Use window properties if available and seem valid
        is_active = False
        is_minimized = False
        try:
            is_active = window.isActive
            is_minimized = window.isMinimized
        except pygetwindow.PyGetWindowException:
             print(f"Advertencia: No se pudo obtener el estado (activo/minimizado) de la ventana '{current_title}'. Intentando alternar de todos modos.")
             # Try activating forcefully as a fallback
             try:
                ctypes.windll.user32.SetForegroundWindow(window._hWnd)
             except Exception as fg_err:
                print(f"Error: Falló SetForegroundWindow forzosamente para '{current_title}': {fg_err}")
             return # Stop here if basic state check fails

        if is_active:
            print(f"Minimizando: {current_title}")
            window.minimize()
        else:
            print(f"Activando: {current_title}")
            # Restore if minimized, then activate
            if is_minimized:
                window.restore()
                time.sleep(0.1) # Short delay helps ensure restore completes
            window.activate()
            time.sleep(0.05) # Another small delay after activate can help
            # Optional: Bring window to foreground forcefully if activate is unreliable
            try:
                ctypes.windll.user32.SetForegroundWindow(window._hWnd)
            except Exception as fg_err:
                print(f"Advertencia: Falló SetForegroundWindow para '{current_title}': {fg_err}")

    except pygetwindow.PyGetWindowException as e:
        print(f"Error de PyGetWindow al alternar ventana '{getattr(window, 'title', 'Desconocido')}': {e}")
    except AttributeError:
         print(f"Error: El objeto de ventana '{getattr(window, 'title', 'Desconocido')}' parece inválido.")
    except Exception as e:
        print(f"Error inesperado al alternar ventana '{getattr(window, 'title', 'Desconocido')}': {e}")

async def toggle_window(window):
    """ Async wrapper for toggling a window. Runs in thread. """
    if not window:
        print("Error async: Se intentó alternar una ventana nula.")
        return
    await asyncio.to_thread(_toggle_window_sync, window)


# ============================================================
#  Funciones de Acción para Hotkeys (Async)
# ============================================================

def _run_command_elevated_sync(command):
    """ Synchronous execution of elevated command. """
    print(f"Ejecutando comando elevado (sync): {command}")
    try:
        ret = ctypes.windll.shell32.ShellExecuteW(None, "runas", command, None, None, 1)
        if ret <= 32:
             print(f"Error al ejecutar comando elevado (Código: {ret}): {command}")
    except Exception as e:
        print(f"Excepción al ejecutar comando elevado '{command}': {e}")

async def run_command_elevated(**kwargs):
    """ Async wrapper for running elevated command. """
    command = kwargs['command']
    print(f"Ejecutando comando elevado (async): {command}")
    await asyncio.to_thread(_run_command_elevated_sync, command)


async def launch_pwa(browser_path, app_id, profile):
    """ Asynchronously launches the PWA using asyncio.create_subprocess_shell. """
    if not os.path.exists(browser_path):
        print(f"Error: No se encontró el ejecutable del navegador: {browser_path}")
        return False
    command = f'"{browser_path}" --app-id={app_id} --profile-directory={profile}'
    print(f"Intentando lanzar PWA (async): {command}")
    try:
        # Launch and forget, don't wait for it to finish
        process = await asyncio.create_subprocess_shell(command)
        print(f"PWA process started (PID: {process.pid})")
        return True
    except Exception as e:
        print(f"Error al lanzar PWA (async): {e}")
        return False

async def launch_app(exe_path, args=None):
    """ Asynchronously launches the App using asyncio.create_subprocess_exec. """
    if not os.path.exists(exe_path):
        print(f"Error: No se encontró el ejecutable de la app: {exe_path}")
        return False

    command_list = [exe_path] + (args if args else [])
    print(f"Intentando lanzar App (async): {' '.join(command_list)}")
    try:
        # Launch and forget
        process = await asyncio.create_subprocess_exec(*command_list)
        print(f"App process started (PID: {process.pid})")
        return True
    except Exception as e:
        print(f"Error al lanzar App (async): {e}")
        return False

# --- Acciones Toggle Async ---

async def toggle_pwa_action(**kwargs):
    """ (Async) Siempre intenta lanzar la PWA, luego busca y alterna. """
    title = kwargs['window_title']
    app_id = kwargs['app_id']
    browser_path = kwargs['browser_path']
    profile = kwargs['browser_profile']
    exe_name = kwargs['browser_exe_name']

    print(f"Acción TogglePWA (Async): {title}")
    await launch_pwa(browser_path, app_id, profile)

    # Espera un poco para que la ventana aparezca si se acaba de lanzar
    await asyncio.sleep(0.03) # Slightly longer delay might be needed for async launch
    window = await find_window(title, exe_name)
    if window:
        await toggle_window(window)
    else:
        print(f"No se pudo encontrar/alternar la ventana PWA '{title}' después de lanzar (async).")


async def toggle_app_action(**kwargs):
    """ (Async) Siempre intenta lanzar la App, luego busca y alterna. """
    title = kwargs['window_title']
    exe_path = kwargs['app_exe_path']
    exe_name = kwargs['app_exe_name']

    print(f"Acción ToggleApp (Async): {title}")
    await launch_app(exe_path)

    # Espera un poco y luego intenta encontrar y alternar
    await asyncio.sleep(0.35)
    window = await find_window(title, exe_name)
    if window:
        await toggle_window(window)
    else:
        print(f"No se pudo encontrar/alternar la ventana App '{title}' después de lanzar (async).")

async def toggle_app_with_args_action(**kwargs):
    """ (Async) Siempre intenta lanzar la App con args, luego busca y alterna. """
    title = kwargs['window_title']
    exe_path = kwargs['app_exe_path']
    exe_name = kwargs['app_exe_name']
    app_args = kwargs.get('app_args', [])

    print(f"Acción ToggleAppWithArgs (Async): {title}")
    await launch_app(exe_path, app_args)

    # Espera un poco y luego intenta encontrar y alternar
    await asyncio.sleep(0.35)
    window = await find_window(title, exe_name)
    if window:
        await toggle_window(window)
    else:
        print(f"No se pudo encontrar/alternar la ventana App '{title}' con args después de lanzar (async).")


async def cursor_toggle_action(**kwargs):
    """ (Async) Alterna Cursor: Lanza en dir específico, luego busca y alterna. """
    target_dir = kwargs['dir']
    cursor_exe_path = r"C:\Users\jewc2\AppData\Local\Programs\cursor\cursor.exe"
    cursor_exe_name = "cursor.exe"

    print(f"Acción CursorToggle (Async): Lanzando en {target_dir}, luego alternando.")

    # 1. Intentar lanzar Cursor en el directorio específico (async)
    if not os.path.exists(cursor_exe_path):
        print(f"Error: No se encontró el ejecutable de Cursor: {cursor_exe_path}")
    elif not os.path.isdir(target_dir):
        print(f"Error: El directorio no existe: {target_dir}")
    else:
        # Note: create_subprocess_exec doesn't directly support 'cwd' like Popen.
        # Launching with the directory as an argument is typical for editors.
        await launch_app(cursor_exe_path, [target_dir])

    # 2. Esperar un poco y luego buscar *cualquier* ventana de Cursor y alternarla
    await asyncio.sleep(0.35)
    # Usamos un título genérico o incluso solo el exe para encontrar *alguna* ventana
    window = await find_window("Cursor", cursor_exe_name) # Busca "Cursor" o cualquier ventana de cursor.exe
    if window:
        print(f"Encontrada ventana de Cursor: {window.title}")
        await toggle_window(window)
    else:
        print("No se encontró ninguna ventana de Cursor para alternar después de lanzar (async).")

def _open_url_sync(url):
    """ Synchronous URL opening. """
    print(f"Abriendo URL (sync): {url}")
    try:
        if sys.platform == 'win32':
            os.startfile(url)
        elif sys.platform == 'darwin':
            subprocess.Popen(['open', url])
        else:
            subprocess.Popen(['xdg-open', url])
    except Exception as e:
        print(f"Error al abrir URL '{url}': {e}")

async def open_url_action(**kwargs):
    """ (Async) Opens a URL in the default web browser. """
    url = kwargs['url']
    print(f"Abriendo URL (async): {url}")
    await asyncio.to_thread(_open_url_sync, url)

def _export_hotkeys_sync(output_path):
    """ Synchronous hotkey export. """
    # Use __file__ to get the directory of the currently running script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    full_path = os.path.join(script_dir, output_path)

    print(f"Exportando hotkeys a (sync): {full_path}")
    export_data = []
    for config in HOTKEYS_CONFIG:
        export_data.append({
            "hotkey": config.get("pynput_hotkey", "N/A"),
            "readable": config.get("readable", "N/A"),
            "description": config.get("description", ""),
            "action": config.get("action_type", "unknown")
        })

    try:
        with open(full_path, 'w', encoding='utf-8') as f:
            json.dump(export_data, f, ensure_ascii=False, indent=4)
        print(f"Exportación completada a {full_path}")
    except Exception as e:
        print(f"Error al exportar hotkeys a JSON: {e}")

async def export_hotkeys_action(**kwargs):
    """ (Async) Exports the HOTKEYS_CONFIG to a JSON file. """
    output_path = kwargs['output_path']
    print(f"Exportando hotkeys (async) a: {output_path}")
    await asyncio.to_thread(_export_hotkeys_sync, output_path)

async def reload_script_action(**kwargs):
    """ Attempts to reload the script by restarting the process. """
    global stop_event
    print("Recargando script (señalando parada y reiniciando proceso)...")
    stop_event.set() # Signal the main loop and listener thread to stop
    # Give a moment for things to shut down
    await asyncio.sleep(0.7)

    # The actual restart logic remains synchronous as it replaces the current process
    try:
        print("Ejecutando os.execv...")
        sys.stdout.flush()
        sys.stderr.flush()
        os.execv(sys.executable, ['python'] + sys.argv)
    except Exception as e:
        print(f"Error al intentar recargar el script con os.execv: {e}")
        # If execv fails, try to exit gracefully
        if main_loop and main_loop.is_running():
             main_loop.stop()
        sys.exit(1)


# ============================================================
#  Mapeo de Tipos de Acción a Funciones Async
# ============================================================
# Maps action type strings to the corresponding async function
ACTION_MAP = {
    "toggle_pwa": toggle_pwa_action,
    "toggle_app": toggle_app_action,
    "toggle_app_with_args": toggle_app_with_args_action,
    "cursor_toggle": cursor_toggle_action,
    "open_url": open_url_action,
    "run_elevated": run_command_elevated,
    "export_hotkeys": export_hotkeys_action,
    "reload_script": reload_script_action, # Reload itself is async now
}

# ============================================================
#  Función de Callback Genérica para Hotkeys (Bridge to Async)
# ============================================================
def create_callback(action_type, args, loop):
    """
    Creates a synchronous callback function for pynput.
    This callback schedules the actual async action onto the event loop.
    """
    async_func = ACTION_MAP.get(action_type)
    if not async_func:
        print(f"Advertencia: Tipo de acción desconocido '{action_type}' al crear callback.")
        return lambda: None # Return a no-op lambda

    # The actual async work coroutine
    async def async_task_wrapper():
        print(f"--- Hotkey Triggered: {action_type} ---")
        try:
            await async_func(**args)
            print(f"--- Action Completed: {action_type} ---")
        except Exception as e:
            print(f"Error al ejecutar la acción async '{action_type}': {e}")

    # The synchronous callback that pynput calls
    def sync_callback():
        if loop and loop.is_running():
            # Schedule the async task to run on the loop from this thread
            asyncio.run_coroutine_threadsafe(async_task_wrapper(), loop)
        else:
            print(f"Error: Event loop no está disponible o no está corriendo para acción '{action_type}'.")

    return sync_callback

# ============================================================
#  Creación de Bindings para pynput
# ============================================================
def create_hotkey_bindings(loop):
    """ Creates the dictionary mapping hotkey strings to sync callbacks for pynput. """
    bindings = {}
    for config in HOTKEYS_CONFIG:
        hotkey_str = config.get("pynput_hotkey")
        action_type = config.get("action_type")
        args = config.get("args", {})

        if hotkey_str and action_type:
            # Pass the event loop to the callback creator
            bindings[hotkey_str] = create_callback(action_type, args, loop)
        else:
            print(f"Advertencia: Configuración de hotkey inválida encontrada: {config}")
    return bindings

# ============================================================
#  Listener Thread Function
# ============================================================
def run_listener(bindings, loop):
    """ Function to run the pynput listener in a separate thread. """
    global current_listener
    print("Iniciando listener de hotkeys en hilo separado...")
    try:
        current_listener = keyboard.GlobalHotKeys(bindings)
        current_listener.start()
        print("Listener iniciado en hilo. Presiona los hotkeys definidos.")
        # Keep the listener thread alive until stopped
        current_listener.join() # Blocks this thread until listener.stop() is called
    except Exception as e:
        print(f"Error fatal en el hilo del listener: {e}")
        # Signal the main loop to stop if the listener crashes
        if loop and not stop_event.is_set():
             print("Señalando parada desde el hilo del listener debido a error.")
             loop.call_soon_threadsafe(stop_event.set)
    finally:
        print("Hilo del listener terminado.")

# ============================================================
#  Graceful Shutdown Handling
# ============================================================
def handle_shutdown_signal(sig, frame):
    """ Handles signals like SIGINT (Ctrl+C) for graceful shutdown. """
    print(f"\nSeñal {sig} recibida. Iniciando apagado...")
    global stop_event, main_loop
    if not stop_event.is_set():
        if main_loop:
             # Schedule setting the event from the signal handler's context
             main_loop.call_soon_threadsafe(stop_event.set)
        else:
             # Fallback if loop is not yet available
             stop_event.set()

# ============================================================
#  Ejecución Principal Async
# ============================================================
async def main():
    global main_loop, listener_thread, current_listener

    # Set the global loop reference
    main_loop = asyncio.get_running_loop()

    # Register signal handlers for graceful shutdown
    # signal.signal(signal.SIGINT, handle_shutdown_signal) # Ctrl+C
    # signal.signal(signal.SIGTERM, handle_shutdown_signal) # Termination signal
    # Note: Signal handling in asyncio/Windows can be tricky. Relying on KeyboardInterrupt
    # within the main loop might be more robust for cross-platform Ctrl+C.

    # 1. Verificar privilegios de administrador (async)
    if sys.platform == 'win32':
        admin = await is_admin()
        if not admin:
            print("Se requieren privilegios de administrador. Intentando relanzar...")
            success = await run_as_admin()
            if success:
                print("Relanzado con éxito. Saliendo del proceso actual.")
                sys.exit(0) # Exit current non-admin process
            else:
                print("No se pudo obtener privilegios de administrador. Saliendo.")
                # Display message box for better visibility (sync call in thread)
                await asyncio.to_thread(
                    ctypes.windll.user32.MessageBoxW,
                    0, "Este script requiere privilegios de administrador para funcionar correctamente.",
                    "Error de Permisos", 0x10 | 0x0 # MB_ICONERROR | MB_OK
                )
                sys.exit(1) # Exit if elevation failed
        print("Ejecutando con privilegios de administrador.")


    # 2. Ejecutar exportación inicial de hotkeys (async)
    initial_export_config = next((item for item in HOTKEYS_CONFIG if item["action_type"] == "export_hotkeys"), None)
    if initial_export_config:
        await export_hotkeys_action(**initial_export_config.get("args", {}))
    else:
        print("Advertencia: No se encontró la configuración para la exportación inicial de hotkeys.")


    # 3. Crear los bindings (needs the running loop)
    hotkey_bindings = create_hotkey_bindings(main_loop)

    if not hotkey_bindings:
        print("Error: No se definieron bindings de hotkeys válidos. Saliendo.")
        sys.exit(1)

    # 4. Iniciar el listener en un hilo separado
    listener_thread = threading.Thread(target=run_listener, args=(hotkey_bindings, main_loop), daemon=True)
    listener_thread.start()

    # 5. Keep the main async loop running until stop_event is set
    print("Loop principal iniciado. Esperando eventos o señal de parada (Ctrl+C)...")
    await stop_event.wait() # Wait until the event is set

    # 6. Cleanup
    print("Evento de parada detectado. Limpiando...")
    if current_listener:
        print("Deteniendo listener...")
        # Stopping the listener should happen from any thread,
        # pynput handles internal thread safety for stop()
        current_listener.stop()

    if listener_thread and listener_thread.is_alive():
        print("Esperando que el hilo del listener termine...")
        listener_thread.join(timeout=2.0) # Wait for the listener thread to exit
        if listener_thread.is_alive():
             print("Advertencia: El hilo del listener no terminó a tiempo.")

    print("Limpieza completada. Saliendo del loop principal.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nInterrupción de teclado detectada en __main__. Saliendo.")
    except Exception as e:
         print(f"\nError inesperado en el nivel superior: {e}")
    finally:
         print("Programa terminado.")
         # Ensure exit, especially if threads are stuck
         os._exit(0) # Force exit if necessary

