.data

.text

testeLW_SW:

addi t1 x0 16
addi t2 x0 2

addi x0 x0 0 # nop
addi x0 x0 0 # nop
addi x0 x0 0 # nop

sw t2, 0(t1)

addi x0 x0 0 # nop
addi x0 x0 0 # nop
addi x0 x0 0 # nop

lw t0, 0(t1)