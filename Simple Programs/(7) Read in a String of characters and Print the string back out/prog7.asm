.model small
.data
		StringToPrint db 28h dup(0)
		MyChar db ?
		
		ExtraString db "     $"
		
.stack 100h
.code

main:
		call InitSegs
		call ReadString
		call PrintExtraString
		call PrintString
		call PrintChar
		call Exit
		
		;=============== InitSegs ===============
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;================ ReadString ===============
		Proc ReadString
			push ax bx
			
			clc
			mov bx, OFFSET StringToPrint
		next_char:
			call ReadChar
			jc done
			mov al, MyChar
			mov [bx], al
			inc bx
			jmp next_char
		done:
			mov [bx], BYTE PTR '$'

			pop bx ax
		RET
		EndP ReadString
		
		;--------------- ReadChar ------------------
		Proc ReadChar
			push ax
			
			mov ah, 1
			int 21h
			
			mov MyChar, al
			cmp MyChar, 13
			jnz done2
			stc
		done2:
			pop ax
		RET
		EndP ReadChar
		;=============== PrintExtraString ============
		Proc PrintExtraString
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET ExtraString
			int 21h
			
			pop dx ax
		RET
		EndP PrintExtraString
		
		;=============== PrintString ===============
		Proc PrintString
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP PrintString
		
		;================ PrintChar ================
		Proc PrintChar
			push ax dx
			
			mov ah, 2
			mov dl, MyChar
			int 21h
			
			pop dx ax
		RET
		EndP PrintChar
	
		;================= Exit =================
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main