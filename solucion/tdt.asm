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
  %define VALOR_VALIDO_OFFSET_VALIDO  15

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
push rbp  ;armo el stack frame
mov rbp,rsp
push rbx
push r11
mov rbx, rdi ;me guardo una copia del puntero a puntero de la tabla
mov r11, rsi ;me guardo una copia del puntero a la nueva identificacion
mov rdi,[rdi] ;en rdi tengo el puntero a la tabla
cmp qword rsi,NULL ;en rsi tengo el puntero a la identificacion
je .recreoLaTablaConMismaIdentificacionOriginal
mov rdi,rbx ; en rdi vuelvo a poner el puntero a puntero a la tabla
call tdt_destruir
mov rdi,r11
call tdt_crear
jmp .fin

.recreoLaTablaConMismaIdentificacionOriginal:
mov rdi,rbx ; en rdi vuelvo a poner el puntero a puntero a la tabla
call tdt_destruir
mov rdi, [rbx] ; en rdi pongo el puntero a la tabla, que esta apuntando a la identificacion
call tdt_crear

.fin:
mov [rbx],rax ;me guardo en lo que apuntaba el puntero a la tabla, el nuevo puntero a la nueva tabla

pop r11
pop rbx
pop rbp
ret



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
; en rdi tengo el puntero a la tabla
; en rsi tengo el puntero a la clave
; en rdx tengo el puntero al valor
push rbp
mov rbp,rsp
push rbx
xor rax,rax
cmp qword [rdi + TDT_OFFSET_PRIMERA],NULL
je .fin
mov rdi, [rdi + TDT_OFFSET_PRIMERA] ;en rdi tengo a la primera tabla
mov byte al, [rsi] ;en al tengo la primera parte de la clave
cmp qword [rdi + rax*8],NULL
je .fin
mov rdi,[rdi + rax*8] ;en rdi tengo a la segunda tabla
mov byte al, [rsi + 1] ; en al tengo la segunda parte de la clave
cmp qword [rdi + rax*8],NULL
je .fin
mov rdi,[rdi + rax*8] ;en rdi tengo puntero a la tercera tabla
mov byte al, [rsi + 2] ; en al tengo la tercera parte de la clave
shl rax,4
cmp byte [rdi + rax +15],1d
jne .fin
jmp .copiaValorTraduccion
;mov rax, [rsi + 16] ; en rax tengo la tercera parte de la clave
;mov rdi,[rdi + rax*8] ;en rdi tengo al valor valido
;mov rax, rdi
;mov rdi,[rdi + VALOR_VALIDO_OFFSET_VALIDO] ;en rdi tengo el valor valido
;cmp byte [rdi],1d ;me fijo si valor valido es 1
;jne .fin

;Copio el valor en rsi
.copiaValorTraduccion:
xor rcx,rcx
.loopValorTraduccion:
mov byte  r8b, [rdi + rax]
mov [rdx + rcx],r8b
inc rcx
inc rax
cmp rcx,15
je .fin
jmp .loopValorTraduccion



.fin:
pop rbx
pop rbp
ret



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
push rbx ; rbx puntero a la tabla
push r12
push r13

mov rbx, [rdi]
xor r12,r12


mov rdi,16
call malloc
mov r13,rax
mov [rax],r12





.loopBorrar:
mov rdi, rbx
mov rsi, r13
call tdt_borrar
inc r12
cmp r12,16777216
je .fin
mov [r13],r12
jmp .loopBorrar


.fin:
mov rdi,r13
call free

mov rdi, [rbx + TDT_OFFSET_IDENTIFICACION]
call free
mov rdi, rbx
call free

pop r13
pop r12
pop rbx
pop rbp
ret
