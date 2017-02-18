# Title: Programming Project Part 2		#Filename: Part2.asm
# Author: Joseph Lyons				#Date: February 15th, 2017
# Description: Calculates and displays first 100 prime numbers
# Input: None
# Output: None
################# Data segment #####################
.data

outputText:  .asciiz " is a prime number.\n"
################# Code segment #####################
.text
.globl main

main: # main program entry

            addi  $s0, $zero, 1     # $s0 = loop counter and holds numbers to be tested if prime
            addi  $s1, $zero, 101   # To be used later - 100 is upper limit of numbers to test
Loop:       add   $a0, $s0, $zero   # Load number into argument
            jal   test_Prime        # Jump to function
            beq   $v0, $zero, Skip  # If not prime, skip next steps
            
            addi  $v0, $zero, 1     # Load system call to print prime number
            syscall
            
            addi  $v0, $zero, 4     # Load system call to print input string
            la    $a0, outputText   # Load input string for printing
            syscall

Skip:       addi  $s0, $s0, 1       # Increment number to test
            bne   $s0, $s1, Loop    # Keep looping until we reach 101 (only testing up to 100 though)
            beq   $s0, $s1, Exit2   # Exit program
      
#########################################################      
      
test_Prime: addi  $t0, $zero, 1     # $t0 = number of divisors for argument, set to 1 because number always divisible by itself
            div   $t1, $a0, 2       # $t1 = number that divides $a0, divided by 2 because we only need to check lower half of numbers
	    addi, $t3, $zero, 3     # This will be used later on
Loop2:      div   $a0, $t1          # 1st part of modulus
            mfhi  $t2               # $t1 = number % dividing number
            bne   $t2, $zero, Skip2 # See if argument is evenly divisible by $t1, then...
            addi  $t0, $t0, 1	    # Increment count of divisors
Skip2:      sub   $t1, $t1, 1       # Decrement dividing number

  	    bne   $t0, $t3, Skip3   # $t3 = 3, if count is 3, then number is evenly divisible by more than 2 numbers = not prime
            addi  $v0, $zero, 0     # load 0 into $V0
            jr    $ra               # Leave function early with 0 (as false)
      
Skip3:      slt   $t4, $zero, $t1   # Check to see if dividing number is zero
            beq   $t4, $zero, Exit  # If zero, exit
            bne   $t4, $zero, Loop2 # Else, run loop again
            
            
Exit:       addi  $v0, $zero, 1     # Leave loop, return to function with 1 (as true)
	    jr    $ra
	    
Exit2:
	    
     
      ### Double check that I'm using good register conventions
