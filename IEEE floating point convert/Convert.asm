##########################################################################
# Created by:  Sullivan, Noah
#              noasulli
#              11 November 2019
#
# Assignment:  Lab 4: Sorting Floats
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: This program accepts three arguments in IEEE
#              single precision floating point format and prints
#              them to the screen in order in floating point format
#              and decimal format
#
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

##########################################################################
# Pseduocode:
#              
#              print (Program arguments message)
#        
#              print (arg1, end=" ")
#              print (arg2, end=" ")
#              print (arg3, end=" ")
#             
#              i = 2
#              k = 7
#              y = 0
#
#              for i in len(arg1):
#                  x = ascii value of byte i of arg1
#                  if ascii value > 57:
#                      x -= 55
#                  else:
#                      x -= 48
#                  x = x * 16^k
#                  y = y + x
#                  i += 1
#                  k -= 1
#              a = y
#              i = 2
#              k = 7
#              y = 0
#
#              for i in len(arg2):
#                  x = ascii value of byte i of arg2
#                  if ascii value > 57:
#                      x -= 55
#                  else:
#                      x -= 48
#                  x = x * 16^k
#                  y = y + x
#                  i += 1
#                  k -= 1
#              b = y
#              i = 2
#              k = 7
#              y = 0
#
#              for i in len(arg3):
#                  x = ascii value of byte i of arg3
#                  if ascii value > 57:
#                      x -= 55
#                  else:
#                      x -= 48
#                  x = x * 16^k
#                  y = y + x
#                  i += 1
#                  k -= 1
#              c = y
#              
#              print (sort message ieee)
#
#              
#
#              if arg1 < arg2 < arg3
#                  print (arg1)
#                  store in $f0
#                  print (arg2)
#                  store in $f1
#                  print (arg3)
#                  store in $f2
#
#              if arg1 < arg3 < arg2
#                  print (arg1)
#                  store in $f0
#                  print (arg3)
#                  store in $f1
#                  print (arg2)
#                  store in $f2
#
#              if arg2 < arg1 < arg3
#                  print (arg2)
#                  store in $f0
#                  print (arg1)
#                  store in $f1
#                  print (arg3)
#                  store in $f2
#
#              if arg2 < arg3 < arg1
#                  print (arg2)
#                  store in $f0
#                  print (arg3)
#                  store in $f1
#                  print (arg1)
#                  store in $f2
#
#              if arg3 < arg1 < arg2
#                  print (arg3)
#                  store in $f0
#                  print (arg1)
#                  store in $f1
#                  print (arg2)
#                  store in $f2
#
#              if arg3 < arg2 < arg1
#                  print (arg3)
#                  store in $f0
#                  print (arg2)
#                  store in $f1
#                  print (arg1)
#                  store in $f2
#
#              convert to decimal
#              
#              print (sort message decimal)
#
#              print $f0
#              print $f1
#              print $f2
#
#              end            
# 
##########################################################################
.data
       arg_msg:  .asciiz "Program arguments:\n"
       sort_1:   .asciiz "Sorted values (IEEE 754 single precision floating point format):"
       sort_2:   .asciiz "Sorted values (decimal):"
       base:     .float 16
       
       



