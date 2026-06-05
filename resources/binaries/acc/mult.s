	.arch armv8-a
	.file	"mult.c"
	.text
.Ltext0:
	.file 0 "/home/antonio/U/laburo/PIM-Simulation/resources/binaries/acc" "mult.c"
	.align	2
	.global	fill_matrix
	.type	fill_matrix, %function
fill_matrix:
.LFB6:
	.file 1 "mult.c"
	.loc 1 6 88
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	w2, [sp, 28]
	str	w3, [sp, 24]
	str	w4, [sp, 20]
.LBB2:
	.loc 1 7 13
	str	wzr, [sp, 48]
	.loc 1 7 5
	b	.L2
.L5:
.LBB3:
	.loc 1 8 17
	str	wzr, [sp, 52]
	.loc 1 8 9
	b	.L3
.L4:
	.loc 1 9 34
	ldr	w0, [sp, 48]
	and	w0, w0, 65535
	add	w0, w0, 2
	and	w2, w0, 65535
	.loc 1 9 17
	ldr	w1, [sp, 48]
	ldr	w0, [sp, 24]
	mul	w1, w1, w0
	.loc 1 9 25
	ldr	w0, [sp, 52]
	add	w0, w1, w0
	uxtw	x0, w0
	.loc 1 9 14
	lsl	x0, x0, 1
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	.loc 1 9 34
	sxth	w1, w2
	.loc 1 9 30
	strh	w1, [x0]
	.loc 1 8 35 discriminator 3
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L3:
	.loc 1 8 26 discriminator 1
	ldr	w0, [sp, 52]
	ldr	w1, [sp, 24]
	cmp	w1, w0
	bhi	.L4
.LBE3:
	.loc 1 7 31 discriminator 2
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	str	w0, [sp, 48]
.L2:
	.loc 1 7 22 discriminator 1
	ldr	w0, [sp, 48]
	ldr	w1, [sp, 28]
	cmp	w1, w0
	bhi	.L5
.LBE2:
	.loc 1 13 14
	ldr	x0, [sp, 32]
	str	x0, [sp, 80]
.LBB4:
	.loc 1 14 13
	str	wzr, [sp, 56]
	.loc 1 14 5
	b	.L6
.L17:
.LBB5:
	.loc 1 15 17
	str	wzr, [sp, 60]
	.loc 1 15 9
	b	.L7
.L16:
.LBB6:
	.loc 1 16 21
	str	wzr, [sp, 64]
	.loc 1 16 13
	b	.L8
.L13:
.LBB7:
	.loc 1 17 49
	ldr	x0, [sp, 80]
	.loc 1 17 65
	and	x1, x0, -15361
	.loc 1 17 90
	ldr	w0, [sp, 64]
	lsl	w0, w0, 1
	.loc 1 17 94
	add	w0, w0, 1
	.loc 1 17 99
	lsl	w0, w0, 10
	sxtw	x0, w0
	.loc 1 17 84
	orr	x0, x1, x0
	.loc 1 17 26
	str	x0, [sp, 88]
.LBB8:
	.loc 1 18 25
	str	wzr, [sp, 68]
	.loc 1 18 17
	b	.L9
.L12:
.LBB9:
	.loc 1 19 29
	str	wzr, [sp, 72]
	.loc 1 19 21
	b	.L10
.L11:
	.loc 1 20 43
	ldr	w1, [sp, 56]
	ldr	w0, [sp, 68]
	add	w1, w1, w0
	.loc 1 20 57
	ldr	w0, [sp, 64]
	lsl	w2, w0, 4
	.loc 1 20 53
	ldr	w0, [sp, 60]
	add	w2, w2, w0
	.loc 1 20 62
	ldr	w0, [sp, 72]
	add	w0, w2, w0
	.loc 1 20 48
	cmp	w1, w0
	cset	w0, eq
	and	w2, w0, 255
	.loc 1 20 33
	ldrsw	x0, [sp, 72]
	lsl	x0, x0, 1
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	.loc 1 20 48
	sxth	w1, w2
	.loc 1 20 37
	strh	w1, [x0]
	.loc 1 19 44 discriminator 3
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L10:
	.loc 1 19 38 discriminator 1
	ldr	w0, [sp, 72]
	cmp	w0, 15
	ble	.L11
.LBE9:
	.loc 1 22 32
	ldr	x0, [sp, 88]
	bl	increment_iter
	str	x0, [sp, 88]
	.loc 1 18 39 discriminator 2
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L9:
	.loc 1 18 34 discriminator 1
	ldr	w0, [sp, 68]
	cmp	w0, 7
	ble	.L12
.LBE8:
.LBE7:
	.loc 1 16 35 discriminator 2
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L8:
	.loc 1 16 30 discriminator 1
	ldr	w0, [sp, 64]
	cmp	w0, 7
	ble	.L13
.LBE6:
.LBB10:
	.loc 1 25 21
	str	wzr, [sp, 76]
	.loc 1 25 13
	b	.L14
.L15:
	.loc 1 26 24
	ldr	x0, [sp, 80]
	bl	increment_iter
	str	x0, [sp, 80]
	.loc 1 25 35 discriminator 3
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L14:
	.loc 1 25 30 discriminator 1
	ldr	w0, [sp, 76]
	cmp	w0, 7
	ble	.L15
.LBE10:
	.loc 1 15 35 discriminator 2
	ldr	w0, [sp, 60]
	add	w0, w0, 128
	str	w0, [sp, 60]
.L7:
	.loc 1 15 26 discriminator 1
	ldr	w0, [sp, 60]
	ldr	w1, [sp, 20]
	cmp	w1, w0
	bhi	.L16
.LBE5:
	.loc 1 14 33 discriminator 2
	ldr	w0, [sp, 56]
	add	w0, w0, 8
	str	w0, [sp, 56]
.L6:
	.loc 1 14 22 discriminator 1
	ldr	w0, [sp, 56]
	ldr	w1, [sp, 24]
	cmp	w1, w0
	bhi	.L17
.LBE4:
	.loc 1 30 1
	nop
	nop
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	fill_matrix, .-fill_matrix
	.section	.rodata
	.align	3
.LC0:
	.string	"C[%d][%d] = %d\n"
	.text
	.align	2
	.global	print
	.type	print, %function
print:
.LFB7:
	.loc 1 32 54
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	.loc 1 33 14
	ldr	x0, [sp, 24]
	str	x0, [sp, 56]
.LBB11:
	.loc 1 34 13
	str	wzr, [sp, 40]
	.loc 1 34 5
	b	.L19
.L26:
.LBB12:
	.loc 1 35 17
	str	wzr, [sp, 44]
	.loc 1 35 9
	b	.L20
.L25:
.LBB13:
	.loc 1 36 21
	str	wzr, [sp, 48]
	.loc 1 36 13
	b	.L21
.L24:
	.loc 1 37 25
	ldr	x0, [sp, 56]
	.loc 1 37 41
	and	x1, x0, -15361
	.loc 1 37 62
	ldr	w0, [sp, 48]
	lsl	w0, w0, 10
	sxtw	x0, w0
	.loc 1 37 57
	orr	x0, x1, x0
	.loc 1 37 22
	str	x0, [sp, 56]
.LBB14:
	.loc 1 38 25
	str	wzr, [sp, 52]
	.loc 1 38 17
	b	.L22
.L23:
	.loc 1 39 58
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 1
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrsh	w0, [x0]
	.loc 1 39 21
	mov	w3, w0
	ldr	w2, [sp, 44]
	ldr	w1, [sp, 40]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	.loc 1 40 21
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
	.loc 1 38 40 discriminator 3
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L22:
	.loc 1 38 34 discriminator 1
	ldr	w0, [sp, 52]
	cmp	w0, 15
	ble	.L23
.LBE14:
	.loc 1 36 38 discriminator 2
	ldr	w0, [sp, 48]
	add	w0, w0, 2
	str	w0, [sp, 48]
.L21:
	.loc 1 36 30 discriminator 1
	ldr	w0, [sp, 48]
	cmp	w0, 14
	ble	.L24
