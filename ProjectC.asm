;-------------Printing string macro----------------
print macro p1
mov dx,offset p1
mov ah,9
int 21h
endm

;--------------------------------------------


.model small
.stack 100h
.data  

buffer2 dw ?
;------File Handling
filelife db "fil.txt",0
handle dw ?
lives db 3

filescore db "score.txt",0
handle1 dw ?

;----game win/lose
uwon db "U won the game $"
ulosee db "U loss the game $"
;----Resume option
   gamereturn db "Press 2 to return to game $"

;-------Life
   Lx1 db 1
   lifesped db ?
   lifetimer db 0
   lifebool db 0
   Lx2 db 1
   lifesped2 db ?
   lifetimer2 db 0
   lifebool2 db 0

;------canonspeed-----
	cannonSpedController db 10
    canAsped db ?
	canBsped db ?
;------BUlletsped---
	cBulletSpedController db 10
    Cbulsped db 0
	Cbulsped1 db 0
;-------bulletvar-------	

    temp db ?
	temp2 db ?
    bulletbool1 db 0
    boool db ?
	boool1 db ?
	boool2 db ?

;---- robo var-----
	rBulletSpedController db 10
	temp4 db ?
	rBulTime2 db 0	
	rbul2 db 20
	rbulfired2 db 0
	temp3 db ?
	rBulTime db 0	
	rbul db 20
	rbulfired db 0
	robot db 3
    rbx1 db 20
	rbx2 db 25
	rbx3 db 18
	rbx4 db 19
	rbx5 db 26
	rbx6 db 27
	rbx7 db 20
	rbx8 db 21
	rbx9 db 24
	rbx10 db 25
	rbx11 db 21
	rbx12 db 24

file db 'file1.txt',0 
buffer db 5000 dup("$")
cy1 db 0
;-----------------Declaration of health variables-----------
coalman db "Coal_Man$"
canonA db "Canon_A$"
canonB db "Canon_B$"
;-------------------------------------------------------------
;-----------------Menu-----------------

strtgame db "Press 1 to Start Game $"
inst db "Press 2 for Instructions $"
Exe db "Press 3 to Exit Game $"
hhighscore db "Press 4 to Highscores $"

;--------------Score

score db "Score : $"
scoreVar db 0
score0 db ?
score1 db ?
score2 db ?
level0 db 1 
level1 db 1
strlevel db "Level : $"
highscore1 db ?
highscore2 db ?
highscore3 db ?

;-------Canons
cx1 db 25
cx0 db 1
cannon1 db 1
cannon2 db 1

;---------Bullets
bx1 db 4
bx2 db 4
b1xaxis db ?
b1xUpd db 1
b2xaxis db ?
b2xUpd db 1
bulltemp db ?
bulltemp2 db ?
bulltemp3 db ?
bulltemp4 db ?


;-----Name array
   entername db "Enter Player Name :  $"

Namee DB 50 dup("$")
.code
	
main proc

mov ax,@data
mov ds,ax


;------------ reading from score file
mov ah,3dh
mov al,2
mov dx,offset filescore
int 21h

jc endgame

mov handle1,ax

mov ah,3fh
mov bx,handle1
mov cx,1
mov dx,offset highscore1
int 21h

mov ah,3fh
mov bx,handle1
mov cx,1
mov dx,offset highscore2
int 21h

mov ah,3fh
mov bx,handle1
mov cx,1
mov dx,offset highscore3
int 21h


mov ah,3eh
mov dx,handle1
int 21h
;----------------

;------------ reading from lif file
mov ah,3dh
mov al,0
mov dx,offset filelife
int 21h

jc endgame

mov handle,ax

mov ah,3fh
mov bx,handle
mov cx,1
mov dx,offset lives
int 21h

sub lives,48

mov ah,3eh
mov dx,handle
int 21h

mov al,lives
mov robot,al

mov cannon1,al
mov cannon2,al
;----------------
 lea dx,offset entername
 mov ah,09
 int 21h
 MOV SI, OFFSET Namee
 lx:
	mov ah,01h
	int 21h
	cmp al,13
	je lxe
	mov [si],al
	inc si
	jmp lx
