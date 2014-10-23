.model small
.data
		MyChar db ?
.stack 100h
.code

main:
		call InitSegs
		call ReadChar
		call PrintChar
		call Exit
		
		;============ InitSegs ===========
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;============== ReadChar ============
		Proc ReadChar
			push ax
			
			mov ah, 1
			int 21h
			
			mov MyChar, al
			cmp MyChar, 13
			jnz done
			stc
		done:
			pop ax
		RET
		EndP ReadChar
		
		;=============== PrintChar ===========
		Proc PrintChar
			push ax dx
			
			mov ah, 2
			mov dl, MyChar
			int 21h
		
			pop dx ax
		RET
		EndP PrintChar
		
		;=============== Exit ==============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
		
			pop ax
		RET
		EndP Exit
end main