.globl __start

.text

__start:
  li a0, 5   # ecall code
  ecall 
  
  # determine s0=0 r1
  addi t0,x0,1
  bge a0,t0,FUNC
  beq a0,t0,ONE
  add s1,x0,x0
  beq x0,x0,FINAL
ONE:
  addi s1,x0,1
  beq x0,x0,FINAL
  addi s1,x0,1
  beq x0,x0,FINAL
  
  
FUNC:
  addi sp,sp,-8
  sw s0,0(sp)
  sw ra,4(sp)
  jal L1
  


L1:
  addi s0,s0,-1
  jal func  
  

FINAL:  
  li a0, 1
  mv a1, s1 #0xa # integer to print
  ecall