TITLE Unsigned Integer I/O Converter    (Project6_Derringer_Andrew.asm)

; Author: Andrew Derringer
; Last Modified: 3/16/2019
; OSU email address: derringa@oregonstate.edu
; Course number/section: CS 271 - 400
; Project Number: 6                Due Date: 3/17/2019
; Description: Program reads string input from a user, validates that all characters entered
; were numbers, and stores inputs into an array of 10 integers. The sum and average of the
; array is calculated and displayed, then the integers are reconverted to strings and
; printed again.



INCLUDE Irvine32.inc

mDisplayString MACRO buffer
	push	edx
	mov		edx, buffer
	call	WriteString
	pop		edx
ENDM



mGetString MACRO stringBuffer1, stringBuffer2, stringMaxLength, stringLength
	push	edx
	push	ecx
	push	eax

	mDisplayString stringBuffer1
	mov		edx, stringBuffer2
	mov		ecx, stringMaxLength
	call	ReadString
	mov		stringLength, eax

	pop		eax
	pop		ecx
	pop		edx
ENDM



.data

;---------------------------------------;
; User input data                       ;
;---------------------------------------;

inputString				BYTE		20	DUP(0)				; String variable hoding user input for number before conversion
tempString				BYTE		20	DUP(0)				; Space set aside to hold string converted from number before printing
inputStringLength		DWORD		?
numberLength			DWORD		?						; Holds integer after conversion to from string
inputName				BYTE		50	DUP(0)				; String variable holding user input when prompted for their name



;---------------------------------------;
; Calculations                          ;
;---------------------------------------;

inputSum				DWORD		?						; Holds integer for sum of integer array
inputAverage			DWORD		?						; Holds integer for average of integers in array

;---------------------------------------;
; User input Array                      ;
;---------------------------------------;

integerArray			DWORD		10	DUP(?)				; Array of 10 user input numbers



;---------------------------------------;
; Title page output, greeting, farewell ;
;---------------------------------------;

programTitle			BYTE		"Unsigned Integer I/O Converter with MASM", 0
programAuthor			BYTE		"by: Andrew Derringer", 0

greeting				BYTE		"Welcome and thank you for using the Unsigned Integer I/O Converter.", 0
requestName				BYTE		"Please enter your name: ", 0
hello					BYTE		"Hello ", 0
goodbye					BYTE		"And there you have it. Have a good day ", 0



;---------------------------------------;
; Request input and data validation     ;
;---------------------------------------;

outputTransition		BYTE		"Lets get started.", 0
inputInstructions		BYTE		"Test the program by inputting 10 integers.", 0
requestNumber			BYTE		"Please enter an integer: ", 0

maxError				BYTE		"Your number was too big. Try again: ", 0
charError				BYTE		"Your entry contained something other than integers. Try again...", 0



;---------------------------------------;
; Output formatting                     ;
;---------------------------------------;

integerList				BYTE		"Values Entered: ", 0
sumList					BYTE		"Sum: ", 0
averageList				BYTE		"Average: ", 0
tripleSpace				BYTE		"   ", 0
exclamation				BYTE		"!", 0
colon					BYTE		": ", 0



.code

;---------------------------------------------------------------------;
; Procedure: Main                                                     ;
; Description:                                                        ;
;---------------------------------------------------------------------;

main PROC
	push	OFFSET programTitle				; Introduce program
	push	OFFSET programAuthor
	push	OFFSET greeting
	call	introduction

	push	OFFSET requestName				; Request user's name
	push	OFFSET hello
	push	OFFSET exclamation
	push	OFFSET inputName
	call	getName

	push	OFFSET integerArray
	push	LENGTHOF integerArray
	push	OFFSET inputInstructions
	push	OFFSET requestNumber
	push	OFFSET maxError
	push	OFFSET charError
	push	OFFSET inputString
	push	SIZEOF inputString
	push	OFFSET inputStringLength
	call	readVal

	push	OFFSET integerArray
	push	LENGTHOF integerArray
	push	OFFSET integerList
	push	OFFSET tripleSpace
	call	printList

	push	OFFSET integerArray
	push	LENGTHOF integerArray
	push	OFFSET inputSum
	push	OFFSET sumList
	call	getSum

	push	inputSum
	push	LENGTHOF integerArray
	push	OFFSET inputAverage
	push	OFFSET averageList
	call	getAverage

	exit	; exit to operating system
main ENDP



;---------------------------------------------------------------------;
; Procedure: Introduction                                             ;
; Passed: string programTitle, string programAuthor, string greeting. ;
; Returned:                                                           ;
; Description: Prints introduction text for program.                  ;
;---------------------------------------------------------------------;

