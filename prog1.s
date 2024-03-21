      AREA RESET, DATA, READONLY

        EXPORT __Vectors
__Vectors  DCD 0x20001000 ; stack pointer value when stack is empty
           DCD Reset_Handler; reset vector
		   align
;AREA DATA
Array DCB 4,5,7,16,20,8,28,25,7,5
	
	AREA MYRAM, DATA, READWRITE
;Assigning initial values to the variables
Sumation DCD 0
EVENSUM DCD 0
Array2 DCB 0,0,0,0,0,0,0,0,0,0
;AREA CODE
      area mycode, code, readonly
;Naming the registers with names to know what we want to store in them
SUM RN R10
EVENsum RN R11
count RN R12
count2 RN R9
returnValue RN R6
       ENTRY
       EXPORT Reset_Handler
Reset_Handler

	  
	ASR R1,#2   
	   BL GetSUM				;Calling the procedure GetSUM
		LDR R5,=Sumation       ;Take the address where we want to store the SUM
		STR SUM,[R5]			;Data storage in memory	
		
		BL GetEVENSUM			;Calling the procedure GetEVENSUM
		LDR R5,=EVENSUM			;Take the address where we want to store the EVENsum
		STR EVENsum,[R5]		;Data storage in memory	

		MOV count,#10	
		LDR R1,=Array			;Marking the location of the first element in the Array To READ
		LDR R5,=Array2			;Marking the location of the first element in the Second Array TO Store
AGAIN3	LDRB R2,[R1]			;loop to pass the values
		BL POW					;Calling the procedure POW
		SUBS count,count,#1		;Decrement for the counter
		ADD R1,R1,#1			;Take the second item's location To READ
		STRB returnValue,[R5]	;Store Data in Memory
		ADD R5,R5,#1			;Take the second item's location To Store
		BNE AGAIN3				;Branch for loop
		
here B here
end
	
GetSUM					;Procedure For Get the Sumation
;Give the required values for the program in the registry
		MOV count,#10
		MOV SUM ,#0
		LDR R1, =Array          ;Marking the location of the first element in the Array
AGAIN	LDRB R2,[R1]           ;A loop to add the values in the Array and put the sum into the SUM register
		ADD SUM,SUM,R2
		SUBS count,count,#1    ;Decrement for the counter
		ADD R1,R1,#1		   ;Take the second item's location To READ
		BNE AGAIN              ;Branch for loop
		BX LR
GetEVENSUM			;Procedure For Get the even numbers Sumation
;Give the required values for the program in the registry
		MOV EVENsum,#0
		MOV count,#10		
		LDR R1, =Array			;Marking the location of the first element in the Array
AGAIN2	LDRB R2,[R1]			;A loop to add the EVEN values in the Array and put the sum into the SUM register
		TST R2,#1				;Check the first bit to see if the number is EVEN or Odd
		BNE ODD					;Branch if is in not EVEN
		ADD EVENsum,EVENsum,R2	;Add it to EVENsum if it is EVEN
ODD		
		SUBS count,count,#1		;Decrement for the counter
		ADD R1,R1,#1		    ;Take the second item's location To READ
		BNE AGAIN2				;Branch for loop
		BX LR
count3 RN R8

POW					;Procedure For Find the largest power of 2 divisor that divides into a number
;Give the required values for the program in the registry
	MOV count2,#8
	mov R3,#1
	mov count3,#0
	CMP R2,#0	;compare if it is ZERO 
	MOV returnValue,#0
	BEQ leave ;Branch to leave
loop  			;Loop for Find the largest power of 2 divisor that divides into a number
	TST R2,R3		;Check the specific bit to find which bit we arrive
	BNE out
	ADD count3,count3,#1
	SUBS count2,count2,#1 	;Decrement for the counter
	LSL R3 ,#1		;Shift left to check the second bit 
	BNE loop		;Branch for loop
out	
	MOV returnValue,#1
	MOV R7,#2
	CMP count3,#0
	BEQ leave
loop2    ;loop for get the Required Number
		MUL returnValue,returnValue,R7	; returnValue = returnValue * 2
		SUBS count3,count3,#1	;Decrement for the counter
		BNE loop2		;Branch for loop

leave	BX LR	