lxe:
;---------BULLET 1

;-----------------------Video mode------------
 	mov ah, 0h  
 	mov al, 03
 	int 10h



;--------------------------------------------

 
;--------------Menu background---------------
	mov ah,06h 
	mov al,0h
	mov bh,10010000b

	mov ch,1	;y1		
	mov cl,0  	;x1

	mov dh,25	;y2
	mov dl,79	;x2	
	int 10h 

;----------------------------------------------

;----------------Menu options-----------------
	
	;-----------start
	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,5 	;y1		
	mov cl,25  	;x1

	mov dh,6	;y2
	mov dl,55	;x2	
	int 10h 

    mov ah,02                
    mov bx,0
    mov dh,6    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
    print strtgame
    
;-----------inst--------------
	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,10 	;y1		
	mov cl,25  	;x1

	mov dh,11	;y2
	mov dl,55	;x2	
	int 10h 

	mov ah,02                
    mov bx,0
    mov dh,11    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
    print inst

;----------Exit----------------
	mov ah,06h
	mov al,0h
	mov bh,01000000b

	mov ch,15 	;y1		
	mov cl,25  	;x1

	mov dh,16	;y2
	mov dl,55	;x2	
	int 10h 

    mov ah,02                
    mov bx,0
    mov dh,16    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
	
    print Exe

;----------highscores----------------
	mov ah,06h
	mov al,0h
	mov bh,01000000b

	mov ch,20 	;y1		
	mov cl,25  	;x1

	mov dh,21	;y2
	mov dl,55	;x2	
	int 10h 

    mov ah,02                
    mov bx,0
    mov dh,21    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
	
    print hhighscore



	Tiles_Change:
		mov ah,0
		int 16h

		cmp ah,02h
		je L1

		cmp ah,03h
		je instruct

		cmp ah,04h
		je endgame

		cmp ah,05h
		je higscor

		cmp ah,01
		je Exit
	jmp Tiles_Change

instruct:

;--------------Instructions Background---------------
	mov ah,06h 
	mov al,0h
	mov bh,10010000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,23	;y2
	mov dl,79	;x2	
	int 10h 
;--------------------------------------------

mov dx,offset file
mov al,0
mov ah,3Dh
int 21h

mov bx,ax
mov dx,offset buffer
mov ah,3fh
int 21h

mov dx,@data
mov es,dx
mov ah,13h
lea bp,buffer
mov al,0
mov dh,5
mov dl,0
mov cx,242
mov bl,5Fh
int 10h

mov ah,4ch
int 21h



Jmp instruct


higscor:

	mov ah,06h 
	mov al,0h
	mov bh,10010000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,23	;y2
	mov dl,79	;x2	
	int 10h 


Jmp higscor
L1:




;----------------color
mov ax,@data
mov ds,ax
mov ax,1003h
mov bl,0
int 10h



;------------------------Lower Border Line---------

	mov ah,06h 
	mov al,0h
	mov bh,60h

	mov ch,24	;y1		
	mov cl,1	;x1

	mov dh,24	;y2
	mov dl,79	;x2	
	int 10h   


;--------------------------------------------
;-----------------------Upper Grey block---------
	mov ah,06h 
	mov al,0h
	mov bh,01110000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,23	;y2
	mov dl,79	;x2	
	int 10h 


;----------------------------------Side Bar Work--------------------------
;-------------------------------------------------

;-----------------------black block  side---------
	mov ah,06h 
	mov al,0h
	mov bh,00h

	mov ch,2 	;y1		
	mov cl,62  	;x1

	mov dh,23	;y2
	mov dl,78	;x2	
	int 10h 

;-------------------------------------------------

;-----------------------upper blue block---------
	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,3 	;y1		
	mov cl,63  	;x1

	mov dh,22	;y2
	mov dl,77	;x2	
	int 10h 

;-------------------------------------------------


;-----------------------White line  black block---------
	mov ah,06h 
	mov al,0h
	mov bh,11110000b

	mov ch,16 	;y1		
	mov cl,63  	;x1

	mov dh,16	;y2
	mov dl,77	;x2	
	int 10h 

;-------------------------------------------------

 
;------------------- Display Coalman

