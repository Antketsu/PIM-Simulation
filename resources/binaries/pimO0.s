	.arch armv8-a
	.file	"pim.c"
	.text
	.global	pim_region
	.bss
	.align	3
	.type	pim_region, %object
	.size	pim_region, 8
pim_region:
	.zero	8
	.global	crf
	.align	3
	.type	crf, %object
	.size	crf, 8
crf:
	.zero	8
	.global	pu_space
	.align	3
	.type	pu_space, %object
	.size	pu_space, 8
pu_space:
	.zero	8
	.global	instr_idx
	.type	instr_idx, %object
	.size	instr_idx, 1
instr_idx:
	.zero	1
	.global	pim_size
	.data
	.align	3
	.type	pim_size, %object
	.size	pim_size, 8
pim_size:
	.xword	16777216
	.global	next_addr
	.align	3
	.type	next_addr, %object
	.size	next_addr, 8
next_addr:
	.xword	536870912
	.global	processing_units
	.type	processing_units, %object
	.size	processing_units, 1
processing_units:
	.byte	1
	.text
	.align	2
	.global	set_processing_units
	.type	set_processing_units, %function
set_processing_units:
.LFB6:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strb	w0, [sp, 15]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w1, [sp, 15]
	strb	w1, [x0]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	set_processing_units, .-set_processing_units
	.align	2
	.global	get_processing_units
	.type	get_processing_units, %function
get_processing_units:
.LFB7:
	.cfi_startproc
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	ret
	.cfi_endproc
.LFE7:
	.size	get_processing_units, .-get_processing_units
	.section	.rodata
	.align	3
.LC0:
	.string	"Intentando mapear al banco %d\n"
	.align	3
.LC1:
	.string	"Error al mapear la memoria del banco"
	.text
	.align	2
	.global	init_operand
	.type	init_operand, %function
init_operand:
.LFB8:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -64
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	w2, [sp, 32]
	ldr	x0, [sp, 40]
	ldr	w1, [sp, 36]
	str	w1, [x0, 64]
	ldr	x0, [sp, 40]
	ldr	w1, [sp, 32]
	str	w1, [x0, 68]
	ldr	w1, [sp, 36]
	ldr	w0, [sp, 32]
	mul	w0, w1, w0
	str	w0, [sp, 72]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [sp, 72]
	udiv	w0, w0, w1
	str	w0, [sp, 76]
	ldr	w0, [sp, 76]
	lsr	w1, w0, 9
	ldr	x0, [sp, 40]
	str	w1, [x0, 72]
	ldr	w0, [sp, 76]
	and	w0, w0, 511
	cmp	w0, 0
	beq	.L5
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 72]
	add	w0, w0, 1
	b	.L6
.L5:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 72]
.L6:
	ldr	x1, [sp, 40]
	str	w0, [x1, 72]
	adrp	x0, next_addr
	add	x0, x0, :lo12:next_addr
	ldr	x0, [x0]
	str	w0, [sp, 60]
	str	wzr, [sp, 64]
	b	.L7
.L14:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 72]
	uxtw	x0, w0
	lsl	x0, x0, 4
	bl	malloc
	mov	x2, x0
	ldr	x0, [sp, 40]
	ldrsw	x1, [sp, 64]
	str	x2, [x0, x1, lsl 3]
	str	wzr, [sp, 68]
	b	.L8
.L13:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 72]
	sub	w1, w0, #1
	ldr	w0, [sp, 68]
	cmp	w1, w0
	bne	.L9
	ldr	w0, [sp, 76]
	and	w0, w0, 511
	cmp	w0, 0
	beq	.L9
	ldr	x0, [sp, 40]
	ldrsw	x1, [sp, 64]
	ldr	x1, [x0, x1, lsl 3]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	w1, [sp, 76]
	and	w1, w1, 511
	str	w1, [x0, 8]
	b	.L10
.L9:
	ldr	x0, [sp, 40]
	ldrsw	x1, [sp, 64]
	ldr	x1, [x0, x1, lsl 3]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 4
	add	x0, x1, x0
	mov	w1, 512
	str	w1, [x0, 8]
.L10:
	ldr	w0, [sp, 60]
	mov	x6, x0
	ldr	x0, [sp, 40]
	ldrsw	x1, [sp, 64]
	ldr	x1, [x0, x1, lsl 3]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 4
	add	x19, x1, x0
	mov	x5, 0
	mov	w4, -1
	mov	w3, 50
	mov	w2, 3
	mov	x1, 1024
	mov	x0, x6
	bl	mmap
	str	x0, [x19]
	ldr	x0, [sp, 40]
	ldrsw	x1, [sp, 64]
	ldr	x1, [x0, x1, lsl 3]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x0, [x0]
	cmn	x0, #1
	bne	.L11
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	perror
	mov	w0, 1
	b	.L12
.L11:
	ldr	w0, [sp, 60]
	add	w0, w0, 8192
	str	w0, [sp, 60]
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L8:
	ldr	x0, [sp, 40]
	ldr	w1, [x0, 72]
	ldr	w0, [sp, 68]
	cmp	w1, w0
	bhi	.L13
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L7:
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [sp, 64]
	cmp	w0, w1
	blt	.L14
	ldr	w1, [sp, 60]
	adrp	x0, next_addr
	add	x0, x0, :lo12:next_addr
	str	x1, [x0]
	mov	w0, 0
