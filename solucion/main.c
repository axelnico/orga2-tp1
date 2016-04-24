#include "tdt.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main (void){

    tdt* tabla = tdt_crear("sa");

    //uint8_t tmp1[3] = {0,0,0};
    //uint8_t tmp2[3] = {255,255,255};
    //uint8_t tmp3[3] = {0,0,0};
    //uint8_t tmp5[15] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
    //bloque b1 = {{1,1,0},{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}};
    //tdt_agregar(tabla,tmp1,tmp5);
    //tdt_traducirBloque(tabla,&b1);
    //for(int i=0;i<=14;i++){
    //  printf("%u\n", b1.valor[i]);
    //}


    tdt_destruir(&(tabla));

    return 0;
}
