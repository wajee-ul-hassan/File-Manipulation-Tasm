.model small
.stack 100h
.data
    ; Messages and buffers for prompts and input
      ; main menu
	 menu db 13, 10
     db '             =====================================', 13, 10
     db '             |      WELCOME TO FILE MANAGER       |', 13, 10
     db '             =====================================', 13, 10
     db '             |          Choose an action          |', 13, 10
     db '             =====================================', 13, 10
     db '             |                                    |', 13, 10
     db '             |  1. Copy                           |', 13, 10
     db '             |  2. Append 1->2,3                  |', 13, 10
     db '             |  3. Append 3->1,2                  |', 13, 10
     db '             |  4. Remove A                       |', 13, 10
     db '             |  0. Quit Application               |', 13, 10
     db '             |                                    |', 13, 10
     db '             =====================================', 13, 10
     db '$'

    done_msg db 0Dh, 0Ah, "DONE DONE", 0Dh, 0Ah, '$'
	test_msg db 0Dh, 0Ah, "wajee's testing ", 0Dh, 0Ah, '$'
	
	choice_input db 2, 0, 0  ; Buffer for user choice
	
	fname1 DB 'file1.txt',0
	fhandle1 DW ?
	file_content1 DB 255 dup('$') ; set size=characters in file + 1 for teminator
	fname2 DB 'file2.txt',0
	fhandle2 DW ?
	file_content2 DB 255 dup('$') ; set size=characters in file + 1 for teminator
	fname3 DB 'file3.txt',0
	fhandle3 DW ?
	file_content3 DB 255 dup('$') ; set size=characters in file + 1 for teminator
	content_length DW ? ; Store the length of the content
	new_content1 DB 255 dup('$') 
	new_content2 DB 255 dup('$') 
	new_content3 DB 255 dup('$') 
.code
main proc
    ; Initialize the data segment
    mov ax, @data
    mov ds, ax

    ; Display welcome message
    mov ah, 09h
    lea dx, menu
    int 21h

     ;Get user input for choice
	mov ah, 01h
	int 21h

	; Branch to the selected functionality
	cmp al, '1'             ; Compare with ASCII value of '1'
	je task_make_same
	cmp al, '2'             ; Compare with ASCII value of '2'
	je task_append_1_to_23
	cmp al, '3'             ; Compare with ASCII value of '3'
	je task_append_3_to_12
	cmp al, '4'             ; Compare with ASCII value of '4'
	je task_remove_a
	jmp done                ; If invalid choice, skip to the end


; -------------------------------------------
; Task 1: Make all file's content same
; -------------------------------------------
task_make_same:

	call LOAD_FILE1
    ;Calculate actual length of file_content1 (excluding the $ terminator)
    lea si, file_content1
	call cal_length

    ; Write to file2.txt
    lea dx, fname2
    call WRITE_FILE

    ; Write to file3.txt
    lea dx, fname3
    call WRITE_FILE

    jmp done
; ----------------------------------------------
; Task 2: Append file1 content to files 2 and 3
; ----------------------------------------------
task_append_1_to_23:
   ; Load content of file1
    call LOAD_FILE1

    lea si, file_content1
    call cal_length ; Get valid length of file_content1
    
    ; Append content of file1 to file2
    lea dx, fname2
    call APPEND_FILE1 ; Append to file2

    ; Append content of file1 to file3
    lea dx, fname3
    call APPEND_FILE1 ; Append to file3

    jmp done

; -------------------------------------------
; Task 3: Append file 3 to files 1 and 2
; -------------------------------------------
task_append_3_to_12:
    ; Load content of file3
	call LOAD_FILE3
	
    lea si, file_content3
    call cal_length ; Get valid length of file_content1
    
    ; Append content of file3 to file1
    lea dx, fname1
    call APPEND_FILE3 ; Append to file2

    ; Append content of file3 to file2
    lea dx, fname2
    call APPEND_FILE3 ; Append to file3
    jmp done

; -------------------------------------------
; Task 4: Clear 'A' from all files
; -------------------------------------------
task_remove_a:
;--------removing A from file1----------------------
    ; Process file1.txt
	call LOAD_FILE1
	
    lea si, file_content1
	lea di, new_content1    ; Set DI to the new output buffer
    call REMOVE_A
	
;--------removing A from file2--------------------------
    ; Process file2.txt
	call LOAD_FILE2
		
    lea si, file_content2
	lea di, new_content2    ; Set DI to the new output buffer
    call REMOVE_A
	
;---------removing A from file 3----------------------------
    ; Process file3.txt
	call LOAD_FILE3
	
    lea si, file_content3
	lea di, new_content3    ; Set DI to the new output buffer
    call REMOVE_A
	
;----------------------Writing  the modified content back to files--------------------------------------
;File1
	lea si,new_content1
	call cal_length
	
    mov ah, 3Ch           ; Create file1.txt or overwrite
    lea dx, fname1
    xor cx, cx
    int 21h
    mov fhandle1, ax
    mov ah, 40h           ; Write modified content
    mov bx, fhandle1
    lea dx, new_content1
    mov cx, content_length           ; Assuming max size
    int 21h
	
    mov ah, 3Eh           ; Close file
    mov bx, fhandle1
    int 21h
;File2
	lea si,new_content2
	call cal_length
	
    mov ah, 3Ch           ; Create file1.txt or overwrite
    lea dx, fname2
    xor cx, cx
    int 21h
    mov fhandle2, ax
    mov ah, 40h           ; Write modified content
    mov bx, fhandle2
    lea dx, new_content2
    mov cx, content_length           ; Assuming max size
    int 21h
	
	mov ah, 3Eh           ; Close file
    mov bx, fhandle2
    int 21h
;File3
	lea si,new_content3
	call cal_length
	
    mov ah, 3Ch           ; Create file1.txt or overwrite
    lea dx, fname3
    xor cx, cx
    int 21h
    mov fhandle3, ax
    mov ah, 40h           ; Write modified content
    mov bx, fhandle3
    lea dx, new_content3
    mov cx, content_length           ; Assuming max size
    int 21h
	
    mov ah, 3Eh           ; Close file
    mov bx, fhandle3
    int 21h

    jmp done
;---------------------------------------------------------EXIT-----------------------------------------------------------------------------------
done:
    ; Print "DONE DONE" message
    lea dx, done_msg
    mov ah, 09h
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h

main endp

                                                    ; -------------------------------------------
                                                    ; 				FUNCTIONS
                                                    ; -------------------------------------------
;----------------------------------------------Load File1------------------------------------------------------------
LOAD_FILE1 PROC
  ;open file
  mov ah,3dh
  lea dx,fname1
  mov al,0
  int 21h
  mov fhandle1,ax
  
  ;read from file  
  mov ah,3fh
  lea dx,file_content1
  mov cx,255 ;no of characters in file + 2 
  mov bx,fhandle1
  int 21h
  
  
  ;close file
  mov ah,3eh
  mov bx,fhandle1
  int 21h
  ret
  LOAD_FILE1 ENDP
;-------------------------------------------Load File2------------------------------------------------------------------ 
LOAD_FILE2 PROC
  ;open file
  mov ah,3dh
  lea dx,fname2
  mov al,0
  int 21h
  mov fhandle2,ax
  
  ;read from file  
  mov ah,3fh
  lea dx,file_content2
  mov cx,255 ;no of characters in file + 2 
  mov bx,fhandle2
  int 21h
  
  
  ;close file
  mov ah,3eh
  mov bx,fhandle2
  int 21h
  ret
  LOAD_FILE2 ENDP
;-------------------------------------------Load File3------------------------------------------------------------------ 
LOAD_FILE3 PROC
 ;open file
  mov ah,3dh
  lea dx,fname3
  mov al,0
  int 21h
  mov fhandle3,ax
  
  ;read from file  
  mov ah,3fh
  lea dx,file_content3
  mov cx,255 ;no of characters in file + 2 
  mov bx,fhandle3
  int 21h
  
  
  ;close file
  mov ah,3eh
  mov bx,fhandle3
  int 21h
  ret
  LOAD_FILE3 ENDP

;-----------------------------------------------------
; WRITE_FILE: Write file_content1 to a specified file
; DX = Address of file name
;-----------------------------------------------------
WRITE_FILE PROC
    ; Create a new file or overwrite if exists
    mov ah, 3Ch
    xor cx, cx ; Normal file attribute
    int 21h
	
    mov bx, ax ; Store file handle in BX

    ; Write content of file1.txt to the file
    mov ah, 40h
    lea dx, file_content1
    mov cx, content_length ; Use the calculated length
    int 21h

    ; Close the file
    mov ah, 3Eh
    int 21h
	
    ret

WRITE_FILE ENDP

;-----------------------------------------------------
; APPEND_FILE: Append content of file 1 to a specified file
; DX = Address of file name
;-----------------------------------------------------
APPEND_FILE1 PROC
    ; Open file in read-write mode
    mov ah, 3Dh         ; Open file function
    mov al, 2           ; Read-write mode
    int 21h             ; DOS interrupt
    mov bx, ax          ; Store file handle

    ; Move file pointer to end
    mov ah, 42h         ; Move file pointer
    mov al, 2           ; Move to end
    xor cx, cx          ; High word of offset
    xor dx, dx          ; Low word of offset
    int 21h

    ; Write appended content
    mov ah, 40h         ; Write to file function
    lea dx, file_content1 ; Address of content to write
    mov cx, content_length       ; Use the calculated length
    int 21h

    ; Close the file
    mov ah, 3Eh         ; Close file function
    int 21h
    ret
APPEND_FILE1 ENDP

;-----------------------------------------------------
; APPEND_FILE: Append content of file 3 to a specified file
; DX = Address of file name
;-----------------------------------------------------
APPEND_FILE3 PROC
    ; Open file in read-write mode
    mov ah, 3Dh         ; Open file function
    mov al, 2           ; Read-write mode
    int 21h             ; DOS interrupt
    mov bx, ax          ; Store file handle

    ; Move file pointer to end
    mov ah, 42h         ; Move file pointer
    mov al, 2           ; Move to end
    xor cx, cx          ; High word of offset
    xor dx, dx          ; Low word of offset
    int 21h

    ; Write appended content
    mov ah, 40h         ; Write to file function
    lea dx, file_content3 ; Address of content to write
    mov cx, content_length       ; Use the calculated length
    int 21h

    ; Close the file
    mov ah, 3Eh         ; Close file function
    int 21h
    ret
APPEND_FILE3 ENDP
;-----------------------------------------------------
; Remove A from a specified file
;-----------------------------------------------------
REMOVE_A PROC
    ; SI points to the input buffer containing file content
    ; DI points to the output buffer (new_content)
REMOVE_A_LOOP:
    mov al, [SI]          ; Load a byte from the input buffer
    cmp al, '$'           ; Check for termination character
    je REMOVE_A_END       ; End loop if reached terminator
    cmp al, 'A'           ; Check if character is 'A'
    jne STORE_CHAR        ; If not 'A', store the character
    inc SI                ; Skip 'A' and move to the next character
    jmp REMOVE_A_LOOP     ; Continue processing

STORE_CHAR:
    mov [DI], al          ; Write AL to the output buffer
    inc DI                ; Move to the next position in the output buffer
    inc SI                ; Move to the next character in the input buffer
    jmp REMOVE_A_LOOP     ; Continue processing

REMOVE_A_END:
    mov byte ptr [DI], '$' ; Add terminator at the end of the output buffer
    ret
REMOVE_A ENDP

;----------------------------------------------------------------------------------------------------------------------------------
; Calculate the length of the string terminated by '$'
cal_length PROC
    xor cx, cx             ; Initialize counter (CX = 0)
find_terminator:
    mov al, [SI]           ; Load a byte from the input string into AL
    cmp al, '$'            ; Check for terminator
    je length_found        ; If found, exit loop
    inc SI                 ; Move to the next character in the input string
    inc cx                 ; Increment the counter
    jmp find_terminator    ; Repeat
length_found:
    mov content_length, cx ; Store the length in content_length
    ret

cal_length ENDP
;------------------------------------------------------------------------------------------------------------------------------------------

end main
