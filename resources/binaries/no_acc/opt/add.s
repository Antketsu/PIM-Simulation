	.arch armv8-a
	.file	"add.c"
	.text
	.align	2
	.p2align 4,,11
	.global	add
	.type	add, %function
add:
.LFB39:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	mov	x20, x1
	mov	x0, 0
	mov	x1, 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x21, x2
	mov	w22, w4
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	mov	w23, w3
	bl	m5_work_begin
	cbz	w23, .L2
	cbz	w22, .L2
	mov	w9, w22
	mov	w1, 0
	mov	w0, 0
	.p2align 3,,7
.L3:
	mov	w5, w1
	.p2align 3,,7
.L4:
	ubfiz	x6, x5, 1, 32
	add	w5, w5, 1
	ldrh	w7, [x19, x6]
	ldrh	w8, [x20, x6]
	add	w7, w7, w8
	strh	w7, [x21, x6]
	cmp	w9, w5
	bne	.L4
	add	w0, w0, 1
	add	w1, w1, w22
	add	w9, w9, w22
	cmp	w0, w23
	bne	.L3
.L2:
	ldp	x19, x20, [sp, 16]
	mov	x1, 0
	ldp	x21, x22, [sp, 32]
	mov	x0, 0
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	m5_work_end
	.cfi_endproc
.LFE39:
	.size	add, .-add
	.align	2
	.p2align 4,,11
	.global	init_matrix
	.type	init_matrix, %function
init_matrix:
.LFB40:
	.cfi_startproc
	cbz	x2, .L14
	sub	x5, x2, #1
	cmp	x5, 2
	bls	.L24
	add	x4, x0, 2
	mov	x3, 0
	sub	x4, x1, x4
	cmp	x4, 12
	bhi	.L38
	.p2align 3,,7
.L22:
	sxth	w4, w3
	strh	w4, [x0, x3, lsl 1]
	strh	w4, [x1, x3, lsl 1]
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L22
.L14:
	ret
	.p2align 2,,3
