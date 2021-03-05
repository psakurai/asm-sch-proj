INCLUDE Irvine32.inc
INCLUDE Macros.inc

;------------------------------------------------------ 
; Receives: Display A Set of Deck consist of 5 cards
;------------------------------------------------------ 
mCallPlay MACRO   
	mov eax,green+3
	call SetTextColor
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X      1     X      X      2     X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X       XXXXXXXXXXXXXX"
	call crlf
	mWrite "   X            X      X            X       X            X"
	call crlf
	mWrite "   X            X      X            X       X            X"
	call crlf
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX       X            X"
	call crlf
	mWrite "                                            X      5     X"
	call crlf
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX       X            X"
	call crlf
	mWrite "   X            X      X            X       X            X"
	call crlf
	mWrite "   X            X      X            X       X            X"
	call crlf
	mWrite "   X            X      X            X       X            X"
	call crlf
	mWrite "   X      3     X      X      4     X       XXXXXXXXXXXXXX"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   X            X      X            X"
	call crlf
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX"
	call crlf

ENDM

;------------------------------------------------------ 
; Receives: Display Remaining Card
;------------------------------------------------------ 
mCallDeleteCard MACRO
    mov eax,green+3
	call SetTextColor
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX      XXXXXXXXXXXXXX"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X      "

	mov esi, offset available
	mov ecx, 5
	remn:
	cmp match1, cl		; if (match1 == cl && match2 == cl)
	JE next_remn
	cmp match2, cl		
	JE next_remn		; skip
	mov [esi], cl
	add esi, 1
	next_remn:
	loop remn
	
	mov al, available+2
	call WriteDec
	mWrite "     X      X      "
	
	mov al, available+1
	call WriteDec
	mWrite "     X      X      "
	
	mov al, available
	call WriteDec
	mWrite "     X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   X            X      X            X      X            X"
	call crlf
	mWrite "   XXXXXXXXXXXXXX      XXXXXXXXXXXXXX      XXXXXXXXXXXXXX"
	call crlf
	

ENDM

;------------------------------------------------------
; Receives: Display Virus Card
;------------------------------------------------------
mCallVirus MACRO
	mov eax,green+2
	call SetTextColor
	call crlf
	mWrite "You have opened a trap card!"
	call crlf
	mWrite "You have been infected by a MEOW MEOW virus!"
	call crlf
	call crlf
	mov eax,green+4
	call SetTextColor
	mWrite "    XXXXXXXXXXXXXX"
	call crlf
	mWrite "    X            X"
	call crlf
	mWrite "    X    ^___^   X"
	call crlf
	mov eax,green+11
	call SetTextColor
	mWrite "    X   /_X_  \  X"
	call crlf
	mWrite "    X   \VVV__/  X"
	call crlf
	mWrite "    X  C/   C \  X"
	call crlf
	mov eax,green+10
	call SetTextColor
	mWrite "    X   \___/_/  X"
	call crlf
	mWrite "    X MEOW!!---  X"
	call crlf
	mWrite "    X            X"
	call crlf
	mWrite "    XXXXXXXXXXXXXX"
	call crlf
	call crlf
	mov eax,green+2
	call SetTextColor
	mWrite "You are unable to proceed..."
	call crlf
ENDM

;------------------------------------------------------ 
; Receives: Instruction, a summation procedure  
;        to display instructions for how to play
;------------------------------------------------------ 
mCallHow MACRO
    mov eax,green+6
	call SetTextColor
	call clrscr
	mWrite "=========================================================="
	call crlf
	mWrite "		   HOW - to - PLAY"
	call crlf
	mWrite "=========================================================="
	call crlf
	mWrite "1. You are given five cards."
	call crlf
	mWrite "2. Turn over any two cards."
	call crlf
	mWrite "3. If the two cards match, put away the cards."
	call crlf
	mWrite "4. If they don't match, turn them back over."
	call crlf
	mWrite "5. The game is over when all the cards have been matched"
	call crlf
	mWrite "   or if the card choosen is a trap card."
	call crlf
	call crlf
	mov eax,green
	call SetTextColor
	mWrite "		     (0) Back "
ENDM

