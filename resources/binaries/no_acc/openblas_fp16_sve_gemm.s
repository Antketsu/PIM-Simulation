	.arch armv8.2-a+crc+sve
	.file	"openblas_fp16_sve_gemm.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"%s must be a positive integer (got '%s')\n"
	.text
	.align	2
	.p2align 4,,11
	.type	parse_dimension, %function
parse_dimension:
.LFB77:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	adrp	x4, :got:__stack_chk_guard
	ldr	x4, [x4, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 16]
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	stp	x21, x22, [sp, 48]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x1
	mov	x22, x2
	ldr	x0, [x4]
	str	x0, [sp, 8]
	mov	x0, 0
	bl	__errno_location
	mov	x20, x0
	mov	x1, sp
	mov	x0, x19
	mov	w2, 10
	str	wzr, [x20]
	bl	strtol
	ldr	w3, [x20]
	cbnz	w3, .L2
	mov	x1, x0
	ldrb	w0, [x19]
	cbz	w0, .L2
	ldr	x0, [sp]
	ldrb	w0, [x0]
	cbnz	w0, .L2
	sub	x2, x1, #1
	mov	x0, 2147483646
	cmp	x2, x0
	bhi	.L2
	mov	w0, 1
	str	w1, [x22]
	b	.L1
	.p2align 2,,3
.L2:
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	mov	x4, x19
	mov	x3, x21
	adrp	x2, .LC0
	mov	w1, 2
	add	x2, x2, :lo12:.LC0
	ldr	x0, [x0]
	bl	__fprintf_chk
	mov	w0, 0
.L1:
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 8]
	ldr	x2, [x1]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L11
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	add	sp, sp, 64
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L11:
	.cfi_restore_state
	bl	__stack_chk_fail
	.cfi_endproc
.LFE77:
	.size	parse_dimension, .-parse_dimension
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"Usage: %s M N K\n"
	.align	3
.LC2:
	.string	"Computes C[MxN] = A[MxK] * B[KxN].\n"
	.align	3
.LC3:
	.string	"M"
	.align	3
.LC4:
	.string	"N"
	.align	3
.LC5:
	.string	"K"
	.align	3
.LC6:
	.string	"matrix dimensions are too large\n"
	.align	3
.LC7:
	.string	"matrix allocation failed for %dx%dx%d\n"
	.align	3
.LC8:
	.string	"OpenBLAS core: %s\n"
	.align	3
.LC9:
	.string	"C[%dx%d] = A[%dx%d] * B[%dx%d], with all inputs equal to 1.0\n"
	.align	3
.LC10:
	.string	"C[0] = %8.3f, expected %8.3f\n"
	.align	3
.LC11:
	.string	"result mismatch at %zu: got %g, expected %g\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB78:
	.cfi_startproc
	sub	sp, sp, #176
	.cfi_def_cfa_offset 176
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 64
	stp	x19, x20, [sp, 80]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x19, x1
	ldr	x1, [x2]
	str	x1, [sp, 56]
	mov	x1, 0
	cmp	w0, 4
	bne	.L15
	ldr	x0, [x19, 8]
	adrp	x1, .LC3
	add	x2, sp, 44
	add	x1, x1, :lo12:.LC3
	bl	parse_dimension
	cbnz	w0, .L51
.L15:
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	mov	w1, 2
	ldr	x3, [x19]
	mov	x19, x0
	ldr	x0, [x0]
	adrp	x2, .LC1
	add	x2, x2, :lo12:.LC1
	bl	__fprintf_chk
	ldr	x3, [x19]
	adrp	x0, .LC2
	mov	x2, 35
	add	x0, x0, :lo12:.LC2
	mov	x1, 1
	bl	fwrite
.L14:
	mov	w0, 1
.L12:
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x1]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L52
	ldp	x29, x30, [sp, 64]
	ldp	x19, x20, [sp, 80]
	add	sp, sp, 176
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L51:
	.cfi_restore_state
	ldr	x0, [x19, 16]
	adrp	x1, .LC4
	add	x2, sp, 48
	add	x1, x1, :lo12:.LC4
	bl	parse_dimension
	cbz	w0, .L15
	ldr	x0, [x19, 24]
	adrp	x1, .LC5
	add	x2, sp, 52
	add	x1, x1, :lo12:.LC5
	bl	parse_dimension
	cbz	w0, .L15
	ldr	w20, [sp, 52]
	stp	x25, x26, [sp, 128]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	ldr	w26, [sp, 44]
	sxtw	x0, w20
	sxtw	x1, w26
	umulh	x2, x1, x0
	cbnz	x2, .L18
	stp	x27, x28, [sp, 144]
	.cfi_offset 28, -24
	.cfi_offset 27, -32
	ldr	w27, [sp, 48]
	sxtw	x2, w27
	umulh	x0, x0, x2
	cbnz	x0, .L49
	umulh	x1, x1, x2
	cmp	x1, 0
	cset	x19, ne
	beq	.L23
