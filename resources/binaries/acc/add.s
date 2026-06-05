	.arch armv8-a
	.file	"add.c"
	.text
.Ltext0:
	.file 0 "/home/antonio/U/laburo/PIM-Simulation/resources/binaries/acc" "add.c"
	.align	2
	.global	fill_matrix
	.type	fill_matrix, %function
fill_matrix:
.LFB6:
	.file 1 "add.c"
	.loc 1 6 62
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	.loc 1 7 14
	ldr	x0, [sp, 40]
	str	x0, [sp, 72]
.LBB2:
	.loc 1 8 13
	str	wzr, [sp, 60]
	.loc 1 8 5
	b	.L2
.L7:
.LBB3:
	.loc 1 9 17
	str	wzr, [sp, 64]
	.loc 1 9 9
	b	.L3
.L6:
.LBB4:
	.loc 1 10 46
	ldr	x0, [sp, 72]
	.loc 1 10 62
	and	x1, x0, -15361
	.loc 1 10 87
	ldr	w0, [sp, 64]
	lsl	w0, w0, 1
	.loc 1 10 92
	lsl	w0, w0, 10
	sxtw	x0, w0
	.loc 1 10 81
	orr	x0, x1, x0
	.loc 1 10 22
	str	x0, [sp, 80]
	.loc 1 11 46
	ldr	x0, [sp, 72]
	.loc 1 11 62
	and	x1, x0, -15361
	.loc 1 11 87
	ldr	w0, [sp, 64]
	lsl	w0, w0, 1
	.loc 1 11 91
	add	w0, w0, 1
	.loc 1 11 96
	lsl	w0, w0, 10
	sxtw	x0, w0
	.loc 1 11 81
	orr	x0, x1, x0
	.loc 1 11 22
	str	x0, [sp, 88]
.LBB5:
	.loc 1 13 21
	str	wzr, [sp, 68]
	.loc 1 13 13
	b	.L4
.L5:
	.loc 1 14 26
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 1
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	.loc 1 14 30
	ldr	w1, [sp, 60]
	sxth	w1, w1
	strh	w1, [x0]
	.loc 1 15 26
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 1
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	.loc 1 15 30
	ldr	w1, [sp, 60]
	sxth	w1, w1
	strh	w1, [x0]
	.loc 1 16 17
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
	.loc 1 13 36 discriminator 3
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L4:
	.loc 1 13 30 discriminator 1
	ldr	w0, [sp, 68]
	cmp	w0, 15
	ble	.L5
.LBE5:
.LBE4:
	.loc 1 9 31 discriminator 2
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L3:
	.loc 1 9 26 discriminator 1
	ldr	w0, [sp, 64]
	cmp	w0, 7
	ble	.L6
.LBE3:
	.loc 1 19 16
	ldr	x0, [sp, 72]
	bl	increment_iter
	str	x0, [sp, 72]
.L2:
	.loc 1 8 22 discriminator 1
	ldrsw	x0, [sp, 60]
	ldr	x1, [sp, 24]
	cmp	x1, x0
	bhi	.L7
.LBE2:
	.loc 1 21 12
	ldr	x0, [sp, 72]
	.loc 1 22 1
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
	.loc 1 48 54
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	.loc 1 49 14
	ldr	x0, [sp, 24]
	str	x0, [sp, 48]
.LBB6:
	.loc 1 50 13
	str	wzr, [sp, 32]
	.loc 1 50 5
	b	.L10
.L17:
.LBB7:
	.loc 1 51 17
	str	wzr, [sp, 36]
	.loc 1 51 9
	b	.L11
.L16:
.LBB8:
	.loc 1 52 21
	str	wzr, [sp, 40]
	.loc 1 52 13
	b	.L12
.L15:
.LBB9:
	.loc 1 53 38
	ldr	x0, [sp, 48]
	.loc 1 53 54
	and	x1, x0, -15361
	.loc 1 53 75
	ldr	w0, [sp, 40]
	lsl	w0, w0, 10
	sxtw	x0, w0
	.loc 1 53 70
	orr	x0, x1, x0
	.loc 1 53 26
	str	x0, [sp, 56]
.LBB10:
	.loc 1 54 25
	str	wzr, [sp, 44]
	.loc 1 54 17
	b	.L13
