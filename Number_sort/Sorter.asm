#------------------------------------------------------------------------
# Created by:  Sullivan, Noah
#              noasulli
#              2 December 2019 
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
# 
# Notes:       This file is intended to be run from the Lab 5 test file.
#------------------------------------------------------------------------

.text

j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro

.macro lab5_print_new_line
    addiu $v0 $zero   11
    addiu $a0 $zero   0xA
    syscall
.end_macro

#------------------------------------------------------------------------
# print string

.macro lab5_print_string(%str)

    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall
    
.end_macro

#------------------------------------------------------------------------
# add additional macros here


#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
# 
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: nop
    
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
    
    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array
    
    move  $a0    $s1            # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length
    
                                # print input header
                                 
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")
                      
    ########################### 
    move $a1, $s1
    move $a0, $s2               # load subroutine arguments                         
    jal   print_str_array       # print array of ASCII strings
    
    ###########################
    move $a1, $s1
    move $a0, $s2               # load subroutine arguments
    move $a2, $s0
    jal   str_to_int_array      # convert string array to int array
                                
    ########################### 
    move $a1, $s0
    move $a0, $s2               # load subroutine arguments
    jal   sort_array            # sort int array
    
    move $s3, $v0
    move $s4, $v1               # save min and max values from array
                                                                                                
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")
    
    ########################### 
    move $a1, $s0
    move $a0, $s2               # load subroutine arguments
    jal   print_decimal_array   # print integer array as decimal
                                # save output values
    
    lab5_print_new_line
    
    ########################### # add code (delete this comment)
                                # move min and max values from array
                                # to output registers
    move $v0, $s3
    move $v1, $s4                            
            
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36       # increment stack pointer
    
    jr    $ra                   # return from subroutine

#-----------------------------------------------------------------------
# print_str_array	
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
# 
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_str_array: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
   
    move $t1, $a0
      
print_loop:
    lw $a0, ($a1)
    li $v0, 4
    syscall
    
    subi $t1, $t1, 1
    beqz $t1, exit_print
    
    li $a0, ' '
    li $v0, 11
    syscall
    
    addi $a1, $a1, 4
    j print_loop
    
    
    
exit_print:
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36

    jr  $ra
    
#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
# 
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                    that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
str_to_int_array: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
    
    move $t2, $a0
load:
    beqz $t2, str_to_int_return
    lw $a0, ($a1)
    jal str_to_int
    sw $v0, ($a2)
    addi $a1, $a1, 4
    addi $a2, $a2, 4
    subi $t2, $t2, 1
    j load
    
str_to_int_return:
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36
    jr   $ra
   

#-----------------------------------------------------------------------
# str_to_int	
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
# 
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text

str_to_int: nop

    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)

counter1:
    move $v0, $zero
    addi $t4, $zero, 7                  # counts down exponents
    addi $t7, $zero, 0
    
load_byte1:
    lb    $t3, 2($a0)
    beq   $t4, -1, end1                  # loads the argument one bit at a time
    bgt   $t3, 57, convert_letr1      
    j convert_num1
     
convert_num1:
    subi  $t3, $t3, 48                  # converts number in ascii format to integer
    j exponent_c1
               
convert_letr1:
    subi  $t3, $t3, 55                  # converts letter in ascii form to integer
    j exponent_c1
               
addit1:
    mult  $t3, $t1 
    mflo $t1
    add  $v0, $v0, $t1                  # adds the bit with magnitude to a total register
    addi $a0, $a0, 1
    subi $t4, $t4, 1
    j load_byte1
       
exponent_c1:
    move $t5, $t4
    addi $t1, $zero, 1                 # counter for exponent calculator
                     
exponent1:
    beqz $t5, addit1
    mul $t1, $t1, 16                       # loops until desired power of 16 is reached
    subi $t5, $t5, 1
    j exponent1
   
end1:
  
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36
    
    jr  $ra
    
#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
sort_array: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
    
    addi $sp, $sp, 100
    addi $t0, $zero, 0x7FFFFFFF
    move $t4, $a1
    move $t5, $a0
    mul  $t3, $t5, 4
    sub  $sp, $sp, $t3
    move $t6, $t5
    
start:
    beqz $t5, sort_start
    lw $t2, ($t4)
    blt $t2, $t0 min
    addi $t4, $t4, 4
    subi $t5, $t5, 1
    j start
    
