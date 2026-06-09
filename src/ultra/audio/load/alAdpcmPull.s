
glabel alAdpcmPull
    /* ADCBC 800AD0BC 27BDFF50 */  addiu      $sp, $sp, -0xB0
    /* ADCC0 800AD0C0 AFB70044 */  sw         $s7, 0x44($sp)
    /* ADCC4 800AD0C4 AFA700BC */  sw         $a3, 0xBC($sp)
    /* ADCC8 800AD0C8 00A03825 */  or         $a3, $a1, $zero
    /* ADCCC 800AD0CC 0080B825 */  or         $s7, $a0, $zero
    /* ADCD0 800AD0D0 AFBF004C */  sw         $ra, 0x4C($sp)
    /* ADCD4 800AD0D4 AFBE0048 */  sw         $fp, 0x48($sp)
    /* ADCD8 800AD0D8 AFB60040 */  sw         $s6, 0x40($sp)
    /* ADCDC 800AD0DC AFB5003C */  sw         $s5, 0x3C($sp)
    /* ADCE0 800AD0E0 AFB40038 */  sw         $s4, 0x38($sp)
    /* ADCE4 800AD0E4 AFB30034 */  sw         $s3, 0x34($sp)
    /* ADCE8 800AD0E8 AFB20030 */  sw         $s2, 0x30($sp)
    /* ADCEC 800AD0EC AFB1002C */  sw         $s1, 0x2C($sp)
    /* ADCF0 800AD0F0 AFB00028 */  sw         $s0, 0x28($sp)
    /* ADCF4 800AD0F4 AFA500B4 */  sw         $a1, 0xB4($sp)
    /* ADCF8 800AD0F8 00C04025 */  or         $t0, $a2, $zero
    /* ADCFC 800AD0FC 14C00003 */  bnez       $a2, .L800AD10C
    /* ADD00 800AD100 00006825 */   or        $t5, $zero, $zero
    /* ADD04 800AD104 10000109 */  b          .L800AD52C
    /* ADD08 800AD108 8FA200C0 */   lw        $v0, 0xC0($sp)
  .L800AD10C:
    /* ADD0C 800AD10C 8EEE002C */  lw         $t6, 0x2C($s7)
    /* ADD10 800AD110 3C0100FF */  lui        $at, (0xFFFFFF >> 16)
    /* ADD14 800AD114 3421FFFF */  ori        $at, $at, (0xFFFFFF & 0xFFFF)
    /* ADD18 800AD118 8FA500C0 */  lw         $a1, 0xC0($sp)
    /* ADD1C 800AD11C 01C17824 */  and        $t7, $t6, $at
    /* ADD20 800AD120 3C010B00 */  lui        $at, (0xB000000 >> 16)
    /* ADD24 800AD124 01E1C025 */  or         $t8, $t7, $at
    /* ADD28 800AD128 ACB80000 */  sw         $t8, 0x0($a1)
    /* ADD2C 800AD12C 8EF90028 */  lw         $t9, 0x28($s7)
    /* ADD30 800AD130 3C011FFF */  lui        $at, (0x1FFFFFFF >> 16)
    /* ADD34 800AD134 3421FFFF */  ori        $at, $at, (0x1FFFFFFF & 0xFFFF)
    /* ADD38 800AD138 8F2E0010 */  lw         $t6, 0x10($t9)
    /* ADD3C 800AD13C 24AA0008 */  addiu      $t2, $a1, 0x8
    /* ADD40 800AD140 00003025 */  or         $a2, $zero, $zero
    /* ADD44 800AD144 25CF0008 */  addiu      $t7, $t6, 0x8
    /* ADD48 800AD148 01E1C024 */  and        $t8, $t7, $at
    /* ADD4C 800AD14C ACB80004 */  sw         $t8, 0x4($a1)
    /* ADD50 800AD150 8EE30038 */  lw         $v1, 0x38($s7)
    /* ADD54 800AD154 8EE40020 */  lw         $a0, 0x20($s7)
    /* ADD58 800AD158 01002825 */  or         $a1, $t0, $zero
    /* ADD5C 800AD15C 0068C821 */  addu       $t9, $v1, $t0
    /* ADD60 800AD160 0099482B */  sltu       $t1, $a0, $t9
    /* ADD64 800AD164 11200004 */  beqz       $t1, .L800AD178
    /* ADD68 800AD168 240F0010 */   addiu     $t7, $zero, 0x10
    /* ADD6C 800AD16C 8EE90024 */  lw         $t1, 0x24($s7)
    /* ADD70 800AD170 0009702B */  sltu       $t6, $zero, $t1
    /* ADD74 800AD174 01C04825 */  or         $t1, $t6, $zero
  .L800AD178:
    /* ADD78 800AD178 11200003 */  beqz       $t1, .L800AD188
    /* ADD7C 800AD17C 24010009 */   addiu     $at, $zero, 0x9
    /* ADD80 800AD180 10000001 */  b          .L800AD188
    /* ADD84 800AD184 00832823 */   subu      $a1, $a0, $v1
  .L800AD188:
    /* ADD88 800AD188 8EE3003C */  lw         $v1, 0x3C($s7)
    /* ADD8C 800AD18C 01408025 */  or         $s0, $t2, $zero
    /* ADD90 800AD190 02E09025 */  or         $s2, $s7, $zero
    /* ADD94 800AD194 10600003 */  beqz       $v1, .L800AD1A4
    /* ADD98 800AD198 00009825 */   or        $s3, $zero, $zero
    /* ADD9C 800AD19C 10000001 */  b          .L800AD1A4
    /* ADDA0 800AD1A0 01E33023 */   subu      $a2, $t7, $v1
  .L800AD1A4:
    /* ADDA4 800AD1A4 00A62023 */  subu       $a0, $a1, $a2
    /* ADDA8 800AD1A8 04810002 */  bgez       $a0, .L800AD1B4
    /* ADDAC 800AD1AC 00000000 */   nop
    /* ADDB0 800AD1B0 00002025 */  or         $a0, $zero, $zero
  .L800AD1B4:
    /* ADDB4 800AD1B4 11200081 */  beqz       $t1, .L800AD3BC
    /* ADDB8 800AD1B8 249E000F */   addiu     $fp, $a0, 0xF
    /* ADDBC 800AD1BC 249E000F */  addiu      $fp, $a0, 0xF
    /* ADDC0 800AD1C0 001EC103 */  sra        $t8, $fp, 4
    /* ADDC4 800AD1C4 84F50000 */  lh         $s5, 0x0($a3)
    /* ADDC8 800AD1C8 8EF40040 */  lw         $s4, 0x40($s7)
    /* ADDCC 800AD1CC 001848C0 */  sll        $t1, $t8, 3
    /* ADDD0 800AD1D0 01384821 */  addu       $t1, $t1, $t8
    /* ADDD4 800AD1D4 01208825 */  or         $s1, $t1, $zero
    /* ADDD8 800AD1D8 AFA9005C */  sw         $t1, 0x5C($sp)
    /* ADDDC 800AD1DC AFA800B8 */  sw         $t0, 0xB8($sp)
    /* ADDE0 800AD1E0 AFA700B4 */  sw         $a3, 0xB4($sp)
    /* ADDE4 800AD1E4 AFA5008C */  sw         $a1, 0x8C($sp)
    /* ADDE8 800AD1E8 0300F025 */  or         $fp, $t8, $zero
    /* ADDEC 800AD1EC 0C02B3E4 */  jal        _decodeChunk
    /* ADDF0 800AD1F0 0080B025 */   or        $s6, $a0, $zero
    /* ADDF4 800AD1F4 8EE3003C */  lw         $v1, 0x3C($s7)
    /* ADDF8 800AD1F8 8FA5008C */  lw         $a1, 0x8C($sp)
    /* ADDFC 800AD1FC 8FA700B4 */  lw         $a3, 0xB4($sp)
    /* ADE00 800AD200 8FA800B8 */  lw         $t0, 0xB8($sp)
    /* ADE04 800AD204 8FA9005C */  lw         $t1, 0x5C($sp)
    /* ADE08 800AD208 10600006 */  beqz       $v1, .L800AD224
    /* ADE0C 800AD20C 00405025 */   or        $t2, $v0, $zero
    /* ADE10 800AD210 84F90000 */  lh         $t9, 0x0($a3)
    /* ADE14 800AD214 00037040 */  sll        $t6, $v1, 1
    /* ADE18 800AD218 032E7821 */  addu       $t7, $t9, $t6
    /* ADE1C 800AD21C 10000004 */  b          .L800AD230
    /* ADE20 800AD220 A4EF0000 */   sh        $t7, 0x0($a3)
  .L800AD224:
    /* ADE24 800AD224 84F80000 */  lh         $t8, 0x0($a3)
    /* ADE28 800AD228 27190020 */  addiu      $t9, $t8, 0x20
    /* ADE2C 800AD22C A4F90000 */  sh         $t9, 0x0($a3)
  .L800AD230:
    /* ADE30 800AD230 8EE2001C */  lw         $v0, 0x1C($s7)
    /* ADE34 800AD234 8EEF0028 */  lw         $t7, 0x28($s7)
    /* ADE38 800AD238 00A8082A */  slt        $at, $a1, $t0
    /* ADE3C 800AD23C 304E000F */  andi       $t6, $v0, 0xF
    /* ADE40 800AD240 AEEE003C */  sw         $t6, 0x3C($s7)
    /* ADE44 800AD244 8DF80000 */  lw         $t8, 0x0($t7)
    /* ADE48 800AD248 0002C902 */  srl        $t9, $v0, 4
    /* ADE4C 800AD24C 001970C0 */  sll        $t6, $t9, 3
    /* ADE50 800AD250 01D97021 */  addu       $t6, $t6, $t9
    /* ADE54 800AD254 030E7821 */  addu       $t7, $t8, $t6
    /* ADE58 800AD258 25F90009 */  addiu      $t9, $t7, 0x9
    /* ADE5C 800AD25C AEF90044 */  sw         $t9, 0x44($s7)
    /* ADE60 800AD260 AEE20038 */  sw         $v0, 0x38($s7)
    /* ADE64 800AD264 10200049 */  beqz       $at, .L800AD38C
    /* ADE68 800AD268 84E60000 */   lh        $a2, 0x0($a3)
    /* ADE6C 800AD26C 00051840 */  sll        $v1, $a1, 1
  .L800AD270:
    /* ADE70 800AD270 27D80001 */  addiu      $t8, $fp, 0x1
    /* ADE74 800AD274 00187140 */  sll        $t6, $t8, 5
    /* ADE78 800AD278 8EE20024 */  lw         $v0, 0x24($s7)
    /* ADE7C 800AD27C 01C63821 */  addu       $a3, $t6, $a2
    /* ADE80 800AD280 2401FFE0 */  addiu      $at, $zero, -0x20
    /* ADE84 800AD284 00E17824 */  and        $t7, $a3, $at
    /* ADE88 800AD288 2401FFFF */  addiu      $at, $zero, -0x1
    /* ADE8C 800AD28C 01054023 */  subu       $t0, $t0, $a1
    /* ADE90 800AD290 01E03825 */  or         $a3, $t7, $zero
    /* ADE94 800AD294 10410004 */  beq        $v0, $at, .L800AD2A8
    /* ADE98 800AD298 00C33021 */   addu      $a2, $a2, $v1
    /* ADE9C 800AD29C 10400002 */  beqz       $v0, .L800AD2A8
    /* ADEA0 800AD2A0 2459FFFF */   addiu     $t9, $v0, -0x1
    /* ADEA4 800AD2A4 AEF90024 */  sw         $t9, 0x24($s7)
  .L800AD2A8:
    /* ADEA8 800AD2A8 8EF80020 */  lw         $t8, 0x20($s7)
    /* ADEAC 800AD2AC 8EEE001C */  lw         $t6, 0x1C($s7)
    /* ADEB0 800AD2B0 01408025 */  or         $s0, $t2, $zero
    /* ADEB4 800AD2B4 02E09025 */  or         $s2, $s7, $zero
    /* ADEB8 800AD2B8 030E1023 */  subu       $v0, $t8, $t6
    /* ADEBC 800AD2BC 0102082B */  sltu       $at, $t0, $v0
    /* ADEC0 800AD2C0 10200003 */  beqz       $at, .L800AD2D0
    /* ADEC4 800AD2C4 0007AC00 */   sll       $s5, $a3, 16
    /* ADEC8 800AD2C8 10000002 */  b          .L800AD2D4
    /* ADECC 800AD2CC 01002825 */   or        $a1, $t0, $zero
  .L800AD2D0:
    /* ADED0 800AD2D0 00402825 */  or         $a1, $v0, $zero
  .L800AD2D4:
    /* ADED4 800AD2D4 8EEF003C */  lw         $t7, 0x3C($s7)
    /* ADED8 800AD2D8 0015C403 */  sra        $t8, $s5, 16
    /* ADEDC 800AD2DC 0300A825 */  or         $s5, $t8, $zero
    /* ADEE0 800AD2E0 00AF2021 */  addu       $a0, $a1, $t7
    /* ADEE4 800AD2E4 2484FFF0 */  addiu      $a0, $a0, -0x10
    /* ADEE8 800AD2E8 04810002 */  bgez       $a0, .L800AD2F4
    /* ADEEC 800AD2EC 00009825 */   or        $s3, $zero, $zero
    /* ADEF0 800AD2F0 00002025 */  or         $a0, $zero, $zero
  .L800AD2F4:
    /* ADEF4 800AD2F4 8EF40040 */  lw         $s4, 0x40($s7)
    /* ADEF8 800AD2F8 249E000F */  addiu      $fp, $a0, 0xF
    /* ADEFC 800AD2FC 001EC903 */  sra        $t9, $fp, 4
    /* ADF00 800AD300 001948C0 */  sll        $t1, $t9, 3
    /* ADF04 800AD304 01394821 */  addu       $t1, $t1, $t9
    /* ADF08 800AD308 368E0002 */  ori        $t6, $s4, 0x2
    /* ADF0C 800AD30C 01C0A025 */  or         $s4, $t6, $zero
    /* ADF10 800AD310 01208825 */  or         $s1, $t1, $zero
    /* ADF14 800AD314 AFA9005C */  sw         $t1, 0x5C($sp)
    /* ADF18 800AD318 0320F025 */  or         $fp, $t9, $zero
    /* ADF1C 800AD31C AFA800B8 */  sw         $t0, 0xB8($sp)
    /* ADF20 800AD320 AFA70088 */  sw         $a3, 0x88($sp)
    /* ADF24 800AD324 AFA60080 */  sw         $a2, 0x80($sp)
    /* ADF28 800AD328 AFA5008C */  sw         $a1, 0x8C($sp)
    /* ADF2C 800AD32C 0C02B3E4 */  jal        _decodeChunk
    /* ADF30 800AD330 0080B025 */   or        $s6, $a0, $zero
    /* ADF34 800AD334 8EEF003C */  lw         $t7, 0x3C($s7)
    /* ADF38 800AD338 8FA70088 */  lw         $a3, 0x88($sp)
    /* ADF3C 800AD33C 3C0100FF */  lui        $at, (0xFFFFFF >> 16)
    /* ADF40 800AD340 000FC840 */  sll        $t9, $t7, 1
    /* ADF44 800AD344 3421FFFF */  ori        $at, $at, (0xFFFFFF & 0xFFFF)
    /* ADF48 800AD348 0327C021 */  addu       $t8, $t9, $a3
    /* ADF4C 800AD34C 03017024 */  and        $t6, $t8, $at
    /* ADF50 800AD350 8FA5008C */  lw         $a1, 0x8C($sp)
    /* ADF54 800AD354 3C010A00 */  lui        $at, (0xA000000 >> 16)
    /* ADF58 800AD358 8FA60080 */  lw         $a2, 0x80($sp)
    /* ADF5C 800AD35C 01C17825 */  or         $t7, $t6, $at
    /* ADF60 800AD360 8FA800B8 */  lw         $t0, 0xB8($sp)
    /* ADF64 800AD364 8FA9005C */  lw         $t1, 0x5C($sp)
    /* ADF68 800AD368 00051840 */  sll        $v1, $a1, 1
    /* ADF6C 800AD36C 306EFFFF */  andi       $t6, $v1, 0xFFFF
    /* ADF70 800AD370 AC4F0000 */  sw         $t7, 0x0($v0)
    /* ADF74 800AD374 0006C400 */  sll        $t8, $a2, 16
    /* ADF78 800AD378 030E7825 */  or         $t7, $t8, $t6
    /* ADF7C 800AD37C 00A8082A */  slt        $at, $a1, $t0
    /* ADF80 800AD380 AC4F0004 */  sw         $t7, 0x4($v0)
    /* ADF84 800AD384 1420FFBA */  bnez       $at, .L800AD270
    /* ADF88 800AD388 244A0008 */   addiu     $t2, $v0, 0x8
  .L800AD38C:
    /* ADF8C 800AD38C 8EF9003C */  lw         $t9, 0x3C($s7)
    /* ADF90 800AD390 8EEF0038 */  lw         $t7, 0x38($s7)
    /* ADF94 800AD394 01401025 */  or         $v0, $t2, $zero
    /* ADF98 800AD398 0328C021 */  addu       $t8, $t9, $t0
    /* ADF9C 800AD39C 330E000F */  andi       $t6, $t8, 0xF
    /* ADFA0 800AD3A0 8EF80044 */  lw         $t8, 0x44($s7)
    /* ADFA4 800AD3A4 AEEE003C */  sw         $t6, 0x3C($s7)
    /* ADFA8 800AD3A8 01E8C821 */  addu       $t9, $t7, $t0
    /* ADFAC 800AD3AC 03097021 */  addu       $t6, $t8, $t1
    /* ADFB0 800AD3B0 AEF90038 */  sw         $t9, 0x38($s7)
    /* ADFB4 800AD3B4 1000005D */  b          .L800AD52C
    /* ADFB8 800AD3B8 AEEE0044 */   sw        $t6, 0x44($s7)
  .L800AD3BC:
    /* ADFBC 800AD3BC 8EE20028 */  lw         $v0, 0x28($s7)
    /* ADFC0 800AD3C0 001E7903 */  sra        $t7, $fp, 4
    /* ADFC4 800AD3C4 8EF90044 */  lw         $t9, 0x44($s7)
    /* ADFC8 800AD3C8 000F48C0 */  sll        $t1, $t7, 3
    /* ADFCC 800AD3CC 8C580000 */  lw         $t8, 0x0($v0)
    /* ADFD0 800AD3D0 012F4821 */  addu       $t1, $t1, $t7
    /* ADFD4 800AD3D4 01E0F025 */  or         $fp, $t7, $zero
    /* ADFD8 800AD3D8 8C4F0004 */  lw         $t7, 0x4($v0)
    /* ADFDC 800AD3DC 03295821 */  addu       $t3, $t9, $t1
    /* ADFE0 800AD3E0 01787023 */  subu       $t6, $t3, $t8
    /* ADFE4 800AD3E4 01CF1823 */  subu       $v1, $t6, $t7
    /* ADFE8 800AD3E8 04610002 */  bgez       $v1, .L800AD3F4
    /* ADFEC 800AD3EC 001E2900 */   sll       $a1, $fp, 4
    /* ADFF0 800AD3F0 00001825 */  or         $v1, $zero, $zero
  .L800AD3F4:
    /* ADFF4 800AD3F4 0061001A */  div        $zero, $v1, $at
    /* ADFF8 800AD3F8 00001012 */  mflo       $v0
    /* ADFFC 800AD3FC 00022100 */  sll        $a0, $v0, 4
    /* AE000 800AD400 00A66021 */  addu       $t4, $a1, $a2
    /* AE004 800AD404 0184082A */  slt        $at, $t4, $a0
    /* AE008 800AD408 10200002 */  beqz       $at, .L800AD414
    /* AE00C 800AD40C 01408025 */   or        $s0, $t2, $zero
    /* AE010 800AD410 01802025 */  or         $a0, $t4, $zero
  .L800AD414:
    /* AE014 800AD414 3098000F */  andi       $t8, $a0, 0xF
    /* AE018 800AD418 00987023 */  subu       $t6, $a0, $t8
    /* AE01C 800AD41C 01C8082A */  slt        $at, $t6, $t0
    /* AE020 800AD420 1020002B */  beqz       $at, .L800AD4D0
    /* AE024 800AD424 01233023 */   subu      $a2, $t1, $v1
    /* AE028 800AD428 84F50000 */  lh         $s5, 0x0($a3)
    /* AE02C 800AD42C 8EF40040 */  lw         $s4, 0x40($s7)
    /* AE030 800AD430 240D0001 */  addiu      $t5, $zero, 0x1
    /* AE034 800AD434 AFAD007C */  sw         $t5, 0x7C($sp)
    /* AE038 800AD438 AFAC0050 */  sw         $t4, 0x50($sp)
    /* AE03C 800AD43C AFA9005C */  sw         $t1, 0x5C($sp)
    /* AE040 800AD440 AFA800B8 */  sw         $t0, 0xB8($sp)
    /* AE044 800AD444 AFA700B4 */  sw         $a3, 0xB4($sp)
    /* AE048 800AD448 AFA40090 */  sw         $a0, 0x90($sp)
    /* AE04C 800AD44C 02E09025 */  or         $s2, $s7, $zero
    /* AE050 800AD450 00A4B023 */  subu       $s6, $a1, $a0
    /* AE054 800AD454 00C08825 */  or         $s1, $a2, $zero
    /* AE058 800AD458 0C02B3E4 */  jal        _decodeChunk
    /* AE05C 800AD45C 00009825 */   or        $s3, $zero, $zero
    /* AE060 800AD460 8EE3003C */  lw         $v1, 0x3C($s7)
    /* AE064 800AD464 8FA40090 */  lw         $a0, 0x90($sp)
    /* AE068 800AD468 8FA700B4 */  lw         $a3, 0xB4($sp)
    /* AE06C 800AD46C 8FA800B8 */  lw         $t0, 0xB8($sp)
    /* AE070 800AD470 8FA9005C */  lw         $t1, 0x5C($sp)
    /* AE074 800AD474 8FAC0050 */  lw         $t4, 0x50($sp)
    /* AE078 800AD478 8FAD007C */  lw         $t5, 0x7C($sp)
    /* AE07C 800AD47C 10600006 */  beqz       $v1, .L800AD498
    /* AE080 800AD480 00405025 */   or        $t2, $v0, $zero
    /* AE084 800AD484 84EF0000 */  lh         $t7, 0x0($a3)
    /* AE088 800AD488 0003C840 */  sll        $t9, $v1, 1
    /* AE08C 800AD48C 01F9C021 */  addu       $t8, $t7, $t9
    /* AE090 800AD490 10000004 */  b          .L800AD4A4
    /* AE094 800AD494 A4F80000 */   sh        $t8, 0x0($a3)
  .L800AD498:
    /* AE098 800AD498 84EE0000 */  lh         $t6, 0x0($a3)
    /* AE09C 800AD49C 25CF0020 */  addiu      $t7, $t6, 0x20
    /* AE0A0 800AD4A0 A4EF0000 */  sh         $t7, 0x0($a3)
  .L800AD4A4:
    /* AE0A4 800AD4A4 8EF9003C */  lw         $t9, 0x3C($s7)
    /* AE0A8 800AD4A8 8EEF0038 */  lw         $t7, 0x38($s7)
    /* AE0AC 800AD4AC 0328C021 */  addu       $t8, $t9, $t0
    /* AE0B0 800AD4B0 330E000F */  andi       $t6, $t8, 0xF
    /* AE0B4 800AD4B4 8EF80044 */  lw         $t8, 0x44($s7)
    /* AE0B8 800AD4B8 AEEE003C */  sw         $t6, 0x3C($s7)
    /* AE0BC 800AD4BC 01E8C821 */  addu       $t9, $t7, $t0
    /* AE0C0 800AD4C0 03097021 */  addu       $t6, $t8, $t1
    /* AE0C4 800AD4C4 AEF90038 */  sw         $t9, 0x38($s7)
    /* AE0C8 800AD4C8 10000003 */  b          .L800AD4D8
    /* AE0CC 800AD4CC AEEE0044 */   sw        $t6, 0x44($s7)
  .L800AD4D0:
    /* AE0D0 800AD4D0 AEE0003C */  sw         $zero, 0x3C($s7)
    /* AE0D4 800AD4D4 AEEB0044 */  sw         $t3, 0x44($s7)
  .L800AD4D8:
    /* AE0D8 800AD4D8 10800013 */  beqz       $a0, .L800AD528
    /* AE0DC 800AD4DC 01401025 */   or        $v0, $t2, $zero
    /* AE0E0 800AD4E0 11A00005 */  beqz       $t5, .L800AD4F8
    /* AE0E4 800AD4E4 AEE0003C */   sw        $zero, 0x3C($s7)
    /* AE0E8 800AD4E8 01841823 */  subu       $v1, $t4, $a0
    /* AE0EC 800AD4EC 00037840 */  sll        $t7, $v1, 1
    /* AE0F0 800AD4F0 10000002 */  b          .L800AD4FC
    /* AE0F4 800AD4F4 01E01825 */   or        $v1, $t7, $zero
  .L800AD4F8:
    /* AE0F8 800AD4F8 00001825 */  or         $v1, $zero, $zero
  .L800AD4FC:
    /* AE0FC 800AD4FC 84F90000 */  lh         $t9, 0x0($a3)
    /* AE100 800AD500 3C0100FF */  lui        $at, (0xFFFFFF >> 16)
    /* AE104 800AD504 3421FFFF */  ori        $at, $at, (0xFFFFFF & 0xFFFF)
    /* AE108 800AD508 0323C021 */  addu       $t8, $t9, $v1
    /* AE10C 800AD50C 03017024 */  and        $t6, $t8, $at
    /* AE110 800AD510 3C010200 */  lui        $at, (0x2000000 >> 16)
    /* AE114 800AD514 01C17825 */  or         $t7, $t6, $at
    /* AE118 800AD518 0004C840 */  sll        $t9, $a0, 1
    /* AE11C 800AD51C AC590004 */  sw         $t9, 0x4($v0)
    /* AE120 800AD520 AC4F0000 */  sw         $t7, 0x0($v0)
    /* AE124 800AD524 254A0008 */  addiu      $t2, $t2, 0x8
  .L800AD528:
    /* AE128 800AD528 01401025 */  or         $v0, $t2, $zero
  .L800AD52C:
    /* AE12C 800AD52C 8FBF004C */  lw         $ra, 0x4C($sp)
    /* AE130 800AD530 8FB00028 */  lw         $s0, 0x28($sp)
    /* AE134 800AD534 8FB1002C */  lw         $s1, 0x2C($sp)
    /* AE138 800AD538 8FB20030 */  lw         $s2, 0x30($sp)
    /* AE13C 800AD53C 8FB30034 */  lw         $s3, 0x34($sp)
    /* AE140 800AD540 8FB40038 */  lw         $s4, 0x38($sp)
    /* AE144 800AD544 8FB5003C */  lw         $s5, 0x3C($sp)
    /* AE148 800AD548 8FB60040 */  lw         $s6, 0x40($sp)
    /* AE14C 800AD54C 8FB70044 */  lw         $s7, 0x44($sp)
    /* AE150 800AD550 8FBE0048 */  lw         $fp, 0x48($sp)
    /* AE154 800AD554 03E00008 */  jr         $ra
    /* AE158 800AD558 27BD00B0 */   addiu     $sp, $sp, 0xB0
endlabel alAdpcmPull
