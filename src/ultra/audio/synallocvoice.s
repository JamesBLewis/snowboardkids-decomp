.include "macro.inc"

.set noat
.set noreorder
.set gp=64

.section .text, "ax"

glabel _allocatePVoice
    addiu      $sp, $sp, -0x28
    sw         $ra, 0x14($sp)
    sw         $a2, 0x30($sp)
    lw         $a3, 0x14($a0)
    sll        $t6, $a2, 16
    sra        $a2, $t6, 16
    or         $t0, $a0, $zero
    beqz       $a3, .L_allocatePVoice_free
     or        $v1, $zero, $zero
    sw         $a3, 0x0($a1)
    sw         $t0, 0x28($sp)
    sw         $a3, 0x24($sp)
    sw         $zero, 0x1C($sp)
    jal        alUnlink
     or        $a0, $a3, $zero
    lw         $t0, 0x28($sp)
    lw         $a0, 0x24($sp)
    jal        alLink
     addiu     $a1, $t0, 0xC
    b          .L_allocatePVoice_return
     lw        $v1, 0x1C($sp)
.L_allocatePVoice_free:
    lw         $a3, 0x4($t0)
    beqz       $a3, .L_allocatePVoice_steal
     or        $a0, $a3, $zero
    sw         $a3, 0x0($a1)
    sw         $t0, 0x28($sp)
    sw         $a3, 0x24($sp)
    jal        alUnlink
     sw        $v1, 0x1C($sp)
    lw         $t0, 0x28($sp)
    lw         $a0, 0x24($sp)
    jal        alLink
     addiu     $a1, $t0, 0xC
    b          .L_allocatePVoice_return
     lw        $v1, 0x1C($sp)
.L_allocatePVoice_steal:
    lw         $a3, 0xC($t0)
    beql       $a3, $zero, .L_allocatePVoice_epilogue
     lw        $ra, 0x14($sp)
    lw         $t8, 0x8($a3)
.L_allocatePVoice_loop:
    lh         $t9, 0x16($t8)
    slt        $at, $a2, $t9
    bnel       $at, $zero, .L_allocatePVoice_next
     lw        $a3, 0x0($a3)
    lw         $t1, 0xD8($a3)
    bnel       $t1, $zero, .L_allocatePVoice_next
     lw        $a3, 0x0($a3)
    sw         $a3, 0x0($a1)
    lw         $t2, 0x8($a3)
    addiu      $v1, $zero, 1
    lh         $a2, 0x16($t2)
    lw         $a3, 0x0($a3)
.L_allocatePVoice_next:
    bnel       $a3, $zero, .L_allocatePVoice_loop
     lw        $t8, 0x8($a3)
.L_allocatePVoice_return:
    lw         $ra, 0x14($sp)
.L_allocatePVoice_epilogue:
    addiu      $sp, $sp, 0x28
    or         $v0, $v1, $zero
    jr         $ra
     nop
endlabel _allocatePVoice

glabel alSynAllocVoice
    addiu      $sp, $sp, -0x30
    sw         $ra, 0x1C($sp)
    sw         $s0, 0x18($sp)
    sw         $a0, 0x30($sp)
    sw         $zero, 0x2C($sp)
    lh         $t6, 0x0($a2)
    or         $s0, $a1, $zero
    sh         $t6, 0x16($a1)
    lbu        $t7, 0x4($a2)
    sw         $zero, 0xC($a1)
    sh         $t7, 0x1A($a1)
    lh         $t8, 0x2($a2)
    sh         $zero, 0x14($a1)
    sw         $zero, 0x8($a1)
    sh         $t8, 0x18($a1)
    lh         $a2, 0x0($a2)
    lw         $a0, 0x30($sp)
    jal        _allocatePVoice
     addiu     $a1, $sp, 0x2C
    lw         $t9, 0x2C($sp)
    beql       $t9, $zero, .L_alSynAllocVoice_done
     lw        $v0, 0x2C($sp)
    beqz       $v0, .L_alSynAllocVoice_not_stolen
     lw        $a0, 0xC($t9)
    addiu      $t0, $zero, 0x200
    sw         $t0, 0xD8($t9)
    lw         $t1, 0x2C($sp)
    lw         $t2, 0x8($t1)
    sw         $zero, 0x8($t2)
    jal        __allocParam
     sw        $a0, 0x28($sp)
    lw         $t3, 0x30($sp)
    lw         $a0, 0x28($sp)
    addiu      $t5, $zero, 0xB
    lw         $t4, 0x1C($t3)
    sh         $t5, 0x8($v0)
    sw         $zero, 0xC($v0)
    sw         $t4, 0x4($v0)
    lw         $t6, 0x2C($sp)
    addiu      $a1, $zero, 3
    or         $a2, $v0, $zero
    lw         $t7, 0xD8($t6)
    addiu      $t8, $t7, -0x40
    sw         $t8, 0x10($v0)
    lw         $t9, 0x8($a0)
    jalr       $t9
     nop
    jal        __allocParam
     nop
    lw         $a0, 0x28($sp)
    beqz       $v0, .L_alSynAllocVoice_assign_null
     or        $a2, $v0, $zero
    lw         $t0, 0x30($sp)
    lw         $t2, 0x2C($sp)
    addiu      $t5, $zero, 0xF
    lw         $t1, 0x1C($t0)
    lw         $t3, 0xD8($t2)
    sh         $t5, 0x8($v0)
    sw         $zero, 0x0($v0)
    addu       $t4, $t1, $t3
    sw         $t4, 0x4($v0)
    lw         $t9, 0x8($a0)
    addiu      $a1, $zero, 3
    jalr       $t9
     nop
    b          .L_alSynAllocVoice_assign
     lw        $t7, 0x2C($sp)
.L_alSynAllocVoice_not_stolen:
    lw         $t6, 0x2C($sp)
    sw         $zero, 0xD8($t6)
.L_alSynAllocVoice_assign_null:
    lw         $t7, 0x2C($sp)
.L_alSynAllocVoice_assign:
    sw         $s0, 0x8($t7)
    lw         $t8, 0x2C($sp)
    sw         $t8, 0x8($s0)
    lw         $v0, 0x2C($sp)
.L_alSynAllocVoice_done:
    lw         $ra, 0x1C($sp)
    lw         $s0, 0x18($sp)
    sltu       $t0, $zero, $v0
    or         $v0, $t0, $zero
    jr         $ra
     addiu     $sp, $sp, 0x30
endlabel alSynAllocVoice
    nop
    nop
