nop #Motor Walking Test Code
nop #Will Denton, Eric Seng
nop
nop
nop
nop
addi $1, $0, 1 #Setting IDs of the servos
addi $2, $0, 2
addi $3, $0, 3
addi $4, $0, 4
addi $5, $0, 5
addi $6, $0, 6
addi $7, $0, 7
addi $8, $0, 8
nop
addi $11, $0, 100 #Setting the homes of the servos
addi $12, $0, 112
addi $13, $0, 87
addi $14, $0, 103
addi $15, $0, 69
addi $16, $0, 122
addi $17, $0, 74
addi $18, $0, 102
nop
nop #move home
home:
nop
nop
nop
spin $1, $11, 0
nop             
wait 30
nop
spin $2, $12, 0
nop
wait 30
nop
spin $3, $13, 0
nop
wait 30
nop
spin $4, $14, 0
nop
wait 30
nop
spin $5, $15, 0
nop
wait 30
nop
spin $6, $16, 0
nop
wait 30
nop
spin $7, $17, 0
nop
wait 30
nop
spin $8, $18, 0
nop 
wait 30
nop
wait 1000
nop
nop
nop
j home
nop
