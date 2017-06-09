include Irvine32.inc

.data
key byte -2,4,1,0,-3,5,2,-4,-4,6
nkey byte 10 dup(?)
str1 byte "START:",0				;debug
str2 byte ":END",0					;debug
myArray byte "It's been a long time. How have you been?",0
myArray1 byte "I've been really busy being dead. You know, after you MURDERED ME.",0
keycng PROTO
show_msg PROTO, msg:DWORD
encypt PROTO, input_t:DWORD, lengt:DWORD

.code
main proc
	invoke keycng												;to convert the rotation always on the right
	
	invoke show_msg, ADDR myArray
	invoke encypt, ADDR myArray, (lengthof myArray)-2			;set the amount of myArray
	call crlf
	invoke	show_msg,ADDR myArray1
	invoke encypt, ADDR myArray1, (lengthof myArray1)-2			;set the amount of myArray1

	exit
main endp

keycng PROC
	mov esi,0
c1:							;add 10 to key
	add [key+esi],10
	inc esi
	cmp esi,10
	jne c1
	mov esi,0

	mov al,0
l3:							;add the order(weight) to the key
	add [key+esi],al
	inc esi
	inc al
	cmp esi,10
	jne l3
	mov esi,0

l5:							;divide by 10, get the remainder
	mov dx,0
	movzx ax,[key+esi]
	mov cx,10
	div cx					;remainder in 16bit stored in dl
;	movzx eax,dx			;debug:display key
	mov nkey[esi],dl
;	call writeint			;debug:display key
;	call crlf				;debug:display key
	inc esi
	cmp esi,10
	jne l5
	mov esi,0
;	call crlf

t1:							;debug:display new key
;	movzx eax,nkey[esi]
;	call writeint
;	call crlf
;	inc esi
;	cmp esi,10
;	jne t1
;	call crlf

	ret
keycng endp

encypt PROC, input_t:DWORD, lengt:DWORD
	mov ebx, 0						;init
	mov ecx, 0						;init
	mov esi, 0						;init
	mov edi, 0						;init

enc:
	mov cl, nkey[esi]				;get key
	mov eax, input_t				;load length of the plaintext into EAX
	mov al, [eax+edi]				;get the value from input_t as it's an ADDR
	ror al, cl						;rotate text right the amount of the key 
	call writechar					;show the result of encryption
	cmp edi, lengt					;check if the index pointer EDI reaches the length of plaintext
	je ex_enc						;jump out if it reaches
	inc edi							;add index pointer
	inc esi							;add key pointer
	cmp esi,9                       ;check key pointer ESI gets limitation
	jne enc							;continue if it gets the end of the key 
	mov esi,0						;initial key pointer ESI
	jmp enc							;esi reaches 10, need to be init

ex_enc:
	call crlf
	ret
encypt endp

show_msg PROC, msg:DWORD
	mov edx, 0
	mov edx, msg
	call writestring
	call crlf
	ret
show_msg endp

END main