;------------------------------------------------------ 
; Quit: Instruction, a summation procedure  
;        to display a request to quit
;------------------------------------------------------ 
mCallQuit MACRO
    mov eax,green
	call SetTextColor
	call clrscr
	mov eax, 0
	mov edx, 0426h
	call Gotoxy
	mWrite "Are you sure you want to quit?"

	mov edx, 052Ah
	call Gotoxy
	mWrite "1 = True 2 = False"
	mov edx, 0629h
	call Gotoxy
	mov edx, 0728h
	call Gotoxy
	mWrite "Please choose an option: "
ENDM

.data
	c1 byte ?
	c2 byte ?
	match1 byte ?
	match2 byte ?
	pair byte 0
	virus_in_c1? byte ?
	virus_in_c2? byte ?
	limit_pear byte 0
	limit_cherry byte 0
	limit_virus byte 0
	validDeck byte 0
	deck byte 0, 0, 0, 0, 0
	available byte 0, 0, 0
	temp byte 0
	key dword 0

.code
main PROC
menu:	
	call clrscr
    mov eax,green
    call SetTextColor
	mWrite "         M a t c h   P a i r s   M e m o r y  G a m e s   o f   P a n d e m i c   S u r v i v o r         "
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf 
	mWrite "  XXXXX  XX  X  XXXXX  XXXXX  XXXXX      XXXX   XXXX      XXX XX   X XXXXX XXXXX  XXXX XXXXX XXXXX XXXX   "
	call crlf
	mWrite "  XX     XX  X  XX     XX     XX        XX   X  XX  X      X  XXX  X XX    XX    XX      X   XX    XX  X  "
	call crlf
	mWrite "  XX XX  XX  X  XXXX   XXXX   XXXXX     XX   X  XXXX       X  XX X X XXXXX XXXXX XX      X   XXXXX XX  X  "
	call crlf
	mWrite "  XX  X  XX  X  XX     XX        XX     XX   X  XX  X      X  XX  XX XX    XX    XX      X   XX    XX  X  "
	call crlf
	mWrite "  XXXXX  XXXXX  XXXXX  XXXXX  XXXXX      XXXX   XX  X     XXX XX   X XX    XXXXX  XXXX   X   XXXXX XXXX   "
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf
	mov eax,green+6
    call SetTextColor
	mov edx, 0A32h
	call Gotoxy
	mWrite "(1) Start"
	
	mov edx, 0B2Fh
	call Gotoxy
	mWrite "(2) How to Play"

	mov edx, 0C32h
	call Gotoxy
	mWrite "(3) Quit"

again:
    mov eax,green
    call SetTextColor
	mov edx, 0D2Ah
	call Gotoxy
	mWrite "Please choose an option: "
	call ReadInt
	mov ebx, eax

	cmp ebx, 123456
	JE ADMIN_ONLY
	cmp ebx, 01
	JE PLAY
	cmp ebx, 02
	JE HOW
	cmp ebx, 03
	JE QUIT
	call crlf
	JMP again

ADMIN_ONLY:
	mov key, ebx
	
PLAY:
	call clrscr

	mov eax, 0
	mov esi, offset deck
	mov ecx, 5
	mov limit_cherry, 0
	mov limit_pear, 0
	mov limit_virus, 0
	mov validDeck, 0
;x
arrange:
	call Randomize
	mov al, 3
	call Randomrange
	mov [esi], al

	cmp al, 00
	JNE one
	cmp limit_pear, 2
	JE arrange
	inc limit_pear
	JMP after

	one:
	cmp al, 01
	JNE two
	cmp limit_cherry, 2
	JE arrange
	inc limit_cherry
	JMP after

	two:
	cmp al, 02
	JNE arrange
	cmp limit_virus, 1
	JE arrange
	inc limit_virus
	JMP after

	after:
	add esi, 1
	loop arrange

	call Randomize
	mov eax, 2
	call Randomrange
    mov ebx,eax
    cmp ebx, 0
    JE Rearrange1
    cmp ebx, 1
    JE Rearrange2
Rearrange1:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set1
    cmp ebx, 1
    JE Set2
Rearrange2:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set3
    cmp ebx, 1
    JE Set4
Set1:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set1A
    cmp ebx, 1
    JE Set1B
Set1A:
	mov al, deck
    mov temp, al
	mov al, deck+2
	mov deck, al
    mov al, temp
	mov deck+2,al 
	JMP X
Set1B:
	mov al, deck
    mov temp, al
	mov al, deck+3
	mov deck, al
    mov al, temp
	mov deck+3,al
	JMP X
