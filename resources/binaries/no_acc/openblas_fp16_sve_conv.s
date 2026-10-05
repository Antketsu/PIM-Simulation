	.arch armv8.2-a+crc+sve
	.file	"openblas_fp16_sve_conv.c"
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
	.string	"Usage: %s input_height input_width input_channels kernel_height kernel_width output_channels [print_result]\n"
	.align	3
.LC2:
	.string	"input_height"
	.align	3
.LC3:
	.string	"input_width"
	.align	3
.LC4:
	.string	"input_channels"
	.align	3
.LC5:
	.string	"kernel_height"
	.align	3
.LC6:
	.string	"kernel_width"
	.align	3
.LC7:
	.string	"output_channels"
	.align	3
.LC8:
	.string	"kernel dimensions must fit inside the input\n"
	.align	3
.LC9:
	.string	"convolution dimensions are too large\n"
	.align	3
.LC10:
	.string	"convolution buffers are too large\n"
	.align	3
.LC11:
	.string	"convolution buffer allocation failed\n"
	.align	3
.LC12:
	.string	"OpenBLAS core: %s\n"
	.align	3
.LC13:
	.string	"Valid stride-1 convolution: input %dx%dx%d, kernel %dx%dx%d, output %dx%dx%d\n"
	.align	3
.LC14:
	.string	"C[%d][%d] = %.0f\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB78:
	.cfi_startproc
	sub	sp, sp, #224
	.cfi_def_cfa_offset 224
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 128]
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 128
	stp	x19, x20, [sp, 144]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	w20, w0
	sub	w0, w0, #7
	ldr	x3, [x2]
	str	x3, [sp, 120]
	mov	x3, 0
	mov	x19, x1
	cmp	w0, 1
	bhi	.L15
	ldr	x0, [x19, 8]
	adrp	x1, .LC2
	add	x2, sp, 96
	add	x1, x1, :lo12:.LC2
	bl	parse_dimension
	cbnz	w0, .L92
.L15:
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	adrp	x2, .LC1
	ldr	x3, [x19]
	add	x2, x2, :lo12:.LC1
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
.L14:
	mov	w0, 1
.L12:
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 120]
	ldr	x2, [x1]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L93
	ldp	x29, x30, [sp, 128]
	ldp	x19, x20, [sp, 144]
	add	sp, sp, 224
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L92:
	.cfi_restore_state
	ldr	x0, [x19, 16]
	adrp	x1, .LC3
	add	x2, sp, 100
	add	x1, x1, :lo12:.LC3
	bl	parse_dimension
	cbz	w0, .L15
	ldr	x0, [x19, 24]
	adrp	x1, .LC4
	add	x2, sp, 104
	add	x1, x1, :lo12:.LC4
	bl	parse_dimension
	cbz	w0, .L15
	ldr	x0, [x19, 32]
	adrp	x1, .LC5
	add	x2, sp, 108
	add	x1, x1, :lo12:.LC5
	bl	parse_dimension
	cbz	w0, .L15
	ldr	x0, [x19, 40]
	adrp	x1, .LC6
	add	x2, sp, 112
	add	x1, x1, :lo12:.LC6
	bl	parse_dimension
	cbz	w0, .L15
	ldr	x0, [x19, 48]
	adrp	x1, .LC7
	add	x2, sp, 116
	add	x1, x1, :lo12:.LC7
	bl	parse_dimension
	cbz	w0, .L15
	stp	x25, x26, [sp, 192]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
	cmp	w20, 8
	beq	.L94
	mov	w0, 1
	str	w0, [sp, 40]
