	.arch armv8-a
	.file	"test.c"
	.text
	.align	2
	.p2align 4,,11
	.global	add
	.type	add, %function
add:
.LFB39:
	.cfi_startproc
	cbz	w3, .L1
	cbz	w4, .L1
	mov	w9, w4
	mov	w11, 0
	mov	w10, 0
	.p2align 3,,7
.L3:
	mov	w5, w11
	.p2align 3,,7
.L4:
	ubfiz	x6, x5, 1, 32
	add	w5, w5, 1
	ldrh	w7, [x0, x6]
	ldrh	w8, [x1, x6]
	add	w7, w7, w8
	strh	w7, [x2, x6]
	cmp	w9, w5
	bne	.L4
	add	w10, w10, 1
	add	w11, w11, w4
	add	w9, w9, w4
	cmp	w10, w3
	bne	.L3
.L1:
	ret
	.cfi_endproc
.LFE39:
	.size	add, .-add
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"C[%d][%d] = %d\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB40:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x0, 32768
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	bl	malloc
	mov	x20, x0
	mov	x0, 32768
	bl	malloc
	mov	x19, x0
	mov	x0, 32768
	bl	malloc
	mov	x21, x0
	adrp	x5, .LC6
	adrp	x0, .LC2
	adrp	x1, .LC1
	adrp	x2, .LC5
	ldr	q19, [x5, #:lo12:.LC6]
	adrp	x5, .LC7
	ldr	q23, [x0, #:lo12:.LC2]
	adrp	x0, .LC3
	ldr	q18, [x5, #:lo12:.LC7]
	adrp	x5, .LC8
	ldr	q22, [x0, #:lo12:.LC3]
	adrp	x0, .LC4
	ldr	q17, [x5, #:lo12:.LC8]
	adrp	x5, .LC9
	ldr	q24, [x1, #:lo12:.LC1]
	mov	x3, x19
	ldr	q16, [x5, #:lo12:.LC9]
	adrp	x5, .LC10
	ldr	q21, [x0, #:lo12:.LC4]
	mov	x1, x19
	ldr	q7, [x5, #:lo12:.LC10]
	adrp	x5, .LC11
	mov	x4, x20
	mov	x0, x20
	ldr	q6, [x5, #:lo12:.LC11]
	adrp	x5, .LC12
	ldr	q20, [x2, #:lo12:.LC5]
	mov	w2, 0
	ldr	q5, [x5, #:lo12:.LC12]
	adrp	x5, .LC13
	ldr	q4, [x5, #:lo12:.LC13]
	adrp	x5, .LC14
	ldr	q3, [x5, #:lo12:.LC14]
	adrp	x5, .LC15
	ldr	q2, [x5, #:lo12:.LC15]
	adrp	x5, .LC16
	ldr	q1, [x5, #:lo12:.LC16]
	.p2align 3,,7
.L14:
	dup	v0.8h, w2
	add	w2, w2, 1
	stp	q24, q23, [x1]
	stp	q22, q21, [x1, 32]
	stp	q0, q0, [x0]
	stp	q0, q0, [x0, 32]
	stp	q0, q0, [x0, 64]
	stp	q20, q19, [x1, 64]
	stp	q0, q0, [x0, 96]
	stp	q18, q17, [x1, 96]
	stp	q0, q0, [x0, 128]
	stp	q16, q7, [x1, 128]
	stp	q0, q0, [x0, 160]
	stp	q6, q5, [x1, 160]
	stp	q0, q0, [x0, 192]
	stp	q4, q3, [x1, 192]
	stp	q0, q0, [x0, 224]
	add	x0, x0, 256
	stp	q2, q1, [x1, 224]
	add	x1, x1, 256
	cmp	w2, 128
	bne	.L14
	add	x20, x20, 32768
	mov	x0, x21
.L15:
	ldp	q29, q28, [x3]
	ldp	q18, q17, [x4]
	ldp	q16, q7, [x3, 32]
	ldp	q27, q26, [x4, 32]
	ldp	q25, q24, [x3, 64]
	ldp	q6, q5, [x4, 64]
	ldp	q23, q22, [x3, 96]
	ldp	q4, q3, [x4, 96]
	ldp	q21, q20, [x3, 128]
	ldp	q2, q1, [x4, 128]
	ldr	q19, [x3, 160]
	ldr	q0, [x4, 160]
	add	v17.8h, v17.8h, v28.8h
	add	v16.8h, v16.8h, v27.8h
	add	v7.8h, v7.8h, v26.8h
	add	v6.8h, v6.8h, v25.8h
	add	v5.8h, v5.8h, v24.8h
	add	v4.8h, v4.8h, v23.8h
	add	v3.8h, v3.8h, v22.8h
	stp	q16, q7, [x0, 32]
	add	v2.8h, v2.8h, v21.8h
	stp	q6, q5, [x0, 64]
	add	v1.8h, v1.8h, v20.8h
	stp	q4, q3, [x0, 96]
	add	v18.8h, v18.8h, v29.8h
	add	v0.8h, v0.8h, v19.8h
	stp	q2, q1, [x0, 128]
	stp	q18, q17, [x0]
	str	q0, [x0, 160]
	ldp	q17, q16, [x3, 176]
	ldp	q4, q3, [x4, 176]
	ldp	q7, q6, [x3, 208]
	add	x3, x3, 256
	ldr	q0, [x3, -16]
	ldp	q2, q1, [x4, 208]
	add	x4, x4, 256
	ldr	q5, [x4, -16]
	add	v4.8h, v4.8h, v17.8h
	add	v3.8h, v3.8h, v16.8h
	add	v2.8h, v2.8h, v7.8h
	add	v1.8h, v1.8h, v6.8h
	add	v0.8h, v0.8h, v5.8h
	stp	q4, q3, [x0, 176]
	stp	q2, q1, [x0, 208]
	add	x0, x0, 256
	str	q0, [x0, -16]
	cmp	x4, x20
	bne	.L15
	adrp	x22, .LC0
	add	x22, x22, :lo12:.LC0
	mov	w20, 0
.L16:
	mov	x19, 0
	.p2align 3,,7
.L17:
	ldrsh	w4, [x21, x19, lsl 1]
	mov	w3, w19
	mov	w2, w20
	mov	x1, x22
	mov	w0, 2
	add	x19, x19, 1
	bl	__printf_chk
	cmp	x19, 128
	bne	.L17
	add	w20, w20, 1
	add	x21, x21, 256
	cmp	w20, 128
	bne	.L16
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE40:
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC1:
	.hword	0
	.hword	1
	.hword	2
	.hword	3
	.hword	4
	.hword	5
	.hword	6
	.hword	7
	.align	4
.LC2:
	.hword	8
	.hword	9
	.hword	10
	.hword	11
	.hword	12
	.hword	13
	.hword	14
	.hword	15
	.align	4
.LC3:
	.hword	16
	.hword	17
	.hword	18
	.hword	19
	.hword	20
	.hword	21
	.hword	22
	.hword	23
	.align	4
.LC4:
	.hword	24
	.hword	25
	.hword	26
	.hword	27
	.hword	28
	.hword	29
	.hword	30
	.hword	31
	.align	4
.LC5:
	.hword	32
	.hword	33
	.hword	34
	.hword	35
	.hword	36
	.hword	37
	.hword	38
	.hword	39
	.align	4
.LC6:
	.hword	40
	.hword	41
	.hword	42
	.hword	43
	.hword	44
	.hword	45
	.hword	46
	.hword	47
	.align	4
.LC7:
	.hword	48
	.hword	49
	.hword	50
	.hword	51
	.hword	52
	.hword	53
	.hword	54
	.hword	55
	.align	4
.LC8:
	.hword	56
	.hword	57
	.hword	58
	.hword	59
	.hword	60
	.hword	61
	.hword	62
	.hword	63
	.align	4
.LC9:
	.hword	64
	.hword	65
	.hword	66
	.hword	67
	.hword	68
	.hword	69
	.hword	70
	.hword	71
	.align	4
.LC10:
	.hword	72
	.hword	73
	.hword	74
	.hword	75
	.hword	76
	.hword	77
	.hword	78
	.hword	79
	.align	4
.LC11:
	.hword	80
	.hword	81
	.hword	82
	.hword	83
	.hword	84
	.hword	85
	.hword	86
	.hword	87
	.align	4
.LC12:
	.hword	88
	.hword	89
	.hword	90
	.hword	91
	.hword	92
	.hword	93
	.hword	94
	.hword	95
	.align	4
.LC13:
	.hword	96
	.hword	97
	.hword	98
	.hword	99
	.hword	100
	.hword	101
	.hword	102
	.hword	103
	.align	4
.LC14:
	.hword	104
	.hword	105
	.hword	106
	.hword	107
	.hword	108
	.hword	109
	.hword	110
	.hword	111
	.align	4
.LC15:
	.hword	112
	.hword	113
	.hword	114
	.hword	115
	.hword	116
	.hword	117
	.hword	118
	.hword	119
	.align	4
.LC16:
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