mov ah,02                
mov bx,0
mov dh,4    ;-----vertical
mov dl,66    ;-----horizantal
int 10h 
   
print coalman


;-----------------------------------

;--------------------- Displaing Level

mov ah,02                
mov bx,0
mov dh,20    ;-----vertical
mov dl,66   ;-----horizantal
int 10h

print strlevel

mov ah,02                
mov bx,0
mov dh,20    ;-----vertical
mov dl,74   ;-----horizantal
int 10h

mov ah,0ah
mov al,level1
add al,48
mov cx,1
mov bh,0
int 10h


;------------------- Display Player name

mov ah,06h 
mov al,0h
mov bh,00111000b

mov ch,22 	;y1		
mov cl,64  	;x1

mov dh,22	;y2
mov dl,76	;x2	
int 10h 

mov ah,02                
mov bx,0
mov dh,22    ;-----vertical
mov dl,65    ;-----horizantal
int 10h 
   
print Namee
;------------------- Display Canon A

mov ah,02                
mov bx,0
mov dh,8    ;-----vertical
mov dl,66    ;-----horizantal
int 10h 
   
print canonA


;-----------------------------------



;------------------- Display Canon B

mov ah,02                
mov bx,0
mov dh,12    ;-----vertical
mov dl,66    ;-----horizantal
int 10h 
   
print canonB


;-----------------------------------

;------------------- Display Score

mov ah,02                
mov bx,0
mov dh,18    ;-----vertical
mov dl,66    ;-----horizantal
int 10h 
   
print score

mov ah,0
mov al,scoreVar
mov bl,10
div bl

mov score0,ah

mov ah,0
div bl

mov score1,ah
mov score2,al




mov ah,02                
mov bx,0
mov dh,18    ;-----vertical
mov dl,74    ;-----horizantal
int 10h

mov ah,0ah
mov bh,0
mov cx,1
mov al,score2
add al,48
int 10h

mov ah,02                
mov bx,0
mov dh,18    ;-----vertical
mov dl,75    ;-----horizantal
int 10h

mov ah,0ah
mov bh,0
mov cx,1
mov al,score1
add al,48
int 10h

mov ah,02                
mov bx,0
mov dh,18    ;-----vertical
mov dl,76    ;-----horizantal
int 10h

mov ah,0ah
mov bh,0
mov cx,1
mov al,score0
add al,48
int 10h

;-----------------------------------


;-----------------------Coal man health---------


;----------------------------
mov al,lives
add al,2
.if robot > al || robot == 0
	jmp ulose
.endif

mov ah,02                
mov bx,0
mov dh,6    ;-----vertical
mov dl,68    ;-----horizantal
int 10h 

		mov ah,0ah
		mov al,186
		mov bh,0
		mov ch,0
		mov cl,robot
		int 10h

;----------------------------
	

;-----------------------Canon A health---------


;----------------------------
mov al,lives
	.if cannon1 > al
	mov cannon1,0
.endif

mov ah,02                
mov bx,0
mov dh,10    ;-----vertical
mov dl,68    ;-----horizantal
int 10h 

		mov ah,0ah
		mov al,222
		mov bh,0
		mov ch,0
		mov cl,cannon1
		int 10h 

;----------------------------
	
;-----------------------Canon B health---------


;----------------------------
mov al,lives
	.if cannon2 > al
	mov cannon2,0
.endif

mov ah,02                
mov bx,0
mov dh,14    ;-----vertical
mov dl,68    ;-----horizantal
int 10h 

		mov ah,0ah
		mov al,222
		mov bh,0
		mov ch,0
		mov cl,cannon2
		int 10h
;---------------------------------Side Bar work End --------------------



;-------------Resume ------------
  mov ah,1
  int 16h

  cmp ah,05
  je res
  JMP notres 
 
  res:
  ;---------Big box
  	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,24	;y2
	mov dl,78	;x2	
	int 10h 
  ;--------Small box
	mov ah,06h 
	mov al,0h
	mov bh,00110000b

	mov ch,10 	;y1		
	mov cl,25  	;x1

	mov dh,11	;y2
	mov dl,55	;x2	
	int 10h 

   ;----------String print

   	mov ah,02                
    mov bx,0
    mov dh,10    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
    print gamereturn


	;----------Keyboard check---	
    mov ah,0
    int 16h
    cmp ah,03
    je notres
    JMP res


   

 notres:


