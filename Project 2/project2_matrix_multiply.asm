   .data
N: .word 100 # number of input vectors x
M: .word 6 # number of features
P: .word -56075 # weight vector is 1 dimensional
learned_weight_vector: .word 49, 15, 6, 630, 0, 1460 
x_data: .word
125,256,6000,256,16,128
29,8000,32000,32,8,32
29,8000,32000,32,8,32
29,8000,32000,32,8,32
29,8000,16000,32,8,16
26,8000,32000,64,8,32
23,16000,32000,64,16,32
23,16000,32000,64,16,32
23,16000,64000,64,16,32
23,32000,64000,128,32,64
400,1000,3000,0,1,2
400,512,3500,4,1,6
60,2000,8000,65,1,8
50,4000,16000,65,1,8
350,64,64,0,1,4
200,512,16000,0,4,32
167,524,2000,8,4,15
143,512,5000,0,7,32
143,1000,2000,0,5,16
110,5000,5000,142,8,64
143,1500,6300,0,5,32
143,3100,6200,0,5,20
143,2300,6200,0,6,64
110,3100,6200,0,6,64
320,128,6000,0,1,12
320,512,2000,4,1,3
320,256,6000,0,1,6
320,256,3000,4,1,3
320,512,5000,4,1,5
320,256,5000,4,1,6
25,1310,2620,131,12,24
25,1310,2620,131,12,24
50,2620,10480,30,12,24
50,2620,10480,30,12,24
56,5240,20970,30,12,24
64,5240,20970,30,12,24
50,500,2000,8,1,4
50,1000,4000,8,1,5
50,2000,8000,8,1,5
50,1000,4000,8,3,5
50,1000,8000,8,3,5
50,2000,16000,8,3,5
50,2000,16000,8,3,6
50,2000,16000,8,3,6
133,1000,12000,9,3,12
133,1000,8000,9,3,12
810,512,512,8,1,1
810,1000,5000,0,1,1
320,512,8000,4,1,5
200,512,8000,8,1,8
700,384,8000,0,1,1
700,256,2000,0,1,1
140,1000,16000,16,1,3
200,1000,8000,0,1,2
110,1000,4000,16,1,2
110,1000,12000,16,1,2
220,1000,8000,16,1,2
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
125,512,1000,0,8,20
75,2000,8000,64,1,38
75,2000,16000,64,1,38
75,2000,16000,128,1,38
90,256,1000,0,3,10
105,256,2000,0,3,10
105,1000,4000,0,3,24
105,2000,4000,8,3,19
75,2000,8000,8,3,24
75,3000,8000,8,3,48
175,256,2000,0,3,24
300,768,3000,0,6,24
300,768,3000,6,6,24
300,768,12000,6,6,24
300,768,4500,0,1,24
300,384,12000,6,1,24
300,192,768,6,6,24
180,768,12000,6,1,31
330,1000,3000,0,2,4
300,1000,4000,8,3,64
300,1000,16000,8,2,112
330,1000,2000,0,1,2
330,1000,4000,0,3,6
140,2000,4000,0,3,6
140,2000,4000,0,4,8
140,2000,4000,8,1,20
140,2000,32000,32,1,20
140,2000,8000,32,1,54
140,2000,32000,32,1,54
140,2000,32000,32,1,54
140,2000,4000,8,1,20
57,4000,16000,1,6,12
57,4000,24000,64,12,16
26,16000,32000,64,16,24
26,16000,32000,64,8,24
26,8000,32000,0,8,24
26,8000,16000,0,8,16
480,96,512,0,1,1
203,1000,2000,0,1,5
predictions: .space 400
 .text
main:
 # Store M, N, P in $a? registers
 lw $a0, N
 lw $a1, M
 li $a2, 0
 # This are globel varibales that stores the address value
 la $s7, x_data
 la $s5, predictions
 li $s4, 0 
 jal multiply
 ori $v0,$0,10 # end program gracefully
 syscall
multiply:
 # Register usage:
 # n is $s0, m is $s1, p is $s2,
 # r is $s3, c is $s4, i is $s5,
 # sum is $s6
 # Prologue
 sw $fp, -4($sp)
 la $fp, -4($sp)
 sw $ra, -4($fp)
 sw $s0, -8($fp)
 sw $s1, -12($fp)
 sw $s2, -16($fp)
 sw $s3, -20($fp)
 sw $s7, -24($fp)
 addi $sp, $sp, -28
 # Save arguments
 move $s0, $a0 # n number of vectors x
 move $s1, $a1 # m number of features (6)
 move $s2, $a2 # recursion count
 li $s3, 0 # r = 0
 li $t0, 4 # sizeof(Int)
 ##############################
 # Your code here
 beq $s0, $s2, mult_end
 multu $s1, $s2
 mflo $t3
 multu $t0, $t3
 mflo $a0
 li $a1, 0
 li $a2, 0
 jal getY
 la $t5, predictions 
 li $t0, 4
 multu $t0, $s2
 mflo $s7
 add $s7, $s7, $t5
 sw $v0, 0($s7)
 addi $s2, $s2, 1
 move $a0, $s0
 move $a1, $s1 
 move $a2, $s2
 jal multiply
 ##############################
mult_end:
 lw $ra, -4($fp)
 lw $s0, -8($fp)
 lw $s1, -12($fp)
 lw $s2, -16($fp)
 lw $s3, -20($fp)
 lw $s7, -24($fp)
 la $sp, 4($fp)
 lw $fp, ($fp)
 jr $ra
 
 
 getY: #Calculate Y recurssively
  sw $fp, -4($sp)
  la $fp, -4($sp)
  sw $ra, -4($fp)
  sw $s0, -8($fp)
  sw $s1, -12($fp)
  sw $s2, -16($fp)
  sw $s3, -20($fp)
  addi $sp, $sp, -24
  move $s0, $a0 # x offset (set to 0 only at the beginning of the program) and already *4
  move $s1, $a1 # features offset (set to zero for each x vector)
  move $s2, $a2 # sum set to 0 at beginning
  la $t1, x_data
  la $t2, learned_weight_vector
  lw $t0, M # Number of features
  li $s3, 0 # One feature calculate value
  li $t4, 4
  beq $s1, $t0, baseCaseAddWeight # Finish calculating the last feature.
  multu $t4, $s1
  mflo $t5
  add $t2, $t5, $t2 
  add $t1, $s0, $t1
  lw $t5, 0($t1)
  lw $t6, 0($t2)
  multu $t5, $t6
  mflo $s3 # finish calculation 
  # Set value for the next call
  addi $s0, $s0, 4
  addi $s1, $s1, 1
  move $a0, $s0 # x offset (set to 0 only at the beginning of the program) and already *4
  move $a1, $s1 # features offset (set to zero for each x vector)
  move $a2, $s2 # sum set to 0 at beginning
  jal getY
  
 exitY:
  add $s3, $s3, $v0
 baseCaseExit:
  move $v0, $s3
  lw $ra, -4($fp)
  lw $s0, -8($fp)
  lw $s1, -12($fp)
  lw $s2, -16($fp)
  lw $s3, -20($fp)
  la $sp, 4($fp)
  lw $fp, ($fp)
  jr $ra

 baseCaseAddWeight:
  lw $t7, P
  add $s3, $s3, $t7
  j baseCaseExit
