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
				db 10, "4.             ", "Power Supply   ", "Available      ", "7              ", "                    $"
				db 10, "5.             ", "SSD            ", "Unavailable    ", "0              ", "Require Restock     $"
				db 10, "6.             ", "HDD            ", "Available      ", "1              ", "Require Restock     $"
	qList 	db 10, "1) Check Items"
			db 10, "2) Add Items"
			db 10, "3) Update Item Quantity"
			db 10, "4) Exit Program$"
	uInp 	db 10, "Enter your choice: $"	
	horDash	db 10, "---------------------------------$"
	uInp2	db 10, "| Anything you want to do again? |$"
	errorMsg 	db 10, "The input isn't registered in the system. Please try with another input!$"
	
				
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
		mov cx, 7 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

	printListO: ;Function to print the inventory data array
		
		mov ah, 09h
		lea dx, [si]
		int 21h
		
		add si, 82 ;'82' refers to the amount of character in a row + the dollar sign and the '10' in this case
		
		loop printListO
	
	
	
	printHorDash: ;Function to print a long horizontal dash
		
		printText qList ;Prints List of quetions
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
		
		printText qList
		jmp printHorDash
	
	optionNotPress:
		printText errorMsg
		
		mov ah, 02
		mov dl, 10
		int 21h
		
		jmp printHorDash
	
	askInput:
		
		printText uInp
	
		mov ah, 01h	
		int 21h
		
		
		cmp al, "1"
		je checkItem ;Jump if Equal to checkItem function
	
		cmp al, "2"
		je addItem ;Jump if Equal to addItem function
	
		cmp al, "3"
		je updateItem ;Jump if Equal to updateItem function
	
		cmp al, "4"
		je exitProgram ;Jump if Equal to exitProgram function
	
		jmp optionNotPress
			
; START INITIALIZING INVENTORY FOR THE SECOND TIME
	initializeInventory2:
		mov si, offset lstOfItems	
		mov cx, 7 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

	printListC:
		
		mov ah, 09h
		lea dx, [si]
		int 21h
		
		add si, 82 ;'82' refers to the amount of character in a row + the dollar sign and the '10' in this case
		
		loop printListC
		jmp printQAgain
; END INITIALIZING INVENTORY FOR THE SECOND TIME		
	
	checkItem:
		printText horizontalDash
		printText databaseMsg
		printText horizontalDash
		
		mov ah, 02
		mov dl, 10
		int 21h
		
		jmp initializeInventory2
		
		
	addItem:
		printText availMsg
		jmp printQAgain
		
	updateItem:
		printText IntroMsg
		jmp printQAgain
		
	
	
	exitProgram:
		mov ah, 4ch
		int 21h
	
	
Main Endp
End Main
	