;-----------------Priting canon A--------------------
        

 
        cmp cx0,58
		JAE checkboundary1
		Jmp noboundary
		checkboundary1:
		   mov cx0,5
        noboundary:
  
       
	    
		mov ah,02h
		mov al,01
		mov bh,0d

		mov dl,cx0
		mov dh,1
;		inc cx0
;		inc cy1
		int 10h
	
		mov ah,09h
		mov al,178
		mov bh,0
		mov cx,5	

		mov bl,00010000b
		int 10h

        mov ah,02h
		mov al,01
		mov bh,0d

		mov dl,cx0
		mov dh,2
;		inc cx0
;		inc cy1
		int 10h
	
		mov ah,09h
		mov al,178
		mov bh,0
		mov cx,3	

		mov bl,00010000b
		int 10h

        mov ah,02h
		mov al,01
		mov bh,0d

		mov dl,cx0
		mov temp,dl
		mov dh,3
		mov cl,cannonSpedController
		.if canAsped >= cl
			mov canAsped,0
			jmp incspedA
		.endif
		jmp notspedA
		incspedA:
		inc cx0
		

		notspedA:
;		inc cy1
		int 10h
	
		mov ah,09h
		mov al,178
		mov bh,0
		mov cx,1	

		mov bl,00010000b
		int 10h
               



;--------------------Printing canon B---------------

 
        cmp cx1,58
		JAE checkboundary2
		Jmp noboundary1
		checkboundary2:
		   mov cx1,5
        noboundary1:


        mov ah,02h
		mov al,01
		mov bh,0d

		mov dl,cx1
		mov dh,1
	;	inc cx1
	;	inc cy1
		int 10h
	
		mov ah,09h
		mov al,176
		mov bh,0
		mov cx,5	

		mov bl,01000000b
		int 10h

        mov ah,02h
		mov al,01
		mov bh,0d

		mov dl,cx1
		mov dh,2
	;	inc cx1
	;	inc cy1
		int 10h
	
		mov ah,09h
		mov al,176
		mov bh,0
		mov cx,3	

		mov bl,01000000b
		int 10h

        mov ah,02h
		mov al,01
		mov bh,0d
        mov dl,cx1
		mov temp2,dl
		mov dh,3
		mov cl,cannonSpedController
		.if canBsped >= cl
			mov canBsped,0
			jmp incspedB
		.endif	
		jmp notspedB
		incspedB:
		inc cx1
		

		notspedB:
	;	inc cx1
	;	inc cy1
		int 10h
	
		mov ah,09h
		mov al,176
		mov bh,0
		mov cx,1	

		mov bl,01000000b
		int 10h
        
;--------------------------------------------------

;------------Printing Bullets--------------------

;-----------B
    

		B1:

		.if b1xUpd == 1
			mov al,temp
			mov b1xaxis,al
			mov b1xUpd,0
		.endif		

	    mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,b1xaxis  ;--------x axis
		mov dh,bx1   ;--------y axis
	
		mov cl,b1xaxis
		.if bx1 >= 20
			.if cl >= rbx3 && cl <= rbx6
				dec robot
				mov b1xUpd,1
				mov bx1,4
			.endif
		.endif 

		mov cl,cBulletSpedController
		.if Cbulsped >= cl
			inc bx1
			mov Cbulsped,0
		.endif 

		int 10h
	
		mov ah,0ah
		mov al,'!'
		mov bh,0
		mov cx,1
		int 10h
   
		mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,25
		mov dh,80
		int 10h

		.if bx1 >= 24
			mov b1xUpd,1
			mov bx1,4
			jmp B1
		.endif
		
        
  	     

      
