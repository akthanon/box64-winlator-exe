#!/bin/bash
# =========================================
# Script: build_test_binaries.sh
# Descripción: Crea binario de prueba para Windows x86_64
#              y binario nativo Linux x86_64
# =========================================

# Código de prueba
cat <<'EOF' > funciones_RB.c
#include <stdio.h>
#include <time.h>

int main() {

    long long N = 2000000000LL;
    volatile long long acc = 0;

    printf("Iteraciones: %lld\n", N);

    clock_t inicio = clock();

    for(long long i = 0; i < N; i++){
        acc += i*i + 2*i + 1;
    }

    clock_t fin = clock();

    double tiempo = (double)(fin - inicio) / CLOCKS_PER_SEC;

    printf("Resultado: %lld\n", acc);
    printf("Tiempo: %f s\n", tiempo);

}
EOF

echo "Código de prueba generado: funciones_RB.c"

# -------------------------
# Compilar para Windows x86_64
# -------------------------
echo "Compilando funciones_RB.exe (Windows x86_64)..."
x86_64-w64-mingw32-gcc funciones_RB.c -O2 -o funciones_RB.exe

# -------------------------
# Compilar para Linux nativo x86_64
# -------------------------
echo "Compilando funciones (Linux x86_64)..."
gcc -O3 -march=native funciones_RB.c -o funciones

echo "¡Compilación finalizada!"
echo "Archivos generados: funciones_RB.exe (Windows) y funciones (Linux)"
