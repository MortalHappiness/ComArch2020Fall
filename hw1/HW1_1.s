#----------------------------------------------------Do not modify below text----------------------------------------------------
.data
  str1: .string	"This is HW1_1:\nBefore sorting: \n"
  str2: .string	"\nAfter sorting:\n"
  str3: .string	"  "
  num: .dword  -1, 3, -5, 7, -9, 2, -4, 6, -8, 10 

.globl main

.text
main:
  # Print initiate
  li a7, 4
  la a0, str1
  ecall
  
  # a2 stores the num address, a3 stores the length of  num
  la a2, num
  li a3, 10
  jal prints
  
  la a2, num
  li a3, 10
  jal sort
  
  # Print result
  li a7, 4
  la a0, str2
  ecall

  la a2, num
  li a3, 10
  jal prints
  
  # End the program
  li a7, 10
  ecall
#----------------------------------------------------Do not modify above text----------------------------------------------------
sort:
### Start your code here ###
  
  
  
  jr ra











#----------------------------------------------------Do not modify below text----------------------------------------------------
# Print function	
prints:
  mv t0, zero # for(i=0)
  # a2 stores the num address, a3 stores the length of  num
  mv t1, a2
  mv t2, a3
printloop:
  bge t0, t2, printexit # if ( i>=length of num ) jump to printexit 
  slli t4, t0, 3
  add t5, t1, t4
  lw t3, 0(t5)
  li a7, 1 # print_int
  mv a0, t3
  ecall
	
  li a7, 4
  la a0, str3
  ecall 
	
  addi t0, t0, 1 # i = i + 1
  j printloop
printexit:
  jr ra
#----------------------------------------------------Do not modify above text----------------------------------------------------