;-----------B
    
	B2:

		.if b2xUpd == 1
			mov al,temp2
			mov b2xaxis,al
			mov b2xUpd,0
		.endif

	    mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,b2xaxis
		mov dh,bx2
	
		mov cl,b2xaxis

		.if bx2 >= 20
			.if cl >= rbx3 && cl <= rbx6
				dec robot
				mov b2xUpd,1
				mov bx2,4
			.endif
		.endif
			
		mov cl,cBulletSpedController
		.if Cbulsped1 >= cl
			inc bx2
			mov Cbulsped1,0
		.endif 
		int 10h
	
		mov ah,09h
		mov al,'!'
		mov bh,0
		mov cx,1	

		mov bl,70h
		int 10h
   
		mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,25
		mov dh,80
		int 10h

        .if bx2 >= 24
			mov b2xUpd,1
			mov bx2,4
			jmp B2
		.endif 


	.if cannon1 == 0 && cannon2 == 0
		inc level1
	.endif	
	
	mov al,level1
	.if level0 != al
		mov al,level1
		mov level0,al
	
		mov al,lives
		mov cannon1,al
		
		mov al,lives
		mov cannon2,al
		
		.if level1 == 2
			mov cBulletSpedController,7
			mov rBulletSpedController,7
			mov cannonSpedController,7
		.endif
		
		.if level1 == 3
			mov cBulletSpedController,4
			mov rBulletSpedController,4
			mov cannonSpedController,4
		.endif
	.endif
 
    .if level1==4
	    Jmp overgame
	.endif


	

;--------------Extra life -------------------
;-----------1
        
   	    .if robot==2 && lifebool==0	   
        
		LL1:

	 
	    mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,20 ;--------x axis
		mov dh,Lx1   ;--------y axis
	
		mov cl,20 
		.if Lx1 >= 20
			.if cl >= rbx3 && cl <= rbx6
				inc robot
				mov Lx1,1
			.endif
		.endif 

		.if lifesped >= 10 
			inc Lx1 
			mov lifesped,0

		.endif 

		int 10h
	
		mov ah,09h
		mov al,186
		mov bh,0
		mov cx,1
		int 10h
   
		mov ah,02h
		mov al,01
		mov bh,0d
        mov bl,000000000b
		mov dl,25
		mov dh,80
		int 10h

		.if Lx1 >= 24
			mov lifebool,1
			mov Lx1,0
			jmp LL1
		.endif
		.endif


;-----------2
        
   	    .if robot==1 && lifebool2==0	   
        
		LL2:

	 
	    mov ah,02h
		mov al,01
		mov bh,0d
        
		mov dl,30 ;--------x axis
		mov dh,Lx2   ;--------y axis
	
		mov cl,30 
		.if Lx2 >= 20
			.if cl >= rbx3 && cl <= rbx6
				inc robot
				mov Lx2,1
				
			.endif
		.endif 

		.if lifesped2 >= 10 
			inc Lx2
			mov lifebool,1 
			mov lifesped2,0

		.endif 

		int 10h
	
		mov ah,09h
		mov al,186
		mov bh,0
		mov cx,1
		int 10h
   
		mov ah,02h
		mov al,01
		mov bh,0d
        mov bl,000000000b
		mov dl,25
		mov dh,80
		int 10h

		.if Lx2 >= 24
			mov lifebool2,1
			mov Lx2,0
			jmp LL2
		.endif
		.endif


        
;----------------Printing Robot---------------



; body----
	mov ah,06h 
	mov al,0h
	mov bh,00010000b

	mov ch,21 	;y1		
	mov cl,rbx1  	;x1

	mov dh,22	;y2
	mov dl,rbx2	;x2	
	int 10h 
;-------leftarm
	mov ah,06h 
	mov al,0h
	mov bh,00000000b

	mov ch,20 	;y1		
	mov cl,rbx3  	;x1

	mov dh,21	;y2
	mov dl,rbx4	;x2	
	int 10h 

;----------rightarm--
	mov ah,06h 
	mov al,0h
	mov bh,00h

	mov ch,20 	;y1		
	mov cl,rbx5  	;x1

	mov dh,21	;y2
	mov dl,rbx6	;x2	
	int 10h 

;---------leftleg
	mov ah,06h 
	mov al,0h
	mov bh,00h

	mov ch,23 	;y1		
	mov cl,rbx7  	;x1

	mov dh,23	;y2
	mov dl,rbx8	;x2	
	int 10h 

