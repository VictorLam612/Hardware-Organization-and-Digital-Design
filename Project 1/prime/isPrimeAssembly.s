	.globl isPrimeAssembly
isPrimeAssembly:
	nop								//No Operation - For Debugging purposes
	ADD X9, XZR, XZR				//Initialize X9 = 0
	SUB SP, SP, #48					//Move stack pointer down 48 bytes
	STUR X0, [SP, #0]				//Store X0 into stack
	STUR X1, [SP, #16]				//Store X1 into stack
	STUR X2, [SP, #32]				//Store X2 into stack
	forLoop:
		SUB X10, X9, X3				//Perform i - len
		CBZ X10, Finish				//If i - len == 0
		LDUR X6, [X0, #0]			//Load a[i] into X6; "parameter" for isPrime
		B isPrime					//"Call" isPrime
		Next: //Return point for isPrime
		CBZ X5, Composite			//If isPrime returns 1, goto Composite
		STUR X6, [X1, #0]			//Store a[i] into prime[j]
		ADD X1, X1, #8				//Move pointer to [prime[j + 1]
		B Gen						//Go to Gen
		Composite: //If number is composite
		STUR X6, [X2, #0]			//Store a[i[ into composite[k]
		ADD X2, X2, #8				//Move pointer to composite[k + 1]
		Gen:
		ADD X9, X9, #1				//Increment i; i++
		ADD X0, X0, #8				//Move pointer to a[i + 1]
		B forLoop					//Goto forLoop

	Finish: //When done traversing for loop
		LDUR X0, [SP, #0]			//Load X0 from stack
		LDUR X1, [SP, #16]			//Load X1 from stack
		LDUR X2, [SP, #32]			//Load X2 from stack
		ADD SP, SP, #48				//Restore stack pointer
		BR X30						//Return control to "calling" program

isPrime:
	ADD X17, XZR, XZR				//Initialize i = 0
	ADD X17, X17, #2				//Set i = 2
	UDIV X14, X6, X17				//Perform n/2 and store in X14; i = 2 so really dividing by i
	forLoopB: //isPrime for loop - b to differentiate
		SUB X15, X17, X14			//Perform i - n/2
		SUB X15, X15, #1			//Perform i - n/2 - 1
		CBZ X15, EndA				//If i > n/2, goto EndA
		UDIV X16, X6, X17			//Perform (int) n/i and store into X16
		MUL X16, X16, X17			//Perform ((int) n/i) * i
		SUB X16, X6, X16			//Perform n - ((int) n/i) * i
		CBZ X16, EndB				//If n - ((int) n/i) * i == 0, goto EndB
		ADD X17, X17, #1			//Increment i; i++
		B forLoopB					//Goto forLoopB
	EndA: //If number is prime
		ADD X5, XZR, XZR			//Part I: Return 1
		ADD X5, X5, #1				//Part II: Return 1
		B Next						//Return control to calling program
	EndB: //If number is composite
		ADD X5, XZR, XZR			//Return 0
		B Next						//Return control to calling program
