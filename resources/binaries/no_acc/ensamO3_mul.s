	.arch armv8-a
	.file	"test_mul.c"
	.text
	.align	2
	.p2align 4,,11
	.global	mul_neon_int16
	.type	mul_neon_int16, %function
mul_neon_int16:
.LFB3939:
	.cfi_startproc
	mov	x6, x0
	mov	x7, x1
	mov	x10, x2
	cbz	w3, .L1
	cbz	w4, .L1
	mov	w1, w4
	mov	w2, 0
	mov	w11, 0
	.p2align 3,,7
.L5:
	mov	w0, w2
	.p2align 3,,7
.L4:
	strh	wzr, [x10, w0, uxtw 1]
	add	w0, w0, 1
	cmp	w1, w0
	bne	.L4
	add	w0, w11, 1
	add	w2, w2, w4
	add	w1, w1, w4
	cmp	w3, w0
	beq	.L19
	mov	w11, w0
	b	.L5
.L1:
	ret
.L19:
	mov	w5, w4
	mov	w9, 0
	mov	w12, 0
	.p2align 3,,7
.L6:
	mov	w8, 0
	.p2align 3,,7
.L10:
	movi	v1.4s, 0
	mov	w2, w8
	mov	w0, w9
	.p2align 3,,7
.L8:
	ldrsh	w1, [x6, w0, uxtw 1]
	ubfiz	x3, x2, 1, 32
	add	w0, w0, 1
	add	w2, w2, w4
	dup	v0.4h, w1
	ldr	d2, [x7, x3]
	smlal	v1.4s, v0.4h, v2.4h
	cmp	w0, w5
	bne	.L8
	sqxtn	v1.4h, v1.4s
	add	w0, w8, w9
	add	w8, w8, 4
	lsl	x0, x0, 1
	str	d1, [x10, x0]
	cmp	w4, w8
	bhi	.L10
	add	w9, w9, w4
	add	w5, w5, w4
	add	w0, w12, 1
	cmp	w11, w12
	beq	.L1
	mov	w12, w0
	b	.L6
	.cfi_endproc
.LFE3939:
	.size	mul_neon_int16, .-mul_neon_int16
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"aligned_alloc failed"
	.align	3