.LBE13:
	.loc 1 43 20
	ldr	x0, [sp, 56]
	bl	increment_iter
	str	x0, [sp, 56]
.L20:
	.loc 1 35 26 discriminator 1
	ldr	w0, [sp, 44]
	ldr	w1, [sp, 16]
	cmp	w1, w0
	bhi	.L25
.LBE12:
	.loc 1 34 30 discriminator 2
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L19:
	.loc 1 34 22 discriminator 1
	ldr	w0, [sp, 40]
	ldr	w1, [sp, 20]
	cmp	w1, w0
	bhi	.L26
.LBE11:
	.loc 1 46 1
	nop
	nop
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	print, .-print
	.align	2
	.global	main
	.type	main, %function
main:
.LFB8:
	.loc 1 49 34
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	w0, [sp, 12]
	str	x1, [sp]
	.loc 1 49 34
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	.loc 1 50 5
	bl	init_pim
	.loc 1 53 32
	ldr	x0, [sp]
	add	x0, x0, 8
	.loc 1 53 23
	ldr	x0, [x0]
	bl	atoi
	.loc 1 53 14 discriminator 1
	str	w0, [sp, 20]
	.loc 1 54 32
	ldr	x0, [sp]
	add	x0, x0, 16
	.loc 1 54 23
	ldr	x0, [x0]
	bl	atoi
	.loc 1 54 14 discriminator 1
	str	w0, [sp, 24]
	.loc 1 55 32
	ldr	x0, [sp]
	add	x0, x0, 24
	.loc 1 55 23
	ldr	x0, [x0]
	bl	atoi
	.loc 1 55 14 discriminator 1
	str	w0, [sp, 28]
	.loc 1 58 23
	ldr	w1, [sp, 20]
	ldr	w0, [sp, 24]
	mul	w0, w1, w0
	uxtw	x0, w0
	.loc 1 58 9
	lsl	x0, x0, 1
	bl	malloc
	str	x0, [sp, 40]
	.loc 1 59 5
	add	x0, sp, 32
	bl	init_operand
	.loc 1 60 9
	ldr	x0, [sp, 32]
	.loc 1 60 22
	add	x0, x0, 1024
	.loc 1 60 7
	str	x0, [sp, 48]
	.loc 1 61 5
	mov	x0, 0
	bl	m5_exit
	.loc 1 62 5
	ldr	w4, [sp, 28]
	ldr	w3, [sp, 24]
	ldr	w2, [sp, 20]
	ldr	x1, [sp, 48]
	ldr	x0, [sp, 40]
	bl	fill_matrix
	.loc 1 63 5
	ldr	x0, [sp, 32]
	ldr	w5, [sp, 28]
	ldr	w4, [sp, 24]
	ldr	w3, [sp, 20]
	mov	x2, x0
	ldr	x1, [sp, 48]
	ldr	x0, [sp, 40]
	bl	matrix_multiplication
	.loc 1 64 5
	ldr	x0, [sp, 32]
	ldr	w2, [sp, 28]
	ldr	w1, [sp, 20]
	bl	print
	.loc 1 65 5
	ldr	x0, [sp, 40]
	bl	free
	.loc 1 66 12
	mov	w0, 0
	.loc 1 67 1
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L29
	bl	__stack_chk_fail
