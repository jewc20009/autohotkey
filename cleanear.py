#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Versión: 1.1.0
Script para generar hotkeys_clean.json a partir del archivo de origen de AutoHotKey
"""
import json
import os
import re

def generar_json_limpio():
    """
    Genera un JSON limpio compatible con la web directamente del script AHK
    """
    try:
        # Archivo de salida
        output_file = "hotkeys_clean.json"
        
        # Lista para almacenar los atajos
        hotkeys_clean = []
        
        # Lista de funciones relevantes para el usuario
        funciones_relevantes = [
            "TogglePWA", 
            "ToggleApp", 
            "OpenCursor", 
            "OpenCursorSSH",
            "CursorToggle"
        ]
        
        # Mapa para evitar funciones duplicadas
        mapa_funciones = {}
        
        # Abrir el archivo AHK directamente
        ahk_file = "toogle_gemini_2.ahk"
        with open(ahk_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Primero obtener todos los atajos
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Buscar líneas que contengan atajos de teclado
            hotkey_match = re.match(r'^([\^\+!#][\^\+!#\w]+)::', line)
            if hotkey_match:
                hotkey = hotkey_match.group(1)
                
                # Buscar descripción en líneas anteriores (hasta 5 líneas)
                description = ""
                for j in range(max(0, i-5), i):
                    if lines[j].strip().startswith(';'):
                        description = lines[j].strip()[1:].strip()
                        break
                
                # Convertir el atajo a formato legible
                readable = convertir_a_legible(hotkey)
                
                # Buscar acción en las líneas siguientes
                action = ""
                for j in range(i+1, min(i+10, len(lines))):
                    line_j = lines[j].strip()
                    if "Run(" in line_j:
                        action = "Abre sitio web o ejecuta comando"
                        break
                    elif "TogglePWA(" in line_j:
                        action = "Abre o alterna aplicación web"
                        break
                    elif "ToggleApp(" in line_j:
                        action = "Abre o alterna aplicación"
                        break
                    elif "OpenCursor(" in line_j:
                        action = "Abre Cursor IDE"
                        break
                    elif "CursorToggle(" in line_j:
                        action = "Alterna Cursor IDE"
                        break
                    elif "SendInput(" in line_j:
                        action = "Envía secuencia de teclas"
                        break
                    elif "Reload" in line_j:
                        action = "Recarga el script"
                        break
                
                # Crear objeto de atajo limpio
                clean_shortcut = {
                    "hotkey": hotkey,
                    "readable": readable,
                    "description": description + (" (" + action + ")" if action else "")
                }
                
                hotkeys_clean.append(clean_shortcut)
            
            i += 1
        
        # Buscar definiciones de funciones relevantes
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Buscar definiciones de función
            # Patrón 1: Nombre(parametros) {
            func_match = re.match(r'^([A-Za-z0-9_]+)\s*\(([^)]*)\)\s*{?', line)
            if func_match:
                func_name = func_match.group(1)
                params = func_match.group(2)
                
                # Solo incluir funciones relevantes
                if func_name in funciones_relevantes:
                    # Buscar descripción en comentarios previos (hasta 15 líneas)
                    desc = ""
                    for j in range(max(0, i-15), i):
                        if lines[j].strip().startswith(';'):
                            comment = lines[j].strip()[1:].strip()
                            # Evitar separadores de comentarios
                            if not re.match(r'^=+$', comment):
                                desc += comment + " "
                    
                    # Si la función ya existe en el mapa, combinar descripciones
                    if func_name in mapa_funciones:
                        # Actualizar solo si hay una descripción más completa
                        if len(desc.strip()) > len(mapa_funciones[func_name]["descripcion"]):
                            mapa_funciones[func_name]["descripcion"] = desc.strip()
                    else:
                        # Crear objeto de función
                        func_obj = {
                            "nombre": func_name,
                            "parametros": params,
                            "descripcion": desc.strip()
                        }
                        mapa_funciones[func_name] = func_obj
            
            i += 1
        
        # Convertir mapa a lista
        funciones = list(mapa_funciones.values())
        
        # Asignar descripción estándar para cada tipo de función
        descripciones_predeterminadas = {
            "TogglePWA": "Alterna o abre una aplicación web progresiva (PWA)",
            "ToggleApp": "Alterna o abre una aplicación nativa",
            "OpenCursor": "Abre Cursor IDE en un directorio específico",
            "OpenCursorSSH": "Abre Cursor IDE con conexión SSH a un servidor remoto",
            "CursorToggle": "Alterna la ventana de Cursor IDE (muestra/oculta)"
        }
        
        # Aplicar descripciones predeterminadas si no hay descripción
        for func in funciones:
            if not func["descripcion"] or len(func["descripcion"].strip()) < 10:
                func["descripcion"] = descripciones_predeterminadas.get(func["nombre"], "")
        
        # Crear el objeto JSON completo
        json_completo = {
            "atajos": hotkeys_clean,
            "funciones": funciones
        }
        
        # Guardar a archivo
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(json_completo, f, ensure_ascii=False, indent=4)
        
        print(f"Se generaron {len(hotkeys_clean)} atajos y {len(funciones)} funciones en {output_file}")
        return True
    
    except Exception as e:
        print(f"Error al procesar el archivo: {e}")
        return False

def convertir_a_legible(hotkey):
    """Convierte códigos de atajo a formato legible"""
    # Extraer la tecla base (última parte) y los modificadores (primeras partes)
    base_key = re.search(r'[a-zA-Z0-9]+$', hotkey)
    if not base_key:
        base_key = ""
    else:
        base_key = base_key.group(0)
    
    # Crear lista para almacenar modificadores
    modifiers = []
    
    # Detectar modificadores
    if '^' in hotkey:
        modifiers.append('Ctrl')
    if '+' in hotkey:
        modifiers.append('Shift')
    if '!' in hotkey:
        modifiers.append('Alt')
    if '#' in hotkey:
        modifiers.append('Win')
    
    # Tratar teclas especiales
    special_keys = {
        'Space': 'Espacio',
        'Enter': 'Enter',
        'Tab': 'Tab',
        'Esc': 'Escape',
        '|': 'Pipe'
    }
    
    if base_key.lower() in [k.lower() for k in special_keys.keys()]:
        for k, v in special_keys.items():
            if base_key.lower() == k.lower():
                base_key = v
                break
    
    # Combinar modificadores + tecla base
    result = '+'.join(modifiers)
    if base_key:
        if result:
            result += '+' + base_key
        else:
            result = base_key
    
    return result

if __name__ == "__main__":
    generar_json_limpio()