.L16:
	ldr	w25, [sp, 96]
	ldr	w8, [sp, 108]
	cmp	w8, w25
	bgt	.L17
	ldr	w26, [sp, 112]
	stp	x23, x24, [sp, 176]
	.cfi_offset 24, -40
	.cfi_offset 23, -48
	ldr	w24, [sp, 100]
	cmp	w26, w24
	bgt	.L95
	mov	w0, 2147483647
	sdiv	w1, w0, w26
	cmp	w8, w1
	bgt	.L19
	ldr	w19, [sp, 104]
	mul	w7, w8, w26
	sdiv	w1, w0, w19
	cmp	w7, w1
	bgt	.L19
	sub	w1, w24, w26
	sub	w2, w25, w8
	stp	w2, w1, [sp, 56]
	add	w1, w1, 1
	add	w2, w2, 1
	str	w1, [sp, 32]
	str	w2, [sp, 44]
	udiv	w0, w0, w1
	cmp	w0, w2
	blt	.L19
	sxtw	x0, w25
	sxtw	x1, w24
	umulh	x0, x0, x1
	cbnz	x0, .L23
	smull	x1, w25, w24
	sxtw	x12, w19
	umulh	x0, x1, x12
	cbnz	x0, .L23
	mul	w7, w7, w19
	stp	x21, x22, [sp, 160]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	ldr	w22, [sp, 116]
	sxtw	x2, w7
	sxtw	x0, w22
	umulh	x3, x0, x2
	cbnz	x3, .L88
	ldr	w3, [sp, 44]
	ldr	w4, [sp, 32]
	stp	x27, x28, [sp, 208]
	.cfi_offset 28, -8
	.cfi_offset 27, -16
	mul	w27, w3, w4
	sxtw	x3, w27
	str	x3, [sp, 48]
	umulh	x2, x2, x3
	cbnz	x2, .L90
	umulh	x0, x0, x3
	cbnz	x0, .L90
	mul	x1, x1, x12
	mov	x3, 4611686018427387903
	smull	x2, w22, w7
	smull	x21, w7, w27
	orr	x0, x1, x2
	smull	x28, w22, w27
	orr	x0, x0, x21
	cmp	x0, 0
	ccmp	x28, x3, 2, ge
	bhi	.L90
	lsl	x0, x1, 1
	stp	x2, x1, [sp, 64]
	stp	w8, w7, [sp, 80]
	str	x12, [sp, 88]
	bl	malloc
	ldr	x2, [sp, 64]
	mov	x23, x0
	lsl	x0, x2, 1
	bl	malloc
	mov	x20, x0
	lsl	x0, x21, 1
	bl	malloc
	mov	x3, x0
	lsl	x0, x28, 2
	mov	x28, x3
	bl	malloc
	mov	x21, x0
	cmp	x23, 0
	ccmp	x20, 0, 4, ne
	beq	.L33
	cmp	x28, 0
	mov	x0, 0
	ldp	x2, x1, [sp, 64]
	ccmp	x21, 0, 4, ne
	ldr	x12, [sp, 88]
	mov	x4, 7
	ldp	w8, w7, [sp, 80]
	bne	.L34
	b	.L33
.L35:
	udiv	x3, x0, x4
	msub	x3, x3, x4, x0
	sub	w3, w3, #3
	scvtf	h0, w3
	str	h0, [x23, x0, lsl 1]
	add	x0, x0, 1
.L34:
	cmp	x0, x1
	bne	.L35
	mov	x1, 0
	mov	x3, 5
	b	.L36
.L37:
	udiv	x0, x1, x3
	add	x0, x0, x0, lsl 2
	sub	x0, x1, x0
	sub	w0, w0, #2
	scvtf	h0, w0
	str	h0, [x20, x1, lsl 1]
	add	x1, x1, 1
.L36:
	cmp	x1, x2
	bne	.L37
	mov	x1, 0
	mov	x0, 0
	str	x12, [sp, 64]
	str	w7, [sp, 72]
	str	w8, [sp, 80]
	bl	m5_work_begin
	ldr	x1, [sp, 48]
	whilelo	p1.d, wzr, w19
	cntw	x3
	index	z1.d, #0, x1
	ldr	x12, [sp, 64]
	mul	w17, w26, w19
	ldrsw	x0, [sp, 32]
	mul	x3, x1, x3
	ldr	w7, [sp, 72]
	mov	x5, 0
	ldr	w8, [sp, 80]
	lsl	x12, x12, 1
	mov	w16, 0
	cntd	x4
.L38:
	mov	x14, 0
.L46:
	add	x11, x5, x14
	mov	w13, 0
	mov	w1, 0
.L39:
	cmp	w8, w1
	ble	.L44
	add	w9, w16, w1
	mov	w15, w13
	mov	w10, 0
	smaddl	x9, w24, w9, x14
	madd	x9, x9, x12, x23
.L45:
	cmp	w26, w10
	ble	.L41
	cmp	w19, 0
	ble	.L43
	smaddl	x6, w27, w15, x11
	mov	x2, 0
	mov	p0.b, p1.b
	add	x6, x28, x6, lsl 1
	.p2align 3,,7
.L40:
	ld1h	z0.d, p0/z, [x9, x2, lsl 1]
	st1h	z0.d, p0, [x6, z1.d, lsl 1]
	add	x2, x2, x4
	add	x6, x6, x3
	whilelo	p0.d, w2, w19
	b.any	.L40
.L43:
	add	w10, w10, 1
	add	x9, x9, x12
	add	w15, w15, w19
	b	.L45
.L95:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	.cfi_restore 28
	ldp	x23, x24, [sp, 176]
	.cfi_restore 24
	.cfi_restore 23
