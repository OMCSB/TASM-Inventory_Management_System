.model small
.stack
.data 

	IntroMsg 		db 10,"|                           Inventory Management System                       |$"
	horizontalEqual db 10, "===============================================================================$"
	horizontalDash 	db 10, "-------------------------------------------------------------------------------$"
	unAvailMsg 	db "Unavailable$"
	availMsg 	db "Available$"
	databaseMsg		db 10, "=|                              Inventory                                   |=$"
	lstOfItems 	db 10, "No.            ", "Item Name      ", "Status         ", "Quantity       ", "Alert               $"
				db 10, "1.             ", "Drone          ", "Available      ", "10             ", "                    $"
				db 10, "2.             ", "Motherboard    ", "Unavailable    ", "0              ", "Require Restock     $"
				db 10, "3.             ", "RAM            ", "Available      ", "3              ", "Require Restock     $"
				db 10, "4.             ", "LCD            ", "Available      ", "7              ", "                    $"
	qList 	db 10, "1) Check Items"
			db 10, "2) Add Items"
			db 10, "3) Get Items"
			db 10, "4) Exit Program$"
	uInp 	db 10, "Enter your choice: $"	
	horDash	db 10, "---------------------------------$"
	uInp2	db 10, "| Anything you want to do again? |$"
	errorMsg 	db 10, "The input isn't registered in the system. Please try with another input!$"
	askAddMsg1 	db 10, "Which one would you like to add? : $"
	askAddMsg2	db 10, "You have chosen: $"
	askAddMsg3	db 10, "How many would you like to add$"
	
	
				
.code 
Main Proc
	mov ax, @data
	mov ds, ax
	
	printText Macro val
	
		lea dx, val
		mov ah, 09
		int 21h
	
	EndM
	
	printText horizontalEqual
	printText IntroMsg
	printText horizontalEqual
	
	initializeInventory: ;To initalize the inventory data
		mov si, offset lstOfItems	
		mov cx, 5 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

	printListO: ;Function to print the original inventory data array
		mov ah, 09h
		lea dx, [si]
		int 21h
		
		add si, 82 ;'82' refers to the amount of character in a row + the dollar sign and the '10' in this case
		
		loop printListO
	
	printHorDash: ;Function to print a long horizontal dash
		printText qList ;Prints List of questions
		printText horizontalDash
		jmp askInput
	
	printQAgain: ;Function to print the questions again with a modification on the phrase
		mov ah, 02
		mov dl, 10
		int 21h
		
		printText horDash
		printText uInp2 ;The modified phrase
		printText horDash
		
		mov ah, 02
		mov dl, 10
		int 21h
		
		jmp printHorDash
	
	optionNotPress1:
		printText errorMsg
		
		mov ah, 02
		mov dl, 10
		int 21h
		
		jmp printHorDash
	
	askInput:
		printText uInp
	
		mov ah, 01h	;Ask user for input, input type is string
		int 21h
		
		cmp al, "1"
		je checkItem ;Jump if Equal to checkItem function
		
		cmp al, "2"
		je addItem ;Jump if Equal to addItem function
		
		cmp al, "3"
		je exitProgram
		
		cmp al, "4"
		je exitProgram ;Jump if Equal to exitProgram function
	
		jmp optionNotPress1
		
	exitProgram:
		mov ah, 4ch
		int 21h
		
; START INITIALIZING INVENTORY FOR THE SECOND TIME
	initializeInventory2:
		mov si, offset lstOfItems	
		mov cx, 5 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

	printListC:
		mov ah, 09h
		lea dx, [si]
		int 21h
		add si, 82 ;'82' refers to the amount of character in a row + the dollar sign and the '10' in this case
		loop printListC
		jmp printQAgain
; END INITIALIZING INVENTORY FOR THE SECOND TIME		
	
	checkItem: ;Display the Inventory AGAIN
		printText horizontalDash
		printText databaseMsg
		printText horizontalDash
		
		mov ah, 02
		mov dl, 10 ;Add a new line
		int 21h
		
		jmp initializeInventory2

	addItem:
		printText askAddMsg1
		mov ah, 01h
		int 21h
		
		cmp al, "1"
		je initalizeAddItem1
		
		cmp al, "2"
		je initalizeAddItem2
		
		cmp al, "3"
		je initalizeAddItem3
		
		cmp al, "4"
		je initalizeAddItem4
		
		mov ah, 02
		mov dl, 10
		int 21h
		
		printText errorMsg
		jmp printQAgain

	initalizeAddItem1: ;START to print out "You have chosen: " #1
		mov si, 98
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askAddMsg2
	
	checkAddItem1:
		
		mov cl, [bx+si]
		
		mov dl, cl
		mov ah, 02h
		int 21h
		
		cmp cl, ' '
		je addItem1
		
		inc si
		
		loop checkAddItem1
		; jmp  ;END to print out "You have chosen: " #1
	
	addItem1:
		printText askAddMsg3
		mov ah, 01h
		int 21h
		
	
	initalizeAddItem2:
		mov si, 180
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askAddMsg2
	
	checkAddItem2:
		
		mov cl, [bx+si]
		
		mov dl, cl
		mov ah, 02h
		int 21h
		
		cmp cl, ' '
		je exitProgram2
		
		inc si
		loop checkAddItem1
		; jmp exitProgram
	
	initalizeAddItem3:
		mov si, 262
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askAddMsg2
	
	checkAddItem3:
		
		mov cl, [bx+si]
		
		mov dl, cl
		mov ah, 02h
		int 21h
		
		cmp cl, ' '
		je exitProgram2
		
		inc si
		loop checkAddItem1
		; jmp exitProgram
	
	initalizeAddItem4:
		mov si, 344
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askAddMsg2
	
	checkAddItem4:
		
		mov cl, [bx+si]
		
		mov dl, cl
		mov ah, 02h
		int 21h
		
		cmp cl, ' '
		je exitProgram2
		
		inc si
		loop checkAddItem1
		; jmp exitProgram
		
	exitProgram2:
		mov ah, 4ch
		int 21h
	
	
Main Endp
End Main
	
