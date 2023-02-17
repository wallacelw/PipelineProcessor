.data

.text

testeJalr:

addi t1 x0 1
addi t2 t2 2

addi x0 x0 0 # nop
addi x0 x0 0 # nop
addi x0 x0 0 # nop

jalr t0 t1 -1