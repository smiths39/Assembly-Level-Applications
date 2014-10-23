.model small
.data
		StringToPrint db "Hello$"
.stack 100h
.code

main:
		call InitSegs
		call PrintString
		call Exit
		
		;=========== InitSegs =========
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;=========== PrintString =========
		Proc PrintString
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP PrintString
		
		;=========== Exit ===========
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main