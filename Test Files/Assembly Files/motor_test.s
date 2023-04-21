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
nop
spin $1, $11, 0
nop
spin $2, $12, 0
spin $3, $13, 0
spin $4, $14, 0
spin $5, $15, 0
spin $6, $16, 0
spin $7, $17, 0
spin $8, $18, 0
nop 
nop #Init motor positions
nop
addi $9, $11, 45
spin $1, $9, 0
nop
addi $9, $13, -45
spin $3, $9, 0
nop
wait 2000
nop
motorLoop:
nop
addi $9, $14, -20 #front left leg up and over
spin $4, $9, 0
nop
wait 250
addi $9, $13, 45
spin $3, $9, 0
nop
wait 250
addi $9, $14, 20
spin $4, $9, 0
nop
wait 250
nop
spin $1, $11, 0 #move all legs back
nop
spin $3, $13, 0
nop
addi $9, $15, 45
spin $5, $9, 0
nop
addi $9, $17, 45
spin $7, $9, 0
nop
wait 250
nop
addi $9, $18, -20 #back right leg up and over
spin $8, $9, 0
nop
wait 250
addi $9, $17, -45
spin $7, $9, 0
nop
wait 250
addi $9, $18, 20
spin $8, $9, 0
nop
wait 250
nop
addi $9, $16, -20 #front right leg up and over
spin $6, $9, 0
nop
wait 250
addi $9, $15, -45
spin $5, $9, 0
nop
wait 250
addi $9, $16, 20
spin $6, $9, 0
nop
wait 250
nop
addi $9, $11, -45 #move all legs back
spin $1, $9, 0 
nop
addi $9, $13, -45
spin $3, $9, 0
nop
spin $5, $9, 0
nop
spin $7, $9, 0
nop
wait 250
nop
addi $9, $12, -20 #back left leg up and over
spin $2, $9, 0
nop
wait 250
addi $9, $11, 45
spin $1, $9, 0
nop
wait 250
addi $9, $12, 20
spin $2, $9, 0
nop
wait 250
j motorLoop