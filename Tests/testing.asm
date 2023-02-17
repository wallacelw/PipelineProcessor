.data

.text

testeBEQ:

addi t1 x0 2
addi t2 t2 2

addi x0 x0 0 # nop
addi x0 x0 0 # nop
addi x0 x0 0 # nop

beq t1 t2 testeBEQ