.L12:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	init_operand, .-init_operand
	.align	2
	.global	read_operand
	.type	read_operand, %function
read_operand:
.LFB9:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	w1, [x0, 64]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 68]
	mul	w0, w1, w0
	str	w0, [sp, 20]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [sp, 20]
	udiv	w0, w0, w1
	str	w0, [sp, 24]
	ldr	w0, [sp, 4]
	add	w1, w0, 511
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 9
	str	w0, [sp, 28]
	ldr	x0, [sp, 8]
	ldr	x1, [x0]
	ldr	w0, [sp, 28]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [sp, 4]
	negs	w2, w0
	and	w0, w0, 511
	and	w2, w2, 511
	csneg	w0, w0, w2, mi
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrsh	w0, [x0]
	and	w0, w0, 65535
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	read_operand, .-read_operand
	.align	2
	.global	write_operand
	.type	write_operand, %function
write_operand:
.LFB10:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	strh	w2, [sp, 2]
	ldr	x0, [sp, 8]
	ldr	w1, [x0, 64]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 68]
	mul	w0, w1, w0
	str	w0, [sp, 20]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [sp, 20]
	udiv	w0, w0, w1
	str	w0, [sp, 24]
	ldr	w0, [sp, 4]
	add	w1, w0, 511
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 9
	str	w0, [sp, 28]
	ldr	x0, [sp, 8]
	ldr	x1, [x0]
	ldr	w0, [sp, 28]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [sp, 4]
	negs	w2, w0
	and	w0, w0, 511
	and	w2, w2, 511
	csneg	w0, w0, w2, mi
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w1, [sp, 2]
	strh	w1, [x0]
	nop
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE10:
	.size	write_operand, .-write_operand
	.align	2
	.global	write_add_block
	.type	write_add_block, %function
write_add_block:
.LFB11:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strb	w0, [sp, 15]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 8
	mov	w0, 851443712
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 8
	mov	w0, 1147142144
	orr	w1, w1, w0
	ldrb	w0, [sp, 15]
	lsl	w0, w0, 4
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 4
	mov	w0, 914358272
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11:
	.size	write_add_block, .-write_add_block
	.section	.rodata
	.align	3
.LC2:
	.string	"Loops: %d, Executions: %d\n"
	.align	3
.LC3:
	.string	"Loops after adjustment: %d\n"
	.text
	.align	2
	.global	add
	.type	add, %function
add:
.LFB12:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	str	x21, [sp, 32]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 21, -80
	mov	x20, x0
	mov	x21, x1
	mov	x19, x2
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	ldr	w1, [x20, 64]
	ldr	w0, [x20, 68]
	mul	w0, w1, w0
	uxtw	x0, w0
	str	x0, [sp, 80]
	ldr	w1, [x21, 64]
	ldr	w0, [x21, 68]
	mul	w0, w1, w0
	uxtw	x0, w0
	ldr	x1, [sp, 80]
	cmp	x1, x0
	bne	.L20
	ldr	w1, [x19, 64]
	ldr	w0, [x19, 68]
	mul	w0, w1, w0
	uxtw	x0, w0
	ldr	x1, [sp, 80]
	cmp	x1, x0
	beq	.L21
.L20:
	mov	w0, 1
	b	.L22
.L21:
	ldr	x0, [x20]
	ldr	x0, [x0]
	str	x0, [sp, 88]
	ldr	x0, [x21]
	ldr	x0, [x0]
	str	x0, [sp, 96]
	ldr	x0, [x19]
	ldr	x0, [x0]
	str	x0, [sp, 104]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	and	x0, x0, 255
	ldr	x1, [sp, 80]
	udiv	x0, x1, x0
	str	w0, [sp, 76]
	mov	w0, 8
	strb	w0, [sp, 52]
	b	.L23
.L24:
	ldrb	w0, [sp, 52]
	sub	w0, w0, #1
	strb	w0, [sp, 52]
.L23:
	ldrb	w1, [sp, 52]
	ldr	w0, [sp, 76]
	udiv	w2, w0, w1
	mul	w1, w2, w1
	sub	w0, w0, w1
	cmp	w0, 0
	bne	.L24
	ldrb	w0, [sp, 52]
	lsl	w0, w0, 4
	mov	w1, w0
	ldr	w0, [sp, 76]
	udiv	w0, w0, w1
	strh	w0, [sp, 54]
	str	wzr, [sp, 60]
	b	.L25
.L26:
	ldr	w0, [sp, 60]
	and	w0, w0, 255
	bl	write_add_block
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L25:
	ldrb	w0, [sp, 52]
	ldr	w1, [sp, 60]
	cmp	w1, w0
	blt	.L26
	ldrh	w0, [sp, 54]
	cmp	w0, 1
	bls	.L27
	ldrb	w1, [sp, 52]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	lsl	w0, w0, 11
	orr	w1, w0, 268435456
	ldrh	w0, [sp, 54]
	sub	w0, w0, #1
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
.L27:
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w3, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w3, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, 536870912
	str	w1, [x0]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	cmp	w0, 1
	bls	.L28
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	add	x0, x0, 4
	mov	w1, 1
	strb	w1, [x0]
.L28:
	ldrh	w0, [sp, 54]
	lsr	w0, w0, 8
	and	w0, w0, 65535
	strb	w0, [sp, 53]
	ldrh	w0, [sp, 54]
	and	w0, w0, 255
	and	w0, w0, 65535
	cmp	w0, 0
	cset	w0, ne
	and	w0, w0, 255
	mov	w1, w0
	ldrb	w0, [sp, 53]
	add	w0, w1, w0
	strb	w0, [sp, 53]
	ldrh	w0, [sp, 54]
	ldrb	w1, [sp, 53]
	mov	w2, w1
	mov	w1, w0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldrh	w2, [sp, 54]
	ldrh	w1, [sp, 54]
	mov	w0, 256
	cmp	w2, 256
	csel	w0, w1, w0, ls
	strh	w0, [sp, 54]
	ldrh	w0, [sp, 54]
	mov	w1, w0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	str	wzr, [sp, 64]
	b	.L29
.L35:
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	mov	w1, 1
	strb	w1, [x0]
	str	wzr, [sp, 68]
	b	.L30
.L34:
	str	wzr, [sp, 72]
	b	.L31
.L32:
	ldrb	w1, [sp, 52]
	ldr	w0, [sp, 68]
	mul	w1, w1, w0
	ldr	w0, [sp, 72]
	add	w0, w1, w0
	lsl	w0, w0, 4
	mov	w1, w0
	mov	x0, x20
	bl	read_operand
	and	w0, w0, 65535
	strh	w0, [sp, 56]
	ldrb	w1, [sp, 52]
	ldr	w0, [sp, 68]
	mul	w1, w1, w0
	ldr	w0, [sp, 72]
	add	w0, w1, w0
	lsl	w0, w0, 4
	mov	w1, w0
	mov	x0, x21
	bl	read_operand
	and	w0, w0, 65535
	strh	w0, [sp, 58]
	ldrb	w1, [sp, 52]
	ldr	w0, [sp, 68]
	mul	w1, w1, w0
	ldr	w0, [sp, 72]
	add	w0, w1, w0
	lsl	w0, w0, 4
	mov	w2, 0
	mov	w1, w0
	mov	x0, x19
	bl	write_operand
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L31:
	ldrb	w0, [sp, 52]
	ldr	w1, [sp, 72]
	cmp	w1, w0
	blt	.L32
	ldrh	w0, [sp, 54]
	cmp	w0, 1
	bls	.L33
	mov	w2, 0
	mov	w1, 0
	mov	x0, x19
	bl	write_operand
.L33:
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L30:
	ldrh	w0, [sp, 54]
	ldr	w1, [sp, 68]
	cmp	w1, w0
	blt	.L34
	mov	w2, 0
	mov	w1, 0
	mov	x0, x19
	bl	write_operand
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L29:
	ldrb	w0, [sp, 53]
	ldr	w1, [sp, 64]
	cmp	w1, w0
	blt	.L35
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	cmp	w0, 1
	bls	.L36
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	add	x0, x0, 4
	strb	wzr, [x0]
.L36:
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	mov	w0, 0
.L22:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE12:
	.size	add, .-add
	.align	2
	.global	write_mul_block
	.type	write_mul_block, %function
write_mul_block:
.LFB13:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strb	w0, [sp, 15]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 8
	mov	w0, 884998144
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 8
	mov	w0, 1965555712
	orr	w1, w1, w0
	ldrb	w0, [sp, 15]
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	ldrb	w0, [sp, 15]
	lsl	w1, w0, 4
	mov	w0, 914358272
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13:
	.size	write_mul_block, .-write_mul_block
	.align	2
	.global	read_mul_operand
	.type	read_mul_operand, %function
read_mul_operand:
.LFB14:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	ldr	w0, [sp, 20]
	add	w1, w0, 15
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 4
	str	w0, [sp, 36]
	bl	get_processing_units
	and	w0, w0, 255
	mov	w1, w0
	ldr	w0, [sp, 36]
	udiv	w2, w0, w1
	mul	w1, w2, w1
	sub	w0, w0, w1
	str	w0, [sp, 40]
	bl	get_processing_units
	and	w0, w0, 255
	mov	w1, w0
	ldr	w0, [sp, 36]
	udiv	w0, w0, w1
	str	w0, [sp, 44]
	ldr	w0, [sp, 20]
	negs	w1, w0
	and	w0, w0, 15
	and	w1, w1, 15
	csneg	w0, w0, w1, mi
	str	w0, [sp, 48]
	ldr	w0, [sp, 44]
	lsl	w0, w0, 4
	ldr	w1, [sp, 48]
	add	w0, w1, w0
	str	w0, [sp, 52]
	ldr	w0, [sp, 52]
	lsr	w0, w0, 9
	str	w0, [sp, 56]
	ldr	w0, [sp, 52]
	and	w0, w0, 511
	str	w0, [sp, 60]
	ldr	x0, [sp, 24]
	ldr	w1, [sp, 40]
	ldr	x1, [x0, x1, lsl 3]
	ldr	w0, [sp, 56]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [sp, 60]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrsh	w0, [x0]
	and	w0, w0, 65535
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14:
	.size	read_mul_operand, .-read_mul_operand
	.align	2
	.global	write_mul_operand
	.type	write_mul_operand, %function
write_mul_operand:
.LFB15:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	strh	w2, [sp, 18]
	ldr	w0, [sp, 20]
	add	w1, w0, 15
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 4
	str	w0, [sp, 36]
	bl	get_processing_units
	and	w0, w0, 255
	mov	w1, w0
	ldr	w0, [sp, 36]
	udiv	w2, w0, w1
	mul	w1, w2, w1
	sub	w0, w0, w1
	str	w0, [sp, 40]
	bl	get_processing_units
	and	w0, w0, 255
	mov	w1, w0
	ldr	w0, [sp, 36]
	udiv	w0, w0, w1
	str	w0, [sp, 44]
	ldr	w0, [sp, 20]
	negs	w1, w0
	and	w0, w0, 15
	and	w1, w1, 15
	csneg	w0, w0, w1, mi
	str	w0, [sp, 48]
	ldr	w0, [sp, 44]
	lsl	w0, w0, 4
	ldr	w1, [sp, 48]
	add	w0, w1, w0
	str	w0, [sp, 52]
	ldr	w0, [sp, 52]
	lsr	w0, w0, 9
	str	w0, [sp, 56]
	ldr	w0, [sp, 52]
	and	w0, w0, 511
	str	w0, [sp, 60]
	ldr	x0, [sp, 24]
	ldr	w1, [sp, 40]
	ldr	x1, [x0, x1, lsl 3]
	ldr	w0, [sp, 56]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [sp, 60]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w1, [sp, 18]
	strh	w1, [x0]
	nop
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE15:
	.size	write_mul_operand, .-write_mul_operand
	.align	2
	.global	matrix_multiplication
	.type	matrix_multiplication, %function
matrix_multiplication:
.LFB16:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	sub	sp, sp, #112
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x19, x0
	mov	x21, x1
	mov	x20, x2
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x28, x0
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	ldr	w1, [x19, 68]
	ldr	w0, [x21, 64]
	cmp	w1, w0
	bne	.L42
	ldr	w1, [x20, 64]
	ldr	w0, [x19, 64]
	cmp	w1, w0
	bne	.L42
	ldr	w1, [x20, 68]
	ldr	w0, [x21, 68]
	cmp	w1, w0
	beq	.L43
.L42:
	mov	w0, 1
	b	.L44
.L43:
	ldr	w0, [x21, 68]
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	lsl	w1, w1, 4
	udiv	w0, w0, w1
	strh	w0, [x29, -64]
	mov	w0, 8
	strb	w0, [x29, -65]
	str	wzr, [x29, -60]
	b	.L45
.L46:
	ldr	w0, [x29, -60]
	and	w0, w0, 255
	bl	write_mul_block
	ldr	w0, [x29, -60]
	add	w0, w0, 1
	str	w0, [x29, -60]
.L45:
	ldrb	w0, [x29, -65]
	ldr	w1, [x29, -60]
	cmp	w1, w0
	blt	.L46
	ldrb	w1, [x29, -65]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	lsl	w0, w0, 11
	orr	w1, w0, 268435456
	ldrh	w0, [x29, -64]
	sub	w0, w0, #1
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w3, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w3, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, 536870912
	str	w1, [x0]
	str	wzr, [x29, -56]
	str	wzr, [x29, -52]
	ldrb	w0, [x29, -65]
	and	x1, x0, 255
	sub	x1, x1, #1
	str	x1, [x29, -24]
	and	x1, x0, 255
	str	x1, [x29, -96]
	str	xzr, [x29, -88]
	ldp	x2, x3, [x29, -96]
	mov	x1, x2
	lsr	x1, x1, 58
	mov	x4, x3
	lsl	x25, x4, 6
	orr	x25, x1, x25
	mov	x1, x2
	lsl	x24, x1, 6
	and	x1, x0, 255
	mov	x26, x1
	mov	x27, 0
	lsr	x1, x26, 58
	lsl	x23, x27, 6
	orr	x23, x1, x23
	lsl	x22, x26, 6
	and	x0, x0, 255
	lsl	x0, x0, 3
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L47:
	cmp	sp, x1
	beq	.L48
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L47
.L48:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L49
	str	xzr, [sp, 1024]
.L49:
	add	x0, sp, 16
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, -16]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	cmp	w0, 1
	bls	.L51
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	add	x0, x0, 4
	mov	w1, 1
	strb	w1, [x0]
	b	.L51
.L60:
	str	wzr, [x29, -48]
	b	.L52
.L56:
	str	wzr, [x29, -44]
	b	.L53
