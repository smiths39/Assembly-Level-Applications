.model small
.data
		StringToPrint db "%"
		Str_Length dw 1
		ROW db 15
		COL db 20
		Color db 15
.stack 100h
.code
	
main:
		call InitSegs
		call PrintColorString
		call Exit
		
		;============= InitSegs ============
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;============ PrintColorString =======
		Proc PrintColorString
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, Color
			mov cx, Str_Length
			mov dh, ROW
			mov dl, COL
			mov bp, OFFSET StringToPrint
			int 10h
			
			pop bp dx cx bx ax 
		RET
		EndP PrintColorString
		
		;============= Exit ==============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main