.L38:
	cmp	x5, 6
	bls	.L26
	adrp	x5, .LC0
	lsr	x4, x2, 3
	movi	v4.4s, 0x8
	ldr	q1, [x5, #:lo12:.LC0]
	lsl	x4, x4, 4
	movi	v3.4s, 0x4
	.p2align 3,,7
.L18:
	mov	v0.16b, v1.16b
	add	v1.4s, v1.4s, v4.4s
	add	v2.4s, v0.4s, v3.4s
	uzp1	v0.8h, v0.8h, v2.8h
	str	q0, [x0, x3]
	str	q0, [x1, x3]
	add	x3, x3, 16
	cmp	x3, x4
	bne	.L18
	and	x4, x2, -8
	mov	w3, w4
	tst	x2, 7
	beq	.L14
	sub	x5, x2, x4
	sub	x6, x5, #1
	cmp	x6, 2
	bls	.L20
.L17:
	adrp	x7, .LC0
	dup	v0.4s, w3
	lsl	x6, x4, 1
	ldr	q1, [x7, #:lo12:.LC0]
	and	x7, x5, -4
	add	x4, x4, x7
	add	w3, w3, w7
	add	v0.4s, v0.4s, v1.4s
	xtn	v0.4h, v0.4s
	str	d0, [x0, x6]
	str	d0, [x1, x6]
	tst	x5, 3
	beq	.L14
.L20:
	lsl	x4, x4, 1
	add	w6, w3, 1
	sxth	w7, w3
	sxtw	x5, w6
	strh	w7, [x0, x4]
	strh	w7, [x1, x4]
	cmp	x2, x5
	bls	.L14
	lsl	x4, x5, 1
	sxth	w6, w6
	add	w3, w3, 2
	strh	w6, [x0, x4]
	strh	w6, [x1, x4]
	cmp	x2, w3, sxtw
	bls	.L14
	add	x4, x4, 2
	sxth	w3, w3
	strh	w3, [x0, x4]
	strh	w3, [x1, x4]
	ret
	.p2align 2,,3
.L24:
	mov	x3, 0
	sxth	w4, w3
	strh	w4, [x0, x3, lsl 1]
	strh	w4, [x1, x3, lsl 1]
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L22
	b	.L14
.L26:
	mov	x5, x2
	mov	w3, 0
	mov	x4, 0
	b	.L17
	.cfi_endproc
.LFE40:
	.size	init_matrix, .-init_matrix
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC1:
	.string	"C[%d][%d] = %d\n"
	.text
	.align	2
	.p2align 4,,11
	.global	print_matrix
	.type	print_matrix, %function
print_matrix:
.LFB41:
	.cfi_startproc
	cbz	w1, .L51
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	w22, w2
	cbz	w2, .L39
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	adrp	x24, .LC1
	mov	x23, x0
	add	x24, x24, :lo12:.LC1
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	mov	w25, w1
	mov	w21, 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -56
	.cfi_offset 19, -64
	mov	w20, 0
	.p2align 3,,7
.L41:
	mov	w19, 0
	.p2align 3,,7
.L42:
	add	w4, w19, w21
	mov	w3, w19
	mov	w2, w20
	mov	x1, x24
	mov	w0, 2
	add	w19, w19, 1
	ldrsh	w4, [x23, x4, lsl 1]
	bl	__printf_chk
	cmp	w19, w22
	bne	.L42
	add	w20, w20, 1
	add	w21, w21, w22
	cmp	w20, w25
	bne	.L41
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldr	x25, [sp, 64]
	.cfi_restore 25
.L39:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
.L51:
	ret
	.cfi_endproc
.LFE41:
	.size	print_matrix, .-print_matrix
	.section	.rodata.str1.8
	.align	3
.LC2:
	.string	"Usage: %s <rows> <cols>\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB42:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x1
	cmp	w0, 2
	ble	.L76
	ldr	x0, [x19, 8]
	mov	w2, 10
	mov	x1, 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -40
	.cfi_offset 21, -48
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	bl	strtol
	mov	x22, x0
	mov	w2, 10
	ldr	x0, [x19, 16]
	mov	x1, 0
	bl	strtol
	mov	x24, x0
	mov	x0, 16
	mul	w23, w24, w22
	mov	x25, x23
	ubfiz	x21, x23, 1, 32
	mov	x1, x21
	bl	aligned_alloc
	mov	x1, x21
	mov	x20, x0
	mov	x0, 16
	bl	aligned_alloc
	mov	x1, x21
	mov	x19, x0
	mov	x0, 16
	bl	aligned_alloc
	mov	x21, x0
	cbz	x23, .L58
	sub	x0, x23, #1
	cmp	x0, 6
	bls	.L64
	adrp	x0, .LC0
	lsr	x1, x23, 3
	movi	v4.4s, 0x8
	mov	x3, 0
	ldr	q1, [x0, #:lo12:.LC0]
	lsl	x1, x1, 4
	movi	v3.4s, 0x4
	.p2align 3,,7
.L60:
	mov	v0.16b, v1.16b
	add	v1.4s, v1.4s, v4.4s
	add	v2.4s, v0.4s, v3.4s
	uzp1	v0.8h, v0.8h, v2.8h
	str	q0, [x20, x3]
	str	q0, [x19, x3]
	add	x3, x3, 16
	cmp	x1, x3
	bne	.L60
	and	x4, x23, -8
	mov	w3, w4
	tst	x25, 7
	beq	.L58
.L59:
	sub	x0, x23, x4
	sub	x1, x0, #1
	cmp	x1, 2
	bls	.L62
	adrp	x2, .LC0
	dup	v0.4s, w3
	lsl	x1, x4, 1
	ldr	q1, [x2, #:lo12:.LC0]
	and	x2, x0, -4
	add	x4, x4, x2
	add	w3, w3, w2
	add	v0.4s, v0.4s, v1.4s
	xtn	v0.4h, v0.4s
	str	d0, [x20, x1]
	str	d0, [x19, x1]
	tst	x0, 3
	beq	.L58
.L62:
	lsl	x4, x4, 1
	add	w1, w3, 1
	sxth	w2, w3
	sxtw	x0, w1
	strh	w2, [x20, x4]
	strh	w2, [x19, x4]
	cmp	x23, w1, sxtw
	bls	.L58
	lsl	x0, x0, 1
	add	w3, w3, 2
	sxth	w1, w1
	strh	w1, [x20, x0]
	strh	w1, [x19, x0]
	cmp	x23, w3, sxtw
	bls	.L58
	add	x0, x0, 2
	sxth	w3, w3
	strh	w3, [x20, x0]
	strh	w3, [x19, x0]
.L58:
	mov	w4, w24
	mov	w3, w22
	mov	x2, x21
	mov	x1, x19
	mov	x0, x20
	bl	add
	mov	w2, w24
	mov	w1, w22
	mov	x0, x21
	bl	print_matrix
	mov	x0, x20
	bl	free
	mov	x0, x19
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 0
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldr	x25, [sp, 64]
	.cfi_restore 25
.L55:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L76:
	.cfi_restore_state
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	adrp	x2, .LC2
	ldr	x3, [x19]
	add	x2, x2, :lo12:.LC2
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	mov	w0, 1
	b	.L55
.L64:
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	mov	w3, 0
	mov	x4, 0
	b	.L59
	.cfi_endproc
.LFE42:
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC0:
	.word	0
	.word	1
	.word	2
	.word	3
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