.L29:
	mov	w0, w1
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/lib/gcc-cross/aarch64-linux-gnu/13/include/stddef.h"
	.file 3 "/usr/aarch64-linux-gnu/include/bits/types.h"
	.file 4 "/usr/aarch64-linux-gnu/include/bits/stdint-intn.h"
	.file 5 "/usr/aarch64-linux-gnu/include/bits/stdint-uintn.h"
	.file 6 "/usr/aarch64-linux-gnu/include/stdint.h"
	.file 7 "/usr/aarch64-linux-gnu/include/stdlib.h"
	.file 8 "/home/antonio/U/laburo/PIM-Simulation/gem5-pim/include/gem5/m5ops.h"
	.file 9 "pim.h"
	.file 10 "/usr/aarch64-linux-gnu/include/stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x4be
	.2byte	0x5
	.byte	0x1
	.byte	0x8
	.4byte	.Ldebug_abbrev0
	.uleb128 0xe
	.4byte	.LASF40
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x5
	.4byte	.LASF7
	.byte	0x2
	.byte	0xd6
	.byte	0x17
	.4byte	0x3a
	.uleb128 0x4
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0xf
	.byte	0x8
	.uleb128 0x10
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.4byte	.LASF3
	.uleb128 0x4
	.byte	0x2
	.byte	0x7
	.4byte	.LASF4
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.4byte	.LASF5
	.uleb128 0x4
	.byte	0x1
	.byte	0x6
	.4byte	.LASF6
	.uleb128 0x5
	.4byte	.LASF8
	.byte	0x3
	.byte	0x27
	.byte	0x1a
	.4byte	0x72
	.uleb128 0x4
	.byte	0x2
	.byte	0x5
	.4byte	.LASF9
	.uleb128 0x5
	.4byte	.LASF10
	.byte	0x3
	.byte	0x2a
	.byte	0x16
	.4byte	0x58
	.uleb128 0x4
	.byte	0x8
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x5
	.4byte	.LASF12
	.byte	0x3
	.byte	0x2d
	.byte	0x1b
	.4byte	0x3a
	.uleb128 0x8
	.4byte	0x9d
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.4byte	.LASF13
	.uleb128 0x11
	.4byte	0x9d
	.uleb128 0x8
	.4byte	0xa4
	.uleb128 0x5
	.4byte	.LASF14
	.byte	0x4
	.byte	0x19
	.byte	0x13
	.4byte	0x66
	.uleb128 0x5
	.4byte	.LASF15
	.byte	0x5
	.byte	0x1a
	.byte	0x14
	.4byte	0x79
	.uleb128 0x5
	.4byte	.LASF16
	.byte	0x5
	.byte	0x1b
	.byte	0x14
	.4byte	0x8c
	.uleb128 0x5
	.4byte	.LASF17
	.byte	0x6
	.byte	0x4f
	.byte	0x1b
	.4byte	0x3a
	.uleb128 0x4
	.byte	0x8
	.byte	0x5
	.4byte	.LASF18
	.uleb128 0x4
	.byte	0x8
	.byte	0x7
	.4byte	.LASF19
	.uleb128 0x8
	.4byte	0xae
	.uleb128 0x12
	.4byte	.LASF20
	.byte	0x7
	.2byte	0x2af
	.byte	0xd
	.4byte	0x104
	.uleb128 0x2
	.4byte	0x41
	.byte	0
	.uleb128 0x9
	.4byte	.LASF22
	.byte	0x9
	.byte	0x2d
	.byte	0x5
	.4byte	0x43
	.4byte	0x133
	.uleb128 0x2
	.4byte	0xec
	.uleb128 0x2
	.4byte	0xec
	.uleb128 0x2
	.4byte	0xec
	.uleb128 0x2
	.4byte	0xba
	.uleb128 0x2
	.4byte	0xba
	.uleb128 0x2
	.4byte	0xba
	.byte	0
	.uleb128 0x13
	.4byte	.LASF21
	.byte	0x8
	.byte	0x30
	.byte	0x6
	.4byte	0x145
	.uleb128 0x2
	.4byte	0xc6
	.byte	0
	.uleb128 0x9
	.4byte	.LASF23
	.byte	0x9
	.byte	0x2a
	.byte	0x5
	.4byte	0x43
	.4byte	0x15b
	.uleb128 0x2
	.4byte	0x15b
	.byte	0
	.uleb128 0x8
	.4byte	0xec
	.uleb128 0xb
	.4byte	.LASF24
	.byte	0x7
	.2byte	0x2a0
	.byte	0xe
	.4byte	0x41
	.4byte	0x177
	.uleb128 0x2
	.4byte	0x2e
	.byte	0
	.uleb128 0x9
	.4byte	.LASF25
	.byte	0x7
	.byte	0x69
	.byte	0xc
	.4byte	0x43
	.4byte	0x18d
	.uleb128 0x2
	.4byte	0xa9
	.byte	0
	.uleb128 0x14
	.4byte	.LASF26
	.byte	0x9
	.byte	0x29
	.byte	0x5
	.4byte	0x43
	.4byte	0x19f
	.uleb128 0xc
	.byte	0
	.uleb128 0xb
	.4byte	.LASF27
	.byte	0xa
	.2byte	0x16b
	.byte	0xc
	.4byte	0x43
	.4byte	0x1b7
	.uleb128 0x2
	.4byte	0xa9
	.uleb128 0xc
	.byte	0
	.uleb128 0x9
	.4byte	.LASF28
	.byte	0x9
	.byte	0x2c
	.byte	0xa
	.4byte	0xec
	.4byte	0x1cd
	.uleb128 0x2
	.4byte	0xec
	.byte	0
	.uleb128 0x15
	.4byte	.LASF41
	.byte	0x1
	.byte	0x31
	.byte	0x5
	.4byte	0x43
	.8byte	.LFB8
	.8byte	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x25c
	.uleb128 0x6
	.4byte	.LASF29
	.byte	0x31
	.byte	0xe
	.4byte	0x43
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x6
	.4byte	.LASF30
	.byte	0x31
	.byte	0x1a
	.4byte	0x25c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x7
	.4byte	.LASF31
	.byte	0x35
	.byte	0xe
	.4byte	0xba
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x7
	.4byte	.LASF32
	.byte	0x36
	.byte	0xe
	.4byte	0xba
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x7
	.4byte	.LASF33
	.byte	0x37
	.byte	0xe
	.4byte	0xba
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x1
	.string	"A"
	.byte	0x39
	.byte	0xe
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x1
	.string	"B"
	.byte	0x39
	.byte	0x12
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x1
	.string	"C"
	.byte	0x39
	.byte	0x16
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.uleb128 0x8
	.4byte	0x98
	.uleb128 0x16
	.4byte	.LASF42
	.byte	0x1
	.byte	0x20
	.byte	0x6
	.8byte	.LFB7
	.8byte	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x32f
	.uleb128 0xa
	.string	"op"
	.byte	0x20
	.byte	0x15
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x6
	.4byte	.LASF34
	.byte	0x20
	.byte	0x22
	.4byte	0xba
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x6
	.4byte	.LASF35
	.byte	0x20
	.byte	0x31
	.4byte	0xba
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x7
	.4byte	.LASF36
	.byte	0x21
	.byte	0xe
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x3
	.8byte	.LBB11
	.8byte	.LBE11-.LBB11
	.uleb128 0x1
	.string	"i"
	.byte	0x22
	.byte	0xd
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x3
	.8byte	.LBB12
	.8byte	.LBE12-.LBB12
	.uleb128 0x1
	.string	"j"
	.byte	0x23
	.byte	0x11
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x3
	.8byte	.LBB13
	.8byte	.LBE13-.LBB13
	.uleb128 0x1
	.string	"b"
	.byte	0x24
	.byte	0x15
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x3
	.8byte	.LBB14
	.8byte	.LBE14-.LBB14
	.uleb128 0x1
	.string	"k"
	.byte	0x26
	.byte	0x19
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x17
	.4byte	.LASF43
	.byte	0x1
	.byte	0x6
	.byte	0x6
	.8byte	.LFB6
	.8byte	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xa
	.string	"A"
	.byte	0x6
	.byte	0x1b
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xa
	.string	"B"
	.byte	0x6
	.byte	0x27
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x6
	.4byte	.LASF37
	.byte	0x6
	.byte	0x33
	.4byte	0xba
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x6
	.4byte	.LASF38
	.byte	0x6
	.byte	0x43
	.4byte	0xba
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x6
	.4byte	.LASF35
	.byte	0x6
	.byte	0x53
	.4byte	0xba
	.uleb128 0x3
	.byte	0x91
	.sleb128 -76
	.uleb128 0x7
	.4byte	.LASF36
	.byte	0xd
	.byte	0xe
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x18
	.4byte	.LASF39
	.byte	0x1
	.byte	0xd
	.byte	0x19
	.4byte	0xec
	.uleb128 0xd
	.8byte	.LBB2
	.8byte	.LBE2-.LBB2
	.4byte	0x3e8
	.uleb128 0x1
	.string	"i"
	.byte	0x7
	.byte	0xd
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x3
	.8byte	.LBB3
	.8byte	.LBE3-.LBB3
	.uleb128 0x1
	.string	"j"
	.byte	0x8
	.byte	0x11
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.byte	0
	.byte	0
	.uleb128 0x3
	.8byte	.LBB4
	.8byte	.LBE4-.LBB4
	.uleb128 0x1
	.string	"i"
	.byte	0xe
	.byte	0xd
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x3
	.8byte	.LBB5
	.8byte	.LBE5-.LBB5
	.uleb128 0x1
	.string	"j"
	.byte	0xf
	.byte	0x11
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0xd
	.8byte	.LBB6
	.8byte	.LBE6-.LBB6
	.4byte	0x4a0
	.uleb128 0x1
	.string	"b"
	.byte	0x10
	.byte	0x15
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x3
	.8byte	.LBB7
	.8byte	.LBE7-.LBB7
	.uleb128 0x7
	.4byte	.LASF39
	.byte	0x11
	.byte	0x1a
	.4byte	0xec
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x3
	.8byte	.LBB8
	.8byte	.LBE8-.LBB8
	.uleb128 0x1
	.string	"r"
	.byte	0x12
	.byte	0x19
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x3
	.8byte	.LBB9
	.8byte	.LBE9-.LBB9
	.uleb128 0x1
	.string	"k"
	.byte	0x13
	.byte	0x1d
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x3
	.8byte	.LBB10
	.8byte	.LBE10-.LBB10
	.uleb128 0x1
	.string	"r"
	.byte	0x19
	.byte	0x15
	.4byte	0x43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x8
	.byte	0
	.2byte	0
	.2byte	0
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.8byte	0
	.8byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF7:
	.string	"size_t"
