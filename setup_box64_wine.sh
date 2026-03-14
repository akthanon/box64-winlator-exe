#!/bin/bash
# =========================================
# Script: setup_box64_wine.sh
# Descripción: Instala Box64 + Wine portátil x86_64 en ARM64
#              y prepara entorno para ejecutar .exe Windows 64bits.
# Autor: Akthanon (adaptado para GitHub)
# =========================================

# -------------------------
# 1. Variables principales
# -------------------------
WINE_VERSION="9.0"
WINE_DIR="$HOME/wine64"
EXE_FILE="$1"  # El archivo .exe que quieres ejecutar
SWAP_SIZE="1G" # Swap si RAM es limitada
BOX64_LOG=1    # Para debug opcional, se puede desactivar

# -------------------------
# 2. Comprobaciones previas
# -------------------------
if [ -z "$EXE_FILE" ]; then
  echo "Uso: $0 archivo.exe"
  exit 1
fi

if [ ! -f "$EXE_FILE" ]; then
  echo "Error: No se encontró $EXE_FILE"
  exit 1
fi

echo "Preparando Box64 + Wine para: $EXE_FILE"

# -------------------------
# 3. Instalación de dependencias
# -------------------------
echo "Instalando librerías necesarias..."
sudo apt update
sudo apt install -y wget tar libasound2

# -------------------------
# 4. Crear swap si es necesario
# -------------------------
if ! swapon --show | grep -q "/swapfile"; then
  echo "Creando swap de $SWAP_SIZE..."
  sudo fallocate -l $SWAP_SIZE /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
fi

# -------------------------
# 5. Descargar y descomprimir Wine x86_64 portátil
# -------------------------
if [ ! -d "$WINE_DIR" ]; then
  echo "Descargando Wine $WINE_VERSION x86_64 portátil..."
  wget -O wine-$WINE_VERSION-amd64.tar.xz \
    "https://github.com/Kron4ek/Wine-Builds/releases/download/$WINE_VERSION/wine-$WINE_VERSION-amd64.tar.xz"
  echo "Descomprimiendo..."
  tar -xvf wine-$WINE_VERSION-amd64.tar.xz
  mv wine-$WINE_VERSION-amd64 "$WINE_DIR"
fi

# -------------------------
# 6. Limpiar prefijo Wine anterior y crear uno nuevo 64bits
# -------------------------
echo "Inicializando prefijo Wine 64bits..."
rm -rf ~/.wine
WINEARCH=win64 box64 $WINE_DIR/bin/wine64 wineboot

# -------------------------
# 7. Ejecutar el programa con Box64 + Wine
# -------------------------
echo "Ejecutando $EXE_FILE..."
BOX64_DYNAREC_STRONG_MEM=1 BOX64_LOG=$BOX64_LOG \
  box64 $WINE_DIR/bin/wine64 "$EXE_FILE"

echo "¡Listo! Fin del script."