.L54:
	ldr	w1, [x19, 68]
	ldr	w0, [x29, -56]
	mul	w1, w1, w0
	ldr	w0, [x29, -52]
	add	w0, w1, w0
	mov	w1, w0
	mov	x0, x19
	bl	read_mul_operand
	and	w3, w0, 65535
	adrp	x0, pu_space
	add	x0, x0, :lo12:pu_space
	ldr	x2, [x0]
	ldr	w1, [x29, -44]
	mov	w0, w1
	lsl	w0, w0, 4
	add	w0, w0, w1
	lsl	w0, w0, 4
	mov	w1, w0
	ldr	w0, [x29, -48]
	add	w0, w1, w0
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x2, x0
	sxth	w1, w3
	strh	w1, [x0]
	ldr	w0, [x29, -44]
	add	w0, w0, 1
	str	w0, [x29, -44]
.L53:
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [x29, -44]
	cmp	w0, w1
	blt	.L54
	ldr	x1, [x29, -16]
	ldrsw	x0, [x29, -48]
	lsl	x0, x0, 3
	add	x0, x1, x0
	ldr	w1, [x29, -56]
	str	w1, [x0]
	ldr	x1, [x29, -16]
	ldrsw	x0, [x29, -48]
	lsl	x0, x0, 3
	add	x0, x1, x0
	ldr	w1, [x29, -52]
	str	w1, [x0, 4]
	ldr	w0, [x29, -52]
	add	w0, w0, 1
	str	w0, [x29, -52]
	ldr	w0, [x19, 68]
	ldr	w1, [x29, -52]
	cmp	w1, w0
	bne	.L55
	str	wzr, [x29, -52]
	ldr	w0, [x29, -56]
	add	w0, w0, 1
	str	w0, [x29, -56]
.L55:
	ldr	w0, [x29, -48]
	add	w0, w0, 1
	str	w0, [x29, -48]
.L52:
	ldrb	w0, [x29, -65]
	ldr	w1, [x29, -48]
	cmp	w1, w0
	blt	.L56
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	mov	w1, 1
	strb	w1, [x0]
	str	wzr, [x29, -40]
.L59:
	str	wzr, [x29, -36]
	b	.L57
.L58:
	ldr	x1, [x29, -16]
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 3
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [x29, -32]
	ldr	x1, [x29, -16]
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 3
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	str	w0, [x29, -28]
	ldr	w1, [x20, 68]
	ldr	w0, [x29, -32]
	mul	w0, w1, w0
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	mov	w2, w1
	ldr	w1, [x29, -40]
	mul	w1, w2, w1
	lsl	w1, w1, 4
	add	w0, w0, w1
	mov	w1, w0
	mov	x0, x20
	bl	read_mul_operand
	and	w0, w0, 65535
	strh	w0, [x29, -62]
	ldr	w1, [x21, 68]
	ldr	w0, [x29, -28]
	mul	w0, w1, w0
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	mov	w2, w1
	ldr	w1, [x29, -40]
	mul	w1, w2, w1
	lsl	w1, w1, 4
	add	w0, w0, w1
	mov	w1, w0
	mov	x0, x21
	bl	read_mul_operand
	and	w0, w0, 65535
	strh	w0, [x29, -62]
	ldr	w1, [x20, 68]
	ldr	w0, [x29, -32]
	mul	w0, w1, w0
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	mov	w2, w1
	ldr	w1, [x29, -40]
	mul	w1, w2, w1
	lsl	w1, w1, 4
	add	w0, w0, w1
	mov	w2, 0
	mov	w1, w0
	mov	x0, x20
	bl	write_mul_operand
	ldr	w0, [x29, -36]
	add	w0, w0, 1
	str	w0, [x29, -36]
.L57:
	ldrb	w0, [x29, -65]
	ldr	w1, [x29, -36]
	cmp	w1, w0
	blt	.L58
	mov	w1, 0
	mov	x0, x20
	bl	read_mul_operand
	ldr	w0, [x29, -40]
	add	w0, w0, 1
	str	w0, [x29, -40]
	ldrh	w0, [x29, -64]
	ldr	w1, [x29, -40]
	cmp	w1, w0
	blt	.L59
	mov	w1, 0
	mov	x0, x20
	bl	read_mul_operand
.L51:
	ldr	w1, [x19, 68]
	ldr	w0, [x29, -56]
	mul	w1, w1, w0
	ldr	w0, [x29, -52]
	add	w1, w1, w0
	ldr	w2, [x19, 64]
	ldr	w0, [x19, 68]
	mul	w0, w2, w0
	cmp	w1, w0
	bcc	.L60
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	mov	w0, 0
.L44:
	mov	sp, x28
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L62
	bl	__stack_chk_fail
.L62:
	mov	w0, w1
	mov	sp, x29
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE16:
	.size	matrix_multiplication, .-matrix_multiplication
	.align	2
	.global	getIncrementRowB
	.type	getIncrementRowB, %function
getIncrementRowB:
.LFB17:
	.cfi_startproc
	str	x19, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 19, -32
	mov	x19, x0
	str	x1, [sp, 24]
	str	x2, [sp, 16]
	ldr	w0, [x19, 68]
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	udiv	w0, w0, w1
	cmp	w0, 512
	bls	.L64
	ldr	w0, [x19, 68]
	lsr	w1, w0, 9
	ldr	x0, [sp, 24]
	str	w1, [x0]
	b	.L66
