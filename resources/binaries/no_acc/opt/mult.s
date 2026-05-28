	.arch armv8-a
	.file	"mult.c"
	.text
	.align	2
	.p2align 4,,11
	.global	mult
	.type	mult, %function
mult:
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
	mov	x19, x2
	mov	w20, w5
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	mov	x21, x1
	mov	x0, 0
	mov	x1, 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	mov	w24, w3
	mov	w23, w4
	bl	m5_work_begin
	cbz	w24, .L2
	cbz	w23, .L2
	cbz	w20, .L2
	mov	w6, w23
	mov	w8, 0
	mov	w4, 0
	mov	w7, 0
	.p2align 3,,7
.L3:
	mov	w5, w8
	mov	w3, 0
	.p2align 3,,7
.L5:
	ldrsh	w1, [x22, w5, uxtw 1]
	mov	w0, 0
	dup	v2.8h, w1
	.p2align 3,,7
.L4:
	add	w1, w0, w4
	add	w2, w0, w3
	add	w0, w0, 8
	lsl	x1, x1, 1
	lsl	x2, x2, 1
	ldr	q0, [x19, x1]
	ldr	q1, [x21, x2]
	mla	v0.8h, v2.8h, v1.8h
	str	q0, [x19, x1]
	cmp	w20, w0
	bhi	.L4
	add	w5, w5, 1
	add	w3, w3, w20
	cmp	w5, w6
	bne	.L5
	add	w7, w7, 1
	add	w6, w6, w23
	add	w4, w4, w20
	add	w8, w8, w23
	cmp	w24, w7
	bne	.L3
.L2:
	ldp	x19, x20, [sp, 16]
	mov	x1, 0
	ldp	x21, x22, [sp, 32]
	mov	x0, 0
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	m5_work_end
	.cfi_endproc
.LFE3939:
	.size	mult, .-mult
	.align	2
	.p2align 4,,11
	.global	init_matrix
	.type	init_matrix, %function
init_matrix:
.LFB3940:
	.cfi_startproc
	cbz	w2, .L18
	mov	w6, w3
	mov	w9, 0
	mov	w8, 1
	cbz	w3, .L17
	.p2align 3,,7
.L19:
	sxth	w7, w8
	mov	w5, w9
	.p2align 3,,7
.L21:
	strh	w7, [x0, w5, uxtw 1]
	add	w5, w5, 1
	cmp	w6, w5
	bne	.L21
	add	w9, w9, w3
	add	w6, w6, w3
	add	w5, w8, 1
	cmp	w2, w8
	beq	.L22
	mov	w8, w5
	b	.L19
.L18:
	cbz	w3, .L17
	.p2align 3,,7
.L22:
	cbz	w4, .L17
	mov	w7, 0
	mov	w6, 0
	.p2align 3,,7
.L24:
	mov	w0, 0
	.p2align 3,,7
.L25:
	add	w2, w0, w7
	cmp	w6, w0
	cset	w5, eq
	add	w0, w0, 1
	strh	w5, [x1, x2, lsl 1]
	cmp	w0, w4
	bne	.L25
	add	w6, w6, 1
	add	w7, w7, w4
	cmp	w6, w3
	bne	.L24
.L17:
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
	cbz	w1, .L49
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	w22, w2
	cbz	w2, .L37
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	adrp	x24, .LC0
	mov	x23, x0
	add	x24, x24, :lo12:.LC0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	mov	w25, w1
	mov	w21, 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -56
	.cfi_offset 19, -64
	mov	w20, 0
	.p2align 3,,7
.L39:
	mov	w19, 0
	.p2align 3,,7
.L40:
	add	w4, w19, w21
	mov	w3, w19
	mov	w2, w20
	mov	x1, x24
	mov	w0, 2
	add	w19, w19, 1
	ldrsh	w4, [x23, x4, lsl 1]
	bl	__printf_chk
	cmp	w19, w22
	bne	.L40
	add	w20, w20, 1
	add	w21, w21, w22
	cmp	w20, w25
	bne	.L39
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldr	x25, [sp, 64]
	.cfi_restore 25
.L37:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
.L49:
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
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x1
	cmp	w0, 2
	ble	.L57
	ldr	x0, [x19, 8]
	mov	w2, 10
	mov	x1, 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -24
	.cfi_offset 21, -32
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -8
	.cfi_offset 23, -16
	bl	strtol
	mov	x20, x0
	ldr	x0, [x19, 16]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
	mov	x21, x0
	ldr	x0, [x19, 24]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
	mov	x19, x0
	mul	w1, w21, w20
	mov	x0, 16
	lsl	x1, x1, 1
	bl	aligned_alloc
	mul	w1, w19, w21
	mov	x23, x0
	mov	x0, 16
	lsl	x1, x1, 1
	bl	aligned_alloc
	mul	w1, w19, w20
	mov	x24, x0
	mov	x0, 16
	lsl	x1, x1, 1
	bl	aligned_alloc
	mov	x1, x24
	mov	x22, x0
	mov	w3, w21
	mov	x0, x23
	mov	w4, w19
	mov	w2, w20
	bl	init_matrix
	mov	w4, w21
	mov	w5, w19
	mov	w3, w20
	mov	x2, x22
	mov	x0, x23
	bl	mult
	mov	w2, w19
	mov	w1, w20
	mov	x0, x22
	bl	print_matrix
	mov	x0, x23
	bl	free
	mov	x0, x24
	bl	free
	mov	x0, x22
	bl	free
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 0
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
.L53:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L57:
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
	b	.L53
	.cfi_endproc
.LFE3942:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
