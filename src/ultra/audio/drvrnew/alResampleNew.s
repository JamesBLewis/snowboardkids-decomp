nonmatching alResampleNew, 0x88

glabel alResampleNew
    addiu      $sp, $sp, -0x20
    sw         $a1, 0x24($sp)
    sw         $ra, 0x1C($sp)
    lui        $a1, %hi(alResamplePull)
    lui        $a2, %hi(alResampleParam)
    addiu      $a2, $a2, %lo(alResampleParam)
    addiu      $a1, $a1, %lo(alResamplePull)
    sw         $a0, 0x20($sp)
    jal        alFilterNew
     addiu     $a3, $zero, 0x1
    addiu      $t6, $zero, 0x20
    sw         $t6, 0x10($sp)
    or         $a0, $zero, $zero
    or         $a1, $zero, $zero
    lw         $a2, 0x24($sp)
    jal        alHeapDBAlloc
     addiu     $a3, $zero, 0x1
    lw         $t0, 0x20($sp)
    lui        $at, (0x3F800000 >> 16)
    mtc1       $zero, $f4
    mtc1       $at, $f6
    addiu      $t7, $zero, 0x1
    sw         $v0, 0x14($t0)
    sw         $t7, 0x24($t0)
    sw         $zero, 0x30($t0)
    sw         $zero, 0x1C($t0)
    sw         $zero, 0x28($t0)
    sw         $zero, 0x2C($t0)
    swc1       $f4, 0x20($t0)
    swc1       $f6, 0x18($t0)
    lw         $ra, 0x1C($sp)
    addiu      $sp, $sp, 0x20
    jr         $ra
     nop
endlabel alResampleNew
