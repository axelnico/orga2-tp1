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
  %define BLOQUE_OFFSET_CLAVE         0
  %define BLOQUE_OFFSET_VALOR         3

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

xor rax, rax ; eax lo uso como contador para saber cuantos bytes tengo que reservar para la identificacion
.loop_identificacion:
cmp byte [rdi + rax], NULL
je .copiaIdentificacion
add rax, 1
jmp .loop_identificacion

.copiaIdentificacion:
mov rdi,rax
inc rdi
call malloc
mov rdi,rax
mov rsi,rbx
call strcpy
mov rbx,rax ;en rbx ahora tengo el puntero a la nuea indentificacion

mov rdi,TDT_SIZE ;reservo memoria para la estructura de tdt
call malloc
mov [rax +TDT_OFFSET_IDENTIFICACION],rbx
mov qword [rax + TDT_OFFSET_PRIMERA],NULL
mov dword [rax + TDT_OFFSET_CANTIDAD],0

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
lea rdx,[rsi + BLOQUE_OFFSET_VALOR]
jmp tdt_agregar

; =====================================
; void tdt_agregarBloques(tdt* tabla, bloque** b)
tdt_agregarBloques:
; en rdi tengo el puntero a la tabla
; en rsi tengo el puntero a la cadena de bloques
push rbp
mov rbp,rsp
push r14
push r15
mov r14,rdi ;r14 tiene el puntero a la tabla
mov r15,rsi ;r15 tiene el punero a la candena de bloques
.loopBloques:
cmp qword [r15],NULL
je .fin
mov rdi,r14
mov rsi,[r15]
call tdt_agregarBloque
add r15,8d
jmp .loopBloques


.fin:
pop r15
pop r14
pop rbp
ret

; =====================================
; void tdt_borrarBloque(tdt* tabla, bloque* b)
tdt_borrarBloque:
jmp tdt_borrar

; =====================================
; void tdt_borrarBloques(tdt* tabla, bloque** b)
tdt_borrarBloques:
; en rdi tengo el puntero a la tabla
; en rsi tengo el puntero a la cadena de bloques
push rbp
mov rbp,rsp
push r14
push r15
mov r14,rdi ;r14 tiene el puntero a la tabla
mov r15,rsi ;r15 tiene el punero a la cadena de bloques
.loopBloques:
cmp qword [r15],NULL
je .fin
mov rdi,r14
mov rsi,[r15]
call tdt_borrarBloque
add r15,8d
jmp .loopBloques


.fin:
pop r15
pop r14
pop rbp
ret

; =====================================
; void tdt_traducir(tdt* tabla, uint8_t* clave, uint8_t* valor)
tdt_traducir:

; =====================================
; void tdt_traducirBloque(tdt* tabla, bloque* b)
tdt_traducirBloque:
lea rdx,[rsi + BLOQUE_OFFSET_VALOR]
jmp tdt_traducir

; =====================================
; void tdt_traducirBloques(tdt* tabla, bloque** b)
tdt_traducirBloques:
; en rdi tengo el puntero a la tabla
; en rsi tengo el puntero a la cadena de bloques
push rbp
mov rbp,rsp
push r14
push r15
mov r14,rdi ;r14 tiene el puntero a la tabla
mov r15,rsi ;r15 tiene el punero a la candena de bloques
.loopBloques:
cmp qword [r15],NULL
je .fin
mov rdi,r14
mov rsi,[r15]
call tdt_traducirBloque
add r15,8d
jmp .loopBloques


.fin:
pop r15
pop r14
pop rbp
ret


; =====================================
; void tdt_destruir(tdt** tabla)
tdt_destruir:
push rbp
mov rbp,rsp
push rbx
push r12
push r13
push r14
push r15
sub rsp,8 ; la pila ahora esta alineada a 16 bytes

mov rbx, [rdi] ;en rbx tengo el puntero a la tabla
cmp qword [rbx + TDT_OFFSET_PRIMERA],NULL ; si no tengo primera tabla borro la identificacion y la tabla
je .borrarTablaPrincipal
; itero todas las entradas en la primera tabla
mov r14,[rbx + TDT_OFFSET_PRIMERA]
xor r13,r13 ; r13 lo uso como indice para iterar las tablas

.looptdtN1_t:
cmp qword [r14 +r13*8],NULL ;en [r14] tengo el puntero a la primera entrada de tdtN1
je .siguienteDetdtN1_t
mov r15,[r14 +r13*8]
push r13
xor r13,r13 ; vuelvo a limipiar r13

.looptdtN2_t:
cmp qword [r15 +r13*8],NULL ;en [r15] tengo el puntero a la primera entrada de tdtN2
je .siguienteDetdtN2_t
mov r12,[r15 +r13*8]
;push r13
;xor r13,r13 ; vuelvo a limipiar r13

.looptdtN3_t:
; aca borro todas las tablas de nivel 3
mov rdi,r12
call free
inc r13
cmp r13,256d
je .borrarSegunda
;inc r13
;cmp r13,256d
;je .limpiar_contador_y_loop_segunda_tabla
;add r12,8
jmp .looptdtN2_t

.limpiar_contador_y_loop_segunda_tabla:
pop r13
jmp .looptdtN2_t

.siguienteDetdtN2_t:
inc r13
cmp r13,256d
je .borrarSegunda
jmp .looptdtN2_t

.limpiar_contador_y_loop_primera_tabla:
pop r13
jmp .looptdtN1_t


.siguienteDetdtN1_t:
inc r13
cmp r13,256d
je .borrarprimera
jmp .looptdtN1_t

.borrarSegunda:
mov rdi,r15
call free
pop r13
inc r13
jmp .looptdtN1_t


.borrarprimera:
mov rdi,[rbx + TDT_OFFSET_PRIMERA]
call free

.borrarTablaPrincipal:
;aca borro la idenficacion y por ultimo la tdt_t
mov rdi,[rbx + TDT_OFFSET_IDENTIFICACION]
call free
mov rdi,rbx
call free

.fin:
pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret
