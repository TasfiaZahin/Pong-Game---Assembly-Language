.Model Small

;------------------------------------------------------------------------------------------------------------------------
draw_row Macro x
    Local l1
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ; draws a line in row x from col 5 to col 315
    MOV AH, 0CH
    MOV AL, 1
    MOV CX, 5
    MOV DX, x
L1: INT 10h
    INC CX
    CMP CX, 316
    JL L1
    POP DX
    POP CX
    POP BX
    POP AX
    EndM

;------------------------------------------------------------------------------------------------------------------------
draw_col Macro y
    Local l2
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ; draws a line col y from row 10 to row 179
    MOV AH, 0CH
    MOV AL, 1
    MOV CX, y
    MOV DX, 10
L2: INT 10h
    INC DX
    CMP DX, 180
    JL L2
    POP DX
    POP CX
    POP BX
    POP AX
    EndM

;------------------------------------------------------------------------------------------------------------------------
cursor     macro       x,y
PUSH AX
PUSH BX
PUSH DX
MOV AL, 1              ;PAGE NUMBER
MOV AH, 05H
INT 10H
MOV DH, x   ;ROW
MOV DL, y   ;COLUMN
MOV AH, 02H
MOV BH,1
INT 10H
POP DX
POP BX
POP AX
EndM

;------------------------------------------------------------------------------------------------------------------------
printstring     Macro       Adr
PUSH AX
PUSH DX
MOV DX, OFFSET Adr
MOV AH, 9
INT 21h
POP DX
POP AX
EndM

;------------------------------------------------------------------------------------------------------------------------
.Stack 100h
.Data
;------------------------------------------------------------------------------------------------------------------------

gameovermsg         DB     "  _______  _______  _______  _______    _______           _______  _______  _ ",13,10
                    DB     " (  ____ \(  ___  )(       )(  ____ \  (  ___  )|\     /|(  ____ \(  ____ )( )",13,10
                    DB     " | (    \/| (   ) || () () || (    \/  | (   ) || )   ( || (    \/| (    )|| |",13,10
                    DB     " | |      | (___) || || || || (__      | |   | || |   | || (__    | (____)|| |",13,10
                    DB     " | | ____ |  ___  || |(_)| ||  __)     | |   | |( (   ) )|  __)   |     __)| |",13,10
                    DB     " | | \_  )| (   ) || |   | || (        | |   | | \ \_/ / | (      | (\ (   (_)",13,10
                    DB     " | (___) || )   ( || )   ( || (____/\  | (___) |  \   /  | (____/\| ) \ \__ _ ",13,10
                    DB     " (_______)|/     \||/     \|(_______/  (_______)   \_/   (_______/|/   \__/(_)",13,10,'$'                                                                         

;------------------------------------------------------------------------------------------------------------------------

yay                 DB       "                ,-.----.       ,----..            ,--.               ", 13, 10
                    DB       "                \    /  \     /   /   \         ,--.'|  ,----..      ", 13, 10
                    DB       "                |   :    \   /   .     :    ,--,:  : | /   /   \     ", 13, 10
                    DB       "                |   |  .\ : .   /   ;.  \,`--.'`|  ' :|   :     :    ", 13, 10
                    DB       "                .   :  |: |.   ;   /  ` ;|   :  :  | |.   |  ;. /    ", 13, 10
                    DB       "                |   |   \ :;   |  ; \ ; |:   |   \ | :.   ; /--`     ", 13, 10
                    DB       "                |   : .   /|   :  | ; | '|   : '  '; |;   | ;  __    ", 13, 10
                    DB       "                ;   | |`-' .   |  ' ' ' :'   ' ;.    ;|   : |.' .'   ", 13, 10
                    DB       "                |   | ;    '   ;  \; /  ||   | | \   |.   | '_.' :   ", 13, 10
                    DB       "                :   ' |     \   \  ',  / '   : |  ; .''   ; : \  |   ", 13, 10
                    DB       "                :   : :      ;   :    /  |   | '`--'  '   | '/  .'   ", 13, 10
                    DB       "                |   | :       \   \ .'   '   : |      |   :    /     ", 13, 10
                    DB       "                `---'.|        `---`     ;   |.'       \   \ .'      ", 13, 10
                    DB       "                  `---`                  '---'          `---`        ", 13, 10, '$'

startmsg            DB                            "Enter Player Name and Press Enter !$"

credit              DB                 "Created by Tasfia Zahin (1405041) and Md. Yasin (1405044)   ",13, 10
                    DB       "                                  CSE, BUET                           ",13, 10,'$' 
;------------------------------------------------------------------------------------------------------------------------

backmsg         DB  "Press any key to restart!$"
playernamemsg   DB  "Player: $"
hsmsg           DB  "Highscore: $"

player_name     DB  50 DUP('$')

new_timer_vec   dw  ?,?
old_timer_vec   dw  ?,?
timer_flag      db  0
vel_x           dw  5
vel_y           dw  5

bat_x           dw  80
bat_y           dw  110
bat_speed       dw  9

count_score     db 0
count_life      db 35h

game_flag       DW 0
life_flag       dw 0
temp            dw ?
;------------------------------------------------
handle dw ?

buffer db 512 dup(0)
buffer_name db 512 dup(0)
buffer_score db 512 dup(0)

FILENAME DB 'hs.txt',0

size dw 0
name_size dw 0
score_size dw 0

highscore dw 0
new_highscore db 512 dup(0)
new_highscore_size dw 0
player_name_size dw 0
 
.Code

;--------------------------------------------------------initialization--------------------------------------------------
initialization proc near
    mov timer_flag,0
    mov vel_x,5
    mov vel_y,5
    mov bat_x,80
    mov bat_y,110
    mov bat_speed,9
    mov count_score,0
    mov count_life,33h
    mov game_flag,0
    mov life_flag,0
    mov temp,0
    mov cx,50
    mov si,0
empty_name:
    mov player_name[si],'$'
    inc si
    loop empty_name
    
    mov cx,512
    mov si,0
empty_buffer:
    mov buffer[si],'$'
    inc si
    loop empty_buffer
    
    mov cx,512
    mov si,0
empty_buffer_name:
    mov buffer_name[si],'$'
    inc si
    loop empty_buffer_name
    
    mov cx,512
    mov si,0
empty_buffer_score:
    mov buffer_score[si],'$'
    inc si
    loop empty_buffer_score
    
    mov cx,512
    mov si,0
empty_new_highscore:
    mov new_highscore[si],'$'
    inc si
    loop empty_new_highscore
    
    ret
initialization endp


;----------------------------------------------------------startpage-----------------------------------------------------
startpage proc near

    ; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 10h; 640x350 16 color
    INT 10h
    
    
    cursor 0,0
    printstring yay        ;PRINT PONG
    
    
    cursor 15,23
    printstring startmsg   
    
    cursor 22,12
    printstring credit    
    
    cursor 17,35
    xor si,si
    
name_input:

    mov ah,0                ;KEYBOARD INPUT
    int 16h
    
    cmp al,0
    je name_input
    cmp al,0dh               
    je enter_pressed
    cmp al,20h
    je name_input
    cmp si,10
    je name_input
    
    mov player_name[si],al
    inc si
    
    mov ah,2
    mov dl,al
    int 21h
    
    jmp name_input
    
enter_pressed:
    cmp si,0
    je name_input
    mov player_name_size,si
    jmp go_to_gamepage
    
go_to_gamepage:
    ret
startpage endp

;------------------------------------------------------------------------------------------------------------------------

clearscreen proc near
    MOV AL, 13H ;changes the num of pixels to 640X480 with 16 colors
    MOV AH, 0
    INT 10H

    ret
clearscreen ENDP

;----------------------------------------------------------gamepage------------------------------------------------------
set_display_mode Proc
; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 04h; 320x200 4 color
    INT 10h
; select palette    
    MOV AH, 0BH
    MOV BH, 1
    MOV BL, 1
    INT 10h
; set bgd color
    MOV BH, 1
    MOV BL, 1; cyan
    INT 10h
; draw boundary

    draw_row 10
    draw_row 179
    draw_col 5
    draw_col 315
    
    cursor 0,1
    printstring playernamemsg
    cursor 0,9
    printstring player_name
    cursor 0,21
    printstring hsmsg
    cursor 0,31
    printstring buffer_name
    cursor 0,37
    printstring buffer_score
    
    
    RET
set_display_mode EndP

;---------------------------------------------------------batcontrol----------------------------------------------------

display_bat proc
;display two bats at col 20 and 300 from row bat_x to row bat_y
;input : AL = color of bat
;    CX = col
;    DX = row

    PUSH BX
    PUSH CX
    PUSH DX

    MOV AH, 0CH
    MOV CX, 20
    MOV DX, bat_x
left_bat: INT 10h
    INC DX
    CMP DX, bat_y
    JL left_bat
    
    MOV AH, 0CH
    MOV CX, 300
    MOV DX, bat_x
right_bat: INT 10h
    INC DX
    CMP DX, bat_y
    JL right_bat
    
    POP DX
    POP CX
    POP BX
 
    RET    
display_bat endp

move_bat Proc
    PUSH DX            ;save DX
    
    MOV AL,0           ;erase bat at current position and display at new position
    CALL display_bat
    
    MOV AH,6H          ;input from keyboard
    MOV DL, 0FFH
    INT 21H
   
    
    CMP AL,72          ;is up_arrow?
    JE dec_index
    CMP AL,80          ;is down_arrow?
    JE inc_index
    JMP display_new
    
dec_index:
    MOV DX,bat_x
    SUB DX,bat_speed
    
    CMP DX,10          ;checking boundary
    JLE display_new_before1
    
    MOV bat_x,DX
    MOV DX,bat_y
    SUB DX,bat_speed
    MOV bat_y,DX
    JMP display_new
    
inc_index:
    MOV DX,bat_y
    ADD DX,bat_speed
    
    CMP DX,180         ;checking boundary
    JGE display_new_before2   
    
    MOV bat_y,DX
    MOV DX,bat_x
    ADD DX,bat_speed
    MOV bat_x,DX
    JMP display_new
    
display_new_before1:
    MOV bat_x,11
    MOV bat_y,41
    JMP display_new

display_new_before2:
    MOV bat_x,149
    MOV bat_y,179
    JMP display_new
    

display_new:
    MOV AL,3
    CALL display_bat
    POP DX
    RET
    
move_bat endp

;----------------------------------------------------------ballcontrol--------------------------------------------------

display_ball Proc
; displays ball at col CX and row DX with color given in AL
; input: AL = color of ball
;    CX = col
;    DX = row
    MOV AH, 0CH ; write pixel
    INT 10h
    INC CX      ; pixel on next col
    INT 10h
    INC DX      ; down 1 row
    INT 10h
    DEC CX      ; prev col
    INT 10h
    DEC DX      ; restore dx
    
    draw_col 160
    
    RET 
display_ball EndP

move_ball Proc
; erase ball at current position and display at new position
; input: CX = col of ball position
;    DX = rwo of ball position
; erase ball
    
    MOV AL, 0
    CALL display_ball
; get new position
    ADD CX, vel_x
    ADD DX, vel_y
; check boundary
   
    CALL check_boundary
    
; wait for 1 timer tick to display ball
test_timer:
    CMP timer_flag, 1
    JNE test_timer
    MOV timer_flag, 0
    MOV AL, 3
    CALL display_ball
    
    RET 
move_ball EndP

;----------------------------------------------------boundarychecking----------------------------------------------------
check_boundary Proc
; determine if ball is outside screen, if so move it back in and 
; change ball direction
; input: CX = col of ball
;    DX = row of ball
; output: CX = valid col of ball
;     DX = valid row of ball
; check col value
    CMP CX, 6
    JG LP1
    MOV CX, 160
    MOV DX, 11
    NEG vel_x

    CALL DEC_COUNT_LIFE
    
    JMP LP2 
LP1:    
    CMP CX, 313
    JL LP2
    MOV CX, 160
    MOV DX, 11
    NEG vel_x
    
    CALL DEC_COUNT_LIFE
    JMP LP2
    
; check row value
LP2:    
    CMP DX, 11
    JG LP3
    MOV DX, 11
    NEG vel_y
    JMP done
LP3:    CMP DX, 177
    JL done
    MOV DX, 177
    NEG vel_y
done:
    CALL touch_the_bat
    jmp exit
    
exit:
    RET 
check_boundary EndP

touch_the_bat proc
    
    CMP DX,bat_x
    JGE TB1
    JMP GO_OUT
TB1:
    CMP DX,bat_y
    JLE TB2
    JMP GO_OUT
TB2:
    CMP CX,22
    JL TB3
    JMP TB4
TB3:
    CMP CX,16
    JG neg_x
    JMP GO_OUT
TB4:    
    CMP CX,294
    JG TB5
    JMP GO_OUT
TB5:
    CMP CX,300
    JL neg_x
    JMP GO_OUT

neg_x:
    NEG vel_x
   
    call inc_count_score
  
     
GO_OUT:
        
    RET
touch_the_bat endp

;------------------------------------------------------------------------------------------------------------------------
inc_count_score proc

    cmp game_flag,1
    je exit2
    
    inc count_score
    call show_score
    
    call speedup
    
    exit2:
    ret

inc_count_score endp

;------------------------------------------------------------------------------------------------------------------------
speedup proc
    push dx
    cmp count_score,10
    jle dont
    
    mov dl,count_score
    rcr dl,1
    jnc change_vel_y
    jmp dont
    
change_vel_y:
    cmp vel_y,0
    jge inc_vel_y
    jmp dec_vel_y
    
inc_vel_y:
    inc vel_y
    jmp dont

dec_vel_y:
    dec vel_y
    jmp dont
    
dont:
    pop dx
    ret
speedup endp

;------------------------------------------------------------------------------------------------------------------------
DEC_COUNT_LIFE PROC
    cmp game_flag,1
    je exit1
    
    DEC COUNT_LIFE
    
    CMP count_life,30h
    je game_over
    jmp exit1
    
    game_over:
    mov game_flag,1
    
    
    
    exit1:
    call show_life
    RET
DEC_COUNT_LIFE ENDP

;------------------------------------------------------------------------------------------------------------------------
DISPLAY_GAME_OVER PROC NEAR

    ; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 10h; 320x200 4 color
    INT 10h
    
    cursor 5,0
    printstring gameovermsg
    
    cursor 20,25
    printstring backmsg
    
    call update_highscore
    
    RET
DISPLAY_GAME_OVER ENDP


;------------------------------------------------------------------------------------------------------------------------

OPEN PROC NEAR
    ;OPENS FILE
    ;INPUT DS:DX FILENAME, AL ACCESS CODE
    ;OUTPUT IF SUCCESSFUL AX HANDLE
    ;IF UNSUCCESSFUL CF =1 , AX = ERROR CODE
    MOV AH,3DH
    INT 21H
    RET 
OPEN ENDP  

;-------------------------------------------------------------------------------------------------------------------------
READ PROC NEAR
    ;READS A FILE SECTOR
    ;INPUT: BX FILE HANDLE
    ;CX BYTES TO READ
    ;DS:DX BUFFER
    ;OUTPUT: IF SUCCESSFUL, SECTOR IN BUFFER
    ;AX NUMBER OF BYTED READ
    ; IF UNSUCCESSFUL CF =1
    PUSH CX
    MOV AH,3FH
    MOV CX,512
    INT 21H
    POP CX
  
    RET
READ ENDP
;-------------------------------------------------------------------------------------------------------------------------
WRITE PROC NEAR
    ;WRITES A FILE
    ;INPUT BX = HANDLE
    ;CX = BYTES TO WRITE
    ;DS:DX = DATA ADDRESS
    ;OUTPUT: AX = BYTES WRITTEN
    ;IF UNSUCCESSFUL CF =1, AX = ERROR CODE
    MOV AH,40H
    INT 21H
   
    RET
WRITE ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLOSE PROC NEAR
    ;CLOSES A FILE
    ;INPUT BX = HANDLE
    ;OUTPUT CF =1; ERROR CODE IN AX
    MOV AH,3EH
    INT 21H

    RET
CLOSE ENDP
;-------------------------------------------------------------------------------------------------------------------------
read_file proc near
    MOV AX,@DATA
    MOV DS,AX   ;INITIALIZE DS
    MOV ES,AX   ; AND ES
    
    lea dx,filename
    mov al,0
    call open
    MOV HANDLE,AX
    
    lea dx,buffer
    mov bx,handle
    call read
    mov size,ax
    mov si,0
    mov di,0
setting_name:
    cmp buffer[si],20h
    je setting
    
    mov al,buffer[si]
    mov buffer_name[di],al
    
    inc si
    inc di
    jmp setting_name
setting:
    mov buffer_name[di],'$'
    mov name_size,di
    mov di,0
    inc si
setting_score:
    cmp si,size
    je setting_done
    
    mov al,buffer[si]
    mov buffer_score[di],al
    
    inc si
    inc di
    jmp setting_score
    
setting_done: 
    mov buffer_score[di],'$'  
    mov score_size,di        
    
    call todigit
    
    mov bx,handle
    call close
    
    ret
read_file endp
;-------------------------------------------------------------------------------------------------------------------------
update_highscore proc near
    
    mov bx,highscore
    mov bh,0
    cmp count_score,bl
    jg update
    jmp finish_update
    
update:
    call delete_file
    call open_new_file
    mov handle,ax
    
    mov si,player_name_size
    mov player_name[si],20h
    inc si
    
    mov bx,handle
    mov cx,si
    lea dx,player_name
    call write
    
    call print_number
    mov bx,handle
    mov cx,new_highscore_size
    lea dx,new_highscore
    call write
    
    mov bx,handle
    call close
 
finish_update:
    RET
update_highscore endp
;-------------------------------------------------------------------------------------------------------------------------
open_new_file proc near
    mov ah,3ch
    mov al,1
    lea dx,filename
    mov cl,0
    int 21h

    ret
open_new_file endp

;-------------------------------------------------------------------------------------------------------------------------
delete_file proc near
    mov ah, 41h
    mov dx,offset filename
    int 21h

    ret
delete_file endp
;-------------------------------------------------------------------------------------------------------------------------
todigit proc near    
    xor si,si
    xor ax,ax
    mov cx,score_size
while_loop:
    
    mov dl,buffer_score[si]
    inc si
    sub dl,'0'
 
    mov bx,10
    mul bx
    
    add al,dl
    mov ah,0
    loop while_loop
    
    mov highscore,ax

    RET
todigit endp

;-------------------------------------------------------------------------------------------------------------------------
PRINT_number PROC NEAR   ;PRINT A DECIMAL NUMBER (GCD)

    MOV Al,count_score
    mov ah,0
    MOV BX,10
    MOV CX,0
    MOV SI,0

TAKE_REMAINDER: 
    XOR DX,DX
    DIV BX
    PUSH DX 
    INC CX
    CMP AX,0
    JE PRINT
    JMP TAKE_REMAINDER

PRINT:
    POP DX
    
    ADD DX,'0'
    MOV new_highscore[SI],DL
    INC SI
    LOOP PRINT 
    
    mov new_highscore_size,si

    RET

PRINT_number ENDP 
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
show_life proc
    push ax
    push bx
    push dx
    push cx
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 25
    INT 10H
    MOV AH, 9
    MOV AL, 'L'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 26
    INT 10H
    MOV AH, 9
    MOV AL, 'I'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 27
    INT 10H
    MOV AH, 9
    MOV AL, 'F'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 28
    INT 10H
    MOV AH, 9
    MOV AL, 'E'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 29
    INT 10H
    MOV AH, 9
    MOV AL, ':'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 30
    INT 10H
    MOV AH, 9
    MOV AL,count_life
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    pop cx
    pop dx
    pop bx
    pop ax
    
    ret
show_life endp
    
;------------------------------------------------------------------------------------------------------------------------
show_score proc
    push ax
    push bx
    push dx
    push cx

    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 3
    INT 10H
    MOV AH, 9
    MOV AL, 'S'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 4
    INT 10H
    MOV AH, 9
    MOV AL, 'C'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 5
    INT 10H
    MOV AH, 9
    MOV AL, 'O'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 6
    INT 10H
    MOV AH, 9
    MOV AL, 'R'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 7
    INT 10H
    MOV AH, 9
    MOV AL, 'E'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 8
    INT 10H
    MOV AH, 9
    MOV AL, ':'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 9
    INT 10H
    
    MOV DX, 0
    MOV Al, COUNT_SCORE
    mov ah,0
    MOV TEMP, 10000
    DIV TEMP
    MOV TEMP, DX
    
    MOV AH, 9
    ADD AL, '0'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 10
    INT 10H
    
    MOV DX, 0
    MOV Al, COUNT_SCORE
    mov ah,0
    MOV TEMP, 1000
    DIV TEMP
    MOV TEMP, DX
    
    MOV AH, 9
    ADD AL, '0'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 11
    INT 10H
    
    MOV DX, 0
    MOV Al, COUNT_SCORE
    mov ah,0
    MOV TEMP, 100
    DIV TEMP
    MOV TEMP, DX
    
    MOV AH, 9
    MOV BL, 3
    ADD AL, '0'
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 12
    INT 10H
    
    MOV DX, 0
    MOV AX, TEMP
    MOV TEMP, 10
    DIV TEMP
    MOV TEMP, DX
    
    MOV AH, 9
    ADD AL, '0'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    MOV AH,2
    MOV BH, 0
    MOV DH, 24
    MOV DL, 13 
    INT 10H
    
    
    MOV AX, TEMP
    MOV AH, 9
    ADD AL, '0'
    MOV BL, 3
    MOV CX, 1
    INT 10H
    
    
    pop cx
    pop dx
    pop bx
    pop ax
    
    ret

show_score endp

;------------------------------------------------------------------------------------------------------------------------
timer_tick Proc
    PUSH DS
    PUSH AX
    
    MOV AX, Seg timer_flag
    MOV DS, AX
    MOV timer_flag, 1
    
    POP AX
    POP DS
    
    IRET
timer_tick EndP

;------------------------------------------------------------------------------------------------------------------------
setup_int Proc
; save old vector and set up new vector
; input: al = interrupt number
;    di = address of buffer for old vector
;    si = address of buffer containing new vector
; save old interrupt vector
    MOV AH, 35h ; get vector
    INT 21h
    MOV [DI], BX    ; save offset
    MOV [DI+2], ES  ; save segment
; setup new vector
    MOV DX, [SI]    ; dx has offset
    PUSH DS     ; save ds
    MOV DS, [SI+2]  ; ds has the segment number
    MOV AH, 25h ; set vector
    INT 21h
    POP DS
    RET
setup_int EndP

;------------------------------------------------------------------------------------------------------------------------

main Proc
    MOV AX, @data
    MOV DS, AX

restart:
    
    CALL startpage
    call clearscreen
    
    ;cursor 19,35
    ;MOV AH,9
    ;LEA DX,player_name
    ;INT 21H
    CALL read_file    
    CALL set_display_mode     ; set graphics display mode & draw border
    
    MOV new_timer_vec, offset timer_tick    ; set up timer interrupt vector
    MOV new_timer_vec+2, CS
    MOV AL, 1CH; interrupt type
    LEA DI, old_timer_vec
    LEA SI, new_timer_vec
    CALL setup_int
    
    call show_score
    call show_life
    

    MOV CX, 21          ; start ball at col = 20, row = 95 & for the rest of the program CX = ball row, DX = ball col
    MOV DX, 95
    MOV AL, 3
    CALL display_ball
    Call display_bat
    
tt:
    CMP timer_flag, 1   ; wait for timer tick before moving the ball
    JNE tt
    cmp game_flag,1     ; if life is zero
    je last
    MOV timer_flag, 0
    CALL move_ball
    CALL move_bat
    jmp tt

last:
    call clearscreen
    call display_game_over
    mov ah,1
    int 21h
    call initialization
    call clearscreen
    jmp restart

    main EndP
End main
    