introduction PROC
	push	ebp								; Preserve return address
	mov		ebp, esp

	mDisplayString [ebp+16]					; Print programTitle
	call	CrLf
	call	CrLf
	mDisplayString [ebp+12]					; Print programAuthor
	call	CrLf
	call	CrLf
	mDisplayString [ebp+8]					; Print greeting
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return address
	ret		12								; Clear remaining stack

introduction ENDP



;---------------------------------------------------------------------;
; Procedure: Get Name                                                 ;
; Passed: string requestName, string hello, string exclamation        ;
;		  string pointer inputName.                                   ;
; Returned: string inputName.                                         ;
; Description: Requests and stores the user's name.                   ;
;---------------------------------------------------------------------;

getName PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mDisplayString [ebp+20]					; Print requestName

	mov		edx, [ebp+8]					; Place inputName@ in edx
	mov		ecx, 49
	call	ReadString                      ; Read input string and store at address in edx = inputName
	call	CrLf

	mDisplayString [ebp+16]					; Print hello followed by...
	mDisplayString [ebp+8]					; Print inputName followed by...
	mDisplayString [ebp+12]					; Print exclamation
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack

getName ENDP



;---------------------------------------------------------------------;
; Procedure: Read Value                                               ;
; Passed: int* integerArray, string inputIstructions,                 ;
;		  string requestNumber, string maxError, string charError     ;
;         string inputString, int stringMax, int stringSize           ;
; Returned:                                                           ;
; Description:                                                        ;
;---------------------------------------------------------------------;

readVal PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mDisplayString [ebp+32]					; Print inputInstructions
	call	CrLf
	call	CrLf

	mov		edi, [ebp+40]					; Destination = integerArray
	mov		ecx, [ebp+36]					; Counter = LENGTHOF integerArray
	mov		ebx, 10d						; Prepare multiplier per index
	xor		edx, edx						; Prep to hold sum of values converted from string

OuterLoop:
	push	ecx								; Preserve outer loop count

InnerLoop:
	mGetString [ebp+28], [ebp+16], [ebp+12], [ebp+8]	; Store string in inputString [ebp+16] and its size in stringSize [ebp+8]

	mov		ecx, [ebp+8]					; Prepare inner loop count
	mov		esi, [ebp+16]					; Source = inputString
	cld										; Direction = right

checkLength:
	cmp		ecx, 10					
	ja		TooBig	

ConversionLoop:	
	mov		eax, [edi]						; Move previous index into eax
	mul		ebx								; eax *= 10
	mov		[edi], eax						; Return to destination
	
	xor		eax, eax						; Clear eax
	lodsb									; esi byte to eax and increment esi by 1 byte

	sub		al, 48d							; ASCII value to decimal
	cmp		al, 0				
	jb		OutOfRange						; Must be 0 <= eax <= 9
	cmp		al, 9				
	ja		OutOfRange

EndInnerLoop:
	clc
	add		[edi], al						; Incorporate in string sums
	jc		TooBig
	loop	ConversionLoop
	jmp		EndOuterLoop

OutOfRange:
	xor		eax, eax			
	mov		[edi], eax						

	mDisplayString [ebp+20]					; Print charError
	call	CrLf
	call	CrLf

	jmp		InnerLoop

TooBig:
	xor		eax, eax						
	mov		[edi], eax						

	mDisplayString [ebp+24]					; Print maxError
	call	CrLf
	call	CrLf

	jmp		InnerLoop

EndOuterLoop:
	pop		ecx								; Restore outer loop counter
	add		edi, 4							; increment EDI so it goes to the next array element
	dec		ecx
	cmp		ecx, 0
	jne		OuterLoop

ReturnToMain:
	call	CrLf
	pop		ebp								; Acquire return@
	ret		20								; Clear remaining stack

readVal ENDP



;---------------------------------------------------------------------;
; Procedure: Write Value                                              ;
; Passed: int indexNumber                                             ;
; Returned:                                                           ;
; Description: Called from print list procedure which takes an array  ;
;              of integers and passes individual indexes here.        ;
;              Division by 10 is used to find the integer length. Then;
;			   if the number = 0 a zero is printed otherwise a local  ;
;			   strring is manufactured by storing a 0 at the end and  ;
;			   decrementing through bytes to apply char converted from;
;		       numbers. These numbers are acquired by dividing the    ;
;			   original integer by 10 so that the lowest digit is     ;
;			   moved to the remainder register EDX and converted to   ;
;			   ascii characters before being stored.                  ;
; Citations: Help with division by 10 logic to move single numbers    ;
;            into EDX for char conversion from jyuros at github.      ;
;            Help with first local variables from sinsi at            ;
;            asmcommunty.net                                          ;
;---------------------------------------------------------------------;