.L64:
	ldr	w0, [x19, 68]
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	udiv	w1, w0, w1
	ldr	x0, [sp, 16]
	str	w1, [x0]
.L66:
	nop
	ldr	x19, [sp], 32
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE17:
	.size	getIncrementRowB, .-getIncrementRowB
	.section	.rodata
	.align	3
.LC4:
	.string	"Reg %d, PU %d"
	.text
	.align	2
	.global	fill_srf
	.type	fill_srf, %function
fill_srf:
.LFB18:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -80
	mov	x19, x0
	str	x1, [sp, 72]
	str	x2, [sp, 64]
	str	x3, [sp, 56]
	str	x4, [sp, 48]
	strb	w5, [sp, 47]
	str	wzr, [sp, 88]
	b	.L68
.L75:
	str	wzr, [sp, 92]
	b	.L69
.L70:
	ldr	w2, [sp, 92]
	ldr	w1, [sp, 88]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	ldr	x0, [sp, 64]
	ldr	w0, [x0]
	uxtw	x0, w0
	ldr	x1, [x19, x0, lsl 3]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	uxtw	x0, w0
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	ldr	w0, [x0]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x2, x1, x0
	adrp	x0, pu_space
	add	x0, x0, :lo12:pu_space
	ldr	x3, [x0]
	ldr	w1, [sp, 92]
	mov	w0, w1
	lsl	w0, w0, 4
	add	w0, w0, w1
	lsl	w0, w0, 4
	mov	w1, w0
	ldr	w0, [sp, 88]
	add	w0, w1, w0
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x3, x0
	ldrsh	w1, [x2]
	strh	w1, [x0]
	ldr	w0, [sp, 92]
	add	w0, w0, 1
	str	w0, [sp, 92]
.L69:
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [sp, 92]
	cmp	w0, w1
	blt	.L70
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	add	w1, w0, 1
	ldr	x0, [sp, 72]
	str	w1, [x0]
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	and	w0, w0, 15
	cmp	w0, 0
	bne	.L71
	ldr	x0, [sp, 64]
	cmp	x0, 15
	beq	.L72
	ldr	x0, [sp, 56]
	str	wzr, [x0]
	ldr	x0, [sp, 64]
	str	wzr, [x0]
.L72:
	ldr	x0, [sp, 64]
	ldr	w0, [x0]
	add	w1, w0, 1
	ldr	x0, [sp, 64]
	str	w1, [x0]
	b	.L73
.L71:
	ldr	x0, [sp, 56]
	ldr	w0, [x0]
	add	w1, w0, 1
	ldr	x0, [sp, 56]
	str	w1, [x0]
.L73:
	ldr	x1, [x19]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	uxtw	x0, w0
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	w0, [x0, 8]
	uxtw	x0, w0
	mov	x1, x0
	ldr	x0, [sp, 56]
	cmp	x0, x1
	bne	.L74
	ldr	x0, [sp, 56]
	str	wzr, [x0]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	add	w1, w0, 1
	ldr	x0, [sp, 48]
	str	w1, [x0]
.L74:
	ldr	w0, [sp, 88]
	add	w0, w0, 1
	str	w0, [sp, 88]
.L68:
	ldrb	w0, [sp, 47]
	ldr	w1, [sp, 88]
	cmp	w1, w0
	blt	.L75
	nop
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE18:
	.size	fill_srf, .-fill_srf
	.align	2
	.global	matrix_multiplication_test
	.type	matrix_multiplication_test, %function
matrix_multiplication_test:
.LFB19:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	sub	sp, sp, #288
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x28, x0
	sub	x0, x29, #16384
	str	x1, [x0, 16120]
	mov	x19, x2
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x0]
	str	x3, [x29, -8]
	mov	x3, 0
	mov	x0, sp
	sub	x1, x29, #16384
	str	x0, [x1, 16112]
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_begin
	ldr	w1, [x28, 68]
	sub	x0, x29, #16384
	ldr	x2, [x0, 16120]
	ldr	w0, [x2, 64]
	cmp	w1, w0
	bne	.L77
	ldr	w1, [x19, 64]
	ldr	w0, [x28, 64]
	cmp	w1, w0
	bne	.L77
	ldr	w1, [x19, 68]
	ldr	w0, [x2, 68]
	cmp	w1, w0
	beq	.L78
.L77:
	mov	w0, 1
	b	.L79
.L78:
	sub	x0, x29, #16384
	ldr	x0, [x0, 16120]
	ldr	w0, [x0, 68]
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	lsl	w1, w1, 4
	udiv	w0, w0, w1
	strh	w0, [x29, -160]
	mov	w0, 8
	strb	w0, [x29, -161]
	str	wzr, [x29, -132]
	b	.L80
.L81:
	ldr	w0, [x29, -132]
	and	w0, w0, 255
	bl	write_mul_block
	ldr	w0, [x29, -132]
	add	w0, w0, 1
	str	w0, [x29, -132]