.L49:
	ldp	x27, x28, [sp, 144]
	.cfi_restore 28
	.cfi_restore 27
.L18:
	adrp	x0, .LC6
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	add	x0, x0, :lo12:.LC6
	mov	x2, 32
	mov	x1, 1
	ldr	x3, [x3]
	bl	fwrite
	ldp	x25, x26, [sp, 128]
	.cfi_restore 26
	.cfi_restore 25
	b	.L14
.L23:
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	stp	x23, x24, [sp, 112]
	.cfi_offset 24, -56
	.cfi_offset 23, -64
	smull	x24, w26, w20
	smull	x23, w20, w27
	stp	x21, x22, [sp, 96]
	.cfi_offset 22, -72
	.cfi_offset 21, -80
	smull	x22, w26, w27
	lsl	x0, x24, 1
	bl	malloc
	mov	x28, x0
	lsl	x0, x23, 1
	bl	malloc
	mov	x1, 4
	mov	x25, x0
	mov	x0, x22
	bl	calloc
	cmp	x28, 0
	mov	x21, x0
	ccmp	x25, 0, 4, ne
	mov	x1, 0
	ccmp	x0, 0, 4, ne
	fmov	h0, 1.0e+0
	beq	.L53
	stp	d8, d9, [sp, 160]
	.cfi_offset 73, -8
	.cfi_offset 72, -16
	b	.L25
.L26:
	str	h0, [x28, x1, lsl 1]
	add	x1, x1, 1
.L25:
	cmp	x1, x24
	bne	.L26
	mov	x1, 0
	fmov	h0, 1.0e+0
	b	.L27
.L28:
	str	h0, [x25, x1, lsl 1]
	add	x1, x1, 1
.L27:
	cmp	x1, x23
	bne	.L28
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	str	x25, [sp]
	movi	v1.2s, #0
	fmov	s0, 1.0e+0
	str	w27, [sp, 8]
	mov	w7, w20
	str	x21, [sp, 16]
	mov	x6, x28
	str	w27, [sp, 24]
	mov	w5, w20
	mov	w4, w27
	mov	w3, w26
	mov	w2, 111
	mov	w0, 101
	mov	w1, w2
	bl	cblas_shgemm
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	bl	openblas_get_corename
	mov	x2, x0
	adrp	x1, .LC8
	mov	w0, 2
	add	x1, x1, :lo12:.LC8
	bl	__printf_chk
	mov	w7, w27
	mov	w3, w27
	mov	w6, w20
	mov	w5, w20
	mov	w4, w26
	mov	w2, w26
	adrp	x1, .LC9
	mov	w0, 2
	add	x1, x1, :lo12:.LC9
	bl	__printf_chk
	scvtf	s8, w20
	ldr	s0, [x21]
	adrp	x1, .LC10
	mov	w0, 2
	add	x1, x1, :lo12:.LC10
	fcvt	d0, s0
	fcvt	d9, s8
	fmov	d1, d9
	bl	__printf_chk
	b	.L29
.L31:
	ldr	s0, [x21, x19, lsl 2]
	fcmp	s8, s0
	bne	.L54
	add	x19, x19, 1
.L29:
	cmp	x19, x22
	bne	.L31
	mov	x0, x28
	bl	free
	mov	x0, x25
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 96]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 0
	ldp	x23, x24, [sp, 112]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 128]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 144]
	.cfi_restore 28
	.cfi_restore 27
	ldp	d8, d9, [sp, 160]
	.cfi_restore 73
	.cfi_restore 72
	b	.L12
.L54:
	.cfi_restore_state
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	fmov	d1, d9
	fcvt	d0, s0
	mov	x3, x19
	adrp	x2, .LC11
	add	x2, x2, :lo12:.LC11
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	mov	x0, x28
	bl	free
	mov	x0, x25
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 96]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 112]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 128]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 144]
	.cfi_restore 28
	.cfi_restore 27
	ldp	d8, d9, [sp, 160]
	.cfi_restore 73
	.cfi_restore 72
	b	.L14
.L52:
	stp	x21, x22, [sp, 96]
	.cfi_offset 22, -72
	.cfi_offset 21, -80
	stp	x23, x24, [sp, 112]
	.cfi_offset 24, -56
	.cfi_offset 23, -64
	stp	x25, x26, [sp, 128]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	stp	x27, x28, [sp, 144]
	.cfi_offset 28, -24
	.cfi_offset 27, -32
	stp	d8, d9, [sp, 160]
	.cfi_offset 73, -8
	.cfi_offset 72, -16
	bl	__stack_chk_fail
.L53:
	.cfi_restore 72
	.cfi_restore 73
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	mov	w4, w27
	mov	w3, w26
	mov	w5, w20
	adrp	x2, .LC7
	add	x2, x2, :lo12:.LC7
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	mov	x0, x28
	bl	free
	mov	x0, x25
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 96]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 112]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 128]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 144]
	.cfi_restore 28
	.cfi_restore 27
	b	.L14
	.cfi_endproc
.LFE78:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
