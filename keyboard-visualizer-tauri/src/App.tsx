import { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/tauri';
import './App.css'; // Asegúrate de que este archivo exista o ajusta la importación

// Interfaz para el tipo de dato que viene de Rust
interface Shortcut {
  keys: string[];
  description: string;
}

// Interfaz para el mapeo de colores (similar a tu JS original)
const keyColorMap: { [key: string]: string } = {
  'Ctrl': 'ctrl',
  'Shift': 'shift',
  'Alt': 'alt',
  'Win': 'win', // O 'Meta' si usas Meta en tus datos
  'default': 'regular',
};

function App() {
  const [shortcuts, setShortcuts] = useState<Shortcut[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [pressedKeys, setPressedKeys] = useState<Set<string>>(new Set());
  const [activeShortcutDesc, setActiveShortcutDesc] = useState<string>('');
  const [highlightedVirtualKeys, setHighlightedVirtualKeys] = useState<Set<string>>(new Set());

  // --- Carga los atajos desde el backend Tauri ---
  useEffect(() => {
    setLoading(true);
    invoke<Shortcut[]>('get_shortcuts') // Llama al comando Rust
      .then((fetchedShortcuts) => {
        setShortcuts(fetchedShortcuts);
        setError(null);
        console.log('Atajos cargados desde Tauri:', fetchedShortcuts);
      })
      .catch((err) => {
        console.error('Error cargando atajos desde Tauri:', err);
        setError(typeof err === 'string' ? err : 'Error desconocido al cargar atajos.');
        setShortcuts([]); // Limpia en caso de error
      })
      .finally(() => {
        setLoading(false);
      });
  }, []); // El array vacío asegura que se ejecute solo al montar

  // --- Lógica para manejar teclado físico ---
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const key = event.key === 'Control' ? 'Ctrl' : // Normalizar nombres si es necesario
                  event.key === 'Meta' ? 'Win' : 
                  event.key === ' ' ? 'Space' : event.key;

      setPressedKeys(prev => new Set(prev).add(key));
      
      // Comprobar si se activó un atajo
      checkActiveShortcuts(new Set(pressedKeys).add(key));
    };

    const handleKeyUp = (event: KeyboardEvent) => {
       const key = event.key === 'Control' ? 'Ctrl' :
                   event.key === 'Meta' ? 'Win' :
                   event.key === ' ' ? 'Space' : event.key;

      setPressedKeys(prev => {
        const next = new Set(prev);
        next.delete(key);
        // Si ya no hay teclas presionadas, limpiar descripción
        if (next.size === 0) {
           setActiveShortcutDesc('');
        } else {
            // Re-evaluar con las teclas restantes
            checkActiveShortcuts(next);
        }
        return next;
      });
    };

    // Añadir listeners
    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);

    // Limpiar listeners al desmontar
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('keyup', handleKeyUp);
    };
  }, [shortcuts, pressedKeys]); // Re-ejecutar si cambian los atajos o las teclas presionadas


  // --- Función para comprobar atajos activos ---
  const checkActiveShortcuts = (currentKeys: Set<string>) => {
    let foundDesc = '';
    for (const shortcut of shortcuts) {
      const allKeysPressed = shortcut.keys.every(key => currentKeys.has(key) || currentKeys.has(key.toLowerCase()));
       // Asegurar que no haya teclas extra presionadas (opcional, para exactitud)
      const exactMatch = allKeysPressed && currentKeys.size === shortcut.keys.length; 

      if (exactMatch) {
        foundDesc = shortcut.description;
        break; // Encontrar el primero y salir
      }
    }
    setActiveShortcutDesc(foundDesc);
    if (foundDesc) {
        // Opcional: Limpiar descripción después de un tiempo si se mantiene presionado
        /* setTimeout(() => {
             // Comprobar si la descripción sigue siendo la misma antes de limpiar
             setActiveShortcutDesc(prev => prev === foundDesc ? '' : prev);
         }, 2000); */
    }
  };


  // --- Función para demostrar un atajo (simular click) ---
  const demonstrateShortcut = (shortcut: Shortcut) => {
     setHighlightedVirtualKeys(new Set()); // Limpiar previos
     setActiveShortcutDesc(''); // Limpiar descripción

     let index = 0;
     const interval = setInterval(() => {
         if (index < shortcut.keys.length) {
             const key = shortcut.keys[index];
             // Mapear a la representación visual (ej: 'Control' a 'Ctrl')
             const visualKey = key === 'Control' ? 'Ctrl' :
                               key === 'Meta' ? 'Win' :
                               key === ' ' ? 'Space' : key;
             setHighlightedVirtualKeys(prev => new Set(prev).add(visualKey.toLowerCase()));
             index++;
         } else {
             clearInterval(interval);
             setActiveShortcutDesc(shortcut.description);

             // Restablecer después de 1 segundo
             setTimeout(() => {
                setHighlightedVirtualKeys(new Set());
                setActiveShortcutDesc('');
             }, 1500);
         } 
     }, 300); // Intervalo de simulación
 };

 // --- Función para obtener la clase CSS de una tecla (basado en tu CSS original) ---
 const getKeyClass = (key: string): string => {
    // Clase base
    let classes = 'keyboard-key';

    // Clases de tamaño (adapta esto a tu layout específico)
    const lowerKey = key.toLowerCase();
    if (['backspace', 'tab', 'capslock', 'enter', 'shift'].includes(lowerKey)) classes += ' wide-2';
    if (lowerKey === 'space') classes += ' wide-6';
    
    // Clases de color/tipo
    classes += ` ${keyColorMap[key] || keyColorMap['default']}`;

    // Clase si está presionada físicamente o simulada
    if (pressedKeys.has(key) || pressedKeys.has(key.toLowerCase()) || highlightedVirtualKeys.has(key.toLowerCase())) {
        classes += ' active';
    }

    return classes;
 }

 // --- Renderizado del componente ---
  return (
    <div className="container">
      <h2>Atajos de Teclado</h2>

      {/* --- Teclado Visual --- (Adapta el layout a tu HTML original) */}
      <div className="keyboard-container">
        <div className="keyboard">
          {/* Fila 1: Esc, F1-F12 */}
          <div className="keyboard-row">
            {['Esc', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'].map(k =>
              <div key={k} className={getKeyClass(k)} data-key={k.toLowerCase()}>{k}</div>
            )}
          </div>
           {/* Fila 2: ~, 1-0, -, =, Backspace */}
          <div className="keyboard-row">
             {['~`','1','2','3','4','5','6','7','8','9','0','-','=','Backspace'].map(k =>
                 // Usamos un mapeo para el 'data-key' si es diferente al texto mostrado
                 <div key={k} className={getKeyClass(k === '~`' ? '`' : k === 'Backspace' ? 'Backspace' : k)} data-key={(k === '~`' ? '`' : k).toLowerCase()}>{k === 'Backspace' ? 'Back' : k}</div>
              )}
          </div>
          {/* Fila 3: Tab, Q-P, [, ], \ */}
          <div className="keyboard-row">
              {['Tab','Q','W','E','R','T','Y','U','I','O','P','[',']','\\'].map(k =>
                  <div key={k} className={getKeyClass(k)} data-key={k.toLowerCase()}>{k}</div>
              )}
          </div>
          {/* Fila 4: Caps, A-L, ;, ', Enter */}
           <div className="keyboard-row">
               {['CapsLock','A','S','D','F','G','H','J','K','L',';','\'','Enter'].map(k =>
                   <div key={k} className={getKeyClass(k === 'CapsLock' ? 'Caps' : k)} data-key={(k === '\'' ? "'" : k).toLowerCase()}>{k === 'CapsLock' ? 'Caps' : k}</div>
               )}
           </div>
           {/* Fila 5: Shift, Z-M, ,, ., /, Shift */}
           <div className="keyboard-row">
                {['Shift','Z','X','C','V','B','N','M',',','.','/','Shift'].map((k, idx) => // Añadir idx para key única
                    <div key={`${k}-${idx}`} className={getKeyClass(k)} data-key={k.toLowerCase()}>{k}</div>
                 )}
           </div>
           {/* Fila 6: Ctrl, Win, Alt, Space, Alt, Win, Menu, Ctrl */}
           <div className="keyboard-row">
                {['Ctrl','Win','Alt','Space','Alt','Win','ContextMenu','Ctrl'].map((k, idx) =>
                    <div key={`${k}-${idx}`} className={getKeyClass(k)} data-key={(k === 'Win' ? 'meta' : k === 'ContextMenu' ? 'contextmenu' : k).toLowerCase()}>{k === 'ContextMenu' ? 'Menu' : k}</div>
                )}
           </div>
        </div>
        <div id="shortcut-description" className="shortcut-description">
          {activeShortcutDesc || ''}
        </div>
      </div>

      {/* --- Lista de Atajos --- */}
      <div className="shortcuts-list">
        <h3>Atajos Disponibles - Haz clic para demostrar</h3>
        {loading && <p>Cargando atajos...</p>}
        {error && <div className="error-message" style={{ display: 'block' }}>Error: {error}</div>}
        {!loading && !error && (
          <ul id="shortcuts-grid" className="shortcuts-grid">
            {shortcuts.map((shortcut, index) => (
              <li
                key={index}
                className="shortcut-item"
                onClick={() => demonstrateShortcut(shortcut)}
              >
                <div className="shortcut-keys">
                  {shortcut.keys.map((key, keyIndex) => (
                    <span key={keyIndex} style={{ display: 'inline-flex', alignItems: 'center' }}>
                      <span className={`key ${keyColorMap[key] || keyColorMap['default']}`}>
                        {key}
                      </span>
                      {keyIndex < shortcut.keys.length - 1 && <span style={{ margin: '0 2px' }}>+</span>}
                    </span>
                  ))}
                </div>
                <span>{shortcut.description}</span>
              </li>
            ))}
          </ul>
        )}
         {/* Mensaje si no hay atajos y no está cargando */} 
        {!loading && !error && shortcuts.length === 0 && <p>No se encontraron atajos en la base de datos.</p>}
      </div>
    </div>
  );
}

export default App;
