#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Mostrar ventana sin decoración
Gui, +AlwaysOnTop -Caption +ToolWindow +Border
Gui, Color, FFFFFF
Gui, Font, s10, Segoe UI

; Título
Gui, Font, s14 Bold
Gui, Add, Text, x20 y10 w400 h30 cBlack, Atajos de Teclado

; Botón de cerrar
Gui, Font, s10 Bold
Gui, Add, Button, x380 y10 w30 h30 gCloser, X

; Cargar los atajos desde el JSON
FileRead, jsonContent, %A_ScriptDir%\shortcuts.json
if (jsonContent = "") {
    Gui, Add, Text, x20 y50 w400 h30 cRed, No se pudo cargar el archivo de atajos.
    Gui, Show, w420 h100, Atajos de Teclado
    return
}

; Intentar parsear el JSON
try {
    shortcuts := JSON.Load(jsonContent)
    
    ; Mostrar la lista de atajos
    y := 50
    for i, shortcut in shortcuts {
        ; Obtener teclas y descripción
        keyStr := ""
        for j, key in shortcut.keys {
            if (j > 1)
                keyStr .= " + "
            keyStr .= key
        }
        
        ; Añadir a la GUI
        Gui, Add, Text, x20 y%y% w100 h20 cBlue, %keyStr%
        Gui, Add, Text, x130 y%y% w300 h20, % shortcut.description
        y += 25
    }
    
    ; Mostrar la GUI
    Gui, Show, w450 h%y%, Atajos de Teclado
} catch {
    ; Si falla el parseo, mostrar un mensaje de error
    Gui, Add, Text, x20 y50 w400 h30 cRed, Error al procesar el archivo de atajos.
    Gui, Show, w420 h100, Atajos de Teclado
}

; Eventos
return

Closer:
GuiClose:
GuiEscape:
    Gui, Destroy
    ExitApp
    
; Clase simple para parsear JSON
class JSON {
    class Load {
        __New(jsonString) {
            this.json := jsonString
            this.data := {}
            this.Parse()
            return this.data
        }
        
        Parse() {
            ; Eliminar espacios en blanco al inicio y final
            jsonString := Trim(this.json)
            
            ; Verificar si es un array
            if (SubStr(jsonString, 1, 1) = "[" && SubStr(jsonString, 0) = "]") {
                ; Es un array
                this.data := []
                
                ; Quitar los corchetes
                jsonString := SubStr(jsonString, 2, StrLen(jsonString) - 2)
                
                ; Dividir por comas, pero respetando las estructuras anidadas
                pos := 1
                itemStart := 1
                depth := 0
                
                Loop, Parse, jsonString
                {
                    char := A_LoopField
                    
                    if (char = "{" || char = "[")
                        depth++
                    else if (char = "}" || char = "]")
                        depth--
                    else if (char = "," && depth = 0) {
                        ; Encontramos un elemento del array
                        item := Trim(SubStr(jsonString, itemStart, pos - itemStart))
                        if (item != "")
                            this.data.Push(new JSON.Load(item).data)
                        itemStart := pos + 1
                    }
                    
                    pos++
                }
                
                ; Último elemento
                item := Trim(SubStr(jsonString, itemStart))
                if (item != "")
                    this.data.Push(new JSON.Load(item).data)
            }
            ; Verificar si es un objeto
            else if (SubStr(jsonString, 1, 1) = "{" && SubStr(jsonString, 0) = "}") {
                ; Es un objeto
                this.data := {}
                
                ; Quitar las llaves
                jsonString := SubStr(jsonString, 2, StrLen(jsonString) - 2)
                
                ; Parsear pares clave-valor
                pos := 1
                keyStart := 1
                valueStart := 0
                inKey := true
                depth := 0
                
                Loop, Parse, jsonString
                {
                    char := A_LoopField
                    
                    if (inKey) {
                        if (char = ":") {
                            key := Trim(SubStr(jsonString, keyStart, pos - keyStart))
                            ; Quitar comillas
                            key := RegExReplace(key, "^""(.*)""$", "$1")
                            valueStart := pos + 1
                            inKey := false
                        }
                    } else {
                        if (char = "{" || char = "[")
                            depth++
                        else if (char = "}" || char = "]")
                            depth--
                        else if (char = "," && depth = 0) {
                            ; Fin del valor
                            value := Trim(SubStr(jsonString, valueStart, pos - valueStart))
                            this.data[key] := new JSON.Load(value).data
                            keyStart := pos + 1
                            inKey := true
                        }
                    }
                    
                    pos++
                }
                
                ; Último par clave-valor
                if (!inKey) {
                    value := Trim(SubStr(jsonString, valueStart))
                    this.data[key] := new JSON.Load(value).data
                }
            }
            ; Valor simple
            else {
                ; Verificar si es un string (con comillas)
                if (SubStr(jsonString, 1, 1) = """" && SubStr(jsonString, 0) = """") {
                    ; Es un string
                    this.data := RegExReplace(jsonString, "^""(.*)""$", "$1")
                }
                ; Verificar si es un número
                else if (IsNumber(jsonString)) {
                    ; Es un número
                    this.data := jsonString + 0
                }
                ; Verificar si es un booleano o null
                else if (jsonString = "true") {
                    this.data := true
                }
                else if (jsonString = "false") {
                    this.data := false
                }
                else if (jsonString = "null") {
                    this.data := ""
                }
                ; Asumir string sin comillas
                else {
                    this.data := jsonString
                }
            }
        }
    }
} 