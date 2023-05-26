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
				db 10, "1.             ", "Drone          ", "Available      ", "5              ", "                    $"
				db 10, "2.             ", "Motherboard    ", "Unavailable    ", "0              ", "Require Restock     $"
				db 10, "3.             ", "RAM            ", "Available      ", "3              ", "Require Restock     $"
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
	askAddMsg3	db 10, "How many would you like to add: $"	
	askSubMsg1 	db 10, "Which one would you like to sub? : $"
	askSubMsg2	db 10, "You have chosen: $"
	askSubMsg3	db 10, "How many would you like to sub: $"	
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
		mov cx, 4 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

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
		je subItems ;Jump if Equal to subItem function
		
		cmp al, "4"
		je exitProgram ;Jump if Equal to exitProgram function
	
		jmp optionNotPress1
		
	exitProgram:
		mov ah, 4ch
		int 21h
		
; START INITIALIZING INVENTORY FOR THE SECOND TIME
	initializeInventory2:
		mov si, offset lstOfItems	
		mov cx, 4 ;Register Counter that MUST be included when trying to print an array, which is the number of rows

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
		; mov dl, al ;Why must be before asking for user input?
		mov ah, 01h
		int 21h
	
		cmp al, "1"
		je initalizeAddItem1
		cmp al, "2"
		je initalizeAddItem2
		cmp al, "3"
		je initalizeAddItems3
		
		mov ah, 02
		mov dl, 10
		int 21h
		jmp optionNotPress1

	subItems:
		jmp subItem

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
		loop checkAddItem1 ;END to print out "You have chosen: " #1
	
	addItem1:
		printText askAddMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+128] 
		sub cl, '0'
		sub al, '0'
		add al, cl
		add al, 48
		mov dl, al
		mov BYTE PTR [si+128] , dl
		jmp printQAgain
	
	initalizeAddItems3:
		jmp initalizeAddItem3
	
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
		je addItem2
		inc si
		loop checkAddItem2
	
	addItem2:
		printText askAddMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+210] 
		sub cl, '0'
		sub al, '0'
		add al, cl
		add al, 48
		mov dl, al
		mov BYTE PTR [si+210] , dl
		jmp printQAgain
	
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
		je addItem3
		inc si
		loop checkAddItem3

	addItem3:
		printText askAddMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+292] 
		sub cl, '0'
		sub al, '0'
		add al, cl
		add al, 48
		mov dl, al
		mov BYTE PTR [si+292] , dl
		jmp printQAgain
		
		
		subItem:
		printText askSubMsg1
		; mov dl, al ;Why must be before asking for user input?
		mov ah, 01h
		int 21h
	
		cmp al, "1"
		je initalizeSubItem1
		cmp al, "2"
		je initalizeSubItem2
		cmp al, "3"
		je initalizeSubItems3
		
		mov ah, 02
		mov dl, 10
		int 21h
		jmp optionNotPress1

	initalizeSubItem1: ;START to print out "You have chosen: " #1
		mov si, 98
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askSubMsg2
	
	checkSubItem1:
		mov cl, [bx+si]
		mov dl, cl
		mov ah, 02h
		int 21h
		cmp cl, ' '
		je subItem1
		inc si
		loop checkSubItem1 ;END to print out "You have chosen: " #1
	
	subItem1:
		printText askSubMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+128] 
		sub cl, '0'
		sub al, '0'
		sub cl, al
		add cl, 48
		mov dl, cl
		mov BYTE PTR [si+128] , dl
		jmp printQAgain
	
	initalizeSubItems3:
		jmp initalizeSubItem3
	
	initalizeSubItem2:
		mov si, 180
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askSubMsg2
	
	checkSubItem2:
		mov cl, [bx+si]
		mov dl, cl
		mov ah, 02h
		int 21h
		cmp cl, ' '
		je subItem2
		inc si
		loop checkSubItem2
	
	subItem2:
		printText askSubMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+210] 
		sub cl, '0'
		sub al, '0'
		sub cl, al
		add cl, 48
		mov dl, cl
		mov BYTE PTR [si+210] , dl
		jmp printQAgain
	
	initalizeSubItem3:
		mov si, 262
		lea bx, lstOfItems
		mov cx, 20 
	
	printText askSubMsg2
	
	checkSubItem3:
		mov cl, [bx+si]
		mov dl, cl
		mov ah, 02h
		int 21h
		cmp cl, ' '
		je subItem3
		inc si
		loop checkSubItem3

	subItem3:
		printText askSubMsg3
		mov ah, 01h
		int 21h
		mov si, offset lstOfItems
		mov cl, BYTE PTR [si+292] 
		sub cl, '0'
		sub al, '0'
		sub cl, al
		add cl, 48
		mov dl, cl
		mov BYTE PTR [si+292] , dl
		jmp printQAgain
		
	exitProgram2:
		mov ah, 4ch
		int 21h
	
	
Main Endp
End Main
	