;----------rightleg
	mov ah,06h 
	mov al,0h
	mov bh,00h

	mov ch,23 	;y1		
	mov cl,rbx9 	;x1

	mov dh,23	;y2
	mov dl,rbx10	;x2	
	int 10h 


;-----------Face
	mov ah,06h 
	mov al,0h
	mov bh,00h

	mov ch,20 	;y1		
	mov cl,rbx11  	;x1

	mov dh,20	;y2
	mov dl,rbx12	;x2	
	int 10h 
   
   ;---- keyboard movement robot
		mov ah,01
		int 16h

cmp ah,4bh
je moveLeft

cmp ah,4dh
je moveRight



JMP heree

moveLeft:

    dec rbx1
	dec rbx2
	dec rbx3
	dec rbx4
	dec rbx5
	dec rbx6
	dec rbx7
	dec rbx8
	dec rbx9
	dec rbx10
	dec rbx11
	dec rbx12
	   

	JMP heree
moveRight:
    inc rbx1
	inc rbx2
	inc rbx3
	inc rbx4
	inc rbx5
	inc rbx6
	inc rbx7
	inc rbx8
	inc rbx9
	inc rbx10
	inc rbx11
	inc rbx12
	

heree:


;------------robo bullets------------

	.if rbulfired == 0

		mov ax,5
		mov bx,0
		int 33h

		.if bx >= 1
			mov rbulfired,1
			mov al,rbx3
			mov temp3,al
			jmp rbulCancel
		.endif 

	.endif

	


	.if rbulfired == 0
		mov ah,1
		int 16h

		jz rbulCancel

		mov ah,0
		int 16h

		.if al == 32
			mov rbulfired,1
			mov al,rbx3
			mov temp3,al
		.endif
	.endif

	rbulCancel:

	.if rbulfired == 1

		mov ah,02                
		mov bx,0
		mov dh,rbul   ;-----vertical
		mov dl,temp3    ;-----horizantal
		int 10h 

		mov ah,0ah
		mov al,248
		mov bh,0
		mov ch,0
		mov cl,1
		int 10h

		mov al,temp3
		.if rbul == 3 && al == cx0
			dec cannon1
			mov rbul,0
			add scoreVar,1
		.endif
         mov bl,cx0
		 add bl,2
		.if rbul == 2
			.if al >= cx0 && al <= bl
				dec cannon1
				mov rbul,0
			add scoreVar,1
			.endif 
		.endif 
          mov bl,cx0
          add bl,4
		.if rbul == 1
			.if al >= cx0 && al <= bl
				dec cannon1
				mov rbul,0
			add scoreVar,1
			.endif 
		.endif

		.if rbul == 3 && al == cx1
			dec cannon2
			mov rbul,0
			add scoreVar,1
		.endif
         mov bl,cx1
		 add bl,2
		.if rbul == 2
			.if al >= cx1 && al <= bl
				dec cannon2
				mov rbul,0
			add scoreVar,1
			.endif 
		.endif 
          mov bl,cx1
		  add bl,4

		.if rbul == 1
			.if al >= cx1 && al <= bl
				dec cannon2
				mov rbul,0
			add scoreVar,1
			.endif 
		.endif
;===
		mov cl,rBulletSpedController
		.if rBulTime >= cl
			dec rbul
			mov rBulTime,0
		.endif
		.if rbul <= 0
			mov rbulfired,0
			mov rbul,20
		.endif

		mov ah,02                
		mov bx,0
		mov dh,25   ;-----vertical
		mov dl,0    ;-----horizantal
		int 10h

	.endif