.LC1:
	.string	"C[%d][%d] = %d\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB3940:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x1, 32768
	mov	x0, 16
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	bl	aligned_alloc
	mov	x1, 32768
	mov	x21, x0
	mov	x0, 16
	bl	aligned_alloc
	mov	x20, x0
	mov	x1, 32768
	mov	x0, 16
	bl	aligned_alloc
	cmp	x21, 0
	ccmp	x20, 0, 4, ne
	ccmp	x0, 0, 4, ne
	beq	.L21
	adrp	x2, .LC2
	mov	x19, x0
	mov	x1, x21
	mov	x0, x20
	ldr	q24, [x2, #:lo12:.LC2]
	adrp	x2, .LC3
	mov	w4, 0
	ldr	q23, [x2, #:lo12:.LC3]
	adrp	x2, .LC4
	ldr	q22, [x2, #:lo12:.LC4]
	adrp	x2, .LC5
	ldr	q21, [x2, #:lo12:.LC5]
	adrp	x2, .LC6
	ldr	q20, [x2, #:lo12:.LC6]
	adrp	x2, .LC7
	ldr	q19, [x2, #:lo12:.LC7]
	adrp	x2, .LC8
	ldr	q18, [x2, #:lo12:.LC8]
	adrp	x2, .LC9
	ldr	q17, [x2, #:lo12:.LC9]
	adrp	x2, .LC10
	ldr	q16, [x2, #:lo12:.LC10]
	adrp	x2, .LC11
	ldr	q7, [x2, #:lo12:.LC11]
	adrp	x2, .LC12
	ldr	q6, [x2, #:lo12:.LC12]
	adrp	x2, .LC13
	ldr	q5, [x2, #:lo12:.LC13]
	adrp	x2, .LC14
	ldr	q4, [x2, #:lo12:.LC14]
	adrp	x2, .LC15
	ldr	q3, [x2, #:lo12:.LC15]
	adrp	x2, .LC16
	ldr	q2, [x2, #:lo12:.LC16]
	adrp	x2, .LC17
	ldr	q1, [x2, #:lo12:.LC17]
	.p2align 3,,7
.L22:
	dup	v0.8h, w4
	add	w4, w4, 1
	stp	q24, q23, [x0]
	stp	q22, q21, [x0, 32]
	stp	q0, q0, [x1]
	stp	q0, q0, [x1, 32]
	stp	q20, q19, [x0, 64]
	stp	q0, q0, [x1, 64]
	stp	q18, q17, [x0, 96]
	stp	q0, q0, [x1, 96]
	stp	q16, q7, [x0, 128]
	stp	q0, q0, [x1, 128]
	stp	q6, q5, [x0, 160]
	stp	q0, q0, [x1, 160]
	stp	q4, q3, [x0, 192]
	stp	q0, q0, [x1, 192]
	stp	q2, q1, [x0, 224]
	add	x0, x0, 256
	stp	q0, q0, [x1, 224]
	add	x1, x1, 256
	cmp	w4, 128
	bne	.L22
	mov	w3, w4
	mov	x2, x19
	mov	x1, x20
	mov	x0, x21
	bl	mul_neon_int16
	ldrsh	w4, [x19]
	adrp	x22, .LC1
	add	x22, x22, :lo12:.LC1
	mov	x1, x22
	mov	w3, 0
	mov	w2, 0
	mov	w0, 2
	bl	__printf_chk
	ldrsh	w4, [x19, 2]
	mov	x1, x22
	mov	w3, 1
	mov	w2, 0
	mov	w0, 2
	bl	__printf_chk
	ldrsh	w4, [x19, 256]
	mov	x1, x22
	mov	w3, 0
	mov	w2, 1
	mov	w0, 2
	bl	__printf_chk
	ldrsh	w4, [x19, 258]
	mov	w3, 1
	mov	x1, x22
	mov	w2, w3
	mov	w0, 2
	bl	__printf_chk
	mov	x0, x21
	bl	free
	mov	x0, x20
	bl	free
	mov	x0, x19
	bl	free
	mov	w0, 0
.L20:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L21:
	.cfi_restore_state
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	perror
	mov	w0, 1
	b	.L20
	.cfi_endproc
.LFE3940:
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC2:
	.hword	0
	.hword	1
	.hword	2
	.hword	3
	.hword	4
	.hword	5
	.hword	6
	.hword	7
	.align	4
.LC3:
	.hword	8
	.hword	9
	.hword	10
	.hword	11
	.hword	12
	.hword	13
	.hword	14
	.hword	15
	.align	4
.LC4:
	.hword	16
	.hword	17
	.hword	18
	.hword	19
	.hword	20
	.hword	21
	.hword	22
	.hword	23
	.align	4
.LC5:
	.hword	24
	.hword	25
	.hword	26
	.hword	27
	.hword	28
	.hword	29
	.hword	30
	.hword	31
	.align	4
.LC6:
	.hword	32
	.hword	33
	.hword	34
	.hword	35
	.hword	36
	.hword	37
	.hword	38
	.hword	39
	.align	4
.LC7:
	.hword	40
	.hword	41
	.hword	42
	.hword	43
	.hword	44
	.hword	45
	.hword	46
	.hword	47
	.align	4
.LC8:
	.hword	48
	.hword	49
	.hword	50
	.hword	51
	.hword	52
	.hword	53
	.hword	54
	.hword	55
	.align	4
.LC9:
	.hword	56
	.hword	57
	.hword	58
	.hword	59
	.hword	60
	.hword	61
	.hword	62
	.hword	63
	.align	4
.LC10:
	.hword	64
	.hword	65
	.hword	66
	.hword	67
	.hword	68
	.hword	69
	.hword	70
	.hword	71
	.align	4
.LC11:
	.hword	72
	.hword	73
	.hword	74
	.hword	75
	.hword	76
	.hword	77
	.hword	78
	.hword	79
	.align	4
.LC12:
	.hword	80
	.hword	81
	.hword	82
	.hword	83
	.hword	84
	.hword	85
	.hword	86
	.hword	87
	.align	4
.LC13:
	.hword	88
	.hword	89
	.hword	90
	.hword	91
	.hword	92
	.hword	93
	.hword	94
	.hword	95
	.align	4
.LC14:
	.hword	96
	.hword	97
	.hword	98
	.hword	99
	.hword	100
	.hword	101
	.hword	102
	.hword	103
	.align	4
.LC15:
	.hword	104
	.hword	105
	.hword	106
	.hword	107
	.hword	108
	.hword	109
	.hword	110
	.hword	111
	.align	4
.LC16:
	.hword	112
	.hword	113
	.hword	114
	.hword	115
	.hword	116
	.hword	117
	.hword	118
	.hword	119
	.align	4
.LC17:
	.hword	120
	.hword	121
	.hword	122
	.hword	123
	.hword	124
	.hword	125
	.hword	126
	.hword	127
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