Set2:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set2A
    cmp ebx, 1
    JE Set2B
Set2A:
	mov al, deck
    mov temp, al
	mov al, deck+4
	mov deck, al
    mov al, temp
	mov deck+4,al 
	JMP X
Set2B:
	mov al, deck+1
    mov temp, al
	mov al, deck+3
	mov deck+1, al
    mov al, temp
	mov deck+3,al
	JMP X
Set3:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set3A
    cmp ebx, 1
    JE Set3B
Set3A:
	mov al, deck+1
    mov temp, al
	mov al, deck+4
	mov deck+1, al
    mov al, temp
	mov deck+4,al 
	JMP X
Set3B:
	mov al, deck+2
    mov temp, al
	mov al, deck+3
	mov deck+2, al
    mov al, temp
	mov deck+3,al 
	JMP X
Set4:
	call Randomize
	mov eax, 2
	call Randomrange
	cmp ebx, 0
    JE Set4A
    cmp ebx, 1
    JE Set4B
Set4A:
	mov al, deck+2
    mov temp, al
	mov al, deck+4
	mov deck+2, al
    mov al, temp
	mov deck+4,al 
	JMP X
Set4B:
	mov al, deck+1
    mov temp, al
	mov al, deck+2
	mov deck+1, al
    mov al, temp
	mov deck+2,al
	JMP X

	;--------------------------------------
	; Available for Admin   pass: 000000
	;--------------------------------------
X:
	cmp key, 123456
	JNE R1
	mWrite "deck: "
	call crlf
	mov al, deck
	call WriteDec
	mWrite " "
	mov al, deck+1
	call WriteDec
	mWrite " "
	mov al, deck+2
	call Writedec
	mWrite " "
	mov al, deck+3
	call WriteDec
	mWrite " "
	mov al, deck+4
	call Writedec

R1:
	mov pair, 0
	mov eax, 0
	mov ebx, 0
	mov match1, 0
	mov match2, 0
	call crlf
	mCallPlay
	JMP first_card

R2:
	call crlf
	mCallDeleteCard
	JMP first_card

first_card:
	mov eax,green+4
	call SetTextColor
	call crlf
	mWrite "Please choose your 1st card = "
again_c1:
	call ReadDec
	mov c1, al

	;for R2
	cmp match1, al
	JE again_c1
	cmp match2, al
	JE again_c1
	
	mov esi, offset deck
	mov ecx, 5
	choice1:
	cmp c1, cl			; if c1 == ecx
	JNE next1
	mov bl, [esi]		; bl = deck + n
	JMP second_card
	next1:
	add esi, 1			; c1(deck + n); n = 1, 2, ..., 5
	loop choice1
	JMP again_c1
	
second_card:
	mov eax,green+4
	call SetTextColor
	mWrite "Please choose your 2nd card = "
again_c2:
	call ReadDec
	mov c2, al

	;for R2
	cmp match1, al
	JE again_c2
	cmp match2, al
	JE again_c2
	
	cmp c1, al
	JE equal
	mov esi, offset deck
	mov ecx, 5
	choice2:
	cmp c2, cl			; if c2 == ecx
	JNE next2
	cmp bl, 02			; if c1 == 5
	JE gameOver
	mov ch, [esi]
	cmp ch, 02		; if c2 == 5
	JE gameOver
	cmp [esi], bl		; if c1(deck + n) == c2(deck + n)
	JE ismatch
	JMP notmatch
	next2:
	add esi, 1			; c2(deck + n); n = 1, 2, ..., 5
	loop choice2
	JMP again_c2
	
equal:
	mov eax,green+2
	call SetTextColor
	mWrite "--Same inputs detected--"
	call crlf
	JMP first_card

