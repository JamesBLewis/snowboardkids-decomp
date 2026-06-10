.include "macro.inc"

.set noat
.set noreorder
.set gp=64

.section .text, "ax"

/* Delay slot from the previous raw function. Keep this chunk 0x10-aligned. */
    addiu      $sp, $sp, 0x280

glabel ptstart
    jr         $ra
     nop
    jr         $ra
     nop
endlabel ptstart

glabel func_80042574
    addiu      $sp, $sp, -0x40
    sw         $ra, 0x3C($sp)
    sw         $fp, 0x38($sp)
endlabel func_80042574
