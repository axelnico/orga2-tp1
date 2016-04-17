; FUNCIONES de C
  extern malloc
  extern free
  extern strcpy
  extern tdt_agregar
  extern tdt_borrar

; FUNCIONES
  global tdt_crear
  global tdt_recrear
  global tdt_cantidad
  global tdt_agregarBloque
  global tdt_agregarBloques
  global tdt_borrarBloque
  global tdt_borrarBloques
  global tdt_traducir
  global tdt_traducirBloque
  global tdt_traducirBloques
  global tdt_destruir

; /** defines offsets y size **/
  %define TDT_OFFSET_IDENTIFICACION   0
  %define TDT_OFFSET_PRIMERA          8
  %define TDT_OFFSET_CANTIDAD        16
  %define TDT_SIZE                   20
  %define NULL                        0

section .text

; =====================================
; tdt* tdt_crear(char* identificacion)
tdt_crear:
; rdi tiene el puntero a la identificacion
push rbp  ;armo el stack frame
mov rbp,rsp
push rbx;
push r11;
mov rbx, rdi ; me guardo el puntero a la identificacion

xor eax, eax ; eax lo uso como contador para saber cuantos bytes tengo que reservar para la identificacion
.loop_identificacion:
cmp byte [rdi + eax], NULL
je .copiaIdentificacion
add eax, 1
jmp .loop_identificacion

mov rdi,eax
call malloc





mov rdi,TDT_SIZEd ;reservo memoria para la estructura de tdt
call malloc
mov qword xmm0, rax ; en xmm0 voy a devolver el puntero a la estructura creada


mov rdi, rbx ; en rdi vuelvo a tener el puntero a la identificacion



.copiaIdentificacion:
mov rdi,eax
call malloc
mov [xmm0 + TDT_OFFSET_IDENTIFICACION], rax


.fin:
pop r11
pop rbx
pop rbp
ret


; =====================================
; void tdt_recrear(tdt** tabla, char* identificacion)
tdt_recrear:

; =====================================
; uint32_t tdt_cantidad(tdt* tabla)
tdt_cantidad:
;rdi tiene el puntero a la tabla
mov eax,[rdi + TDT_OFFSET_CANTIDAD]
ret

; =====================================
; void tdt_agregarBloque(tdt* tabla, bloque* b)
tdt_agregarBloque:

; =====================================
; void tdt_agregarBloques(tdt* tabla, bloque** b)
tdt_agregarBloques:

; =====================================
; void tdt_borrarBloque(tdt* tabla, bloque* b)
tdt_borrarBloque:
jmp tdt_borrar

; =====================================
; void tdt_borrarBloques(tdt* tabla, bloque** b)
tdt_borrarBloques:

; =====================================
; void tdt_traducir(tdt* tabla, uint8_t* clave, uint8_t* valor)
tdt_traducir:

; =====================================
; void tdt_traducirBloque(tdt* tabla, bloque* b)
tdt_traducirBloque:

; =====================================
; void tdt_traducirBloques(tdt* tabla, bloque** b)
tdt_traducirBloques:

; =====================================
; void tdt_destruir(tdt** tabla)
tdt_destruir:
