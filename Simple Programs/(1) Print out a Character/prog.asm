.model small
.data

.stack 100h
.code

main:
		call InitSegs
		call PrintChar
		call Exit
		
		;========== InitSegs ==========
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;=========== PrintChar ===========
		Proc PrintChar
			push ax dx
			
			mov ah, 2
			mov dl, "#"
			int 21h
			
			pop dx ax
		RET
		EndP PrintChar
		
		;============ Exit ============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main