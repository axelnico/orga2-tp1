#include "tdt.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main (void){

  tdt* tabla = tdt_crear("pepe");

    uint8_t clave1[3] = {0,0,0};
    uint8_t valor1[15] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    uint8_t clave2[3] = {0xff,0xff,0xff};
    uint8_t valor2[15] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    tdt_agregar(tabla,clave1,valor1);
    tdt_agregar(tabla,clave2,valor2);
    bloque b1 = {{5,5,5},{0x12,0x34,0x56,0x78,0x9A,0xBC,0xDE,0xF1,0x23,0x45,0x67,0x89,0xAB,0xCD,0xEF}};
    bloque b2 = {{0xff,0xff,0xff},{0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff}};
    bloque b3 = {{0x53,0xff,0xaa},{0x11,0x12,0x22,0x33,0x34,0x44,0x55,0x56,0x66,0x77,0x78,0x88,0x99,0x9A,0xaa}};
    bloque b4 = {{0x10,0xee,0x05},{0x11,0x11,0x22,0x22,0x33,0x33,0x44,0x44,0x55,0x55,0x66,0x66,0x77,0x77,0x88}};

    bloque* b[5] = {&b1,&b2,&b3,&b4,0};

    tdt_agregarBloques(tabla,(bloque**)&b);

    tdt_borrarBloque(tabla,&b3);
    tdt_borrarBloque(tabla,&b2);

    int i;
    maxmin *mm = tdt_obtenerMaxMin(tabla);
    printf("max_clave = %i",mm->max_clave[0]);
    for(i=1;i<3;i++) printf("-%i",mm->max_clave[i]);
    printf("\n");
    printf("min_clave = %i",mm->min_clave[0]);
    for(i=1;i<3;i++) printf("-%i",mm->min_clave[i]);
    printf("\n");
    printf("max_valor = %i",mm->max_valor[0]);
    for(i=1;i<15;i++) printf("-%i",mm->max_valor[i]);
    printf("\n");
    printf("min_valor = %i",mm->min_valor[0]);
    for(i=1;i<15;i++) printf("-%i",mm->min_valor[i]);
    printf("\n");
    free(mm);


    printf( "- ");
  	printf("%s", tabla->identificacion);
  	printf(" -\n");
  	if(tabla->primera != NULL){
  		for(int i = 0;i<256;i++){
  			if (tabla->primera->entradas[i] != NULL){
  				for(int j= 0;j<256;j++){
  					if(tabla->primera->entradas[i]->entradas[j] != NULL){
  						for(int k=0;k<256;k++){
  							if(tabla->primera->entradas[i]->entradas[j]->entradas[k].valido == 1){
  								printf("%02X%02X%02X => ", i,j,k);
  								for(int l=0;l<=14;l++){
  									printf("%02X",tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[l]);
  								}
  								printf("\n");
  							}
  						}
  					}
  				}
  			}
  		}
  	}

    printf("Cantidad de traducciones: %d",tabla->cantidad);

    printf("\n");

    tdt_destruir(&(tabla));

    return 0;
}
