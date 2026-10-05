	.arch armv8.2-a+crc+sve
	.file	"add.c"
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
.LFB41:
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
	bl	strtoul
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
.LFE41:
	.size	parse_dimension, .-parse_dimension
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"Usage: %s rows cols [print_result]\n"
	.align	3
.LC2:
	.string	"rows"
	.align	3
.LC3:
	.string	"cols"
	.align	3
.LC4:
	.string	"matrix buffers are too large\n"
	.align	3
.LC5:
	.string	"matrix allocation failed for %ux%u\n"
	.align	3
.LC6:
	.string	"SVE FP16 addition: C[%ux%u] = A + B\n"
	.align	3
.LC7:
	.string	"C[%u][%u] = %.0f\n"
	.align	3
.LC8:
	.string	"result mismatch at %zu: got %.0f, expected %.0f\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB43:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 32]
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 32
	stp	x19, x20, [sp, 48]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	w20, w0
	sub	w0, w0, #3
	ldr	x3, [x2]
	str	x3, [sp, 24]
	mov	x3, 0
	mov	x19, x1
	cmp	w0, 1
	bhi	.L15
	ldr	x0, [x19, 8]
	adrp	x1, .LC2
	add	x2, sp, 16
	add	x1, x1, :lo12:.LC2
	bl	parse_dimension
	cbnz	w0, .L54
.L15:
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	adrp	x2, .LC1
	ldr	x3, [x19]
	add	x2, x2, :lo12:.LC1
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	mov	w0, 1
	b	.L12
.L54:
	ldr	x0, [x19, 16]
	adrp	x1, .LC3
	add	x2, sp, 20
	add	x1, x1, :lo12:.LC3
	bl	parse_dimension
	cbz	w0, .L15
	stp	x21, x22, [sp, 64]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	cmp	w20, 4
	beq	.L55
	mov	w19, 1
.L16:
	ldp	w1, w0, [sp, 16]
	stp	w1, w0, [sp, 8]
	uxtw	x20, w0
	umull	x21, w1, w0
	tbnz	x21, #63, .L56
	lsl	x22, x21, 1
	stp	x23, x24, [sp, 80]
	.cfi_offset 24, -40
	.cfi_offset 23, -48
	mov	x0, x22
	stp	x25, x26, [sp, 96]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
	bl	malloc
	mov	x24, x0
	mov	x0, x22
	bl	malloc
	mov	x25, x0
	mov	x0, x22
	bl	malloc
	mov	x23, x0
	cmp	x24, 0
	ccmp	x25, 0, 4, ne
	ccmp	x0, 0, 4, ne
	beq	.L18
	mov	x2, 0
	cbz	x21, .L50
	mov	x3, 63439
	movk	x3, 0xe353, lsl 16
	movk	x3, 0x9ba5, lsl 32
	movk	x3, 0x20c4, lsl 48
	.p2align 3,,7
.L19:
	lsr	x1, x2, 3
	umulh	x1, x1, x3
	lsr	x1, x1, 4
	lsl	x0, x1, 5
	sub	x0, x0, x1
	add	x0, x1, x0, lsl 2
	sub	x0, x2, x0, lsl 3
	scvtf	h0, x0
	str	h0, [x24, x2, lsl 1]
	str	h0, [x25, x2, lsl 1]
	add	x2, x2, 1
	cmp	x21, x2
	bne	.L19
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	mov	x0, 0
	cnth	x1
	.p2align 3,,7
.L21:
	whilelo	p0.h, x0, x21
	ld1h	z0.h, p0/z, [x24, x0, lsl 1]
	ld1h	z1.h, p0/z, [x25, x0, lsl 1]
	fadd	z0.h, p0/m, z0.h, z1.h
	st1h	z0.h, p0, [x23, x0, lsl 1]
	add	x0, x0, x1
	cmp	x21, x0
	bhi	.L21
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	ldp	w2, w3, [sp, 8]
	adrp	x1, .LC6
	mov	w0, 2
	add	x1, x1, :lo12:.LC6
	bl	__printf_chk
	cbz	w19, .L22
