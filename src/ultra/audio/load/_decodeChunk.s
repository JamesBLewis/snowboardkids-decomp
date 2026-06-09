
glabel _decodeChunk
    /* ADB90 800ACF90 27BDFFE8 */  addiu      $sp, $sp, -0x18
    /* ADB94 800ACF94 AFB3002C */  sw         $s3, 0x2C($sp)
    /* ADB98 800ACF98 AFB50028 */  sw         $s5, 0x28($sp)
    /* ADB9C 800ACF9C 00137400 */  sll        $t6, $s3, 16
    /* ADBA0 800ACFA0 0015C400 */  sll        $t8, $s5, 16
    /* ADBA4 800ACFA4 0018AC03 */  sra        $s5, $t8, 16
    /* ADBA8 800ACFA8 000E9C03 */  sra        $s3, $t6, 16
    /* ADBAC 800ACFAC 1A20001A */  blez       $s1, .L800AD018
    /* ADBB0 800ACFB0 AFBF0014 */   sw        $ra, 0x14($sp)
    /* ADBB4 800ACFB4 8E590030 */  lw         $t9, 0x30($s2)
    /* ADBB8 800ACFB8 8E440044 */  lw         $a0, 0x44($s2)
    /* ADBBC 800ACFBC 02202825 */  or         $a1, $s1, $zero
    /* ADBC0 800ACFC0 0320F809 */  jalr       $t9
    /* ADBC4 800ACFC4 8E460034 */   lw        $a2, 0x34($s2)
    /* ADBC8 800ACFC8 30460007 */  andi       $a2, $v0, 0x7
    /* ADBCC 800ACFCC 02268821 */  addu       $s1, $s1, $a2
    /* ADBD0 800ACFD0 326EFFFF */  andi       $t6, $s3, 0xFFFF
    /* ADBD4 800ACFD4 3C010800 */  lui        $at, (0x8000000 >> 16)
    /* ADBD8 800ACFD8 01C17825 */  or         $t7, $t6, $at
    /* ADBDC 800ACFDC 32380007 */  andi       $t8, $s1, 0x7
    /* ADBE0 800ACFE0 02002025 */  or         $a0, $s0, $zero
    /* ADBE4 800ACFE4 0238C823 */  subu       $t9, $s1, $t8
    /* ADBE8 800ACFE8 272E0008 */  addiu      $t6, $t9, 0x8
    /* ADBEC 800ACFEC AC8F0000 */  sw         $t7, 0x0($a0)
    /* ADBF0 800ACFF0 26100008 */  addiu      $s0, $s0, 0x8
    /* ADBF4 800ACFF4 31CFFFFF */  andi       $t7, $t6, 0xFFFF
    /* ADBF8 800ACFF8 02002825 */  or         $a1, $s0, $zero
    /* ADBFC 800ACFFC AC8F0004 */  sw         $t7, 0x4($a0)
    /* ADC00 800AD000 0046C823 */  subu       $t9, $v0, $a2
    /* ADC04 800AD004 3C180400 */  lui        $t8, (0x4000000 >> 16)
    /* ADC08 800AD008 ACB80000 */  sw         $t8, 0x0($a1)
    /* ADC0C 800AD00C ACB90004 */  sw         $t9, 0x4($a1)
    /* ADC10 800AD010 10000002 */  b          .L800AD01C
    /* ADC14 800AD014 26100008 */   addiu     $s0, $s0, 0x8
  .L800AD018:
    /* ADC18 800AD018 00003025 */  or         $a2, $zero, $zero
  .L800AD01C:
    /* ADC1C 800AD01C 328E0002 */  andi       $t6, $s4, 0x2
    /* ADC20 800AD020 11C00009 */  beqz       $t6, .L800AD048
    /* ADC24 800AD024 02001025 */   or        $v0, $s0, $zero
    /* ADC28 800AD028 3C0F0F00 */  lui        $t7, (0xF000000 >> 16)
    /* ADC2C 800AD02C AC4F0000 */  sw         $t7, 0x0($v0)
    /* ADC30 800AD030 8E580018 */  lw         $t8, 0x18($s2)
    /* ADC34 800AD034 3C011FFF */  lui        $at, (0x1FFFFFFF >> 16)
    /* ADC38 800AD038 3421FFFF */  ori        $at, $at, (0x1FFFFFFF & 0xFFFF)
    /* ADC3C 800AD03C 0301C824 */  and        $t9, $t8, $at
    /* ADC40 800AD040 AC590004 */  sw         $t9, 0x4($v0)
    /* ADC44 800AD044 26100008 */  addiu      $s0, $s0, 0x8
  .L800AD048:
    /* ADC48 800AD048 02667021 */  addu       $t6, $s3, $a2
    /* ADC4C 800AD04C 31CFFFFF */  andi       $t7, $t6, 0xFFFF
    /* ADC50 800AD050 3C010800 */  lui        $at, (0x8000000 >> 16)
    /* ADC54 800AD054 01E1C025 */  or         $t8, $t7, $at
    /* ADC58 800AD058 02001825 */  or         $v1, $s0, $zero
    /* ADC5C 800AD05C AC780000 */  sw         $t8, 0x0($v1)
    /* ADC60 800AD060 00167840 */  sll        $t7, $s6, 1
    /* ADC64 800AD064 31F8FFFF */  andi       $t8, $t7, 0xFFFF
    /* ADC68 800AD068 00157400 */  sll        $t6, $s5, 16
    /* ADC6C 800AD06C 01D8C825 */  or         $t9, $t6, $t8
    /* ADC70 800AD070 328F00FF */  andi       $t7, $s4, 0xFF
    /* ADC74 800AD074 26100008 */  addiu      $s0, $s0, 0x8
    /* ADC78 800AD078 000F7400 */  sll        $t6, $t7, 16
    /* ADC7C 800AD07C 3C010100 */  lui        $at, (0x1000000 >> 16)
    /* ADC80 800AD080 AC790004 */  sw         $t9, 0x4($v1)
    /* ADC84 800AD084 01C1C025 */  or         $t8, $t6, $at
    /* ADC88 800AD088 02002025 */  or         $a0, $s0, $zero
    /* ADC8C 800AD08C AC980000 */  sw         $t8, 0x0($a0)
    /* ADC90 800AD090 8E590014 */  lw         $t9, 0x14($s2)
    /* ADC94 800AD094 3C011FFF */  lui        $at, (0x1FFFFFFF >> 16)
    /* ADC98 800AD098 3421FFFF */  ori        $at, $at, (0x1FFFFFFF & 0xFFFF)
    /* ADC9C 800AD09C 03217824 */  and        $t7, $t9, $at
    /* ADCA0 800AD0A0 AC8F0004 */  sw         $t7, 0x4($a0)
    /* ADCA4 800AD0A4 AE400040 */  sw         $zero, 0x40($s2)
    /* ADCA8 800AD0A8 8FBF0014 */  lw         $ra, 0x14($sp)
    /* ADCAC 800AD0AC 26100008 */  addiu      $s0, $s0, 0x8
    /* ADCB0 800AD0B0 02001025 */  or         $v0, $s0, $zero
    /* ADCB4 800AD0B4 03E00008 */  jr         $ra
    /* ADCB8 800AD0B8 27BD0018 */   addiu     $sp, $sp, 0x18
endlabel _decodeChunk
