#include "tdt.h"

void tdt_agregar(tdt* tabla, uint8_t* clave, uint8_t* valor) {
	// si no hay ninguna traduccion entonces la primera tabla no existe y por lo tanto, ninguna de sus subtablas
	if(tabla->primera == NULL){
		tabla->primera = malloc(sizeof(tdtN1));
		for(int i=0;i<=255;i++){
			tabla->primera->entradas[i] = NULL;
		}
	}

	// Hay una tabla pero la primera subtabla no corresponde con el primer caracter de la clave
	if(tabla->primera->entradas[clave[0]] == NULL){
		tabla->primera->entradas[clave[0]] = malloc(sizeof(tdtN2));
		for(int i=0;i<=255;i++){
			tabla->primera->entradas[clave[0]]->entradas[i] = NULL;
		}
	}

	// Hay una tabla y existe la pimera subtabla con el primer caracter de la clave pero no existe la segunda subtabla con el segundo caracter
	if(tabla->primera->entradas[clave[0]]->entradas[clave[1]] == NULL){
			tabla->primera->entradas[clave[0]]->entradas[clave[1]] = malloc(sizeof(tdtN3));
			for(int i=0;i<=255;i++){
				tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[i].valido = 0;
			}
	}

	// En la tercera subtabla en la posicion del tercer caracter registro la nueva traduccion
	for(int i=0;i<=14;i++){
		tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[clave[2]].valor.val[i] = valor[i];
	}

	if(tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[clave[2]].valido != 1){
		tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[clave[2]].valido = 1;
		tabla->cantidad = tabla->cantidad + 1;
	}
}

void tdt_borrar(tdt* tabla, uint8_t* clave) {
	// Pongo en invalido el valor de la traduccion almacenado
	if(tabla->primera != NULL && tabla->primera->entradas[clave[0]] != NULL && tabla->primera->entradas[clave[0]]->entradas[clave[1]] != NULL
	&& tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[clave[2]].valido == 1){

	tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[clave[2]].valido = 0;
	tabla->cantidad = tabla->cantidad  - 1;

	// Me fijo si quedo aluna traduccion valida en la tercer subtabla
	int i = 0;
	while(i<256 && tabla->primera->entradas[clave[0]]->entradas[clave[1]]->entradas[i].valido == 0){
		i++;
	}
	// Si no quedo ninguna traduccion valida en la tercer subtabla la borro
	if(i==256){
		free(tabla->primera->entradas[clave[0]]->entradas[clave[1]]);
		tabla->primera->entradas[clave[0]]->entradas[clave[1]] = NULL;
	}
	// Me fijo si quedo algun caracter de alguna clave en la segunda subtabla
	i= 0;
	while(i<256 && tabla->primera->entradas[clave[0]]->entradas[i] == NULL){
		i++;
	}
	// Si en la segunda subtabla no hay ningun caracter almacenado la borro
	if(i==256){
		free(tabla->primera->entradas[clave[0]]);
		tabla->primera->entradas[clave[0]] = NULL;
	}
	// Me fijo si hay al menos una traduccion almacenada en la tabla
	i = 0;
	while(i<256 && tabla->primera->entradas[i] == NULL){
		i++;
	}
	// Si la tabla se quedó sin ninguna traduccion la borro
	if(i==256){
		free(tabla->primera);
		tabla->primera = NULL;
	}
}
}

void tdt_imprimirTraducciones(tdt* tabla, FILE *pFile) {
	fseek(pFile,0,SEEK_END);
	fputs( "- ", pFile );
	fprintf(pFile, "%s", tabla->identificacion);
	fputs(" -\n",pFile);
	if(tabla->primera != NULL){
		for(int i = 0;i<256;i++){
			if (tabla->primera->entradas[i] != NULL){
				for(int j= 0;j<256;j++){
					if(tabla->primera->entradas[i]->entradas[j] != NULL){
						for(int k=0;k<256;k++){
							if(tabla->primera->entradas[i]->entradas[j]->entradas[k].valido == 1){
								fprintf(pFile, "%02X%02X%02X => ", i,j,k);
								for(int l=0;l<=14;l++){
									fprintf(pFile,"%02X",tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[l]);
								}
								fprintf(pFile, "\n");
							}
						}
					}
				}
			}
		}
	}
}

maxmin* tdt_obtenerMaxMin(tdt* tabla) {
	maxmin* maximoYMinimo = malloc(sizeof(maxmin));
	for(int i=0;i<=2;i++){
		maximoYMinimo->max_clave[i] = 0;
	}
	for(int i=0;i<=2;i++){
		maximoYMinimo->min_clave[i] = 255;
	}
	for(int i=0;i<=14;i++){
		maximoYMinimo->max_valor[i] = 0;
	}
	for(int i=0;i<=14;i++){
		maximoYMinimo->min_valor[i] = 255;
	}
	if(tabla->primera != NULL){
		for(int i = 0;i<256;i++){
			if (tabla->primera->entradas[i] != NULL){
				for(int j= 0;j<256;j++){
					if(tabla->primera->entradas[i]->entradas[j] != NULL){
						for(int k=0;k<256;k++){
							if(tabla->primera->entradas[i]->entradas[j]->entradas[k].valido == 1){
								if(tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[0] > maximoYMinimo->max_valor[0]){
									for(int l=0;l<=14;l++){
										maximoYMinimo->max_valor[l] = tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[l];
									}
								}
								maximoYMinimo->max_clave[0] = i;
								maximoYMinimo->max_clave[1] = j;
								maximoYMinimo->max_clave[2] = k;
								if(tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[0] < maximoYMinimo->min_valor[0]){
									for(int l=0;l<=14;l++){
										maximoYMinimo->min_valor[l] = tabla->primera->entradas[i]->entradas[j]->entradas[k].valor.val[l];
									}
								}
								uint8_t clave_actual[3] = {i,j,k};
								int m=0;
								while(m<=2 && clave_actual[m] == maximoYMinimo->min_clave[m]){
									m++;
								}
								if(m<=2 && clave_actual[m] < maximoYMinimo->min_clave[m]){
									maximoYMinimo->min_clave[0] = i;
									maximoYMinimo->min_clave[1] = j;
									maximoYMinimo->min_clave[2] = k;
								}
							}
						}
					}
				}
			}
		}
	}
	return maximoYMinimo;
}