;for bullet 2
; JUST COPY PASTE THIS CODE FOR AS MANY BULLETS AS YOU WANT TO MAKE// There was no need for the last check we applied here so I removed it...

		


		.if rbulfired2 == 0
			mov ah,1
			int 16h

			jz rbulCancel2

			mov ah,0
			int 16h

			.if al == 32
				mov rbulfired2,1
				mov al,rbx3
				mov temp4,al
			.endif
		.endif

		rbulCancel2:

		.if rbulfired2 == 1

			mov ah,02                
			mov bx,0
			mov dh,rbul2   ;-----vertical
			mov dl,temp4    ;-----horizantal
			int 10h 

			mov ah,0ah
			mov al,248
			mov bh,0
			mov ch,0
			mov cl,1
			int 10h


		mov al,temp4
		.if rbul2 == 3 && al == cx0
			dec cannon1
			mov rbul2,0
			add scoreVar,1
		.endif
         mov bl,cx0
		 add bl,2
		.if rbul2 == 2
			.if al >= cx0 && al <= bl
				dec cannon1
				mov rbul2,0
			add scoreVar,1
			.endif 
		.endif 
         mov bl,cx0
		 add bl,4
		.if rbul2 == 1
			.if al >= cx0 && al <= bl
				dec cannon1
				mov rbul2,0
			add scoreVar,1
			.endif 		
			.endif 

		.if rbul2 == 3 && al == cx1
			dec cannon2
			mov rbul2,0
			add scoreVar,1
		.endif
         mov bl,cx1
		 add bl,2
		.if rbul2 == 2
			.if al >= cx1 && al <= bl
				dec cannon2
				mov rbul2,0
			add scoreVar,1
			.endif 
		.endif 
         mov bl,cx1
		 add bl,4
		.if rbul2 == 1
			.if al >= cx1 && al <= bl
				dec cannon2
				mov rbul2,0
			add scoreVar,1
			.endif 
		.endif

			mov cl,rBulletSpedController
			.if rBulTime2 >= cl
				dec rbul2
				mov rBulTime2,0
			.endif
			.if rbul2 <= 0
				mov rbulfired2,0
				mov rbul2,20
			.endif

			mov ah,02                
			mov bx,0
			mov dh,25   ;-----vertical
			mov dl,0    ;-----horizantal
			int 10h

		.endif
	;end for bullet 2

	passAllBullets:

;-----------robo boundary check----
       robonoboundary00:
        cmp rbx1,60
		JAE robocheckboundary1
		cmp rbx2,60
		JE robocheckboundary2
		        cmp rbx3,60
		JE robocheckboundary3
		        cmp rbx4,60
		JE robocheckboundary4
		        cmp rbx5,60
		JE robocheckboundary5
		        cmp rbx6,60
		JE robocheckboundary6
		        cmp rbx7,60
		JE robocheckboundary7
		        cmp rbx8,60
		JE robocheckboundary8
		        cmp rbx9,60
		JE robocheckboundary9
		        cmp rbx10,60
		JE robocheckboundary10
		        cmp rbx11,60
		JE robocheckboundary11
		        cmp rbx12,60
		JE robocheckboundary12
	

		Jmp robonoboundary
		robocheckboundary1:
		   mov rbx1,2
				Jmp robonoboundary00
		robocheckboundary2:
		   mov rbx2,2
		   		Jmp robonoboundary00
		robocheckboundary3:
		   mov rbx3,2
		   		Jmp robonoboundary00
		robocheckboundary4:
		   mov rbx4,2
		   		Jmp robonoboundary00
		robocheckboundary5:
		   mov rbx5,2
		   		Jmp robonoboundary00
		robocheckboundary6:
		   mov rbx6,2
		   		Jmp robonoboundary00
		robocheckboundary7:
		   mov rbx7,2
		   		Jmp robonoboundary00
		robocheckboundary8:
		   mov rbx8,2
		   		Jmp robonoboundary00
		robocheckboundary9:
		   mov rbx9,2
		   		Jmp robonoboundary00
		robocheckboundary10:
		   mov rbx10,2
		   		Jmp robonoboundary00
		robocheckboundary11:
		   mov rbx11,2
		   		Jmp robonoboundary00
		robocheckboundary12:
		   mov rbx12,2
		   		Jmp robonoboundary
	

        robonoboundary:

