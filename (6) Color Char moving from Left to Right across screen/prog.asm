.model small
.data 
		StringToPrint db "Enter a character: $"
		MyChar db ?
		Row db 3
		Col db 0
		Color db 5
		Counter dw 0
		Direction db 0
		Num_Loops dw 0FFFFh
.stack 100h
.code

main:	
		call InitSegs
		call Print_Prompt
		call ReadChar
		call Wait4Key
		call Blank
		call PrintChar
		call Wait4Key
	done:
		call Blank
		call PrintChar
		call Delay
		call MovePosition
		dec Num_Loops
		loop done
	
		call Exit
		
		;================== InitSegs =====================
		Proc InitSegs
			push ax 
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;================== Print_Prompt ================
		Proc Print_Prompt
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP Print_Prompt
		
		;================= ReadChar ================
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
		
		;============== Wait4Key ================
		Proc Wait4Key
			push ax
			
			mov ah, 0h
			int 16h
			
			pop ax
		RET
		EndP Wait4Key
		;=============== Blank ==================
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
		
		;============== Delay ==================
		Proc Delay
			push cx dx
			
			mov dx, 0FFFFh
		dec_again:
			mov cx, 300h
		dec2:
			loop dec2
			dec dx
			jnz dec_again
			
			pop dx cx
		RET
		EndP Delay
		
		;============== PrintChar ============
		Proc PrintChar
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, 1
			mov dh, row
			mov dl, col
			mov bp, OFFSET MyChar
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintChar
		
		;============== MovePosition =============
		Proc MovePosition 
			push ax bx
			
			cmp direction, 0
			jnz go_left
			inc col
			inc color
			call blank
			xor ax, ax
			mov al, Col
			mov bx, Counter
			add bx, ax
			cmp bx, 79
			jnz not_end
			mov direction, 1
			jmp not_end
		go_left:
			dec col
			inc color
			call blank
			cmp col, 0h
			jnz not_end
			mov direction, 0
		not_end:
			pop bx ax
		RET
		EndP MovePosition
		
		;============== Exit ===============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
		
end main