writeVal	PROC
	LOCAL	mystring[20]:BYTE				; Store local string long enough to print

	pushad									; Save all registers from calling procedure
			
	mov		eax, [ebp+8]					; Passed index Number into eax
	mov		eax, [eax]
	mov		ecx, 0							; Length Counter = 0
	mov		ebx, 10d

LenCountLoop:
	xor		edx, edx						; clear edx register for remainder
	cmp		eax, 0
	je		EndCount						; Done if previous div or original number = 0
	div		ebx
	inc		ecx								; Count++
	jmp		LenCountLoop

EndCount:		
	cmp		ecx, 0							; Jump to print conditions for length = 0
	je		ZeroCount
	lea		edi, mystring					; Set local string for conversion
	add		edi, ecx

ZeroEnding:				
	std										; Direction = left
	mov		al, 0
	stosb									; Add 0 from al to back of string

	mov		eax, [ebp+8]					; eax = indexNumber
	mov		eax, [eax]
	
ConversionLoop:
	xor		edx, edx						; clear edx

	div		ebx								; Remainder = lowest remaining integer
	add		edx, 48d						; Convert to ascii
	push	eax								; Preserve remaining indexNumber
	mov		eax, edx						; Prepare char for storage in local string
	stosb
	pop		eax								; Restore EAX
	cmp		eax, 0							; Conversion is done if dividend = 0
	je		printString
	jmp		ConversionLoop

ZeroCount:
	xor		eax, eax						; Clear eax and and '0' character for print if index held 0
	mov		al, '0'
	call	WriteChar
	jmp		EndCall

printString:
	lea		eax, mystring
	mDisplayString  eax

EndCall:
	popad									; Restore Registers
	ret		4

writeVal	ENDP



;---------------------------------------------------------------------;
; Procedure: Print List                                               ;
; Passed: int* integerArray, int arrayLength, string integerList      ;
;         string tripleSpace                                          ;
; Returned: Nothing                                                   ;
; Description: Prints array values by passing individual elements     ;
;              to the writeVal procedure.                             ;
;---------------------------------------------------------------------;

printList PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mDisplayString [ebp+12]

	mov		ecx, [ebp+16]					; Count = LENGTHOF integerArray
	mov		esi, [ebp+20]					; Source = integerArray

PrintLoop:
	push	esi								; integerArray element passed to WriteVal
	call	WriteVal
	add		esi, 4							; Increment to next element in integerArray
	mDisplayString [ebp+8]
	loop	PrintLoop

ReturnToMain:
	call	CrLf
	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack

printList ENDP



;---------------------------------------------------------------------;
; Procedure: Get Sum                                                  ;
; Passed: int* integerArray, int LENGTHOF integerArray, int* inputSum ;
;         string sumList                                              ;
; Returned: int inputSum                                              ;
; Description: Crawls through array to calculate and store its sum.   ;
;---------------------------------------------------------------------;

getSum PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		esi, [ebp+20]					; Place start of array in esi
	mov		ecx, [ebp+16]					; Counter = LENGTHOF integerArray
	mov		eax, 0
	
SumLoop:
	add		eax, [esi]						; Add current element to eax
	add		esi, 4							; Increment to next element
	loop	SumLoop

EndLoop:
	mov		ebx, [ebp+12]					; Save sum to inputSum variable
	mov		[ebx], eax
	mDisplayString [ebp+8]					; Print "Sum: " and result
    call	WriteDec
	call	CrLf

	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack

getSum ENDP



;---------------------------------------------------------------------;
; Procedure: Get Average                                              ;
; Passed: int inputSum, int LENGTHOF integerArray, int* inputAverage  ;
;         string averageList                                          ;
; Returned: int inputAverage                                          ;
; Description: Uses previously calculated sum of array, and length    ;
;              to calculate the average. Remainder is cut-off.        ;
;---------------------------------------------------------------------;

getAverage PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	xor		edx,edx							; Clear for division

	mov		eax, [ebp+20]					; Place inputSum in eax
	mov		ebx, [ebp+16]					; Place divisor in ebx									
	div		ebx

	mDisplayString [ebp+8]					; display "Average: "
	call	WriteDec
	call	CrLf

	mov		[ebp+12], eax					; Save result in inputAverage
	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack

getAverage ENDP



END main