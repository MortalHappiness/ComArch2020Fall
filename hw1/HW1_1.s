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
### Start your code here ###

# Given array v and its size n, bubble sort in place
#
# Arguments:
#   a2: array address for v
#   a3: size n
sort:
  # save register values
  addi sp, sp, -40
  sd   ra, 0(sp)
  sd   s0, 8(sp)
  sd   s1, 16(sp)
  sd   s2, 24(sp)
  sd   s3, 32(sp)

  # store arguments into saved registers
  mv s0, a2  # reg s0 = addr v
  mv s1, a3  # reg s1 = n

  # for loop 1 (s2: i)
  li s2, 0  # i = 0
for1test:
  bge s2, s1, for1exit  # if (i >= n) then jump to for1exit
  # for loop 2 (s3: j)
  addi s3, s2, -1  # j = i - 1
for2test:
  blt  s3, zero, for2exit  # if (j < 0) then jump to for2exit
  slli t0, s3, 3   # reg t0 = j * 8
  add  t0, s0, t0  # reg t0 = (addr v) + (j * 8)
  ld   t1, 0(t0)   # reg t1 = v[j]
  ld   t2, 8(t0)   # reg t2 = v[j+1]
  ble  t1, t2, for2exit  # if (v[j] <= v[j+1]) then jump to for2exit
  mv   a0, s0      # reg a0 = v
  mv   a1, s3      # reg a1 = j
  jal  swap        # call swap
  addi s3, s3, -1  # j -= 1
  j    for2test    # jump back to for2test
for2exit:
  addi s2, s2, 1  # i += 1
  j    for1test   # jump back to for1test
for1exit:

  # restore register values and return
  ld   ra, 0(sp)
  ld   s0, 8(sp)
  ld   s1, 16(sp)
  ld   s2, 24(sp)
  ld   s3, 32(sp)
  addi sp, sp, 40
  jr ra


# Given array v and index k, swap v[k] and v[k+1]
#
# Arguments:
#   a0: array address for v
#   a1: the index k
swap:
  slli t0, a1, 3   # reg t0 = k * 8
  add  t0, a0, t0  # reg t0 = (addr v) + (k * 8)
  ld   t1, 0(t0)   # reg t1 = v[k]
  ld   t2, 8(t0)   # reg t2 = v[k+1]
  sd   t2, 0(t0)   # v[k] = reg t2
  sd   t1, 8(t0)   # v[K+1] = reg t1
  jr   ra

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
