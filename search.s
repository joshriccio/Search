# Performs multiple searches.  Performs a search for each value
# in mainValues.  All searches should find the requested value.
# Uses a 15-element array. This results in all calculations for middle
# having an integer answer.

.data

mainNumValues:
         .word  15
         
mainValues:
         .word    3    # mainValues[0]
         .word    4    # mainValues[1]
         .word    7    # mainValues[2]
         .word    8    # mainValues[3]
         .word   10    # mainValues[4]
         .word   13    # mainValues[5]
         .word   23    # mainValues[6]
         .word   28    # mainValues[7]
         .word   33    # mainValues[8]
         .word   43    # mainValues[9]
         .word   44    # mainValues[10]
         .word   47    # mainValues[11]
         .word   53    # mainValues[12]
         .word   54    # mainValues[13]
         .word   63    # mainValues[14]
         .word   66    # mainValues[15]
         .word   73    # mainValues[16]
         .word  252    # mainValues[17] 
         .word  836    # mainValues[18]
         .word  837    # mainValues[19]
         .word  936    # mainValues[20]
         .word 0x400   # mainValues[21]
         .word 1950    # mainValues[22]
         .word 2012    # mainValues[23]
         .word 3846    # mainValues[24]
         .word 8600    # mainValues[25]

mainNumSearchValues:
         .word 15
mainSearchValues:
         .word    3    # mainSearchValues[0]
         .word    4    # mainSearchValues[1]
         .word    7    # mainSearchValues[2]
         .word    8    # mainSearchValues[3]
         .word   10    # mainSearchValues[4]
         .word   13    # mainSearchValues[5]
         .word   23    # mainSearchValues[6]
         .word   28    # mainSearchValues[7]
         .word   33    # mainSearchValues[8]
         .word   43    # mainSearchValues[9]
         .word   44    # mainSearchValues[10]
         .word   47    # mainSearchValues[11]
         .word   53    # mainSearchValues[12]
         .word   54    # mainSearchValues[13]
         .word   63    # mainSearchValues[14]
         .word   66    # mainSearchValues[15]
         .word   73    # mainSearchValues[16]
         .word  252    # mainSearchValues[17] 
         .word  836    # mainSearchValues[18]
         .word  837    # mainSearchValues[19]
         .word  936    # mainSearchValues[20]
         .word 0x400   # mainSearchValues[21]
         .word 1950    # mainSearchValues[22]
         .word 2012    # mainSearchValues[23]
         .word 3846    # mainSearchValues[24]
         .word 8600    # mainSearchValues[25]

mainResultString:
         .asciiz "main: search returned "
mainDashes:
         .asciiz "----------------------------------------"
mainSearchStr:
         .asciiz "main searching for "
         
.text

main:
         # Function prologue -- even main has one
         addiu $sp, $sp, -24     # allocate stack space -- default of 24
         sw    $ra, 4($sp)       # save return address
         sw    $fp, 0($sp)       # save frame pointer of caller
         addiu $fp, $sp, 20      # setup frame pointer for main

         # for (i = 0; i < mainNumSearchValues; i++)
         #    search(mainValues, searchNum, left=0, right=mainNumValues-1,
         #           level=0)

         addi $s0, $zero, 0      # i = $s0 = 0
         la   $t0, mainNumSearchValues
         lw   $s1, 0($t0)        # $s1 = mainNumSearchValues
         
         la   $s2, mainSearchValues  # $s2 = &mainSearchValues[0]

mainLoopBegin:
         slt  $t0, $s0, $s1      # $t1 = i < mainNumSearchValues
         beq  $t0, $zero, mainLoopEnd

         # Print dashes
         la    $a0, mainDashes
         addi  $v0, $zero, 4
         syscall
         
         # print 1 newline
         addi  $a0, $zero, 1
         jal   newLines
         
         la    $a0, mainSearchStr
         addi  $v0, $zero, 4
         syscall
         
         sll   $t0, $s0, 2       # $t0 = i * 4
         add   $t0, $s2, $t0     # $t0 = &mainSearchValues[i]
         lw    $a0, 0($t0)       # $a1 = mainSearchValues[i], search value
         addi  $v0, $zero, 1
         syscall
         
         # print 2 newlines
         addi  $a0, $zero, 2
         jal   newLines
         
         # Call search(mainValues, searchNum, left=0, right=mainNumValues-1,
         #             level=0)

         addi  $t0, $zero, 1
         sw    $t0, -4($sp)      # 5th arg: level = 1

         la    $t0, mainNumValues
         lw    $a3, 0($t0)
         addi  $a3, $a3, -1      # $a3 = right = mainNumValues - 1

         addi  $a2, $zero, 0     # $a2 = left = 0

         sll   $t0, $s0, 2       # $t0 = i * 4
         add   $t0, $s2, $t0     # $t0 = &mainSearchValues[i]
         lw    $a1, 0($t0)       # $a1 = mainSearchValues[i], search value

         la    $a0, mainValues   # $a0 = &mainValues[0]

         jal   search
         
         addi  $t0, $v0, 0       # copy result to $t0
         
         la    $a0, mainResultString
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $t0, 0       # print the result
         addi  $v0, $zero, 1
         syscall
         
         # Print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

         addi  $s0, $s0, 1       # i++
         j     mainLoopBegin

