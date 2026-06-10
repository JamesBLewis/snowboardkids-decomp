nonmatching alSynAllocFX, 0x98

glabel alSynAllocFX
    addiu      $sp, $sp, -0x20
    sll        $t0, $a1, 16
    sra        $t6, $t0, 16
    sw         $s1, 0x18($sp)
    sll        $s1, $t6, 2
    sw         $ra, 0x1C($sp)
    sw         $s0, 0x14($sp)
    sw         $a1, 0x24($sp)
    addu       $s1, $s1, $t6
    lw         $t7, 0x34($a0)
    sll        $s1, $s1, 2
    subu       $s1, $s1, $t6
    or         $s0, $a0, $zero
    sll        $s1, $s1, 2
    or         $a1, $a2, $zero
    addu       $a0, $t7, $s1
    addiu      $a0, $a0, 0x20
    jal        alFxNew
     or        $a2, $a3, $zero
    lw         $t8, 0x34($s0)
    addiu      $a1, $zero, 0x1
    addu       $a2, $t8, $s1
    jal        alFxParam
     addiu     $a0, $a2, 0x20
    lw         $t9, 0x34($s0)
    lw         $a0, 0x30($s0)
    addiu      $a1, $zero, 0x2
    addu       $a2, $t9, $s1
    jal        alMainBusParam
     addiu     $a2, $a2, 0x20
    lw         $t2, 0x34($s0)
    lw         $ra, 0x1C($sp)
    lw         $s0, 0x14($sp)
    addu       $v0, $t2, $s1
    lw         $s1, 0x18($sp)
    addiu      $sp, $sp, 0x20
    jr         $ra
     addiu     $v0, $v0, 0x20
endlabel alSynAllocFX
