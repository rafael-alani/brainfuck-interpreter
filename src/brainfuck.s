#########################################################
##    //   ) )                                         ##
##   //___/ /      __        ___       ( )       __    ##
##  / __  (      //  ) )   //   ) )   / /     //   ) ) ##
## //    ) )    //        //   / /   / /     //   / /  ##
##//____/ /    //        ((___( (   / /     //   / /   ##
##                                            	      ##
##                                            	      ##
##    //  ) )                                 	      ##	
## __//__                    ___       / ___  	      ##	
##  //          //   / /   //   ) )   //\ \   	      ##	
## //          //   / /   //         //  \ \  	      ##
##//          ((___( (   ((____     //    \ \ 	      ##
#########################################################
.global brainfuck

.data
mem: .skip 30000, 0
readChar: .byte, 0

format_str: .asciz "We should be executing the following code:\n%s"

formatChar: .asciz "%d\n"
char: .asciz "%c"
test: .asciz "It works till here!\n"
testHex: .asciz "%#010x\n"

# The brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

#	%r12 source pointer
# 	%r13 memory pointer

.text
brainfuck:
	pushq %rbp
	movq %rsp, %rbp
	
	#movq $0, %rax
	#movq $formatChar, %rdi
	#movb $65, %sil
	#call printf

	# save the pointer to the instruction and memory
	movq %rdi, %r12
	movq $mem, %r13

# This is the main loop statement, we are going to loop
# over all the possible brainfuck commands ><+-,.[]
#the stop condition is for the instruction bit to be equal with 0
#if not increment the instruction pointer and go through every command
#calling the apropriate case
execute:
	cmpb $'>', (%r12)
	je incrementMemPointer 

	cmpb $'<', (%r12)
	je decrementMemPointer

	cmpb $'+', (%r12)
	je incrementMemReference

	cmpb $'-', (%r12)
	je decrementMemReference

	cmpb $'.', (%r12)
	je printChar

	cmpb $',', (%r12)
	je scanChar

	cmpb $'[', (%r12)
	je loopForward

	cmpb $']', (%r12)
	je loopBackward

#this is where the logic for the loop is implemented
#the stop condition is for the instruction bit to be equal with 0
#if not increment the instruction pointer and go through every command
executeEnd:
	#movq $0, %rax
	#movq $testHex, %rdi
	#movq %r13, %rsi
	#call printf

	incq %r12
	cmpb $0, (%r12)
	jne execute

	#movq $0, %rax
	#movq $test, %rdi
	#call printf
exit:
	movq %rbp, %rsp
	popq %rbp
	ret

#increments the memory pointer
incrementMemPointer:
	incq %r13
	jmp executeEnd

#decrements the memory pointer
decrementMemPointer:
	decq %r13
	jmp executeEnd

#increments the memory cell at which the poitner points at
incrementMemReference:
	#movb (%r13), %r15b
	#incb %r15b
	#movb %r15b, (%r13)
	incb (%r13)
	jmp executeEnd

#decrements the memory cell at which the poitner points at
decrementMemReference:
	decb (%r13)
	jmp executeEnd

#used to print the data inside the cell the pointer points to as a %c
printChar:
	movq $0, %rax
	movq $formatChar, %rdi
	movzb (%r13), %rsi			#the only question here is if (%r13) contains the byte i want
	call printf
	jmp executeEnd

#used to read 1 %c from the stdin buffer and save it in the cell the pointer points to
scanChar:
	call getchar
	movb %al, (%r13)
	call getchar
	#movq $0, %rax
	#movq $char, %rdi
	#movq %r13, %rsi
	#call scanf
	jmp executeEnd

#used to loop to the matching ] bracket if the cell is different from 0
loopForward:
	cmpb $0, (%r13)
	jne executeEnd

	movq $1, %r14
	whileF:
		incq %r12
		cmpb $'[', (%r12)
		je incrementF

		cmpb $']', (%r12)
		je decrementF

	whileEndF:
			cmpq $0, %r14
			jne whileF
			jmp executeEnd

#if
incrementF:
	incq %r14
	jmp whileEndF

#else
decrementF:
	decq %r14
	jmp whileEndF
	
#used to loop to the matching [ bracket if the cell is different from 0
loopBackward:
	cmpb $0, (%r13)
	je executeEnd

	movq $1, %r14
	whileB:
		decq %r12
		cmpb $']', (%r12)
		je incrementB

		cmpb $'[', (%r12)
		je decrementB

	whileEndB:
			cmpq $0, %r14
			jne whileB
			decq %r12
			jmp executeEnd

#if
incrementB:
	incq %r14
	jmp whileEndB

#else
decrementB:
	decq %r14
	jmp whileEndB

