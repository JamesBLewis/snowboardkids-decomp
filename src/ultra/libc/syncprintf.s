.include "macro.inc"

.set noat
.set noreorder
.set gp=64

.section .text, "ax"

/* Tail of the preceding final-ROM print stub. Keep this chunk 0x10-aligned. */
    sw         $a1, 0x4($sp)
    jr         $ra
     sw        $a2, 0x8($sp)

glabel osSyncPrintf
    sw         $a0, 0x0($sp)
    sw         $a1, 0x4($sp)
    sw         $a2, 0x8($sp)
    jr         $ra
     sw        $a3, 0xC($sp)
endlabel osSyncPrintf

glabel func_80048E60
    lui        $t6, %hi(D_800EC9C2)
    lbu        $t6, %lo(D_800EC9C2)($t6)
    addiu      $at, $zero, 0x2
    bne        $t6, $at, .L80048E7C
     lui       $t7, %hi(D_801124B0)
    jr         $ra
     addiu     $v0, $zero, 0x1
.L80048E7C:
    lb         $t7, %lo(D_801124B0)($t7)
endlabel func_80048E60