ismatch:
	cmp bl,0
    JNE Love
	;Diamond:
	mov eax,green
	call SetTextColor
	call crlf
	call crlf
	mWrite "    XXXXXXXXXXXXXXX                                  XXXXXXXXXXXXXXX"
	call crlf
	mWrite "    X             X                                  X             X"
	call crlf
	mWrite "    X     xxx     X                                  X     xxx     X"
	call crlf
	mov eax,green+7
	call SetTextColor
	mWrite "    X   xxxxxxx   X                                  X   xxxxxxx   X"
	call crlf
	mWrite "    X  xxxx    x  X                                  X  xxxx    x  X"
	call crlf
	mWrite "    X  xxx        X  XXXXXXXX ITS A MATCH  XXXXXXXX  X  xxx        X"
	call crlf
	mWrite "    X  xxxx    x  X                                  X  xxxx    x  X"
	call crlf
	mWrite "    X   xxxxxxx   X                                  X   xxxxxxx   X"
	call crlf
	mov eax,green+3
	call SetTextColor
	mWrite "    X     xxxx    X                                  X     xxxx    X"
	call crlf
	mWrite "    X             X                                  X             X"
	call crlf
	mWrite "    XXXXXXXXXXXXXXX                                  XXXXXXXXXXXXXXX"
	call crlf
	call crlf
	add pair, 1
	cmp pair, 2
	JE WON
	mov al, c1
	mov match1, al		; match1 = c1
	mov al, c2
	mov match2, al		; match2 = c2
	mov eax,green+4
	call SetTextColor
	mWrite "Press Enter to continue..."
	call ReadDec
	mov bl, al
	call clrscr
	JMP R2

Love:
	mov eax,green
	call SetTextColor
	call crlf
	call crlf
	mWrite "    XXXXXXXXXXXXXXX                                  XXXXXXXXXXXXXXX"
	call crlf
	mWrite "    X             X                                  X             X"
	call crlf
	mWrite "    X             X                                  X             X"
	call crlf
	mWrite "    X      x      X                                  X      x      X"
	call crlf
	mov eax,green+7
	call SetTextColor
	mWrite "    X     xxx     X                                  X     xxx     X"
	call crlf
	mWrite "    X <xxxxxxxxx> X  XXXXXXXX ITS A MATCH  XXXXXXXX  X <xxxxxxxxx> X"
	call crlf
	mWrite "    X   *xxxxx*   X                                  X   *xxxxx*   X"
	call crlf
	mWrite "    X   xxx xxx   X                                  X   xxx xxx   X"
	call crlf
	mov eax,green+3
	call SetTextColor
	mWrite "    X  xx     xx  X                                  X  xx     xx  X"
	call crlf
	mWrite "    X             X                                  X             X"
	call crlf
	mWrite "    XXXXXXXXXXXXXXX                                  XXXXXXXXXXXXXXX"
	call crlf
	call crlf
	add pair, 1
	cmp pair, 2
	JE WON
	mov al, c1
	mov match1, al		; match1 = c1
	mov al, c2
	mov match2, al		; match2 = c2
	mov eax,green+4
	call SetTextColor
	mWrite "Press Enter to continue..."
	call ReadDec
	mov bl, al
	call clrscr
	JMP R2

notmatch:
	mov eax,green+2
	call SetTextColor
	mWrite "Not a match!"
	call crlf
	cmp pair, 1
	JE R2
	JMP R1

gameOver:
	mov virus_in_c1?, bl
	mov virus_in_c2?, ch
	mCallVirus
	mov eax,green+2
	call SetTextColor
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf
	mWrite "X    XXXX  XXXXXX XX   X XXXXXX      XXXX  XX   X XXXXXX XXXXX   X"
	call crlf
	mWrite "X   XX     XX   X XXX XX XX         XX   X XX   X XX     XX   X  X"
	call crlf
	mWrite "X   XX XXX XXXXXX XX X X XXXXXX     XX   X XX   X XXXXXX XXXXX   X"
	call crlf
	mWrite "X   XX   X XX   X XX   X XX         XX   X  XX X  XX     XX   X  X"
	call crlf
	mWrite "X    XXXX  XX   X XX   X XXXXXX      XXXX    XX   XXXXXX XX   X  X"
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf
opt:
	mov eax,green+4
	call SetTextColor
	mWrite "Restart or Return to Main Menu (1-Restart/2-Return): "
	call ReadDec
	mov bl, al
	cmp bl, 2
	JE menu
	cmp bl, 1
	JNE opt
	mov eax,green+4
	call SetTextColor
	mWrite "Press Enter to continue..."
	call ReadDec
	mov bl, al
	call clrscr
	JMP R1

