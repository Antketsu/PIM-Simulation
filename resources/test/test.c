#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(){
    int16_t* v = (int16_t*)malloc(sizeof(int16_t) * 4096);
    printf("Veamos\n");
    for(int i = 0; i < 4096; i++){
        v[i] = i;
        printf("%d\n ", v[i]);
    }
    free(v);
    return 0;
}