.LASF8:
	.string	"__int16_t"
.LASF26:
	.string	"init_pim"
.LASF17:
	.string	"uintptr_t"
.LASF23:
	.string	"init_operand"
.LASF36:
	.string	"iter"
.LASF21:
	.string	"m5_exit"
.LASF16:
	.string	"uint64_t"
.LASF3:
	.string	"unsigned char"
.LASF32:
	.string	"rows_B"
.LASF2:
	.string	"long unsigned int"
.LASF4:
	.string	"short unsigned int"
.LASF37:
	.string	"rowsA"
.LASF40:
	.string	"GNU C17 13.3.0 -mlittle-endian -mabi=lp64 -g -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection"
.LASF39:
	.string	"bank_ptr"
.LASF10:
	.string	"__uint32_t"
.LASF35:
	.string	"cols"
.LASF41:
	.string	"main"
.LASF5:
	.string	"unsigned int"
.LASF22:
	.string	"matrix_multiplication"
.LASF38:
	.string	"rowsB"
.LASF19:
	.string	"long long unsigned int"
.LASF43:
	.string	"fill_matrix"
.LASF14:
	.string	"int16_t"
.LASF29:
	.string	"argc"
.LASF34:
	.string	"rows"
.LASF20:
	.string	"free"
.LASF18:
	.string	"long long int"
.LASF13:
	.string	"char"
.LASF42:
	.string	"print"
.LASF27:
	.string	"printf"
.LASF9:
	.string	"short int"
.LASF12:
	.string	"__uint64_t"
.LASF30:
	.string	"argv"
.LASF15:
	.string	"uint32_t"
.LASF11:
	.string	"long int"
.LASF6:
	.string	"signed char"
.LASF33:
	.string	"cols_B"
.LASF25:
	.string	"atoi"
.LASF31:
	.string	"rows_A"
.LASF24:
	.string	"malloc"
.LASF28:
	.string	"increment_iter"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/antonio/U/laburo/PIM-Simulation/resources/binaries/acc"
.LASF0:
	.string	"mult.c"
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
