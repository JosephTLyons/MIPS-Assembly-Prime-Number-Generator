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
            addi  $s1, $zero, 0     # Counts the amount of prime numbers
            addi  $s2, $zero, 100   # Used to test when we hit 100 prime numbers
Loop:       add   $a0, $s0, $zero   # Load number into argument
            jal   test_Prime        # Jump to function
            beq   $v0, $zero, Skip  # If not prime, skip next steps
            
            addi  $s1, $s1, 1       # Increment prime number count
            
            addi  $v0, $zero, 1     # Load system call to print prime number
            syscall
            
            addi  $v0, $zero, 4     # Load system call to print input string
            la    $a0, outputText   # Load input string for printing
            syscall

Skip:       addi  $s0, $s0, 1       # Increment number to test
            bne   $s1, $s2, Loop    # Keep looping until we reach 101 (only testing up to 100 though)
            beq   $s0, $s1, Exit2   # Exit program
      
#########################################################      
      
test_Prime: addi  $t0, $zero, 1     # $t0 = number of divisors for argument, 1 because number always divisible by itself
            div   $t1, $a0, 2       # $t1 = number that divides $a0, divided by 2 - we only need to check lower half of numbers
	    addi, $t3, $zero, 2     # This will be used later on for testing if prime or not
Loop2:      div   $a0, $t1          # 1st part of modulus
            mfhi  $t2               # $t1 = number % dividing number
            bne   $t2, $zero, Skip2 # See if argument is evenly divisible by $t1, If so...
            addi  $t0, $t0, 1	    # Increment count of divisors
Skip2:      sub   $t1, $t1, 1       # Decrement dividing number

  	    sgt   $t4, $t0, $t3     # $t3 = 2, check if count > 2, then number is evenly divisible by more than 2 numbers = not prime
            beq   $t4, $zero, Skip3 # Continue looping if prior test was false, otherwise return 0 
            addi  $v0, $zero, 0     # load 0 into $V0
            jr    $ra               # Leave function early with 0 (as false)
      
Skip3:      slt   $t5, $zero, $t1   # Check to see if dividing number is zero
            beq   $t5, $zero, Exit  # If zero, exit
            bne   $t5, $zero, Loop2 # Else, run loop again
            
            
Exit:       slt   $t4, $t0, $t3     # $t3 = 2, check if count < 2, only happens for number "1"
            beq   $t4, $zero, Skip4 # If prior test was false... skip next instructions 
            addi  $v0, $zero, 0     # load 0 into $V0
            jr    $ra               # Leave function early with 0 (as false)

Skip4:      addi  $v0, $zero, 1     # Leave loop, return to main with 1 (as true)
	    jr    $ra
	    
Exit2:
	    
     
      ### Double check that I'm using good register conventions