.L80:
	ldrb	w0, [x29, -161]
	ldr	w1, [x29, -132]
	cmp	w1, w0
	blt	.L81
	ldrb	w1, [x29, -161]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	lsl	w0, w0, 11
	orr	w1, w0, 268435456
	ldrh	w0, [x29, -160]
	sub	w0, w0, #1
	orr	w3, w1, w0
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w4, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w4, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, w3
	str	w1, [x0]
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x1, [x0]
	adrp	x0, instr_idx
	add	x0, x0, :lo12:instr_idx
	ldrb	w0, [x0]
	add	w2, w0, 1
	and	w3, w2, 255
	adrp	x2, instr_idx
	add	x2, x2, :lo12:instr_idx
	strb	w3, [x2]
	and	x0, x0, 255
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, 536870912
	str	w1, [x0]
	str	wzr, [x29, -104]
	str	wzr, [x29, -100]
	ldrb	w0, [x29, -161]
	and	x1, x0, 255
	sub	x1, x1, #1
	str	x1, [x29, -88]
	and	x1, x0, 255
	mov	x26, x1
	mov	x27, 0
	lsr	x1, x26, 58
	lsl	x23, x27, 6
	orr	x23, x1, x23
	lsl	x22, x26, 6
	and	x1, x0, 255
	mov	x24, x1
	mov	x25, 0
	lsr	x1, x24, 58
	lsl	x21, x25, 6
	orr	x21, x1, x21
	lsl	x20, x24, 6
	and	x0, x0, 255
	lsl	x0, x0, 3
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L82:
	cmp	sp, x1
	beq	.L83
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L82
.L83:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L84
	str	xzr, [sp, 1024]
.L84:
	add	x0, sp, 16
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, -80]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	cmp	w0, 1
	bls	.L85
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	add	x0, x0, 4
	mov	w1, 1
	strb	w1, [x0]
.L85:
	str	wzr, [x29, -156]
	str	wzr, [x29, -152]
	str	wzr, [x29, -128]
	str	wzr, [x29, -124]
	str	wzr, [x29, -96]
	str	wzr, [x29, -92]
	str	wzr, [x29, -148]
	str	wzr, [x29, -144]
	str	wzr, [x29, -140]
	str	wzr, [x29, -136]
	sub	x0, x29, #256
	sub	x1, x29, #16384
	ldr	x1, [x1, 16120]
	ldp	q0, q1, [x1]
	stp	q0, q1, [x0]
	ldp	q0, q1, [x1, 32]
	stp	q0, q1, [x0, 32]
	ldr	q0, [x1, 64]
	str	q0, [x0, 64]
	sub	x2, x29, #136
	sub	x1, x29, #140
	sub	x0, x29, #256
	bl	getIncrementRowB
	str	wzr, [x29, -68]
	str	wzr, [x29, -72]
	b	.L86
.L99:
	sub	x0, x29, #256
	mov	x1, x28
	ldp	q0, q1, [x1]
	stp	q0, q1, [x0]
	ldp	q0, q1, [x1, 32]
	stp	q0, q1, [x0, 32]
	ldr	q0, [x1, 64]
	str	q0, [x0, 64]
	sub	x4, x29, #156
	sub	x3, x29, #152
	sub	x2, x29, #144
	sub	x1, x29, #148
	sub	x0, x29, #256
	ldrb	w5, [x29, -161]
	bl	fill_srf
	ldr	w0, [x29, -136]
	cmp	w0, 0
	beq	.L87
	mov	w0, 1
	str	w0, [x29, -120]
	b	.L88
.L89:
	ldr	w0, [x29, -120]
	sub	w0, w0, #1
	sxtw	x0, w0
	lsl	x0, x0, 3
	sub	x1, x29, #72
	ldr	w1, [x1, x0]
	ldr	w0, [x29, -140]
	add	w2, w1, w0
	ldrsw	x0, [x29, -120]
	lsl	x0, x0, 3
	sub	x1, x29, #72
	str	w2, [x1, x0]
	ldr	w0, [x29, -120]
	add	w0, w0, 1
	str	w0, [x29, -120]
.L88:
	ldr	w0, [x29, -120]
	cmp	w0, 7
	ble	.L89
	b	.L90
.L87:
	mov	w0, 1
	str	w0, [x29, -116]
	b	.L91
.L93:
	ldr	w0, [x29, -116]
	sub	w0, w0, #1
	sxtw	x0, w0
	lsl	x0, x0, 3
	sub	x1, x29, #68
	ldr	w1, [x1, x0]
	ldr	w0, [x29, -136]
	add	w2, w1, w0
	ldrsw	x0, [x29, -116]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	str	w2, [x1, x0]
	ldrsw	x0, [x29, -116]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	ldr	w0, [x1, x0]
	cmp	w0, 511
	bls	.L92
	ldrsw	x0, [x29, -116]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	str	wzr, [x1, x0]
	ldrsw	x0, [x29, -116]
	lsl	x0, x0, 3
	sub	x1, x29, #72
	ldr	w0, [x1, x0]
	add	w2, w0, 1
	ldrsw	x0, [x29, -116]
	lsl	x0, x0, 3
	sub	x1, x29, #72
	str	w2, [x1, x0]