.L32:
	adrp	x22, .LC7
	add	x22, x22, :lo12:.LC7
	mov	x26, 0
	mov	w19, 0
	stp	x27, x28, [sp, 112]
	.cfi_offset 28, -8
	.cfi_offset 27, -16
.L23:
	ldr	w0, [sp, 8]
	cmp	w0, w19
	beq	.L25
	ldr	w0, [sp, 12]
	cbz	w0, .L27
	add	x27, x23, x26, lsl 1
	mov	x28, 0
	.p2align 3,,7
.L24:
	ldr	h0, [x27, x28, lsl 1]
	mov	w3, w28
	mov	w2, w19
	mov	x1, x22
	mov	w0, 2
	add	x28, x28, 1
	fcvt	d0, h0
	bl	__printf_chk
	cmp	x20, x28
	bne	.L24
.L27:
	add	w19, w19, 1
	add	x26, x26, x20
	b	.L23
.L25:
	ldp	x27, x28, [sp, 112]
	.cfi_restore 28
	.cfi_restore 27
	cbz	x21, .L31
.L22:
	mov	x3, 0
	b	.L30
	.p2align 2,,3
.L29:
	add	x3, x3, 1
	cmp	x21, x3
	beq	.L31
.L30:
	ldr	h2, [x25, x3, lsl 1]
	ldr	h1, [x24, x3, lsl 1]
	ldr	h0, [x23, x3, lsl 1]
	fadd	h1, h1, h2
	fcvt	s3, h0
	fcvt	s2, h1
	fcmp	s3, s2
	beq	.L29
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	fcvt	d1, h1
	fcvt	d0, h0
	adrp	x2, .LC8
	mov	w1, 2
	add	x2, x2, :lo12:.LC8
	ldr	x0, [x0]
	bl	__fprintf_chk
.L53:
	mov	x0, x24
	bl	free
	mov	x0, x25
	bl	free
	mov	x0, x23
	bl	free
	ldp	x21, x22, [sp, 64]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 1
	ldp	x23, x24, [sp, 80]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 96]
	.cfi_restore 26
	.cfi_restore 25
	b	.L12
.L50:
	.cfi_restore_state
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	ldp	w2, w3, [sp, 8]
	adrp	x1, .LC6
	mov	w0, 2
	add	x1, x1, :lo12:.LC6
	bl	__printf_chk
	cbnz	w19, .L32
.L31:
	mov	x0, x24
	bl	free
	mov	x0, x25
	bl	free
	mov	x0, x23
	bl	free
	ldp	x21, x22, [sp, 64]
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 0
	ldp	x23, x24, [sp, 80]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 96]
	.cfi_restore 26
	.cfi_restore 25
	.p2align 3,,7
.L12:
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 24]
	ldr	x2, [x1]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L57
	ldp	x29, x30, [sp, 32]
	ldp	x19, x20, [sp, 48]
	add	sp, sp, 128
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L56:
	.cfi_def_cfa_offset 128
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	adrp	x3, :got:stderr
	ldr	x3, [x3, :got_lo12:stderr]
	adrp	x0, .LC4
	mov	x2, 29
	add	x0, x0, :lo12:.LC4
	mov	x1, 1
	ldr	x3, [x3]
	bl	fwrite
	ldp	x21, x22, [sp, 64]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	mov	w0, 1
	b	.L12
.L55:
	.cfi_restore_state
	ldr	x0, [x19, 24]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
	cmp	w0, 0
	cset	w19, ne
	b	.L16
.L57:
	.cfi_restore 21
	.cfi_restore 22
	stp	x21, x22, [sp, 64]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	stp	x23, x24, [sp, 80]
	.cfi_offset 24, -40
	.cfi_offset 23, -48
	stp	x25, x26, [sp, 96]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
	stp	x27, x28, [sp, 112]
	.cfi_offset 28, -8
	.cfi_offset 27, -16
	bl	__stack_chk_fail
.L18:
	.cfi_restore 27
	.cfi_restore 28
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	adrp	x2, .LC5
	ldp	w3, w4, [sp, 8]
	add	x2, x2, :lo12:.LC5
	ldr	x0, [x0]
	mov	w1, 2
	bl	__fprintf_chk
	b	.L53
	.cfi_endproc
.LFE43:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
