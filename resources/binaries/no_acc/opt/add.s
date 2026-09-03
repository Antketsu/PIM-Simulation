	.arch armv8-a
	.file	"add.c"
	.text
	.align	2
	.p2align 4,,11
	.global	add
	.type	add, %function
add:
.LFB3939:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	w19, w3
	mov	x20, x2
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	mov	w23, w4
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	mov	x21, x1
	mov	x0, 0
	mov	x1, 0
	bl	m5_work_begin
	mul	w6, w19, w23
	cmp	w6, 7
	bls	.L2
	mov	w4, 8
	.p2align 3,,7
.L3:
	sub	w3, w4, #8
	mov	w5, w4
	add	w4, w4, 8
	lsl	x3, x3, 1
	ldr	q0, [x22, x3]
	ldr	q1, [x21, x3]
	add	v0.8h, v0.8h, v1.8h
	str	q0, [x20, x3]
	cmp	w4, w6
	bls	.L3
	cmp	w6, w5
	bls	.L6
	sub	w0, w6, w5
	sub	w1, w0, #1
	cmp	w1, 6
	bls	.L11
	ubfiz	x3, x5, 1, 32
	and	w2, w0, -8
	add	w1, w5, w2
	ldr	q0, [x21, x3]
	ldr	q1, [x22, x3]
	add	v0.8h, v0.8h, v1.8h
	str	q0, [x20, x3]
	tst	x0, 7
	beq	.L6
.L5:
	sub	w0, w0, w2
	sub	w3, w0, #1
	cmp	w3, 2
	bls	.L8
	add	x5, x2, w5, uxtw
	lsl	x5, x5, 1
	ldr	d0, [x22, x5]
	ldr	d1, [x21, x5]
	add	v0.4h, v0.4h, v1.4h
	str	d0, [x20, x5]
	tst	x0, 3
	beq	.L6
	and	w0, w0, -4
	add	w1, w1, w0
.L8:
	ubfiz	x2, x1, 1, 32
	add	w0, w1, 1
	ldrh	w3, [x22, x2]
	ldrh	w4, [x21, x2]
	add	w3, w3, w4
	strh	w3, [x20, x2]
	cmp	w6, w0
	bls	.L6
	ubfiz	x0, x0, 1, 32
	add	w1, w1, 2
	ldrh	w2, [x21, x0]
	ldrh	w3, [x22, x0]
	add	w2, w2, w3
	strh	w2, [x20, x0]
	cmp	w6, w1
	bls	.L6
	ubfiz	x1, x1, 1, 32
	ldrh	w0, [x22, x1]
	ldrh	w2, [x21, x1]
	add	w0, w0, w2
	strh	w0, [x20, x1]
.L6:
	ldp	x19, x20, [sp, 16]
	mov	x1, 0
	ldp	x21, x22, [sp, 32]
	mov	x0, 0
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	m5_work_end
	.p2align 2,,3
.L2:
	.cfi_restore_state
	cbz	w6, .L6
	mov	w0, w6
	mov	w5, 0
	mov	x2, 0
	mov	w1, 0
	b	.L5
.L11:
	mov	w1, w5
	mov	x2, 0
	b	.L5
	.cfi_endproc
.LFE3939:
	.size	add, .-add
	.align	2
	.p2align 4,,11
	.global	init_matrix
	.type	init_matrix, %function
init_matrix:
.LFB3940:
	.cfi_startproc
	cbz	w2, .L22
	mov	w9, w3
	mov	w11, 0
	mov	w10, 0
	cbz	w3, .L22
	.p2align 3,,7
.L24:
	and	w5, w10, 65535
	mov	w4, w11
	.p2align 3,,7
.L26:
	ubfiz	x6, x4, 1, 32
	ubfiz	w7, w5, 1, 15
	add	w8, w5, 1
	add	w4, w4, 1
	strh	w5, [x0, x6]
	and	w5, w8, 65535
	strh	w7, [x1, x6]
	cmp	w4, w9
	bne	.L26
	add	w10, w10, 1
	add	w11, w11, w3
	add	w9, w9, w3
	cmp	w2, w10
	bne	.L24
.L22:
	ret
	.cfi_endproc
.LFE3940:
	.size	init_matrix, .-init_matrix
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"C[%d][%d] = %d\n"
	.text
	.align	2
	.p2align 4,,11
	.global	print_matrix
	.type	print_matrix, %function
print_matrix:
.LFB3941:
	.cfi_startproc
	cbz	w1, .L45
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	w20, 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	w22, w2
	mov	w21, 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	adrp	x24, .LC0
	mov	x23, x0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	add	x24, x24, :lo12:.LC0
	mov	w25, w1
	cbz	w2, .L34
	.p2align 3,,7
.L36:
	mov	w19, 0
	.p2align 3,,7
.L37:
	add	w4, w19, w21
	mov	w3, w19
	mov	w2, w20
	mov	x1, x24
	mov	w0, 2
	add	w19, w19, 1
	ldrsh	w4, [x23, x4, lsl 1]
	bl	__printf_chk
	cmp	w22, w19
	bne	.L37
	add	w20, w20, 1
	add	w21, w21, w22
	cmp	w25, w20
	bne	.L36
.L34:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L45:
	ret
	.cfi_endproc
.LFE3941:
	.size	print_matrix, .-print_matrix
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"Usage: %s <rows> <cols>\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB3942:
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
	ble	.L59
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
	mov	x25, x0
	mov	w24, w0
	ldr	x0, [x19, 16]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
	mov	x23, x0
	mov	x0, 16
	mov	w22, w23
	mul	w19, w23, w25
	lsl	x19, x19, 1
	mov	x1, x19
	bl	aligned_alloc
	mov	x1, x19
	mov	x20, x0
	mov	x0, 16
	bl	aligned_alloc
	mov	x1, x19
	mov	x19, x0
	mov	x0, 16
	bl	aligned_alloc
	mov	x21, x0
	cbz	w25, .L51
	cbz	w23, .L51
	mov	w6, w23
	mov	w8, 0
	mov	w7, 0
	.p2align 3,,7
.L52:
	and	w2, w7, 65535
	mov	w1, w8
	.p2align 3,,7
.L54:
	ubfiz	x3, x1, 1, 32
	ubfiz	w4, w2, 1, 15
	add	w5, w2, 1
	add	w1, w1, 1
	strh	w2, [x20, x3]
	and	w2, w5, 65535
	strh	w4, [x19, x3]
	cmp	w1, w6
	bne	.L54
	add	w7, w7, 1
	add	w8, w8, w22
	add	w6, w6, w22
	cmp	w24, w7
	bne	.L52
.L51:
	mov	w4, w23
	mov	w3, w25
	mov	x2, x21
	mov	x1, x19
	mov	x0, x20
	bl	add
	mov	w2, w23
	mov	w1, w25
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
.L48:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L59:
	.cfi_restore_state
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	adrp	x2, .LC1
	ldr	x3, [x19]
	add	x2, x2, :lo12:.LC1
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	mov	w0, 1
	b	.L48
	.cfi_endproc
.LFE3942:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