mainLoopEnd:

         # Print dashes
         la    $a0, mainDashes
         addi  $v0, $zero, 4
         syscall
         
         # print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

mainDone:
         # Epilogue for main -- restore stack & frame pointers
         lw    $ra, 4($sp)       # get return address from stack
         lw    $fp, 0($sp)       # restore frame pointer of caller
         addiu $sp, $sp, 24      # restore stack pointer of caller
         jr    $ra               # return to caller

.data
newLinesStr:
         .asciiz "\n"
.text
newLines:
         # Function prologue
         addiu $sp, $sp, -24     # allocate stack space -- default of 24
         sw    $a0, 8($sp)       # save $a0 = number of newlines to print
         sw    $ra, 4($sp)       # save return address
         sw    $fp, 0($sp)       # save frame pointer of caller
         addiu $fp, $sp, 20      # setup frame pointer for newLines

         # for (i = 0; i < numNewLines; i++)
         #    print newLinesStr
         addi  $t0, $zero, 0     # $t0 = i = 0
         addi  $t1, $a0, 0       # $t1 = number of newlines to print
         la    $a0, newLinesStr

newLinesLoopBegin:
         slt   $t2, $t0, $t1     # $t2 = i < numNewLines
         beq   $t2, $zero, newLinesLoopEnd

         addi  $v0, $zero, 4
         syscall

         addi  $t0, $t0, 1       # i++
         j     newLinesLoopBegin

newLinesLoopEnd:
         # Epilogue for newLines -- restore stack & frame pointers and return
         lw    $ra, 4($sp)       # get return address from stack
         lw    $fp, 0($sp)       # restore frame pointer of caller
         addiu $sp, $sp, 24      # restore stack pointer of caller
         jr    $ra               # return to caller

# Witten by Joshua Riccio

.data
searchlevel:
         .asciiz "search level "
searchleft:
         .asciiz "left "
searchright:
         .asciiz "right "
searchcomma:
         .asciiz ", "
searchmakingrecursive:
         .asciiz " making recursive call"
searchlevelfound:
         .asciiz " found number in location "
searchreturning:
         .asciiz " done, returning "
searchnotfoundarray:
         .asciiz " did not find number in array"

.text
search:
         # Function prologue
         addiu $sp, $sp, -80     # allocate stack space -- default of 24
         sw    $fp, 0($sp)       # save frame pointer of caller
         sw    $ra, 4($sp)       # save return address
         sw    $a0, 8($sp)       # save $a0 = address of element zero of the array of values
         sw    $a1, 12($sp)      # save $a1 = value to search for
         sw    $a2, 16($sp)      # save $a2 = left index
         sw    $a3, 20($sp)      # save $a3 = right index
         sw    $s0, 24($sp)      # save $s0 = left value
         sw    $s1, 28($sp)      # save $s1 = right value
         sw    $s2, 32($sp)      # save $s2 = middle value
         sw    $s3, 36($sp)      # save $s3
         sw    $s4, 40($sp)      # save $s4
         sw    $s6, 44($sp)      # save $s4
         sw    $s7, 48($sp)      # save $s4
         sw    $s5, 52($sp)        
         lw    $s5, 76($sp)      # load $s5 = index
         addiu $fp, $sp, 76      # setup frame pointer for search

         lw    $s0, 16($sp)
         lw    $s1, 20($sp)

         add   $s2, $s0, $s1     # add left + right
         addi  $s3, $zero, 2     # store 2 in $s3
         div   $s2, $s3          # left+right / 2 = middle
         mflo  $s2               # store middle in $s2
         sw    $s2, 56($sp)      # save middle at 56

         #load address of first element of array into $s3
         lw    $s3, 8($sp)
         addi  $s4, $zero, 4     # load 4 into $s4
         mult  $s2, $s4          # middle * 4 = (compute index offset)
         mflo  $s4               # store offset in $s4

         add   $s3, $s3, $s4     # $s3 = address of middle
         lw    $s3, 0($s3)       # $s3 = value at middle

         # if middle = search value, goto done
         beq $s3, $a1, searchdonefound
         j searchskip