.L92:
	ldr	w0, [x29, -116]
	add	w0, w0, 1
	str	w0, [x29, -116]
.L91:
	ldr	w0, [x29, -116]
	cmp	w0, 7
	ble	.L93
.L90:
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	mov	w1, 1
	strb	w1, [x0]
	str	wzr, [x29, -112]
.L98:
	str	wzr, [x29, -108]
	b	.L94
.L97:
	ldr	x1, [x19]
	ldr	w0, [x29, -128]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [x29, -124]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	strh	w0, [x29, -158]
	sub	x0, x29, #16384
	ldr	x0, [x0, 16120]
	ldr	x1, [x0]
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x2, x29, #72
	ldr	w0, [x2, x0]
	uxtw	x0, w0
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x2, x29, #68
	ldr	w0, [x2, x0]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	strh	w0, [x29, -158]
	ldr	x1, [x19]
	ldr	w0, [x29, -128]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	x1, [x0]
	ldr	w0, [x29, -124]
	lsl	x0, x0, 1
	add	x0, x1, x0
	strh	wzr, [x0]
	adrp	x0, processing_units
	add	x0, x0, :lo12:processing_units
	ldrb	w0, [x0]
	lsl	w0, w0, 4
	mov	w1, w0
	ldr	w0, [x29, -124]
	add	w0, w0, w1
	str	w0, [x29, -124]
	ldr	x1, [x19]
	ldr	w0, [x29, -128]
	lsl	x0, x0, 4
	add	x0, x1, x0
	ldr	w0, [x0, 8]
	ldr	w1, [x29, -124]
	cmp	w1, w0
	bcc	.L95
	str	wzr, [x29, -124]
	ldr	w0, [x29, -128]
	add	w0, w0, 1
	str	w0, [x29, -128]
.L95:
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	ldr	w0, [x1, x0]
	adrp	x1, processing_units
	add	x1, x1, :lo12:processing_units
	ldrb	w1, [x1]
	lsl	w1, w1, 4
	add	w2, w0, w1
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	str	w2, [x1, x0]
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	ldr	w0, [x1, x0]
	cmp	w0, 511
	bls	.L96
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #68
	str	wzr, [x1, x0]
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #72
	ldr	w0, [x1, x0]
	add	w2, w0, 1
	ldrsw	x0, [x29, -108]
	lsl	x0, x0, 3
	sub	x1, x29, #72
	str	w2, [x1, x0]
.L96:
	ldr	w0, [x29, -108]
	add	w0, w0, 1
	str	w0, [x29, -108]
.L94:
	ldrb	w0, [x29, -161]
	ldr	w1, [x29, -108]
	cmp	w1, w0
	blt	.L97
	ldr	x0, [x19]
	ldr	x0, [x0]
	ldrh	w0, [x0]
	strh	w0, [x29, -158]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	str	w0, [x29, -112]
	ldrh	w0, [x29, -160]
	ldr	w1, [x29, -112]
	cmp	w1, w0
	blt	.L98
	ldr	x0, [x19]
	ldr	x0, [x0]
	ldrh	w0, [x0]
	strh	w0, [x29, -158]
.L86:
	ldr	w1, [x28, 64]
	ldr	w0, [x28, 68]
	mul	w1, w1, w0
	ldr	w0, [x29, -148]
	cmp	w1, w0
	bhi	.L99
	mov	x1, 0
	mov	x0, 0
	bl	m5_work_end
	mov	w0, 0
.L79:
	sub	x1, x29, #16384
	ldr	x1, [x1, 16112]
	mov	sp, x1
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L101
	bl	__stack_chk_fail
.L101:
	mov	w0, w1
	mov	sp, x29
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE19:
	.size	matrix_multiplication_test, .-matrix_multiplication_test
	.section	.rodata
	.align	3
.LC5:
	.string	"Error al mapear la regi\303\263n PIM"
	.text
	.align	2
	.global	init_pim
	.type	init_pim, %function
init_pim:
.LFB20:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	adrp	x0, pim_size
	add	x0, x0, :lo12:pim_size
	ldr	x0, [x0]
	mov	x5, 0
	mov	w4, -1
	mov	w3, 50
	mov	w2, 3
	mov	x1, x0
	mov	x0, 268435456
	bl	mmap
	mov	x1, x0
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	str	x1, [x0]
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	cmn	x0, #1
	bne	.L103
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	perror
	mov	w0, 1
	b	.L104
.L103:
	adrp	x0, pim_region
	add	x0, x0, :lo12:pim_region
	ldr	x0, [x0]
	add	x1, x0, 8
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	str	x1, [x0]
	adrp	x0, crf
	add	x0, x0, :lo12:crf
	ldr	x0, [x0]
	add	x1, x0, 128
	adrp	x0, pu_space
	add	x0, x0, :lo12:pu_space
	str	x1, [x0]
	mov	w0, 0
.L104:
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE20:
	.size	init_pim, .-init_pim
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