.text
       main:
               li $v0, 4                           # prints argument message
               la $a0, arg_msg
               syscall
       
               lw $a0, 0($a1)
               li $v0, 4
               syscall
       
               li $a0, ' '
               li $v0, 11
               syscall
       
               lw $a0, 4($a1)
               li $v0, 4
               syscall
       
               li $a0, ' '
               li $v0, 11
               syscall
                                            
               lw $a0, 8($a1)
               li $v0, 4
               syscall
                                                   # prints arguments
               li $a0, '\n'
               li $v0, 11
               syscall
               
               li $a0, '\n'
               li $v0, 11
               syscall
               
               li $v0, 4
               la $a0, sort_1
               syscall
               
               li $a0, '\n'
               li $v0, 11
               syscall
       counter1:
               addi $t4, $zero, 7                  # counts down exponents
               addi $t7, $zero, 0
               lw $t0, 0($a1)
    
       load_byte1:
               lb    $t3, ($t0)
               beq   $t3, 0, end1                  # loads the argument one bit at a time
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
               mflo $t2
               add  $t7, $t7, $t2                  # adds the bit with magnitude to a total register
               addi $t0, $t0, 1
               subi $t4, $t4, 1
               j load_byte1
     
  
  
       end1:
               mtc1 $t7, $f21
               j counter2                          # jumps to the next argument
       
       exponent_c1:
               move $t5, $t4
               addi $t6, $zero, 16                 # counter for exponent calculator
               move $t1, $t6
                     
       exponent1:
               mult $zero, $zero
               bltz $t5, addit1
               subi $t5, $t5, 1
               mult $t1, $t6                       # loops until desired power of 16 is reached
               mflo $t1
               mfhi $t2
               j exponent1
       
       
       counter2:
               addi $t4, $zero, 7                  # counts down exponents
               addi $t7, $zero, 0
               lw   $t0, 4($a1)
    
       load_byte2:
               lb   $t3, ($t0)
               beq  $t3, 0, end2
               bgt  $t3, 57, convert_letr2         # loads argument 2 bit by bit
               j convert_num2
     
       convert_num2:
               subi  $t3, $t3, 48                  # converts number in ascii format to integer
               j exponent_c2
               
       convert_letr2:
               subi  $t3, $t3, 55                  # converts letter in ascii form to integer
               j exponent_c2
               
       addit2:
               mult  $t3, $t1 
               mflo $t2
               add  $t7, $t7, $t2                  # adds the bit with magnitude to a total register
               addi $t0, $t0, 1
               subi $t4, $t4, 1
               j load_byte2
     
       end2:
               mtc1 $t7, $f22                      # jumps to argument 3
               j counter3
       
       exponent_c2:
               move $t5, $t4
               addi $t6, $zero, 16                 # counter for exponent calculator
               move $t1, $t6
               
       exponent2:
               mult $zero, $zero
               bltz    $t5, addit2                 # loops until desired power of 16 is reached
               subi    $t5, $t5, 1
               mult    $t1, $t6
               mflo    $t1
               mfhi    $t2
               j exponent2    
       
       
       counter3:
               addi $t4, $zero, 7                  # counts down exponents
               addi $t7, $zero, 0
               lw $t0, 8($a1)
    
       load_byte3:
               lb    $t3, ($t0)
               beq   $t3, 0, end3                  # loads the argument one bit at a time
               bgt   $t3, 57, convert_letr3
               j convert_num3
     
       convert_num3:
               subi  $t3, $t3, 48                  # converts number in ascii format to integer
               j exponent_c3
       convert_letr3:
               subi  $t3, $t3, 55                  # converts letter in ascii form to integer
               j exponent_c3
       addit3:
               mult  $t3, $t1 
               mflo $t2
               add  $t7, $t7, $t2                  # adds the bit with magnitude to a total register
               addi $t0, $t0, 1
               subi $t4, $t4, 1
               j load_byte3      
       exponent_c3:
               move $t5, $t4
               addi $t6, $zero, 16                 # counter for exponent calculator
               move $t1, $t6
       exponent3:
               mult $zero, $zero
               bltz    $t5, addit3                 # loops until desired power of 16 is reached
               subi    $t5, $t5, 1
               mult    $t1, $t6
               mflo    $t1
               mfhi    $t2
               j exponent3
       end3:
               mtc1 $t7, $f23                      # jumps to sort
               j sort1_1
   
   
       sort1_1:
               c.lt.s  $f21, $f22                 
               bc1t   sort2_1  
               bc1f   sort3_1
       sort2_1: 
               c.lt.s  $f21, $f23                 
               bc1t    print1_1                    # finds the lowest argument
               bc1f    print3_1
       sort3_1:
               c.lt.s  $f22, $f23
               bc1t    print2_1
               bc1f    print3_1
       
       print1_1:
               mfc1  $a0, $f21
               mov.s   $f0,  $f21
               li $v0, 34
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               j sort3_2
       print2_1:
               mfc1  $a0, $f22
               mov.s   $f0,  $f22
               li $v0, 34                          # prints lowest argument depending on sort outcome and stores it in $f0
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               j sort2_2
       print3_1:
               mfc1  $a0, $f23
               mov.s   $f0,  $f23
               li $v0, 34
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               j sort1_2
       
       sort1_2:
               c.lt.s  $f21, $f22
               bc1t    print12
               bc1f    print21
       sort2_2: 
               c.lt.s  $f21, $f23
               bc1t    print13                     # finds middle argument 
               bc1f    print31
       sort3_2:
               c.lt.s  $f22, $f23
               bc1t    print23
               bc1f    print32
               
       print12:
               li $v0, 34                          # this print block will print the middle argument, store it in $f1, then find the highest argument based
               mov.s   $f12, $f21                  # of the sorting done previously.  The code then stores the highest argument in $f2 and prints it.
               mov.s   $f1,  $f21
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               li $v0, 2
               mov.s   $f12, $f22
               mov.s   $f2,  $f22
               syscall
               j decimal
       print13:
               li $v0, 34
               mov.s   $f12, $f21
               mov.s   $f1,  $f21
               syscall
               li $a0, ' '                     
               li $v0, 11
               syscall
               li $v0, 2
               mov.s   $f12, $f23
               mov.s   $f2,  $f23
               syscall
               j decimal
       print21:
               li $v0, 34
               mfc1  $a0, $f22
               mov.s   $f1,  $f22
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               li $v0, 34
               mfc1  $a0, $f21
               mov.s   $f2,  $f21
               syscall
               j decimal
       print23:
               li $v0, 34
               mfc1  $a0, $f22
               mov.s   $f1,  $f22
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               li $v0, 34
               mfc1  $a0, $f23
               mov.s   $f2,  $f23
               syscall
               j decimal  
       print31:
               li $v0, 34
               mfc1  $a0, $f23
               mov.s   $f1,  $f23
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               li $v0, 34
               mfc1  $a0, $f21
               mov.s   $f2,  $f21
               syscall
               j decimal 
       print32: 
               li $v0, 34
               mfc1  $a0, $f23
               mov.s   $f1,  $f23
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               li $v0, 34
               mfc1  $a0, $f22
               mov.s   $f2,  $f22
               syscall
               j decimal
               
       decimal:
               li  $a0, '\n'
               li $v0, 11
               syscall
               li $a0, '\n'
               li $v0, 11
               syscall
               la $a0, sort_2                      # print the decimal sort message
               li $v0, 4
               syscall
                li $a0, '\n'
               li $v0, 11
               syscall
               mov.s $f12, $f0                     # print the values again in decimal 
               li $v0, 2
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               mov.s $f12, $f1
               li $v0, 2
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               mov.s $f12, $f2
               li $v0, 2
               syscall
               li $a0, ' '
               li $v0, 11
               syscall
               j exit
       
       
       
       
       
       exit:
               li $v0, 10                          # exits the program
               syscall