min:
    move $t0, $t2
    addi $t4, $t4, 4
    subi $t5, $t5, 1
    sw   $t0, ($sp)
    j start

reset:
    move $t0, $t7
    addi $sp, $sp, 4
    subi $t6, $t6, 1
    beqz $t6, reset_sp
    j sort_start
    
sort_start:
    move $t4, $a1
    move $t5, $a0
    addi $t7, $zero, 0x7FFFFFFF
    
check:
    beqz $t5, reset
    lw $t2, ($t4)
    bgt $t2, $t0, sort_next
    addi $t4, $t4, 4
    subi $t5, $t5, 1
    j check

sort_next:
    blt $t2, $t7 store_next
    addi $t4, $t4, 4
    subi $t5, $t5, 1
    j check
    
store_next:
    move $t7, $t2
    addi $t4, $t4, 4
    subi $t5, $t5, 1
    sw   $t7, 4($sp)
    j check

reset_sp:
    sub $sp, $sp, $t3
    move $t5, $a0
    move $t4, $a1
    
add_to_array:
    beqz $t5, min_and_max
    lw $t0, ($sp)
    sw $t0, ($t4)
    addi $t4, $t4, 4
    addi $sp, $sp, 4
    subi $t5, $t5, 1
    j add_to_array

min_and_max:
    move $t4, $a1
    lw $t0, ($t4)
    move $v0, $t0
    add $t4, $t4, $t3
    lw $t0, -4($t4)
    move $v1, $t0
    
    subi $sp, $sp, 100
    
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36
    jr   $ra

#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal_array: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack

    
    move $t1, $a0
    
load_int:
    
    lw $a0, ($a1)
    jal print_decimal
    beq $t1, 1, decimal_return
    
    li $a0, ' '
    li $v0, 11
    syscall
    
    addi $a1, $a1, 4
    subi $t1, $t1, 1
    j load_int
    
decimal_return:
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack

    addi  $sp    $sp   36
    jr   $ra
    
#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
    
    subi $sp, $sp 4
    sw $zero, ($sp)
    move $t5, $zero
    move $t0, $a0
    add $t3, $zero, 10
    bgez $t0, loop
    move $t5, $t0
    sub  $t0, $zero, $t0 

loop:
    div $t0, $t3
    mflo $t0
    mfhi $t2
    addi $t2, $t2, 48
    subi  $sp, $sp, 4    
    sw    $t2, ($sp) 
    beqz  $t0, check1                   
    j loop

check1:
    bltz $t5, minus
    
print:
    lw $a0, ($sp)
    beqz $a0, end
    addi $sp, $sp, 4
    li $v0, 11
    syscall
    j print

minus:
    li $t3, '-'
    subi  $sp, $sp, 4    
    sw    $t3, ($sp) 
    j print

end:

    addi  $sp     $sp  4
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36
    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop

    addiu   $v0  $zero  10      # exit program cleanly
    syscall
    
#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES
#-----------------------------------------------------------------------
# You are permitted to delete these comments.

#-----------------------------------------------------------------------
# get_array_length (optional)
# 
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
get_array_length: nop
    subi  $sp     $sp   36       # decrement stack pointer
    sw    $ra  32($sp)           # push return address to stack
    sw    $s0  28($sp)           # push save registers to stack
    sw    $s1  24($sp)
    sw    $s2  20($sp)
    sw    $s3  16($sp)           # push save registers to stack
    sw    $s4  12($sp)
    sw    $s5   8($sp)
    sw    $s6   4($sp)           # push save registers to stack
    sw    $s7    ($sp)
    
    move  $s0, $zero

add_one_to_length:

    lw   $s1 ($a0)               #loads argument, adds 1 to length if != 0
    beqz $s1, return_length
    addi $s0, $s0, 1
    addi $a0, $a0, 4
    j add_one_to_length
         
return_length:   
    move  $v0,    $s0
    lw    $ra  32($sp)           # push return address to stack
    lw    $s0  28($sp)           # push save registers to stack
    lw    $s1  24($sp)
    lw    $s2  20($sp)
    lw    $s3  16($sp)           # push save registers to stack
    lw    $s4  12($sp)
    lw    $s5   8($sp)
    lw    $s6   4($sp)           # push save registers to stack
    lw    $s7    ($sp)
    addi  $sp    $sp   36                            
    jr      $ra
    
#-----------------------------------------------------------------------
# save_to_int_array (optional)
# 
# Saves a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------
