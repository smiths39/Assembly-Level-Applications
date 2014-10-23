.model small
.data
		StringToPrint db "Enter a word: $"
		MyString db 28h dup(0)
		MyChar db ?
		BlankString db "    $"
		Str_Length dw 4
		Row db 0
		Col db 1
		Color db 5

.stack 100h
.code

main:
		call InitSegs
		call Print_Prompt
		call ReadString
		call Blank
		call PrintColorString
		call Wait4Key
		mov cx, 15
	done:
		call Blank
		call PrintColorString
		call Delay
		call PrintBlank
		inc col
		inc col
		inc col
		inc col
		inc row
		loop done
		
		call Exit
		
		;============= InitSegs ================
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;============== Print_Prompt ==============
		Proc Print_Prompt
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP Print_Prompt
		
		;============= ReadString ==============
		Proc ReadString
			push ax bx
			
			clc
			mov bx, OFFSET MyString
		next_char:
			call ReadChar
			jc done2
			mov al, MyChar
			mov [bx], al
			inc bx
			jmp next_char
		done2:
			mov [bx], BYTE PTR '$'
		
			pop bx ax
		RET
		EndP ReadString
		
		;------------- ReadChar ------------------
		Proc ReadChar
			push ax
		
			mov ah, 1
			int 21h
			
			mov MyChar, al
			cmp MyChar, 13
			jnz done3
			stc
		done3:
			pop ax
		RET
		EndP ReadChar
		
		;============== Blank ==================
		Proc Blank
			push ax bx cx dx
			
			mov bh, 0
			mov bl, 0
			sub cx, cx
			mov dx, 184fh
			mov ax, 0600h
			int 10h
			
			pop dx cx bx ax
		RET
		EndP Blank
		
		;=============== Delay ==================
		Proc Delay
			push cx dx
			
			mov dx, 0FFFFh
		dec_again:
			mov cx, 300h
		dec2:
			loop dec2
			dec dx
			jnz dec_again
		
			pop cx dx
		RET
		EndP Delay
		
		;============= Wait4Key ===============
		Proc Wait4Key
			push ax
			
			mov ah, 0h
			int 16h
			
			pop ax
		RET
		EndP Wait4Key
		
		;============= PrintBlank ===============
		Proc PrintBlank
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET BlankString
			int 21h
			
			pop dx ax
		RET
		EndP PrintBlank
		
		;============= PrintColorString ===========
		Proc PrintColorString
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, Str_Length
			mov dh, Row
			mov dl, Col
			mov bp, OFFSET MyString
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintColorString
		;=============== Exit =================
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main