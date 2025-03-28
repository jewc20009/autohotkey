# Comandos Git para resolver conflictos y subir cambios
# Este script asume que estás en el directorio del repositorio

# 1. Traer cambios del repositorio remoto
git pull origin master --allow-unrelated-histories

# 2. Añadir el archivo modificado al staging
git add comandos.ahk

# 3. Crear un commit con los cambios
git commit -m "Merge: Resuelto conflictos y combinado funcionalidades de ambas versiones"

# 4. Subir los cambios al repositorio remoto
git push origin master 