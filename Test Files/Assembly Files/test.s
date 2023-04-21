nop
nop
nop
addi $5, $0, 1 
sw $5, 2($0)
nop
nop
lw $5, 2($0)
bne $5, $0, supnnprev
addi $2, $0, 3
supnnprev:
addi $1, $0, 10