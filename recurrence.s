.globl __start

.text

__start:
  li a0, 5   # ecall code
  ecall 
  addi t3,x0,2
  blt a0,t3,TOEXIT
  jal ra,FUNC

EXIT:
  li a0, 1 
  ecall
  li a0, 10
  ecall

TOEXIT: 
  add a1,a0,x0
  beq x0,x0,EXIT

FUNC:
  addi sp,sp,-24
  sw ra,0(sp)  
  sw a0,8(sp) 
  sw s0,16(sp)  
  addi t1,x0,1
  slt t0,t1,a0 
  bne t0,x0,L1
  add a1,s1,a0 
  addi sp,sp,24
  jalr x0,0(ra)
  
L1:
  addi a0,a0,-1 
  jal ra,FUNC
  mv s0,a1
  addi a0,a0,-1 
  jal ra,FUNC
  add s0,s0,s0
  add a1,a1,s0 
  lw ra,0(sp)
  lw a0,8(sp) #a0
  lw s0,16(sp)
  addi sp,sp,24
  jalr x0,0(ra)
  