.L14:
	.loc 1 55 62
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 1
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrsh	w0, [x0]
	.loc 1 55 21
	mov	w3, w0
	ldr	w2, [sp, 36]
	ldr	w1, [sp, 32]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	.loc 1 56 21
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
	.loc 1 54 40 discriminator 3
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L13:
	.loc 1 54 34 discriminator 1
	ldr	w0, [sp, 44]
	cmp	w0, 15
	ble	.L14
.LBE10:
.LBE9:
	.loc 1 52 38 discriminator 2
	ldr	w0, [sp, 40]
	add	w0, w0, 2
	str	w0, [sp, 40]
.L12:
	.loc 1 52 30 discriminator 1
	ldr	w0, [sp, 40]
	cmp	w0, 14
	ble	.L15
.LBE8:
	.loc 1 59 20
	ldr	x0, [sp, 48]
	bl	increment_iter
	str	x0, [sp, 48]
.L11:
	.loc 1 51 26 discriminator 1
	ldr	w0, [sp, 36]
	ldr	w1, [sp, 16]
	cmp	w1, w0
	bhi	.L16
.LBE7:
	.loc 1 50 30 discriminator 2
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L10:
	.loc 1 50 22 discriminator 1
	ldr	w0, [sp, 32]
	ldr	w1, [sp, 20]
	cmp	w1, w0
	bhi	.L17
.LBE6:
	.loc 1 62 1
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
	.loc 1 65 34
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	w0, [sp, 12]
	str	x1, [sp]
	.loc 1 65 34
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	.loc 1 66 5
	bl	init_pim
	.loc 1 69 30
	ldr	x0, [sp]
	add	x0, x0, 8
	.loc 1 69 21
	ldr	x0, [x0]
	bl	atoi
	.loc 1 69 14 discriminator 1
	str	w0, [sp, 16]
	.loc 1 70 30
	ldr	x0, [sp]
	add	x0, x0, 16
	.loc 1 70 21
	ldr	x0, [x0]
	bl	atoi
	.loc 1 70 14 discriminator 1
	str	w0, [sp, 20]
	.loc 1 72 27
	ldr	w1, [sp, 16]
	ldr	w0, [sp, 20]
	mul	w0, w1, w0
	.loc 1 72 14
	uxtw	x0, w0
	str	x0, [sp, 32]
	.loc 1 75 5
	add	x0, sp, 24
	bl	init_operand
	.loc 1 76 9
	ldr	x0, [sp, 24]
	.loc 1 76 22
	add	x0, x0, 1024
	.loc 1 76 7
	str	x0, [sp, 40]
	.loc 1 77 5
	mov	x0, 0
	bl	m5_exit
	.loc 1 78 9
	ldr	x0, [sp, 24]
	ldr	x2, [sp, 32]
	ldr	x1, [sp, 40]
	bl	fill_matrix
	str	x0, [sp, 48]
	.loc 1 79 5
	ldr	x0, [sp, 24]
	ldr	x3, [sp, 32]
	ldr	x2, [sp, 48]
	ldr	x1, [sp, 40]
	bl	add
	.loc 1 80 5
	ldr	w2, [sp, 20]
	ldr	w1, [sp, 16]
	ldr	x0, [sp, 48]
	bl	print
	.loc 1 81 12
	mov	w0, 0
	.loc 1 82 1
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L20
	bl	__stack_chk_fail
