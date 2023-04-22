nop #Motor Walking Test Code
nop #Will Denton, Eric Seng
nop
nop
nop
nop
addi $7, $0, 7
addi $8, $0, 8
nop
nop
addi $17, $0, 74
addi $18, $0, 102
nop
nop
J1:
nop
nop
addi $9, $17, 40
spin $7, $9, 0
nop             
nop
wait 20
nop
nop
addi $9, $18, 20
spin $8, $9, 0
nop
nop
wait 20
nop
nop
wait 1000
nop
nop
nop
addi $9, $17, -40
spin $7, $9, 0
nop             
nop
wait 20
nop
nop
addi $9, $18, -20
spin $8, $9, 0
nop
nop
wait 20
nop
nop
wait 1000
nop
nop
j J1
nop
nop