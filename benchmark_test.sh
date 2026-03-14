#!/bin/bash
# =========================================
# Script: benchmark_test.sh
# Descripción: Compara rendimiento nativo Linux x86_64
#              vs Box64+Wine x86_64 en ARM64
# =========================================

EXE_FILE="./funciones_RB.exe"
LINUX_BIN="./funciones"
WINE_DIR="$HOME/wine64"

if [ ! -f "$EXE_FILE" ] || [ ! -f "$LINUX_BIN" ]; then
  echo "Error: Debes ejecutar primero build_test_binaries.sh"
  exit 1
fi

echo "=============================="
echo "Prueba nativa Linux x86_64"
echo "=============================="
time $LINUX_BIN

echo ""
echo "=============================="
echo "Prueba Box64 + Wine x86_64"
echo "=============================="
BOX64_DYNAREC_STRONG_MEM=1 BOX64_LOG=0 box64 $WINE_DIR/bin/wine64 $EXE_FILE