;--------left boundry
       robonoboundary00l:
        cmp rbx1,1
		JE robocheckboundary1l
		cmp rbx2,1
		JE robocheckboundary2l
		        cmp rbx3,1
		JE robocheckboundary3l
		        cmp rbx4,1
		JE robocheckboundary4l
		        cmp rbx5,1
		JE robocheckboundary5l
		        cmp rbx6,1
		JE robocheckboundary6l
		        cmp rbx7,1
		JE robocheckboundary7l
		        cmp rbx8,1
		JE robocheckboundary8l
		        cmp rbx9,1
		JE robocheckboundary9l
		        cmp rbx10,1
		JE robocheckboundary10l
		        cmp rbx11,1
		JE robocheckboundary11l
		        cmp rbx12,1
		JE robocheckboundary12l
	

		Jmp robonoboundaryl
		robocheckboundary1l:
		   mov rbx1,59
				Jmp robonoboundary00l
		robocheckboundary2l:
		   mov rbx2,59
		   		Jmp robonoboundary00l
		robocheckboundary3l:
		   mov rbx3,59
		   		Jmp robonoboundary00l
		robocheckboundary4l:
		   mov rbx4,59
		   		Jmp robonoboundary00l
		robocheckboundary5l:
		   mov rbx5,59
		   		Jmp robonoboundary00l
		robocheckboundary6l:
		   mov rbx6,59
		   		Jmp robonoboundary00l
		robocheckboundary7l:
		   mov rbx7,59
		   		Jmp robonoboundary00l
		robocheckboundary8l:
		   mov rbx8,59
		   		Jmp robonoboundary00l
		robocheckboundary9l:
		   mov rbx9,59
		   		Jmp robonoboundary00l
		robocheckboundary10l:
		   mov rbx10,59
		   		Jmp robonoboundary00l
		robocheckboundary11l:
		   mov rbx11,59
		   		Jmp robonoboundary00l
		robocheckboundary12l:
		   mov rbx12,59
		   		Jmp robonoboundaryl
	

        robonoboundaryl:



   inc canAsped
   inc canBsped
   inc Cbulsped
   inc Cbulsped1
   inc rBulTime
   inc rBulTime2
   inc lifesped
   inc lifetimer
   inc lifesped2
   inc lifetimer2
   
   
   
   mov ah,0ch
   int 21h
;-----------Exit program------------


;-------Delete Screen----------
		MOV CX, 0H
		MOV DX, 5EEEH ; CX:DX = interval in microseconds
		MOV AH, 86H
		INT 15H

	jmp L1
	
	Exit:

ulose:
  ;---------Big box
  	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,24	;y2
	mov dl,78	;x2	
	int 10h 
  ;--------Small box
	mov ah,06h 
	mov al,0h
	mov bh,00110000b

	mov ch,10 	;y1		
	mov cl,25  	;x1

	mov dh,11	;y2
	mov dl,55	;x2	
	int 10h 

   ;----------String print

   	mov ah,02                
    mov bx,0
    mov dh,10    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
    print ulosee
    Jmp endgame

overgame:

  ;---------Big box
  	mov ah,06h 
	mov al,0h
	mov bh,01000000b

	mov ch,1 	;y1		
	mov cl,1  	;x1

	mov dh,24	;y2
	mov dl,78	;x2	
	int 10h 
  ;--------Small box
	mov ah,06h 
	mov al,0h
	mov bh,00110000b

	mov ch,10 	;y1		
	mov cl,25  	;x1

	mov dh,11	;y2
	mov dl,55	;x2	
	int 10h 

   ;----------String print

   	mov ah,02                
    mov bx,0
    mov dh,10    ;-----vertical
    mov dl,25    ;-----horizantal
    int 10h
    print uwon
 
 ;-----------------------------------------End PRogram
endgame: 
;----------------------------------------------End-------------------------------

mov al,Score

.if al > highscore1
	mov highscore1,al
.elseif al > highscore2
	mov highscore2,al
.elseif al > highscore3
	mov highscore3,al
.endif

mov ah,3dh
mov al,2
mov dx,offset filescore
int 21h

mov buffer2,ax

mov ah,40h
mov bx,buffer2
mov cx,1
mov dx,offset highscore1
int 21h

mov ah,40h
mov bx,buffer2
mov cx,1
mov dx,offset highscore2
int 21h

mov ah,40h
mov bx,buffer2
mov cx,1
mov dx,offset highscore3
int 21h

mov ah,3eh
mov bx,buffer2
int 21h

mov ah,4ch
int 21h

main endp

end main