.L17:
	adrp	x0, .LC8
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	add	x0, x0, :lo12:.LC8
	mov	x2, 44
	mov	x1, 1
	ldr	x3, [x3]
	bl	fwrite
	ldp	x25, x26, [sp, 192]
	.cfi_restore 26
	.cfi_restore 25
	b	.L14
.L19:
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	mov	x2, 37
.L91:
	ldr	x3, [x3]
	mov	x1, 1
	bl	fwrite
	ldp	x23, x24, [sp, 176]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 192]
	.cfi_restore 26
	.cfi_restore 25
	b	.L14
.L94:
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	ldr	x0, [x19, 56]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
	cmp	w0, 0
	cset	w0, ne
	str	w0, [sp, 40]
	b	.L16
.L90:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	ldp	x21, x22, [sp, 160]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x27, x28, [sp, 208]
	.cfi_restore 28
	.cfi_restore 27
.L23:
	adrp	x0, .LC10
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	add	x0, x0, :lo12:.LC10
	mov	x2, 34
	b	.L91
.L93:
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	stp	x21, x22, [sp, 160]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	stp	x23, x24, [sp, 176]
	.cfi_offset 24, -40
	.cfi_offset 23, -48
	stp	x25, x26, [sp, 192]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
	stp	x27, x28, [sp, 208]
	.cfi_offset 28, -8
	.cfi_offset 27, -16
	bl	__stack_chk_fail
.L33:
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	mov	x2, 37
	mov	x1, 1
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	ldr	x3, [x3]
	bl	fwrite
	mov	x0, x23
	bl	free
	mov	x0, x20
	bl	free
	mov	x0, x28
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 160]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 176]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 192]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 208]
	.cfi_restore 28
	.cfi_restore 27
	b	.L14
.L88:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	ldp	x21, x22, [sp, 160]
	.cfi_restore 22
	.cfi_restore 21
	b	.L23
.L41:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	add	w1, w1, 1
	add	w13, w13, w17
	b	.L39
.L44:
	add	x14, x14, 1
	ldr	w2, [sp, 60]
	sub	w1, w14, #1
	cmp	w2, w1
	bgt	.L46
	ldr	w2, [sp, 56]
	add	x5, x5, x0
	add	w1, w16, 1
	cmp	w2, w16
	beq	.L47
	mov	w16, w1
	b	.L38
.L47:
	movi	v1.2s, #0
	fmov	s0, 1.0e+0
	str	x28, [sp]
	mov	w5, w7
	str	w27, [sp, 8]
	mov	x6, x20
	str	x21, [sp, 16]
	mov	w4, w27
	str	w27, [sp, 24]
	mov	w3, w22
	mov	w2, 111
	mov	w0, 101
	mov	w1, w2
	str	w8, [sp, 56]
	bl	cblas_shgemm
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	bl	openblas_get_corename
	mov	x2, x0
	adrp	x1, .LC12
	mov	w0, 2
	add	x1, x1, :lo12:.LC12
	bl	__printf_chk
	ldr	w0, [sp, 44]
	mov	w6, w26
	ldr	w8, [sp, 56]
	mov	w3, w24
	str	w0, [sp]
	mov	w2, w25
	ldr	w0, [sp, 32]
	mov	w7, w19
	str	w0, [sp, 8]
	mov	w4, w19
	str	w22, [sp, 16]
	mov	w5, w8
	adrp	x1, .LC13
	mov	w0, 2
	add	x1, x1, :lo12:.LC13
	bl	__printf_chk
	ldr	w0, [sp, 40]
	cbz	w0, .L52
	adrp	x26, .LC14
	add	x26, x26, :lo12:.LC14
	str	x28, [sp, 32]
	mov	x28, x20
	mov	x25, 0
	mov	w24, 0
.L48:
	cmp	w22, w24
	ble	.L96
	add	x20, x21, x25, lsl 2
	mov	x19, 0
.L50:
	ldr	s0, [x20, x19, lsl 2]
	mov	w3, w19
	mov	w2, w24
	mov	x1, x26
	mov	w0, 2
	add	x19, x19, 1
	fcvt	d0, s0
	bl	__printf_chk
	cmp	w27, w19
	bgt	.L50
	ldr	x0, [sp, 48]
	add	w24, w24, 1
	add	x25, x25, x0
	b	.L48
.L96:
	mov	x20, x28
	ldr	x28, [sp, 32]
.L52:
	mov	x0, x23
	bl	free
	mov	x0, x20
	bl	free
	mov	x0, x28
	bl	free
	mov	x0, x21
	bl	free
	ldp	x21, x22, [sp, 160]
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 0
	ldp	x23, x24, [sp, 176]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 192]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 208]
	.cfi_restore 28
	.cfi_restore 27
	b	.L12
	.cfi_endproc
.LFE78:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
