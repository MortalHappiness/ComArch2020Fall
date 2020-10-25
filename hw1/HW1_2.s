.data
  str1: .string	"This is HW1_2: With size "
  str2: .string	" * "
  str3: .string	"\nBefore:\n"
  str4: .string	"Result:\n"
  str5: .string	"\t"
  str6: .string	"\n"
  data_i: .dword 208, 37, 181, 125, 192, 90, 20, 154, 28, 35
       .dword 231, 108, 9, 114, 66, 51, 14, 68, 246, 222
       .dword 33, 234, 71, 165, 130, 65, 136, 167, 2, 148
       .dword 233, 203, 12, 181, 179, 158, 199, 176, 198, 141
       .dword 162, 245, 25, 193, 228, 121, 239, 191, 209, 37
       .dword 25, 168, 210, 71, 245, 90, 34, 115, 222, 218
       .dword 72, 10, 178, 174, 140, 212, 146, 22, 22, 159
       .dword 140, 217, 81, 168, 36, 150, 120, 59, 102, 90
       .dword 245, 239, 243, 42, 39, 141, 4, 233, 67, 131
       .dword 247, 174, 9, 31, 66, 234, 86, 39, 205, 103
       .dword 41, 194, 112, 128, 215, 73, 42, 211, 111, 20
       .dword 248, 190, 98, 245, 65, 194, 203, 138, 233, 62
       .dword 245, 101, 196, 87, 208, 193, 80, 255, 47, 32
       .dword 124, 168, 203, 150, 63, 98, 135, 20, 68, 47
       .dword 205, 44, 48, 58, 237, 145, 43, 113, 38, 62
  data_o: .dword 0:104 #initiate 104 dwords with value 0
  data_size: .dword 15, 10
  buffer: .dword 0:9

.globl main

.text

#----------------------------------------------------Do not modify below text----------------------------------------------------
main:
  # Main function loop parameters setting
  la t0, data_size
  ld s2, 0(t0)				# rows
  ld s3, 8(t0)				# cols

  # Print initiate
  li a7, 4
  la a0, str1
  ecall
  li a7, 1
  mv a0, s2
  ecall
  li a7, 4
  la a0, str2
  ecall
  li a7, 1
  mv a0, s3
  ecall
  li a7, 4
  la a0, str3
  ecall

  # Print function
  # a1 stores print address, a2 stores the row length, and a3 stores the col length
  la a1, data_i
  mv a2, s2					# data_i rows
  mv a3, s3					# data_i cols
  jal prints				# print data
#----------------------------------------------------Do not modify above text----------------------------------------------------
### Start your code here ###













#----------------------------------------------------Do not modify below text----------------------------------------------------
ends:
  # Print str4
  li a7, 4
  la a0, str4
  ecall
  # Print function
  # a1 stores print address, a2 stores the row length, and a3 stores the col length
  la a1, data_o
  addi a2, s2, -2			# data_o rows
  addi a3, s3, -2			# data_o cols
  jal prints				# print data

  # Done, terminate program
  li a7, 10				# terminate
  ecall					# system call

# Print function
prints:
  addi sp, sp, -32
  sd ra, 24(sp)
  sd s3, 16(sp)
  sd s2, 8(sp)
  sd s1, 0(sp)
  # a1 stores print address, a2 stores the row length, and a3 stores the col length
  mv s1, a1
  mv s2, a2
  mv s3, a3
  li t0, 0				# for(i=0)
printforloop1:
  bge t0, s2, printexit1		# if ( i>=row ) jump to printexit1
  li t1, 0				# for(j=0)
printforloop2:
  bge t1, s3, printexit2		# if ( j>=col ) jump to printexit2
  li a7, 1				# print_int
  ld t2, 0(s1)
  mv a0, t2
  ecall
  li a7 4
  la a0, str5
  ecall
  addi s1, s1, 8			# Move to next memory address(8 bytes)
  addi t1, t1, 1			# j = j + 1
  j printforloop2
printexit2:
  li a7, 4
  la a0, str6
  ecall
  addi t0, t0, 1			# i = i + 1
  j printforloop1
printexit1:
  ld s1, 0(sp)
  ld s2, 8(sp)
  ld s3, 16(sp)
  ld ra, 24(sp)
  addi sp, sp, 32
  jr ra
#----------------------------------------------------Do not modify above text----------------------------------------------------