
glabel alRaw16Pull
    /* AD7E4 800ACBE4 27BDFFB0 */  addiu      $sp, $sp, -0x50
    /* AD7E8 800ACBE8 8FA80060 */  lw         $t0, 0x60($sp)
    /* AD7EC 800ACBEC AFB30020 */  sw         $s3, 0x20($sp)
    /* AD7F0 800ACBF0 AFB00014 */  sw         $s0, 0x14($sp)
    /* AD7F4 800ACBF4 00808025 */  or         $s0, $a0, $zero
    /* AD7F8 800ACBF8 00C09825 */  or         $s3, $a2, $zero
    /* AD7FC 800ACBFC AFBF0024 */  sw         $ra, 0x24($sp)
    /* AD800 800ACC00 AFB2001C */  sw         $s2, 0x1C($sp)
    /* AD804 800ACC04 AFB10018 */  sw         $s1, 0x18($sp)
    /* AD808 800ACC08 AFA7005C */  sw         $a3, 0x5C($sp)
    /* AD80C 800ACC0C 00A05025 */  or         $t2, $a1, $zero
    /* AD810 800ACC10 14C00003 */  bnez       $a2, .L800ACC20
    /* AD814 800ACC14 01004825 */   or        $t1, $t0, $zero
    /* AD818 800ACC18 100000D6 */  b          .L800ACF74
    /* AD81C 800ACC1C 01001025 */   or        $v0, $t0, $zero
  .L800ACC20:
    /* AD820 800ACC20 8E020038 */  lw         $v0, 0x38($s0)
    /* AD824 800ACC24 8E030020 */  lw         $v1, 0x20($s0)
    /* AD828 800ACC28 00537021 */  addu       $t6, $v0, $s3
    /* AD82C 800ACC2C 006E082B */  sltu       $at, $v1, $t6
    /* AD830 800ACC30 50200084 */  beql       $at, $zero, .L800ACE44
    /* AD834 800ACC34 8E020028 */   lw        $v0, 0x28($s0)
    /* AD838 800ACC38 8E0F0024 */  lw         $t7, 0x24($s0)
    /* AD83C 800ACC3C 00629023 */  subu       $s2, $v1, $v0
    /* AD840 800ACC40 51E00080 */  beql       $t7, $zero, .L800ACE44
    /* AD844 800ACC44 8E020028 */   lw        $v0, 0x28($s0)
    /* AD848 800ACC48 1A40001E */  blez       $s2, .L800ACCC4
    /* AD84C 800ACC4C 00128840 */   sll       $s1, $s2, 1
    /* AD850 800ACC50 8E040044 */  lw         $a0, 0x44($s0)
    /* AD854 800ACC54 8E060034 */  lw         $a2, 0x34($s0)
    /* AD858 800ACC58 AFAA0054 */  sw         $t2, 0x54($sp)
    /* AD85C 800ACC5C 8E190030 */  lw         $t9, 0x30($s0)
    /* AD860 800ACC60 02202825 */  or         $a1, $s1, $zero
    /* AD864 800ACC64 0320F809 */  jalr       $t9
    /* AD868 800ACC68 00000000 */   nop
    /* AD86C 800ACC6C 8FAA0054 */  lw         $t2, 0x54($sp)
    /* AD870 800ACC70 30460007 */  andi       $a2, $v0, 0x7
    /* AD874 800ACC74 8FA80060 */  lw         $t0, 0x60($sp)
    /* AD878 800ACC78 85580000 */  lh         $t8, 0x0($t2)
    /* AD87C 800ACC7C 02263821 */  addu       $a3, $s1, $a2
    /* AD880 800ACC80 30ED0007 */  andi       $t5, $a3, 0x7
    /* AD884 800ACC84 00ED7023 */  subu       $t6, $a3, $t5
    /* AD888 800ACC88 3C010800 */  lui        $at, (0x8000000 >> 16)
    /* AD88C 800ACC8C 330BFFFF */  andi       $t3, $t8, 0xFFFF
    /* AD890 800ACC90 01616025 */  or         $t4, $t3, $at
    /* AD894 800ACC94 25CF0008 */  addiu      $t7, $t6, 0x8
    /* AD898 800ACC98 25090008 */  addiu      $t1, $t0, 0x8
    /* AD89C 800ACC9C 31F9FFFF */  andi       $t9, $t7, 0xFFFF
    /* AD8A0 800ACCA0 01202025 */  or         $a0, $t1, $zero
    /* AD8A4 800ACCA4 00465823 */  subu       $t3, $v0, $a2
    /* AD8A8 800ACCA8 3C180400 */  lui        $t8, (0x4000000 >> 16)
    /* AD8AC 800ACCAC AD190004 */  sw         $t9, 0x4($t0)
    /* AD8B0 800ACCB0 AD0C0000 */  sw         $t4, 0x0($t0)
    /* AD8B4 800ACCB4 AC8B0004 */  sw         $t3, 0x4($a0)
    /* AD8B8 800ACCB8 AC980000 */  sw         $t8, 0x0($a0)
    /* AD8BC 800ACCBC 10000002 */  b          .L800ACCC8
    /* AD8C0 800ACCC0 25290008 */   addiu     $t1, $t1, 0x8
  .L800ACCC4:
    /* AD8C4 800ACCC4 00003025 */  or         $a2, $zero, $zero
  .L800ACCC8:
    /* AD8C8 800ACCC8 854C0000 */  lh         $t4, 0x0($t2)
    /* AD8CC 800ACCCC 0253082A */  slt        $at, $s2, $s3
    /* AD8D0 800ACCD0 01866821 */  addu       $t5, $t4, $a2
    /* AD8D4 800ACCD4 A54D0000 */  sh         $t5, 0x0($t2)
    /* AD8D8 800ACCD8 8E0E0028 */  lw         $t6, 0x28($s0)
    /* AD8DC 800ACCDC 8E02001C */  lw         $v0, 0x1C($s0)
    /* AD8E0 800ACCE0 8DCF0000 */  lw         $t7, 0x0($t6)
    /* AD8E4 800ACCE4 0002C840 */  sll        $t9, $v0, 1
    /* AD8E8 800ACCE8 AE020038 */  sw         $v0, 0x38($s0)
    /* AD8EC 800ACCEC 01F9C021 */  addu       $t8, $t7, $t9
    /* AD8F0 800ACCF0 AE180044 */  sw         $t8, 0x44($s0)
    /* AD8F4 800ACCF4 10200049 */  beqz       $at, .L800ACE1C
    /* AD8F8 800ACCF8 85480000 */   lh        $t0, 0x0($t2)
    /* AD8FC 800ACCFC 8E020024 */  lw         $v0, 0x24($s0)
  .L800ACD00:
    /* AD900 800ACD00 2401FFFF */  addiu      $at, $zero, -0x1
    /* AD904 800ACD04 01114021 */  addu       $t0, $t0, $s1
    /* AD908 800ACD08 10410004 */  beq        $v0, $at, .L800ACD1C
    /* AD90C 800ACD0C 02729823 */   subu      $s3, $s3, $s2
    /* AD910 800ACD10 10400002 */  beqz       $v0, .L800ACD1C
    /* AD914 800ACD14 244BFFFF */   addiu     $t3, $v0, -0x1
    /* AD918 800ACD18 AE0B0024 */  sw         $t3, 0x24($s0)
  .L800ACD1C:
    /* AD91C 800ACD1C 8E0C0020 */  lw         $t4, 0x20($s0)
    /* AD920 800ACD20 8E0D001C */  lw         $t5, 0x1C($s0)
    /* AD924 800ACD24 018D1023 */  subu       $v0, $t4, $t5
    /* AD928 800ACD28 0262082B */  sltu       $at, $s3, $v0
    /* AD92C 800ACD2C 10200003 */  beqz       $at, .L800ACD3C
    /* AD930 800ACD30 00409025 */   or        $s2, $v0, $zero
    /* AD934 800ACD34 10000001 */  b          .L800ACD3C
    /* AD938 800ACD38 02609025 */   or        $s2, $s3, $zero
  .L800ACD3C:
    /* AD93C 800ACD3C 8E040044 */  lw         $a0, 0x44($s0)
    /* AD940 800ACD40 8E060034 */  lw         $a2, 0x34($s0)
    /* AD944 800ACD44 AFA9004C */  sw         $t1, 0x4C($sp)
    /* AD948 800ACD48 AFA8002C */  sw         $t0, 0x2C($sp)
    /* AD94C 800ACD4C 8E190030 */  lw         $t9, 0x30($s0)
    /* AD950 800ACD50 00128840 */  sll        $s1, $s2, 1
    /* AD954 800ACD54 02202825 */  or         $a1, $s1, $zero
    /* AD958 800ACD58 0320F809 */  jalr       $t9
    /* AD95C 800ACD5C 00000000 */   nop
    /* AD960 800ACD60 8FA8002C */  lw         $t0, 0x2C($sp)
    /* AD964 800ACD64 30450007 */  andi       $a1, $v0, 0x7
    /* AD968 800ACD68 8FA9004C */  lw         $t1, 0x4C($sp)
    /* AD96C 800ACD6C 31030007 */  andi       $v1, $t0, 0x7
    /* AD970 800ACD70 10600004 */  beqz       $v1, .L800ACD84
    /* AD974 800ACD74 02253821 */   addu      $a3, $s1, $a1
    /* AD978 800ACD78 240E0008 */  addiu      $t6, $zero, 0x8
    /* AD97C 800ACD7C 10000002 */  b          .L800ACD88
    /* AD980 800ACD80 01C33023 */   subu      $a2, $t6, $v1
  .L800ACD84:
    /* AD984 800ACD84 00003025 */  or         $a2, $zero, $zero
  .L800ACD88:
    /* AD988 800ACD88 01067821 */  addu       $t7, $t0, $a2
    /* AD98C 800ACD8C 30EC0007 */  andi       $t4, $a3, 0x7
    /* AD990 800ACD90 00EC6823 */  subu       $t5, $a3, $t4
    /* AD994 800ACD94 31F8FFFF */  andi       $t8, $t7, 0xFFFF
    /* AD998 800ACD98 01201825 */  or         $v1, $t1, $zero
    /* AD99C 800ACD9C 3C010800 */  lui        $at, (0x8000000 >> 16)
    /* AD9A0 800ACDA0 03015825 */  or         $t3, $t8, $at
    /* AD9A4 800ACDA4 25290008 */  addiu      $t1, $t1, 0x8
    /* AD9A8 800ACDA8 25B90008 */  addiu      $t9, $t5, 0x8
    /* AD9AC 800ACDAC 332EFFFF */  andi       $t6, $t9, 0xFFFF
    /* AD9B0 800ACDB0 01202025 */  or         $a0, $t1, $zero
    /* AD9B4 800ACDB4 AC6E0004 */  sw         $t6, 0x4($v1)
    /* AD9B8 800ACDB8 AC6B0000 */  sw         $t3, 0x0($v1)
    /* AD9BC 800ACDBC 0045C023 */  subu       $t8, $v0, $a1
    /* AD9C0 800ACDC0 3C0F0400 */  lui        $t7, (0x4000000 >> 16)
    /* AD9C4 800ACDC4 AC8F0000 */  sw         $t7, 0x0($a0)
    /* AD9C8 800ACDC8 AC980004 */  sw         $t8, 0x4($a0)
    /* AD9CC 800ACDCC 14A00002 */  bnez       $a1, .L800ACDD8
    /* AD9D0 800ACDD0 25290008 */   addiu     $t1, $t1, 0x8
    /* AD9D4 800ACDD4 10C0000E */  beqz       $a2, .L800ACE10
  .L800ACDD8:
    /* AD9D8 800ACDD8 01055821 */   addu      $t3, $t0, $a1
    /* AD9DC 800ACDDC 3C0100FF */  lui        $at, (0xFFFFFF >> 16)
    /* AD9E0 800ACDE0 3421FFFF */  ori        $at, $at, (0xFFFFFF & 0xFFFF)
    /* AD9E4 800ACDE4 01666021 */  addu       $t4, $t3, $a2
    /* AD9E8 800ACDE8 01816824 */  and        $t5, $t4, $at
    /* AD9EC 800ACDEC 01201025 */  or         $v0, $t1, $zero
    /* AD9F0 800ACDF0 3C010A00 */  lui        $at, (0xA000000 >> 16)
    /* AD9F4 800ACDF4 00087C00 */  sll        $t7, $t0, 16
    /* AD9F8 800ACDF8 3238FFFF */  andi       $t8, $s1, 0xFFFF
    /* AD9FC 800ACDFC 01F85825 */  or         $t3, $t7, $t8
    /* ADA00 800ACE00 01A1C825 */  or         $t9, $t5, $at
    /* ADA04 800ACE04 AC590000 */  sw         $t9, 0x0($v0)
    /* ADA08 800ACE08 AC4B0004 */  sw         $t3, 0x4($v0)
    /* ADA0C 800ACE0C 25290008 */  addiu      $t1, $t1, 0x8
  .L800ACE10:
    /* ADA10 800ACE10 0253082A */  slt        $at, $s2, $s3
    /* ADA14 800ACE14 5420FFBA */  bnel       $at, $zero, .L800ACD00
    /* ADA18 800ACE18 8E020024 */   lw        $v0, 0x24($s0)
  .L800ACE1C:
    /* ADA1C 800ACE1C 8E0C0038 */  lw         $t4, 0x38($s0)
    /* ADA20 800ACE20 8E190044 */  lw         $t9, 0x44($s0)
    /* ADA24 800ACE24 00137040 */  sll        $t6, $s3, 1
    /* ADA28 800ACE28 01936821 */  addu       $t5, $t4, $s3
    /* ADA2C 800ACE2C 032E7821 */  addu       $t7, $t9, $t6
    /* ADA30 800ACE30 AE0D0038 */  sw         $t5, 0x38($s0)
    /* ADA34 800ACE34 AE0F0044 */  sw         $t7, 0x44($s0)
    /* ADA38 800ACE38 1000004E */  b          .L800ACF74
    /* ADA3C 800ACE3C 01201025 */   or        $v0, $t1, $zero
    /* ADA40 800ACE40 8E020028 */  lw         $v0, 0x28($s0)
  .L800ACE44:
    /* ADA44 800ACE44 8E040044 */  lw         $a0, 0x44($s0)
    /* ADA48 800ACE48 00138840 */  sll        $s1, $s3, 1
    /* ADA4C 800ACE4C 8C580000 */  lw         $t8, 0x0($v0)
    /* ADA50 800ACE50 8C4C0004 */  lw         $t4, 0x4($v0)
    /* ADA54 800ACE54 00911821 */  addu       $v1, $a0, $s1
    /* ADA58 800ACE58 00785823 */  subu       $t3, $v1, $t8
    /* ADA5C 800ACE5C 016C9023 */  subu       $s2, $t3, $t4
    /* ADA60 800ACE60 06430003 */  bgezl      $s2, .L800ACE70
    /* ADA64 800ACE64 0232082A */   slt       $at, $s1, $s2
    /* ADA68 800ACE68 00009025 */  or         $s2, $zero, $zero
    /* ADA6C 800ACE6C 0232082A */  slt        $at, $s1, $s2
  .L800ACE70:
    /* ADA70 800ACE70 50200003 */  beql       $at, $zero, .L800ACE80
    /* ADA74 800ACE74 0251082A */   slt       $at, $s2, $s1
    /* ADA78 800ACE78 02209025 */  or         $s2, $s1, $zero
    /* ADA7C 800ACE7C 0251082A */  slt        $at, $s2, $s1
  .L800ACE80:
    /* ADA80 800ACE80 5020002C */  beql       $at, $zero, .L800ACF34
    /* ADA84 800ACE84 AE030044 */   sw        $v1, 0x44($s0)
    /* ADA88 800ACE88 1A60001F */  blez       $s3, .L800ACF08
    /* ADA8C 800ACE8C 00003025 */   or        $a2, $zero, $zero
    /* ADA90 800ACE90 8E060034 */  lw         $a2, 0x34($s0)
    /* ADA94 800ACE94 02322823 */  subu       $a1, $s1, $s2
    /* ADA98 800ACE98 AFA50048 */  sw         $a1, 0x48($sp)
    /* ADA9C 800ACE9C AFAA0054 */  sw         $t2, 0x54($sp)
    /* ADAA0 800ACEA0 8E190030 */  lw         $t9, 0x30($s0)
    /* ADAA4 800ACEA4 0320F809 */  jalr       $t9
    /* ADAA8 800ACEA8 00000000 */   nop
    /* ADAAC 800ACEAC 8FAA0054 */  lw         $t2, 0x54($sp)
    /* ADAB0 800ACEB0 8FA70048 */  lw         $a3, 0x48($sp)
    /* ADAB4 800ACEB4 30460007 */  andi       $a2, $v0, 0x7
    /* ADAB8 800ACEB8 854D0000 */  lh         $t5, 0x0($t2)
    /* ADABC 800ACEBC 8FA80060 */  lw         $t0, 0x60($sp)
    /* ADAC0 800ACEC0 00E63821 */  addu       $a3, $a3, $a2
    /* ADAC4 800ACEC4 30F80007 */  andi       $t8, $a3, 0x7
    /* ADAC8 800ACEC8 00F85823 */  subu       $t3, $a3, $t8
    /* ADACC 800ACECC 3C010800 */  lui        $at, (0x8000000 >> 16)
    /* ADAD0 800ACED0 31AEFFFF */  andi       $t6, $t5, 0xFFFF
    /* ADAD4 800ACED4 01C17825 */  or         $t7, $t6, $at
    /* ADAD8 800ACED8 256C0008 */  addiu      $t4, $t3, 0x8
    /* ADADC 800ACEDC 25090008 */  addiu      $t1, $t0, 0x8
    /* ADAE0 800ACEE0 3199FFFF */  andi       $t9, $t4, 0xFFFF
    /* ADAE4 800ACEE4 01202025 */  or         $a0, $t1, $zero
    /* ADAE8 800ACEE8 00467023 */  subu       $t6, $v0, $a2
    /* ADAEC 800ACEEC 3C0D0400 */  lui        $t5, (0x4000000 >> 16)
    /* ADAF0 800ACEF0 AD190004 */  sw         $t9, 0x4($t0)
    /* ADAF4 800ACEF4 AD0F0000 */  sw         $t7, 0x0($t0)
    /* ADAF8 800ACEF8 AC8E0004 */  sw         $t6, 0x4($a0)
    /* ADAFC 800ACEFC AC8D0000 */  sw         $t5, 0x0($a0)
    /* ADB00 800ACF00 10000001 */  b          .L800ACF08
    /* ADB04 800ACF04 25290008 */   addiu     $t1, $t1, 0x8
  .L800ACF08:
    /* ADB08 800ACF08 854F0000 */  lh         $t7, 0x0($t2)
    /* ADB0C 800ACF0C 01E6C021 */  addu       $t8, $t7, $a2
    /* ADB10 800ACF10 A5580000 */  sh         $t8, 0x0($t2)
    /* ADB14 800ACF14 8E0B0038 */  lw         $t3, 0x38($s0)
    /* ADB18 800ACF18 8E190044 */  lw         $t9, 0x44($s0)
    /* ADB1C 800ACF1C 01736021 */  addu       $t4, $t3, $s3
    /* ADB20 800ACF20 03316821 */  addu       $t5, $t9, $s1
    /* ADB24 800ACF24 AE0C0038 */  sw         $t4, 0x38($s0)
    /* ADB28 800ACF28 10000002 */  b          .L800ACF34
    /* ADB2C 800ACF2C AE0D0044 */   sw        $t5, 0x44($s0)
    /* ADB30 800ACF30 AE030044 */  sw         $v1, 0x44($s0)
  .L800ACF34:
    /* ADB34 800ACF34 1240000E */  beqz       $s2, .L800ACF70
    /* ADB38 800ACF38 02321823 */   subu      $v1, $s1, $s2
    /* ADB3C 800ACF3C 04610002 */  bgez       $v1, .L800ACF48
    /* ADB40 800ACF40 01201025 */   or        $v0, $t1, $zero
    /* ADB44 800ACF44 00001825 */  or         $v1, $zero, $zero
  .L800ACF48:
    /* ADB48 800ACF48 854E0000 */  lh         $t6, 0x0($t2)
    /* ADB4C 800ACF4C 3C0100FF */  lui        $at, (0xFFFFFF >> 16)
    /* ADB50 800ACF50 3421FFFF */  ori        $at, $at, (0xFFFFFF & 0xFFFF)
    /* ADB54 800ACF54 01C37821 */  addu       $t7, $t6, $v1
    /* ADB58 800ACF58 01E1C024 */  and        $t8, $t7, $at
    /* ADB5C 800ACF5C 3C010200 */  lui        $at, (0x2000000 >> 16)
    /* ADB60 800ACF60 03015825 */  or         $t3, $t8, $at
    /* ADB64 800ACF64 AC4B0000 */  sw         $t3, 0x0($v0)
    /* ADB68 800ACF68 AC520004 */  sw         $s2, 0x4($v0)
    /* ADB6C 800ACF6C 25290008 */  addiu      $t1, $t1, 0x8
  .L800ACF70:
    /* ADB70 800ACF70 01201025 */  or         $v0, $t1, $zero
  .L800ACF74:
    /* ADB74 800ACF74 8FBF0024 */  lw         $ra, 0x24($sp)
    /* ADB78 800ACF78 8FB00014 */  lw         $s0, 0x14($sp)
    /* ADB7C 800ACF7C 8FB10018 */  lw         $s1, 0x18($sp)
    /* ADB80 800ACF80 8FB2001C */  lw         $s2, 0x1C($sp)
    /* ADB84 800ACF84 8FB30020 */  lw         $s3, 0x20($sp)
    /* ADB88 800ACF88 03E00008 */  jr         $ra
    /* ADB8C 800ACF8C 27BD0050 */   addiu     $sp, $sp, 0x50
endlabel alRaw16Pull