WON:
	mov eax,green
	call SetTextColor
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf
	mWrite "X  XX   X  XXXX  XX   X     XX   X XXXX XX    X  X"
	call crlf
	mov eax,green+7
	call SetTextColor
	mWrite "X  XX   X XX   X XX   X     XX   X  XX  XXX   X  X"
	call crlf
	mWrite "X   XXXX  XX   X XX   X     XX X X  XX  XX XX X  X"
	call crlf
	mWrite "X    XX   XX   X XX   X     XXX XX  XX  XX  XXX  X"
	call crlf
	mov eax,green+3
	call SetTextColor
	mWrite "X    XX    XXXX   XXXX      XX   X XXXX XX   XX  X"
	call crlf
	mWrite "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	call crlf
	mov eax,green+4
	call SetTextColor
	mWrite "Press Enter to continue..."
	call ReadDec
	mov bl, al
	call clrscr
	JMP credit

credit:
	call clrscr
    mov eax,green+6
	call SetTextColor
	mWrite "==================================="
	call crlf
	mWrite "           Quote of A Day"
	call crlf
	mWrite "==================================="
	call crlf
	call crlf
	call randomize
	mov eax, 4
	call randomrange
	mov ebx, eax

	cmp eax, 0
	JNE Q2
	mWrite " If you cannot do great thing, do"
	call crlf
	mWrite " small thing in a great way."
	call crlf
	call crlf
	mWrite "                 -Napolean Hill-"
	call crlf
	JMP close_quote

	Q2:
	cmp eax, 1
	JNE Q3
	mWrite " Be the change you want to see"
	call crlf
	mWrite " in the world."
	call crlf
	call crlf
	mWrite "                -Mahatma Gandhi-"
	call crlf
	JMP close_quote

	Q3:
	cmp eax, 2
	JNE Q4
	mWrite " I have no special talent. I am " 
	call crlf
	mWrite " only passionately curious."
	call crlf
	call crlf
	mWrite "               -Albert Einstein-"
	call crlf
	JMP close_quote

	Q4:
	mWrite " The quieter you become, the"
	call crlf
	mWrite " more you are able to hear."
	call crlf
	call crlf
	mWrite "                          -Rumi-"
	call crlf
	JMP close_quote

	Q5:
	cmp eax, 3
	JNE Q5
	mWrite " All that we are the result of" 
	call crlf
	mWrite " what we have thought."
	call crlf
	call crlf
	mWrite "                        -Buddha-"
	call crlf

close_quote:
	call crlf
	mWrite "----------------------------------"
	call crlf
	mWrite "Press Enter to return ..."
	call ReadDec
	mov bl, al
	call clrscr
	JMP menu

HOW:
	mCallHow
	mov eax,green
	call SetTextColor
	call crlf
	mWrite "             Please choose an option: "
	call ReadInt
	mov ebx, eax
	call clrscr
	
	cmp ebx, 0
	JE menu
	JMP outt

QUIT:
	mCallQuit
	call ReadDec
	mov ebx, eax
	call clrscr
	
	cmp ebx, 1
	JE last
	cmp ebx, 2
	JE menu

last:
	mov eax,green+1
 	call SetTextColor
	mWrite " *                         *      *           *      *       * _    *           *       *   "
	call crlf
	mWrite "       *        *                   __________________________(_)"
	call crlf
	mWrite "                     *              \                         | |*    *                 *     *"
	call crlf
	mWrite "          *                     *    >  Thanks for Playing :) | |           *       *"
	call crlf
	mWrite "                         *          /_________________________| |*                         *"
	call crlf
	mWrite "  *                                    *                      | |              "
	call crlf
	mWrite "              *      *         *                   _          | |   *       *          *"
	call crlf
	mov eax,green+7
 	call SetTextColor
	mWrite "                      ____________________________(_)    *    | |"
	call crlf
	mWrite "     *    *      *    \                           | |         | |  *______       *             *"
	call crlf
	mWrite "                       >  Developed by Naz,Fik,Ri | |         | | _/      \       ____"
	call crlf
	mWrite "    _______           /___________________________| |       __| |/         \____ /    \___"
	call crlf
	mWrite "   /  _     _\_   _  __/ _   \_                   | |    __/  | |             _ \_ _    _ \_ _"
	call crlf
	mWrite " _/  { }   { } \_{ }/   { }    \_____             | |  _/     | |            { }  { }  { }  { }"
	call crlf
	mWrite "/_____|_____|_____|__\___|___________\____________|_|_/_______|_|_____________|____|____|____|__\_"
	call crlf
	call crlf
outt:
exit
main ENDP
END main
