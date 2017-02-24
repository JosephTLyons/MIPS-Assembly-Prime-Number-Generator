# Title: Programming Project Part 2		#Filename: PrimeNumbers.asm
# Author: Joseph Lyons				    #Date: February 15th, 2017
# Description: Calculates and displays first 100 prime numbers
# Input: None
# Output: 100 Prime Numbers
################# Data segment #####################
.data

outputText:  .asciiz " is prime\n"
################# Code segment #####################
.text
.globl main

# Variable Key:
# $s0 = loop counter and holds nubers to be tested for prime-ness
# $s1 = Prime number count
# $s2 = 100: Upper limit of prime numbers
# $a0 = Number being tested for prime-ness
# $t0 = Number of divisors for $a0
# $t1 = Number that divides $a0
# $t2 = 2: Max number of divisors before a number becomes not prime
# $t3 = Remainder after dividing, used to test if number is evenly divisble when dividing or not
# $t4 = Holds 1 or 0 after slt instructions

main:
            addi  $s0, $zero, 1     # Set loop counter to 1
            addi  $s1, $zero, 0     # Set prime number count to 0
            addi  $s2, $zero, 100   # Used to test when we hit 100 prime numbers
Loop:       add   $a0, $s0, $zero   # Load number into argument
            jal   test_Prime        # Jump to function
            beq   $v0, $zero, Skip  # If not prime, skip next steps
            
            addi  $s1, $s1, 1       # Increment prime number count
            
            li    $v0, 1            # Load system call to print prime number
            syscall
            
            li    $v0, 4            # Load system call to print input string
            la    $a0, outputText   # Load input string for printing
            syscall

Skip:       addi  $s0, $s0, 1       # Increment number to test
            bne   $s1, $s2, Loop    # Keep looping until we reach 100 prime numbers
            j Exit2                 # Else, exit program
      
#########################################################      
      
test_Prime: addi  $t0, $zero, 1     # 1 because number always divisible by itself
            div   $t1, $a0, 2       # We only need to check lower half of numbers
            addi, $t2, $zero, 2     # This will be used later on for testing if prime or not
Loop2:      div   $a0, $t1          # 1st part of modulus
            mfhi  $t3               # $t3 = number % dividing number
            bne   $t3, $zero, Skip2 # See if argument is evenly divisible by $t1, If so...
            addi  $t0, $t0, 1	    # Increment count of divisors
Skip2:      sub   $t1, $t1, 1       # Decrement dividing number

            slt   $t4, $t2, $t0     # Not prime if number of numbers that divide $a0 are > 2
            beq   $t4, $zero, Skip3 # Continue looping if prior test was false, otherwise return 0
            addi  $v0, $zero, 0     # load 0 into $V0
            jr    $ra               # Leave function early with 0 (as false)
      
Skip3:      slt   $t5, $zero, $t1   # Check to see if dividing number is zero
            beq   $t5, $zero, Exit  # If zero, exit
            j Loop2                 # Else, run loop again       
            
Exit:       slt   $t4, $t0, $t2     # $t2 = 2, check if count < 2, only happens for number "1"
            beq   $t4, $zero, Skip4 # If prior test was false... skip next instructions 
            addi  $v0, $zero, 0     # load 0 into $V0
            jr    $ra               # Leave function early with 0 (as false)

Skip4:      addi  $v0, $zero, 1     # Leave loop, return to main with 1 (as true)
            jr    $ra
	    
Exit2:
