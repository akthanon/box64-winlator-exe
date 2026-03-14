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
