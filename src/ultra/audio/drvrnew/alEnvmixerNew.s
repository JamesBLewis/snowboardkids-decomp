nonmatching alEnvmixerNew, 0xA4

glabel alEnvmixerNew
    addiu      $sp, $sp, -0x20
    sw         $a1, 0x24($sp)
    sw         $ra, 0x1C($sp)
    lui        $a1, %hi(alEnvmixerPull)
    lui        $a2, %hi(alEnvmixerParam)
    addiu      $a2, $a2, %lo(alEnvmixerParam)
    addiu      $a1, $a1, %lo(alEnvmixerPull)
    sw         $a0, 0x20($sp)
    jal        alFilterNew
     addiu     $a3, $zero, 0x4
    addiu      $t6, $zero, 0x50
    sw         $t6, 0x10($sp)
    or         $a0, $zero, $zero
    or         $a1, $zero, $zero
    lw         $a2, 0x24($sp)
    jal        alHeapDBAlloc
     addiu     $a3, $zero, 0x1
    lw         $t0, 0x20($sp)
    addiu      $v1, $zero, 0x1
    sw         $v0, 0x14($t0)
    sw         $v1, 0x38($t0)
    sw         $zero, 0x48($t0)
    sh         $v1, 0x1A($t0)
    sh         $v1, 0x28($t0)
    sh         $v1, 0x2E($t0)
    sh         $v1, 0x1C($t0)
    sh         $v1, 0x1E($t0)
    sh         $zero, 0x20($t0)
    sh         $zero, 0x22($t0)
    sh         $v1, 0x26($t0)
    sh         $zero, 0x24($t0)
    sw         $zero, 0x30($t0)
    sw         $zero, 0x34($t0)
    sh         $zero, 0x18($t0)
    sw         $zero, 0x3C($t0)
    sw         $zero, 0x40($t0)
    sw         $zero, 0x44($t0)
    lw         $ra, 0x1C($sp)
    addiu      $sp, $sp, 0x20
    jr         $ra
     nop
endlabel alEnvmixerNew