.L20:
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
	.file 2 "/usr/aarch64-linux-gnu/include/bits/types.h"
	.file 3 "/usr/aarch64-linux-gnu/include/bits/stdint-intn.h"
	.file 4 "/usr/aarch64-linux-gnu/include/bits/stdint-uintn.h"
	.file 5 "/usr/aarch64-linux-gnu/include/stdint.h"
	.file 6 "pim.h"
	.file 7 "/usr/aarch64-linux-gnu/include/stdlib.h"
	.file 8 "/home/antonio/U/laburo/PIM-Simulation/gem5-pim/include/gem5/m5ops.h"
	.file 9 "/usr/aarch64-linux-gnu/include/stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x3e2
	.2byte	0x5
	.byte	0x1
	.byte	0x8
	.4byte	.Ldebug_abbrev0
	.uleb128 0xc
	.4byte	.LASF36
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0xd
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF3
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF4
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF5
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF6
	.uleb128 0x6
	.4byte	.LASF8
	.byte	0x2
	.byte	0x27
	.byte	0x1a
	.4byte	0x64
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x6
	.4byte	.LASF9
	.byte	0x2
	.byte	0x2a
	.byte	0x16
	.4byte	0x4a
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF10
	.uleb128 0x6
	.4byte	.LASF11
	.byte	0x2
	.byte	0x2d
	.byte	0x1b
	.4byte	0x2e
	.uleb128 0x7
	.4byte	0x8f
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF12
	.uleb128 0xe
	.4byte	0x8f
	.uleb128 0x7
	.4byte	0x96
	.uleb128 0x6
	.4byte	.LASF13
	.byte	0x3
	.byte	0x19
	.byte	0x13
	.4byte	0x58
	.uleb128 0x6
	.4byte	.LASF14
	.byte	0x4
	.byte	0x1a
	.byte	0x14
	.4byte	0x6b
	.uleb128 0x6
	.4byte	.LASF15
	.byte	0x4
	.byte	0x1b
	.byte	0x14
	.4byte	0x7e
	.uleb128 0x6
	.4byte	.LASF16
	.byte	0x5
	.byte	0x4f
	.byte	0x1b
	.4byte	0x2e
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF17
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF18
	.uleb128 0x7
	.4byte	0xa0
	.uleb128 0xf
	.string	"add"
	.byte	0x6
	.byte	0x2b
	.byte	0x6
	.4byte	0x104
	.uleb128 0x3
	.4byte	0xde
	.uleb128 0x3
	.4byte	0xde
	.uleb128 0x3
	.4byte	0xde
	.uleb128 0x3
	.4byte	0xb8
	.byte	0
	.uleb128 0x10
	.4byte	.LASF19
	.byte	0x8
	.byte	0x30
	.byte	0x6
	.4byte	0x116
	.uleb128 0x3
	.4byte	0xb8
	.byte	0
	.uleb128 0x9
	.4byte	.LASF20
	.byte	0x6
	.byte	0x2a
	.byte	0x5
	.4byte	0x35
	.4byte	0x12c
	.uleb128 0x3
	.4byte	0x12c
	.byte	0
	.uleb128 0x7
	.4byte	0xde
	.uleb128 0x9
	.4byte	.LASF21
	.byte	0x7
	.byte	0x69
	.byte	0xc
	.4byte	0x35
	.4byte	0x147
	.uleb128 0x3
	.4byte	0x9b
	.byte	0
	.uleb128 0x11
	.4byte	.LASF22
	.byte	0x6
	.byte	0x29
	.byte	0x5
	.4byte	0x35
	.4byte	0x159
	.uleb128 0xb
	.byte	0
	.uleb128 0x12
	.4byte	.LASF23
	.byte	0x9
	.2byte	0x16b
	.byte	0xc
	.4byte	0x35
	.4byte	0x171
	.uleb128 0x3
	.4byte	0x9b
	.uleb128 0xb
	.byte	0
	.uleb128 0x9
	.4byte	.LASF24
	.byte	0x6
	.byte	0x2c
	.byte	0xa
	.4byte	0xde
	.4byte	0x187
	.uleb128 0x3
	.4byte	0xde
	.byte	0
	.uleb128 0x13
	.4byte	.LASF37
	.byte	0x1
	.byte	0x41
	.byte	0x5
	.4byte	0x35
	.8byte	.LFB8
	.8byte	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x216
	.uleb128 0x8
	.4byte	.LASF25
	.byte	0x41
	.byte	0xe
	.4byte	0x35
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x8
	.4byte	.LASF26
	.byte	0x41
	.byte	0x1a
	.4byte	0x216
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x5
	.4byte	.LASF27
	.byte	0x45
	.byte	0xe
	.4byte	0xac
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x5
	.4byte	.LASF28
	.byte	0x46
	.byte	0xe
	.4byte	0xac
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x5
	.4byte	.LASF29
	.byte	0x48
	.byte	0xe
	.4byte	0xb8
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x2
	.string	"A"
	.byte	0x4a
	.byte	0xe
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x2
	.string	"B"
	.byte	0x4a
	.byte	0x12
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x2
	.string	"C"
	.byte	0x4a
	.byte	0x16
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x7
	.4byte	0x8a
	.uleb128 0x14
	.4byte	.LASF32
	.byte	0x1
	.byte	0x30
	.byte	0x6
	.8byte	.LFB7
	.8byte	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x309
	.uleb128 0xa
	.string	"op"
	.byte	0x30
	.byte	0x15
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x8
	.4byte	.LASF27
	.byte	0x30
	.byte	0x22
	.4byte	0xac
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x8
	.4byte	.LASF28
	.byte	0x30
	.byte	0x31
	.4byte	0xac
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x5
	.4byte	.LASF30
	.byte	0x31
	.byte	0xe
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x4
	.8byte	.LBB6
	.8byte	.LBE6-.LBB6
	.uleb128 0x2
	.string	"i"
	.byte	0x32
	.byte	0xd
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x4
	.8byte	.LBB7
	.8byte	.LBE7-.LBB7
	.uleb128 0x2
	.string	"j"
	.byte	0x33
	.byte	0x11
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x4
	.8byte	.LBB8
	.8byte	.LBE8-.LBB8
	.uleb128 0x2
	.string	"b"
	.byte	0x34
	.byte	0x15
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x4
	.8byte	.LBB9
	.8byte	.LBE9-.LBB9
	.uleb128 0x5
	.4byte	.LASF31
	.byte	0x35
	.byte	0x1a
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x4
	.8byte	.LBB10
	.8byte	.LBE10-.LBB10
	.uleb128 0x2
	.string	"k"
	.byte	0x36
	.byte	0x19
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x15
	.4byte	.LASF33
	.byte	0x1
	.byte	0x6
	.byte	0xa
	.4byte	0xde
	.8byte	.LFB6
	.8byte	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xa
	.string	"A"
	.byte	0x6
	.byte	0x1f
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xa
	.string	"B"
	.byte	0x6
	.byte	0x2b
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x8
	.4byte	.LASF29
	.byte	0x6
	.byte	0x38
	.4byte	0xb8
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x5
	.4byte	.LASF30
	.byte	0x7
	.byte	0xe
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x4
	.8byte	.LBB2
	.8byte	.LBE2-.LBB2
	.uleb128 0x2
	.string	"i"
	.byte	0x8
	.byte	0xd
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x4
	.8byte	.LBB3
	.8byte	.LBE3-.LBB3
	.uleb128 0x2
	.string	"b"
	.byte	0x9
	.byte	0x11
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x4
	.8byte	.LBB4
	.8byte	.LBE4-.LBB4
	.uleb128 0x5
	.4byte	.LASF34
	.byte	0xa
	.byte	0x16
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x5
	.4byte	.LASF35
	.byte	0xb
	.byte	0x16
	.4byte	0xde
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x4
	.8byte	.LBB5
	.8byte	.LBE5-.LBB5
	.uleb128 0x2
	.string	"k"
	.byte	0xd
	.byte	0x15
	.4byte	0x35
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
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
	.uleb128 0x2
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
	.uleb128 0x3
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
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
	.uleb128 0x7
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0x10
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
	.uleb128 0x11
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
	.uleb128 0x49
	.uleb128 0x13
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
.LASF8:
	.string	"__int16_t"