searchdonefound:

         # print level
         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchleft
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 16($sp)
         addi  $a0, $s6, 0       # print the left
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchright
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 20($sp)
         addi  $a0, $s6, 0       # print the right
         addi  $v0, $zero, 1
         syscall

         #print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

         # print level
         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchlevelfound
         addi  $v0, $zero, 4
         syscall

         lw $s6, 56($sp)
         add  $a0, $zero, $s6       # print the index
         addi  $v0, $zero, 1
         syscall

         #print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

         add   $s7, $zero, $s2   #load middle value into $s7 for return

         j searchdone

searchskip:
         # if right < left, $s4 = 1, else 0
         slt $s4, $s1, $s0
         bne $s4, $zero, searchnotfoundprint
         j searchskipb

searchnotfoundprint:
         # print level
         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchleft
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 16($sp)
         addi  $a0, $s6, 0       # print the left
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchright
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 20($sp)
         addi  $a0, $s6, 0       # print the right
         addi  $v0, $zero, 1
         syscall

         #print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         lw $s6, 76($sp)
         add  $a0, $zero, $s6       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchnotfoundarray
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $zero, 1
         jal   newLines

         j searchdonenotfound

searchskipb:
         # if value at middle > search value, $s4 = 1, else 0
         slt $s4, $a1, $s3
         bne $s4, $zero, searchlessthan
         j searchgreaterthan

searchlessthan:
         # $s1 = middle - 1
         addi $s1, $s2, -1

         j searchrecursive

searchgreaterthan:
         # $s0 = middle + 1
         addi $s0, $s2, 1

searchrecursive:
         # print level
         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchleft
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 16($sp)
         addi  $a0, $s6, 0       # print the left
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchcomma
         addi  $v0, $zero, 4
         syscall

         la    $a0, searchright
         addi  $v0, $zero, 4
         syscall

         lw    $s6, 20($sp)
         addi  $a0, $s6, 0       # print the right
         addi  $v0, $zero, 1
         syscall

         #print 1 newline
         addi  $a0, $zero, 1
         jal   newLines

         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchmakingrecursive
         addi  $v0, $zero, 4
         syscall

         #print 2 newline
         addi  $a0, $zero, 2
         jal   newLines

         # put parameters in registers to print each stat
         lw    $s6, 8($sp)
         add   $a0, $zero, $s6
         lw    $s6, 12($sp)
         add   $a1, $zero, $s6
         add   $a2, $zero, $s0
         add   $a3, $zero, $s1
         addi  $s5, $s5, 1
         sw    $s5, -4($sp)      #put value onto stack for 5th arg 
         jal   search

         add $s7, $zero, $v0

         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchreturning
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s7, 0       # print returning value
         addi  $v0, $zero, 1
         syscall

         #print 2 newline
         addi  $a0, $zero, 2
         jal   newLines

         j searchdone

searchdonenotfound:
         addi  $v0, $zero, -1    #load -1 into $v0 for return
         add   $s7, $zero, -1

         addi  $s6, $zero, 1
         lw    $s5, 76($sp)
         bne   $s6, $s5, searchfinal

         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchreturning
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s7, 0       # print returning value
         addi  $v0, $zero, 1
         syscall

         #print 2 newline
         addi  $a0, $zero, 2
         jal   newLines

         j searchfinal

searchdone:
         addi  $s6, $zero, 1
         lw    $s5, 76($sp)
         bne   $s6, $s5, searchfinal

         la    $a0, searchlevel
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s5, 0       # print the level
         addi  $v0, $zero, 1
         syscall

         la    $a0, searchreturning
         addi  $v0, $zero, 4
         syscall

         addi  $a0, $s7, 0       # print returning value
         addi  $v0, $zero, 1
         syscall

         #print 2 newline
         addi  $a0, $zero, 2
         jal   newLines

searchfinal:
         add   $v0, $zero, $s7   #load middle value into $v0 for return

         # Epilogue for search -- restore stack & frame pointers and return
         lw    $fp, 0($sp)       # restore frame pointer of caller
         lw    $ra, 4($sp)       # get return address from stack
         lw    $s0, 24($sp)
         lw    $s1, 28($sp) 
         lw    $s2, 32($sp)
         lw    $s3, 36($sp)
         lw    $s4, 40($sp) 
         lw    $s6, 44($sp)
         lw    $s7, 48($sp)  
         lw    $s5, 52($sp)       
         addiu $sp, $sp, 80      # restore stack pointer of caller
         jr    $ra               # return to caller
