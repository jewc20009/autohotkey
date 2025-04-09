const { app, BrowserWindow } = require('electron');
const path = require('path');

// Configurar para inicio rápido
app.commandLine.appendSwitch('disable-http-cache');
app.commandLine.appendSwitch('disable-gpu');
app.commandLine.appendSwitch('disable-software-rasterizer');

function createWindow() {
    const win = new BrowserWindow({
        width: 900,
        height: 700,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        },
        show: false,
        autoHideMenuBar: true
    });

    // Cargar el archivo HTML
    win.loadFile('index.html');
    
    // Mostrar la ventana solo cuando esté lista para reducir percepción de lentitud
    win.once('ready-to-show', () => {
        win.show();
    });
}

// Optimización para iniciar más rápido
if (process.platform === 'win32') {
    app.setAppUserModelId(process.execPath);
}

// No usar una segunda instancia para mejorar la velocidad
const gotTheLock = app.requestSingleInstanceLock();
if (!gotTheLock) {
    app.quit();
} else {
    app.on('second-instance', () => {
        // Alguien trató de ejecutar una segunda instancia, debemos enfocarnos en nuestra ventana
        if (BrowserWindow.getAllWindows().length) {
            const mainWindow = BrowserWindow.getAllWindows()[0];
            if (mainWindow.isMinimized()) mainWindow.restore();
            mainWindow.focus();
        }
    });

    app.whenReady().then(createWindow);
}

app.on('window-all-closed', () => app.quit()); 