.LASF22:
	.string	"init_pim"
.LASF16:
	.string	"uintptr_t"
.LASF20:
	.string	"init_operand"
.LASF30:
	.string	"iter"
.LASF19:
	.string	"m5_exit"
.LASF15:
	.string	"uint64_t"
.LASF28:
	.string	"cols"
.LASF3:
	.string	"unsigned char"
.LASF2:
	.string	"long unsigned int"
.LASF4:
	.string	"short unsigned int"
.LASF36:
	.string	"GNU C17 13.3.0 -mlittle-endian -mabi=lp64 -g -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection"
.LASF31:
	.string	"bank_ptr"
.LASF9:
	.string	"__uint32_t"
.LASF37:
	.string	"main"
.LASF5:
	.string	"unsigned int"
.LASF18:
	.string	"long long unsigned int"
.LASF33:
	.string	"fill_matrix"
.LASF13:
	.string	"int16_t"
.LASF25:
	.string	"argc"
.LASF27:
	.string	"rows"
.LASF17:
	.string	"long long int"
.LASF12:
	.string	"char"
.LASF32:
	.string	"print"
.LASF23:
	.string	"printf"
.LASF34:
	.string	"bank_ptrA"
.LASF35:
	.string	"bank_ptrB"
.LASF7:
	.string	"short int"
.LASF11:
	.string	"__uint64_t"
.LASF26:
	.string	"argv"
.LASF14:
	.string	"uint32_t"
.LASF10:
	.string	"long int"
.LASF29:
	.string	"elems"
.LASF6:
	.string	"signed char"
.LASF21:
	.string	"atoi"
.LASF24:
	.string	"increment_iter"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/antonio/U/laburo/PIM-Simulation/resources/binaries/acc"
.LASF0:
	.string	"add.c"
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
