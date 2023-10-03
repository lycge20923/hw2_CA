.globl	__start

.rodata
        msg: .asciiz "Empty!"
.text

push_front_list:             
        ### if(list == NULL)return; ###
        beqz    a0, LBB0_2
        ### save ra、s0 ###
        addi    sp, sp, -16
        sw      ra, 12(sp) #store ra                     
        sw      s0, 8(sp)  #store s0, the addr    
        sw      s1, 4(sp)  #store s1, value                     
        mv      s1, a1 #s1=a1 =>store var. a1 at s1
        mv      s0, a0 #s0=a0 =>store var. a0 at s0
        ### node_t *new_node = (node_t*)sbrk(sizeof(*new_node)); ###
        li      a0, 8 #needs 2 args, a1=string, buffer addr.;a2=length, the buffer minimal size  
        call    sbrk #output 2 num, a1 = buffer addr, a0 = buffer min size 
        
        ### new_node->value = value; ###
        sw      s1, 0(a0) # mem[a0] = s1
        ### new_node->next = list->head; ###
        lw      a1, 0(s0) #a1 = mem[s0], s0 in the line16 
        sw      a1, 4(a0) #mem[a0+1] = a1
        ### list->head = new_node; ###
        sw      a0, 0(s0) #mem[s0] = a0
        
        #mv a1,a0
        #li a0,1
        #ecall
        
LBB0_2:
        ## exit handling ###
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        lw      s1, 4(sp)                       
        addi    sp, sp, 16
        ret
        
print_list:
############################################
#  TODO:Print out the linked list          #
#                                          #
############################################
        # 4(a0):store first ele addr
        # 0(a0):store first ele
        #-4(a0):store second addr
        #-8(a0):store second ele
        #....
        #read until the addr become 0
        #addi t1,a0,4
        #lw a1,0(t1)
        add t1,x0,a0 
        addi sp,sp,-4
        sw ra,0(sp)
        
        lw t1,4(a0) #store the next node's "value"'s addr
        lw a0,0(a0) #prepare to print the int
        jal print_int   
        add a0,t1,x0
        lw ra,0(sp)
        addi sp,sp,4
        bne t1,x0,print_list        
        ret

__start:
        ### save ra、s0 ###                                   
        addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)                                            
        ### read the numbers of the linked list ###
        call    read_int # read the expected size of the array
        ### if(nums == 0) output "Empty!" ###
        beqz    a0, LBB2_2
        ### if(nums <= 0) exit
        mv      s0, a0
        blez    a0, exit
LBB2_1:                                
        call    read_int # read the element in the array
        ### set push_front_list argument ###
        mv      a1, a0 # the ele store at a1
        mv      a0, sp # the sp store at a0
        call    push_front_list #push the ele in the front of the list 
        addi    s0, s0, -1 
        bnez    s0, LBB2_1 #like while loop
        lw      a0, 0(sp) 
        j       LBB2_3
LBB2_2:
        call    print_str
        j       exit
LBB2_3:
        call    print_list
exit:   
        ### exit handling ###
        li      a0, 0
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        addi    sp, sp, 16
	li a0,	10 #stop programming
	ecall

read_int:
	li	a0, 5 #read an int from the console 
	ecall
	jr	ra

sbrk: 
        #combine the backward, the buffer store at addr a0(first); it's size is a0(second)  
	mv	a1, a0
	li	a0, 9
	ecall
	jr	ra
 
print_int:

        mv 	a1, a0
	li	a0, 1
	ecall
	li	a0, 11
	li	a1, ' '
	ecall
          
         
	jr	ra

print_str:
        li      a0, 4 # print string 
        la      a1, msg
        ecall
        jr      ra