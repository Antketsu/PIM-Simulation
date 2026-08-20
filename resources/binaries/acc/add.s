	.arch armv8-a
	.file	"add.c"
	.text
.Ltext0:
	.file 0 "/home/antonio/U/laburo/PIM-Simulation/resources/binaries/acc" "add.c"
	.align	2
	.p2align 4,,11
	.global	fill_matrix
	.type	fill_matrix, %function
fill_matrix:
.LVL0:
.LFB53:
	.file 1 "add.c"
	.loc 1 6 62 view -0
	.cfi_startproc
	.loc 1 7 5 view .LVU1
	.loc 1 8 5 view .LVU2
.LBB13:
	.loc 1 8 9 view .LVU3
	.loc 1 8 22 discriminator 1 view .LVU4
	cbz	x2, .L2
	sub	x13, x2, #1
	mov	w1, 8320
.LVL1:
	.loc 1 8 22 is_stmt 0 discriminator 1 view .LVU5
	mov	w12, 4224
	mov	x14, 31744
	lsr	x13, x13, 12
	add	w13, w1, w13, lsl 12
.LVL2:
.L3:
.LBB14:
	.loc 1 9 26 is_stmt 1 discriminator 1 view .LVU6
	sub	w10, w12, #4096
.LBB15:
.LBB16:
	.loc 1 11 66 is_stmt 0 view .LVU7
	mov	x11, x0
.LVL3:
.L6:
	.loc 1 11 66 view .LVU8
	sub	w4, w10, #128
.LVL4:
	.loc 1 11 66 view .LVU9
.LBE16:
	.loc 1 10 30 is_stmt 1 discriminator 1 view .LVU10
.LBB19:
	.loc 1 11 66 is_stmt 0 view .LVU11
	and	x9, x11, -15361
	mov	x8, 0
.LVL5:
	.p2align 3,,7
.L4:
	.loc 1 11 17 is_stmt 1 view .LVU12
	.loc 1 11 85 is_stmt 0 view .LVU13
	orr	x3, x9, x8
.LVL6:
	.loc 1 12 17 is_stmt 1 view .LVU14
	.loc 1 12 85 is_stmt 0 view .LVU15
	add	x2, x8, 1024
	orr	x2, x2, x9
.LVL7:
	.loc 1 14 17 is_stmt 1 view .LVU16
.LBB17:
	.loc 1 14 21 view .LVU17
	.loc 1 14 34 discriminator 1 view .LVU18
	.loc 1 15 21 view .LVU19
	and	w1, w4, 65535
	.loc 1 15 34 is_stmt 0 view .LVU20
	sxth	w7, w4
	add	w5, w1, 1
	strh	w7, [x3]
	.loc 1 16 21 is_stmt 1 view .LVU21
	.loc 1 15 34 is_stmt 0 view .LVU22
	add	w6, w1, 2
	.loc 1 16 34 view .LVU23
	strh	w7, [x2]
	.loc 1 17 21 is_stmt 1 view .LVU24
.LVL8:
	.loc 1 14 40 discriminator 3 view .LVU25
	.loc 1 14 34 discriminator 1 view .LVU26
	.loc 1 15 21 view .LVU27
	.loc 1 15 34 is_stmt 0 view .LVU28
	sxth	w5, w5
	strh	w5, [x3, 2]
	.loc 1 16 21 is_stmt 1 view .LVU29
	.loc 1 15 34 is_stmt 0 view .LVU30
	sxth	w6, w6
	.loc 1 16 34 view .LVU31
	strh	w5, [x2, 2]
	.loc 1 17 21 is_stmt 1 view .LVU32
.LVL9:
	.loc 1 14 40 discriminator 3 view .LVU33
	.loc 1 14 34 discriminator 1 view .LVU34
	.loc 1 15 21 view .LVU35
	.loc 1 15 34 is_stmt 0 view .LVU36
	add	w5, w1, 3
	strh	w6, [x3, 4]
	.loc 1 16 21 is_stmt 1 view .LVU37
	.loc 1 15 34 is_stmt 0 view .LVU38
	add	w7, w1, 4
	.loc 1 16 34 view .LVU39
	strh	w6, [x2, 4]
	.loc 1 17 21 is_stmt 1 view .LVU40
.LVL10:
	.loc 1 14 40 discriminator 3 view .LVU41
	.loc 1 14 34 discriminator 1 view .LVU42
	.loc 1 15 21 view .LVU43
	.loc 1 15 34 is_stmt 0 view .LVU44
	sxth	w5, w5
	strh	w5, [x3, 6]
	.loc 1 16 21 is_stmt 1 view .LVU45
	.loc 1 15 34 is_stmt 0 view .LVU46
	sxth	w7, w7
	.loc 1 16 34 view .LVU47
	strh	w5, [x2, 6]
	.loc 1 17 21 is_stmt 1 view .LVU48
.LVL11:
	.loc 1 14 40 discriminator 3 view .LVU49
	.loc 1 14 34 discriminator 1 view .LVU50
	.loc 1 15 21 view .LVU51
	.loc 1 15 34 is_stmt 0 view .LVU52
	add	w5, w1, 5
	strh	w7, [x3, 8]
	.loc 1 16 21 is_stmt 1 view .LVU53
	.loc 1 15 34 is_stmt 0 view .LVU54
	add	w6, w1, 6
	.loc 1 16 34 view .LVU55
	strh	w7, [x2, 8]
	.loc 1 17 21 is_stmt 1 view .LVU56
.LVL12:
	.loc 1 14 40 discriminator 3 view .LVU57
	.loc 1 14 34 discriminator 1 view .LVU58
	.loc 1 15 21 view .LVU59
	.loc 1 15 34 is_stmt 0 view .LVU60
	sxth	w5, w5
	strh	w5, [x3, 10]
	.loc 1 16 21 is_stmt 1 view .LVU61
	.loc 1 15 34 is_stmt 0 view .LVU62
	sxth	w6, w6
	.loc 1 16 34 view .LVU63
	strh	w5, [x2, 10]
	.loc 1 17 21 is_stmt 1 view .LVU64
.LVL13:
	.loc 1 14 40 discriminator 3 view .LVU65
	.loc 1 14 34 discriminator 1 view .LVU66
	.loc 1 15 21 view .LVU67
	.loc 1 15 34 is_stmt 0 view .LVU68
	add	w5, w1, 7
	strh	w6, [x3, 12]
	.loc 1 16 21 is_stmt 1 view .LVU69
	.loc 1 15 34 is_stmt 0 view .LVU70
	add	w7, w1, 8
	.loc 1 16 34 view .LVU71
	strh	w6, [x2, 12]
	.loc 1 17 21 is_stmt 1 view .LVU72
.LVL14:
	.loc 1 14 40 discriminator 3 view .LVU73
	.loc 1 14 34 discriminator 1 view .LVU74
	.loc 1 15 21 view .LVU75
	.loc 1 15 34 is_stmt 0 view .LVU76
	sxth	w5, w5
	strh	w5, [x3, 14]
	.loc 1 16 21 is_stmt 1 view .LVU77
	.loc 1 15 34 is_stmt 0 view .LVU78
	sxth	w7, w7
	.loc 1 16 34 view .LVU79
	strh	w5, [x2, 14]
	.loc 1 17 21 is_stmt 1 view .LVU80
.LVL15:
	.loc 1 14 40 discriminator 3 view .LVU81
	.loc 1 14 34 discriminator 1 view .LVU82
	.loc 1 15 21 view .LVU83
	.loc 1 15 34 is_stmt 0 view .LVU84
	add	w5, w1, 9
	strh	w7, [x3, 16]
	.loc 1 16 21 is_stmt 1 view .LVU85
	.loc 1 15 34 is_stmt 0 view .LVU86
	add	w6, w1, 10
	.loc 1 16 34 view .LVU87
	strh	w7, [x2, 16]
	.loc 1 17 21 is_stmt 1 view .LVU88
.LVL16:
	.loc 1 14 40 discriminator 3 view .LVU89
	.loc 1 14 34 discriminator 1 view .LVU90
	.loc 1 15 21 view .LVU91
	.loc 1 15 34 is_stmt 0 view .LVU92
	sxth	w5, w5
	strh	w5, [x3, 18]
	.loc 1 16 21 is_stmt 1 view .LVU93
	.loc 1 15 34 is_stmt 0 view .LVU94
	sxth	w6, w6
	.loc 1 16 34 view .LVU95
	strh	w5, [x2, 18]
	.loc 1 17 21 is_stmt 1 view .LVU96
.LVL17:
	.loc 1 14 40 discriminator 3 view .LVU97
	.loc 1 14 34 discriminator 1 view .LVU98
	.loc 1 15 21 view .LVU99
	.loc 1 15 34 is_stmt 0 view .LVU100
	add	w5, w1, 11
	strh	w6, [x3, 20]
	.loc 1 16 21 is_stmt 1 view .LVU101
	.loc 1 15 34 is_stmt 0 view .LVU102
	add	w7, w1, 12
	.loc 1 16 34 view .LVU103
	strh	w6, [x2, 20]
	.loc 1 17 21 is_stmt 1 view .LVU104
.LVL18:
	.loc 1 14 40 discriminator 3 view .LVU105
	.loc 1 14 34 discriminator 1 view .LVU106
	.loc 1 15 21 view .LVU107
	.loc 1 15 34 is_stmt 0 view .LVU108
	sxth	w5, w5
	strh	w5, [x3, 22]
	.loc 1 16 21 is_stmt 1 view .LVU109
	.loc 1 15 34 is_stmt 0 view .LVU110
	sxth	w7, w7
	.loc 1 16 34 view .LVU111
	strh	w5, [x2, 22]
	.loc 1 17 21 is_stmt 1 view .LVU112
.LVL19:
	.loc 1 14 40 discriminator 3 view .LVU113
	.loc 1 14 34 discriminator 1 view .LVU114
	.loc 1 15 21 view .LVU115
	.loc 1 15 34 is_stmt 0 view .LVU116
	add	w6, w1, 13
	strh	w7, [x3, 24]
	.loc 1 16 21 is_stmt 1 view .LVU117
	.loc 1 15 34 is_stmt 0 view .LVU118
	add	w5, w1, 14
	.loc 1 16 34 view .LVU119
	strh	w7, [x2, 24]
	.loc 1 17 21 is_stmt 1 view .LVU120
.LVL20:
	.loc 1 14 40 discriminator 3 view .LVU121
	.loc 1 14 34 discriminator 1 view .LVU122
	.loc 1 15 21 view .LVU123
	.loc 1 15 34 is_stmt 0 view .LVU124
	sxth	w6, w6
	strh	w6, [x3, 26]
	.loc 1 16 21 is_stmt 1 view .LVU125
	.loc 1 15 34 is_stmt 0 view .LVU126
	sxth	w5, w5
	.loc 1 16 34 view .LVU127
	strh	w6, [x2, 26]
	.loc 1 17 21 is_stmt 1 view .LVU128
.LVL21:
	.loc 1 14 40 discriminator 3 view .LVU129
	.loc 1 14 34 discriminator 1 view .LVU130
	.loc 1 15 21 view .LVU131
	.loc 1 15 34 is_stmt 0 view .LVU132
	add	w1, w1, 15
	strh	w5, [x3, 28]
	.loc 1 16 21 is_stmt 1 view .LVU133
	.loc 1 17 21 is_stmt 0 view .LVU134
	add	w4, w4, 16
.LVL22:
	.loc 1 16 34 view .LVU135
	strh	w5, [x2, 28]
	.loc 1 17 21 is_stmt 1 view .LVU136
.LVL23:
	.loc 1 14 40 discriminator 3 view .LVU137
	.loc 1 14 34 discriminator 1 view .LVU138
	.loc 1 15 21 view .LVU139
	.loc 1 15 34 is_stmt 0 view .LVU140
	sxth	w1, w1
	strh	w1, [x3, 30]
	.loc 1 16 21 is_stmt 1 view .LVU141
.LBE17:
.LBE19:
	.loc 1 10 30 is_stmt 0 discriminator 1 view .LVU142
	add	x8, x8, 2048
.LVL24:
.LBB20:
.LBB18:
	.loc 1 16 34 view .LVU143
	strh	w1, [x2, 30]
	.loc 1 17 21 is_stmt 1 view .LVU144
.LVL25:
	.loc 1 14 40 discriminator 3 view .LVU145
	.loc 1 14 34 discriminator 1 view .LVU146
.LBE18:
.LBE20:
	.loc 1 10 35 discriminator 2 view .LVU147
	.loc 1 10 30 discriminator 1 view .LVU148
	cmp	w4, w10
	bne	.L4
.LBE15:
	.loc 1 20 13 view .LVU149
	.loc 1 9 26 is_stmt 0 discriminator 1 view .LVU150
	add	w10, w4, 128
	.loc 1 20 18 view .LVU151
	add	x11, x11, 32
.LVL26:
	.loc 1 9 32 is_stmt 1 discriminator 2 view .LVU152
	.loc 1 9 26 discriminator 1 view .LVU153
	cmp	w12, w10
	bne	.L6
.LBE14:
	.loc 1 22 9 view .LVU154
	.loc 1 8 22 is_stmt 0 discriminator 1 view .LVU155
	add	w12, w12, 4096
	add	x0, x0, x14
.LVL27:
	.loc 1 8 22 is_stmt 1 discriminator 1 view .LVU156
	cmp	w13, w12
	bne	.L3
.LVL28:
.L2:
	.loc 1 8 22 is_stmt 0 discriminator 1 view .LVU157
.LBE13:
	.loc 1 24 5 is_stmt 1 view .LVU158
	.loc 1 25 1 is_stmt 0 view .LVU159
	ret
	.cfi_endproc
.LFE53:
	.size	fill_matrix, .-fill_matrix
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"C[%d][%d] = %d\n"
	.text
	.align	2
	.p2align 4,,11
	.global	print
	.type	print, %function
print:
.LVL29:
.LFB54:
	.loc 1 51 54 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 52 5 view .LVU161
	.loc 1 53 5 view .LVU162
.LBB21:
	.loc 1 53 9 view .LVU163
	.loc 1 53 22 discriminator 1 view .LVU164
.LBE21:
	.loc 1 51 54 is_stmt 0 view .LVU165
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	str	w1, [sp, 108]
.LBB36:
	.loc 1 53 22 discriminator 1 view .LVU166
	cbz	w1, .L12
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -24
	.cfi_offset 27, -32
	mov	w27, w2
	cbz	w2, .L32
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -72
	.cfi_offset 21, -80
	adrp	x22, .LC0
.LBB22:
.LBB23:
.LBB24:
.LBB25:
.LBB26:
.LBB27:
	.file 2 "/usr/aarch64-linux-gnu/include/bits/stdio2.h"
	.loc 2 86 10 view .LVU167
	add	x22, x22, :lo12:.LC0
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	mov	x25, x0
.LBE27:
.LBE26:
.LBE25:
.LBE24:
.LBE23:
.LBE22:
	.loc 1 53 13 view .LVU168
	mov	w21, 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -88
	.cfi_offset 19, -96
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -56
	.cfi_offset 23, -64
.LVL30:
.L15:
.LBB35:
	.loc 1 54 26 is_stmt 1 discriminator 1 view .LVU169
	.loc 1 54 17 is_stmt 0 view .LVU170
	mov	w26, 0
.LVL31:
.L19:
.LBB34:
	.loc 1 55 30 is_stmt 1 discriminator 1 view .LVU171
.LBB33:
	.loc 1 56 54 is_stmt 0 view .LVU172
	and	x24, x25, -15361
	add	w20, w26, 16
	mov	x23, 0
.LVL32:
	.p2align 3,,7
.L17:
	.loc 1 56 54 view .LVU173
	sub	w19, w20, #16
.LVL33:
	.loc 1 56 17 is_stmt 1 view .LVU174
	.loc 1 56 70 is_stmt 0 view .LVU175
	orr	x28, x23, x24
.LVL34:
	.loc 1 57 17 is_stmt 1 view .LVU176
.LBB32:
	.loc 1 57 21 view .LVU177
	.loc 1 57 34 discriminator 1 view .LVU178
	.p2align 3,,7
.L16:
	.loc 1 58 21 view .LVU179
.LBB30:
.LBI26:
	.loc 2 84 1 view .LVU180
.LBB28:
	.loc 2 86 3 view .LVU181
	.loc 2 86 10 is_stmt 0 view .LVU182
	ldrsh	w4, [x28], 2
	mov	w3, w19
	mov	w2, w21
	mov	x1, x22
	mov	w0, 2
.LBE28:
.LBE30:
	.loc 1 59 21 view .LVU183
	add	w19, w19, 1
.LVL35:
.LBB31:
.LBB29:
	.loc 2 86 10 view .LVU184
	bl	__printf_chk
.LVL36:
	.loc 2 86 10 view .LVU185
.LBE29:
.LBE31:
	.loc 1 59 21 is_stmt 1 view .LVU186
	.loc 1 57 40 discriminator 3 view .LVU187
	.loc 1 57 34 discriminator 1 view .LVU188
	cmp	w20, w19
	bne	.L16
.LBE32:
.LBE33:
	.loc 1 55 38 discriminator 2 view .LVU189
.LVL37:
	.loc 1 55 30 discriminator 1 view .LVU190
	add	x23, x23, 2048
.LVL38:
	.loc 1 55 30 is_stmt 0 discriminator 1 view .LVU191
	add	w20, w20, 16
.LVL39:
	.loc 1 55 30 discriminator 1 view .LVU192
	cmp	x23, 16384
	bne	.L17
.LBE34:
	.loc 1 62 20 view .LVU193
	mov	x0, x25
	add	w26, w26, 128
	.loc 1 62 13 is_stmt 1 view .LVU194
	.loc 1 62 20 is_stmt 0 view .LVU195
	bl	increment_iter
.LVL40:
	mov	x25, x0
.LVL41:
	.loc 1 54 26 is_stmt 1 discriminator 1 view .LVU196
	cmp	w26, w27
	bcc	.L19
.LBE35:
	.loc 1 53 30 discriminator 2 view .LVU197
	.loc 1 53 22 is_stmt 0 discriminator 1 view .LVU198
	ldr	w0, [sp, 108]
.LVL42:
	.loc 1 53 30 discriminator 2 view .LVU199
	add	w21, w21, 1
.LVL43:
	.loc 1 53 22 is_stmt 1 discriminator 1 view .LVU200
	cmp	w0, w21
	bne	.L15
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
.LVL44:
	.loc 1 53 22 is_stmt 0 discriminator 1 view .LVU201
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
.LVL45:
	.loc 1 53 22 discriminator 1 view .LVU202
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
.LVL46:
.L32:
	.loc 1 53 22 discriminator 1 view .LVU203
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
.LVL47:
.L12:
	.loc 1 53 22 discriminator 1 view .LVU204
.LBE36:
	.loc 1 65 1 view .LVU205
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
.LVL48:
	.loc 1 65 1 view .LVU206
	ret
	.cfi_endproc
.LFE54:
	.size	print, .-print
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LVL49:
.LFB55:
	.loc 1 68 34 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 68 34 is_stmt 0 view .LVU208
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
.LVL50:
	.loc 1 68 34 view .LVU209
	stp	x29, x30, [sp, 16]
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x1
	stp	x21, x22, [sp, 48]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	.loc 1 68 34 view .LVU210
	ldr	x1, [x0]
	str	x1, [sp, 8]
	mov	x1, 0
.LVL51:
	.loc 1 69 5 is_stmt 1 view .LVU211
	bl	init_pim
.LVL52:
	.loc 1 72 5 view .LVU212
.LBB37:
.LBI37:
	.file 3 "/usr/aarch64-linux-gnu/include/stdlib.h"
	.loc 3 481 1 view .LVU213
.LBB38:
	.loc 3 483 3 view .LVU214
	.loc 3 483 16 is_stmt 0 view .LVU215
	ldr	x0, [x19, 8]
	mov	w2, 10
	mov	x1, 0
	bl	strtol
.LVL53:
	.loc 3 483 16 view .LVU216
	mov	x20, x0
.LBE38:
.LBE37:
.LBB39:
.LBB40:
	ldr	x0, [x19, 16]
.LVL54:
	.loc 3 483 16 view .LVU217
.LBE40:
.LBE39:
	.loc 1 73 5 is_stmt 1 view .LVU218
.LBB42:
.LBI39:
	.loc 3 481 1 view .LVU219
.LBB41:
	.loc 3 483 3 view .LVU220
	.loc 3 483 16 is_stmt 0 view .LVU221
	mov	w2, 10
	mov	x1, 0
	bl	strtol
.LVL55:
	.loc 3 483 16 view .LVU222
	mov	x21, x0
.LVL56:
	.loc 3 483 16 view .LVU223
.LBE41:
.LBE42:
	.loc 1 75 5 is_stmt 1 view .LVU224
	.loc 1 78 5 is_stmt 0 view .LVU225
	mov	x0, sp
	bl	init_operand
.LVL57:
	.loc 1 79 22 view .LVU226
	ldr	x22, [sp]
	.loc 1 80 5 view .LVU227
	mov	x0, 0
	bl	m5_exit
.LVL58:
	.loc 1 75 14 view .LVU228
	mul	w19, w21, w20
.LVL59:
	.loc 1 77 5 is_stmt 1 view .LVU229
	.loc 1 78 5 view .LVU230
	.loc 1 79 5 view .LVU231
	.loc 1 81 9 is_stmt 0 view .LVU232
	ldr	x15, [sp]
	.loc 1 79 22 view .LVU233
	add	x22, x22, 1024
.LVL60:
	.loc 1 80 5 is_stmt 1 view .LVU234
	.loc 1 81 5 view .LVU235
	.loc 1 81 9 is_stmt 0 view .LVU236
	mov	x2, x19
	mov	x1, x22
	mov	x0, x15
	bl	fill_matrix
.LVL61:
	.loc 1 82 5 view .LVU237
	mov	x3, x19
	.loc 1 81 9 view .LVU238
	mov	x19, x0
.LVL62:
	.loc 1 82 5 is_stmt 1 view .LVU239
	mov	x1, x22
	mov	x0, x15
.LVL63:
	.loc 1 82 5 is_stmt 0 view .LVU240
	mov	x2, x19
	bl	add
.LVL64:
	.loc 1 83 5 is_stmt 1 view .LVU241
	mov	w2, w21
	mov	w1, w20
	mov	x0, x19
	bl	print
.LVL65:
	.loc 1 84 5 view .LVU242
	.loc 1 85 1 is_stmt 0 view .LVU243
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 8]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L36
	ldp	x29, x30, [sp, 16]
	mov	w0, 0
	ldp	x19, x20, [sp, 32]
.LVL66:
	.loc 1 85 1 view .LVU244
	ldp	x21, x22, [sp, 48]
.LVL67:
	.loc 1 85 1 view .LVU245
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
.LVL68:
.L36:
	.cfi_restore_state
	.loc 1 85 1 view .LVU246
	bl	__stack_chk_fail
.LVL69:
	.cfi_endproc
.LFE55:
	.size	main, .-main
	.text
.Letext0:
	.file 4 "/usr/aarch64-linux-gnu/include/bits/types.h"
	.file 5 "/usr/aarch64-linux-gnu/include/bits/stdint-intn.h"
	.file 6 "/usr/aarch64-linux-gnu/include/bits/stdint-uintn.h"
	.file 7 "/usr/aarch64-linux-gnu/include/stdint.h"
	.file 8 "pim.h"
	.file 9 "/home/antonio/U/laburo/PIM-Simulation/gem5-pim/include/gem5/m5ops.h"
	.file 10 "/usr/aarch64-linux-gnu/include/bits/stdio2-decl.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x632
	.2byte	0x5
	.byte	0x1
	.byte	0x8
	.4byte	.Ldebug_abbrev0
	.uleb128 0x14
	.4byte	.LASF39
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL38
	.8byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x15
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF3
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF4
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF5
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.4byte	.LASF6
	.uleb128 0x6
	.4byte	.LASF8
	.byte	0x4
	.byte	0x27
	.byte	0x1a
	.4byte	0x60
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x6
	.4byte	.LASF9
	.byte	0x4
	.byte	0x2a
	.byte	0x16
	.4byte	0x46
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF10
	.uleb128 0x6
	.4byte	.LASF11
	.byte	0x4
	.byte	0x2d
	.byte	0x1b
	.4byte	0x2a
	.uleb128 0x8
	.4byte	0x8b
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF12
	.uleb128 0x16
	.4byte	0x8b
	.uleb128 0x8
	.4byte	0x92
	.uleb128 0x11
	.4byte	0x97
	.uleb128 0x6
	.4byte	.LASF13
	.byte	0x5
	.byte	0x19
	.byte	0x13
	.4byte	0x54
	.uleb128 0x6
	.4byte	.LASF14
	.byte	0x6
	.byte	0x1a
	.byte	0x14
	.4byte	0x67
	.uleb128 0x6
	.4byte	.LASF15
	.byte	0x6
	.byte	0x1b
	.byte	0x14
	.4byte	0x7a
	.uleb128 0x6
	.4byte	.LASF16
	.byte	0x7
	.byte	0x4f
	.byte	0x1b
	.4byte	0x2a
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF17
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF18
	.uleb128 0x8
	.4byte	0xa1
	.uleb128 0xb
	.4byte	.LASF20
	.byte	0x3
	.byte	0xb1
	.byte	0x11
	.4byte	0x73
	.4byte	0x104
	.uleb128 0x2
	.4byte	0x9c
	.uleb128 0x2
	.4byte	0x109
	.uleb128 0x2
	.4byte	0x31
	.byte	0
	.uleb128 0x8
	.4byte	0x86
	.uleb128 0x11
	.4byte	0x104
	.uleb128 0x17
	.string	"add"
	.byte	0x8
	.byte	0x2b
	.byte	0x6
	.4byte	0x12f
	.uleb128 0x2
	.4byte	0xdf
	.uleb128 0x2
	.4byte	0xdf
	.uleb128 0x2
	.4byte	0xdf
	.uleb128 0x2
	.4byte	0xb9
	.byte	0
	.uleb128 0x18
	.4byte	.LASF19
	.byte	0x9
	.byte	0x30
	.byte	0x6
	.4byte	0x141
	.uleb128 0x2
	.4byte	0xb9
	.byte	0
	.uleb128 0xb
	.4byte	.LASF21
	.byte	0x8
	.byte	0x2a
	.byte	0x5
	.4byte	0x31
	.4byte	0x157
	.uleb128 0x2
	.4byte	0x157
	.byte	0
	.uleb128 0x8
	.4byte	0xdf
	.uleb128 0x19
	.4byte	.LASF22
	.byte	0x8
	.byte	0x29
	.byte	0x5
	.4byte	0x31
	.4byte	0x16e
	.uleb128 0xd
	.byte	0
	.uleb128 0xb
	.4byte	.LASF23
	.byte	0xa
	.byte	0x34
	.byte	0xc
	.4byte	0x31
	.4byte	0x18a
	.uleb128 0x2
	.4byte	0x31
	.uleb128 0x2
	.4byte	0x97
	.uleb128 0xd
	.byte	0
	.uleb128 0xb
	.4byte	.LASF24
	.byte	0x8
	.byte	0x2c
	.byte	0xa
	.4byte	0xdf
	.4byte	0x1a0
	.uleb128 0x2
	.4byte	0xdf
	.byte	0
	.uleb128 0x12
	.4byte	.LASF32
	.byte	0x44
	.byte	0x5
	.4byte	0x31
	.8byte	.LFB55
	.8byte	.LFE55-.LFB55
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x398
	.uleb128 0x9
	.4byte	.LASF25
	.byte	0x44
	.byte	0xe
	.4byte	0x31
	.4byte	.LLST28
	.4byte	.LVUS28
	.uleb128 0x9
	.4byte	.LASF26
	.byte	0x44
	.byte	0x1a
	.4byte	0x104
	.4byte	.LLST29
	.4byte	.LVUS29
	.uleb128 0x5
	.4byte	.LASF27
	.byte	0x48
	.byte	0xe
	.4byte	0xad
	.4byte	.LLST30
	.4byte	.LVUS30
	.uleb128 0x5
	.4byte	.LASF28
	.byte	0x49
	.byte	0xe
	.4byte	0xad
	.4byte	.LLST31
	.4byte	.LVUS31
	.uleb128 0x5
	.4byte	.LASF29
	.byte	0x4b
	.byte	0xe
	.4byte	0xb9
	.4byte	.LLST32
	.4byte	.LVUS32
	.uleb128 0x1a
	.string	"A"
	.byte	0x1
	.byte	0x4d
	.byte	0xe
	.4byte	0xdf
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x4
	.string	"B"
	.byte	0x4d
	.byte	0x12
	.4byte	0xdf
	.4byte	.LLST33
	.4byte	.LVUS33
	.uleb128 0x4
	.string	"C"
	.byte	0x4d
	.byte	0x16
	.4byte	0xdf
	.4byte	.LLST34
	.4byte	.LVUS34
	.uleb128 0x1b
	.4byte	0x5ed
	.8byte	.LBI37
	.byte	.LVU213
	.8byte	.LBB37
	.8byte	.LBE37-.LBB37
	.byte	0x1
	.byte	0x48
	.byte	0x15
	.4byte	0x29a
	.uleb128 0xe
	.4byte	0x5ff
	.4byte	.LLST35
	.4byte	.LVUS35
	.uleb128 0xc
	.8byte	.LVL53
	.4byte	0xe4
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x3a
	.byte	0
	.byte	0
	.uleb128 0x1c
	.4byte	0x5ed
	.8byte	.LBI39
	.byte	.LVU219
	.4byte	.LLRL36
	.byte	0x1
	.byte	0x49
	.byte	0x15
	.4byte	0x2d9
	.uleb128 0xe
	.4byte	0x5ff
	.4byte	.LLST37
	.4byte	.LVUS37
	.uleb128 0xc
	.8byte	.LVL55
	.4byte	0xe4
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x3a
	.byte	0
	.byte	0
	.uleb128 0x13
	.8byte	.LVL52
	.4byte	0x15c
	.uleb128 0xa
	.8byte	.LVL57
	.4byte	0x141
	.4byte	0x2fe
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8f
	.sleb128 0
	.byte	0
	.uleb128 0xa
	.8byte	.LVL58
	.4byte	0x12f
	.4byte	0x315
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0xa
	.8byte	.LVL61
	.4byte	0x4d7
	.4byte	0x339
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0xa
	.8byte	.LVL64
	.4byte	0x10e
	.4byte	0x366
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x53
	.uleb128 0xb
	.byte	0x85
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x1e
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0
	.uleb128 0xa
	.8byte	.LVL65
	.4byte	0x398
	.4byte	0x38a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x13
	.8byte	.LVL69
	.4byte	0x62c
	.byte	0
	.uleb128 0x1d
	.4byte	.LASF40
	.byte	0x1
	.byte	0x33
	.byte	0x6
	.8byte	.LFB54
	.8byte	.LFE54-.LFB54
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4d7
	.uleb128 0xf
	.string	"op"
	.byte	0x33
	.byte	0x15
	.4byte	0xdf
	.4byte	.LLST12
	.4byte	.LVUS12
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x33
	.byte	0x22
	.4byte	0xad
	.4byte	.LLST13
	.4byte	.LVUS13
	.uleb128 0x9
	.4byte	.LASF28
	.byte	0x33
	.byte	0x31
	.4byte	0xad
	.4byte	.LLST14
	.4byte	.LVUS14
	.uleb128 0x5
	.4byte	.LASF30
	.byte	0x34
	.byte	0xe
	.4byte	0xdf
	.4byte	.LLST15
	.4byte	.LVUS15
	.uleb128 0x7
	.4byte	.LLRL16
	.uleb128 0x4
	.string	"i"
	.byte	0x35
	.byte	0xd
	.4byte	0x31
	.4byte	.LLST17
	.4byte	.LVUS17
	.uleb128 0x7
	.4byte	.LLRL18
	.uleb128 0x4
	.string	"j"
	.byte	0x36
	.byte	0x11
	.4byte	0x31
	.4byte	.LLST19
	.4byte	.LVUS19
	.uleb128 0x1e
	.4byte	.LLRL20
	.4byte	0x4c0
	.uleb128 0x4
	.string	"b"
	.byte	0x37
	.byte	0x15
	.4byte	0x31
	.4byte	.LLST21
	.4byte	.LVUS21
	.uleb128 0x7
	.4byte	.LLRL22
	.uleb128 0x5
	.4byte	.LASF31
	.byte	0x38
	.byte	0x1a
	.4byte	0xdf
	.4byte	.LLST23
	.4byte	.LVUS23
	.uleb128 0x7
	.4byte	.LLRL24
	.uleb128 0x4
	.string	"k"
	.byte	0x39
	.byte	0x19
	.4byte	0x31
	.4byte	.LLST25
	.4byte	.LVUS25
	.uleb128 0x1f
	.4byte	0x60d
	.8byte	.LBI26
	.byte	.LVU180
	.4byte	.LLRL26
	.byte	0x1
	.byte	0x3a
	.byte	0x15
	.uleb128 0xe
	.4byte	0x61e
	.4byte	.LLST27
	.4byte	.LVUS27
	.uleb128 0xc
	.8byte	.LVL36
	.4byte	0x16e
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x32
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x2
	.byte	0x83
	.sleb128 -1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xc
	.8byte	.LVL40
	.4byte	0x18a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x12
	.4byte	.LASF33
	.byte	0x6
	.byte	0xa
	.4byte	0xdf
	.8byte	.LFB53
	.8byte	.LFE53-.LFB53
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5ed
	.uleb128 0xf
	.string	"A"
	.byte	0x6
	.byte	0x1f
	.4byte	0xdf
	.4byte	.LLST0
	.4byte	.LVUS0
	.uleb128 0xf
	.string	"B"
	.byte	0x6
	.byte	0x2b
	.4byte	0xdf
	.4byte	.LLST1
	.4byte	.LVUS1
	.uleb128 0x9
	.4byte	.LASF29
	.byte	0x6
	.byte	0x38
	.4byte	0xb9
	.4byte	.LLST2
	.4byte	.LVUS2
	.uleb128 0x5
	.4byte	.LASF30
	.byte	0x7
	.byte	0xe
	.4byte	0xdf
	.4byte	.LLST3
	.4byte	.LVUS3
	.uleb128 0x10
	.8byte	.LBB13
	.8byte	.LBE13-.LBB13
	.uleb128 0x4
	.string	"i"
	.byte	0x8
	.byte	0xd
	.4byte	0x31
	.4byte	.LLST4
	.4byte	.LVUS4
	.uleb128 0x10
	.8byte	.LBB14
	.8byte	.LBE14-.LBB14
	.uleb128 0x4
	.string	"r"
	.byte	0x9
	.byte	0x11
	.4byte	0x31
	.4byte	.LLST5
	.4byte	.LVUS5
	.uleb128 0x10
	.8byte	.LBB15
	.8byte	.LBE15-.LBB15
	.uleb128 0x4
	.string	"b"
	.byte	0xa
	.byte	0x15
	.4byte	0x31
	.4byte	.LLST6
	.4byte	.LVUS6
	.uleb128 0x7
	.4byte	.LLRL7
	.uleb128 0x5
	.4byte	.LASF34
	.byte	0xb
	.byte	0x1a
	.4byte	0xdf
	.4byte	.LLST8
	.4byte	.LVUS8
	.uleb128 0x5
	.4byte	.LASF35
	.byte	0xc
	.byte	0x1a
	.4byte	0xdf
	.4byte	.LLST9
	.4byte	.LVUS9
	.uleb128 0x7
	.4byte	.LLRL10
	.uleb128 0x4
	.string	"k"
	.byte	0xe
	.byte	0x19
	.4byte	0x31
	.4byte	.LLST11
	.4byte	.LVUS11
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x20
	.4byte	.LASF36
	.byte	0x3
	.2byte	0x1e1
	.byte	0x1
	.4byte	0x31
	.byte	0x3
	.4byte	0x60d
	.uleb128 0x21
	.4byte	.LASF37
	.byte	0x3
	.2byte	0x1e1
	.byte	0x1
	.4byte	0x97
	.byte	0
	.uleb128 0x22
	.4byte	.LASF41
	.byte	0x2
	.byte	0x54
	.byte	0x1
	.4byte	0x31
	.byte	0x3
	.4byte	0x62c
	.uleb128 0x23
	.4byte	.LASF38
	.byte	0x2
	.byte	0x54
	.byte	0x20
	.4byte	0x9c
	.uleb128 0xd
	.byte	0
	.uleb128 0x24
	.4byte	.LASF42
	.4byte	.LASF42
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
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
	.uleb128 0x4
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
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
	.uleb128 0xc
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xf
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x37
	.byte	0
	.uleb128 0x49
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
	.uleb128 0x21
	.sleb128 1
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
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
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
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x15
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
	.uleb128 0x16
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
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
	.uleb128 0x18
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
	.uleb128 0x19
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
	.uleb128 0x1a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
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
	.uleb128 0x1b
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
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
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x20
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
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
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
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x34
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x5
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
	.uleb128 0x24
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"",@progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x8
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LVUS28:
	.uleb128 0
	.uleb128 .LVU209
	.uleb128 .LVU209
	.uleb128 0
.LLST28:
	.byte	0x6
	.8byte	.LVL49
	.byte	0x4
	.uleb128 .LVL49-.LVL49
	.uleb128 .LVL50-.LVL49
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL50-.LVL49
	.uleb128 .LFE55-.LVL49
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.byte	0
.LVUS29:
	.uleb128 0
	.uleb128 .LVU211
	.uleb128 .LVU211
	.uleb128 .LVU229
	.uleb128 .LVU229
	.uleb128 0
.LLST29:
	.byte	0x6
	.8byte	.LVL49
	.byte	0x4
	.uleb128 .LVL49-.LVL49
	.uleb128 .LVL51-.LVL49
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL51-.LVL49
	.uleb128 .LVL59-.LVL49
	.uleb128 0x1
	.byte	0x63
	.byte	0x4
	.uleb128 .LVL59-.LVL49
	.uleb128 .LFE55-.LVL49
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0
.LVUS30:
	.uleb128 .LVU217
	.uleb128 .LVU244
	.uleb128 .LVU246
	.uleb128 0
.LLST30:
	.byte	0x6
	.8byte	.LVL54
	.byte	0x4
	.uleb128 .LVL54-.LVL54
	.uleb128 .LVL66-.LVL54
	.uleb128 0x1
	.byte	0x64
	.byte	0x4
	.uleb128 .LVL68-.LVL54
	.uleb128 .LFE55-.LVL54
	.uleb128 0x1
	.byte	0x64
	.byte	0
.LVUS31:
	.uleb128 .LVU223
	.uleb128 .LVU245
	.uleb128 .LVU246
	.uleb128 0
.LLST31:
	.byte	0x6
	.8byte	.LVL56
	.byte	0x4
	.uleb128 .LVL56-.LVL56
	.uleb128 .LVL67-.LVL56
	.uleb128 0x1
	.byte	0x65
	.byte	0x4
	.uleb128 .LVL68-.LVL56
	.uleb128 .LFE55-.LVL56
	.uleb128 0x1
	.byte	0x65
	.byte	0
.LVUS32:
	.uleb128 .LVU229
	.uleb128 .LVU239
	.uleb128 .LVU239
	.uleb128 .LVU241
	.uleb128 .LVU241
	.uleb128 .LVU244
	.uleb128 .LVU246
	.uleb128 0
.LLST32:
	.byte	0x6
	.8byte	.LVL59
	.byte	0x4
	.uleb128 .LVL59-.LVL59
	.uleb128 .LVL62-.LVL59
	.uleb128 0x1
	.byte	0x63
	.byte	0x4
	.uleb128 .LVL62-.LVL59
	.uleb128 .LVL64-1-.LVL59
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL64-1-.LVL59
	.uleb128 .LVL66-.LVL59
	.uleb128 0xc
	.byte	0x85
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x1e
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL68-.LVL59
	.uleb128 .LFE55-.LVL59
	.uleb128 0xc
	.byte	0x85
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x1e
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x9f
	.byte	0
.LVUS33:
	.uleb128 .LVU234
	.uleb128 .LVU245
	.uleb128 .LVU246
	.uleb128 0
.LLST33:
	.byte	0x6
	.8byte	.LVL60
	.byte	0x4
	.uleb128 .LVL60-.LVL60
	.uleb128 .LVL67-.LVL60
	.uleb128 0x1
	.byte	0x66
	.byte	0x4
	.uleb128 .LVL68-.LVL60
	.uleb128 .LFE55-.LVL60
	.uleb128 0x1
	.byte	0x66
	.byte	0
.LVUS34:
	.uleb128 .LVU239
	.uleb128 .LVU240
	.uleb128 .LVU240
	.uleb128 .LVU244
	.uleb128 .LVU246
	.uleb128 0
.LLST34:
	.byte	0x6
	.8byte	.LVL62
	.byte	0x4
	.uleb128 .LVL62-.LVL62
	.uleb128 .LVL63-.LVL62
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL63-.LVL62
	.uleb128 .LVL66-.LVL62
	.uleb128 0x1
	.byte	0x63
	.byte	0x4
	.uleb128 .LVL68-.LVL62
	.uleb128 .LFE55-.LVL62
	.uleb128 0x1
	.byte	0x63
	.byte	0
.LVUS35:
	.uleb128 .LVU213
	.uleb128 .LVU216
.LLST35:
	.byte	0x8
	.8byte	.LVL52
	.uleb128 .LVL53-1-.LVL52
	.uleb128 0x2
	.byte	0x83
	.sleb128 8
	.byte	0
.LVUS37:
	.uleb128 .LVU219
	.uleb128 .LVU222
.LLST37:
	.byte	0x8
	.8byte	.LVL54
	.uleb128 .LVL55-1-.LVL54
	.uleb128 0x2
	.byte	0x83
	.sleb128 16
	.byte	0
.LVUS12:
	.uleb128 0
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 0
.LLST12:
	.byte	0x6
	.8byte	.LVL29
	.byte	0x4
	.uleb128 .LVL29-.LVL29
	.uleb128 .LVL30-.LVL29
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL30-.LVL29
	.uleb128 .LFE54-.LVL29
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.byte	0
.LVUS13:
	.uleb128 0
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 .LVU206
	.uleb128 .LVU206
	.uleb128 0
.LLST13:
	.byte	0x6
	.8byte	.LVL29
	.byte	0x4
	.uleb128 .LVL29-.LVL29
	.uleb128 .LVL30-.LVL29
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL30-.LVL29
	.uleb128 .LVL48-.LVL29
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.byte	0x4
	.uleb128 .LVL48-.LVL29
	.uleb128 .LFE54-.LVL29
	.uleb128 0x2
	.byte	0x8f
	.sleb128 -4
	.byte	0
.LVUS14:
	.uleb128 0
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 .LVU204
	.uleb128 .LVU204
	.uleb128 0
.LLST14:
	.byte	0x6
	.8byte	.LVL29
	.byte	0x4
	.uleb128 .LVL29-.LVL29
	.uleb128 .LVL30-.LVL29
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL30-.LVL29
	.uleb128 .LVL47-.LVL29
	.uleb128 0x1
	.byte	0x6b
	.byte	0x4
	.uleb128 .LVL47-.LVL29
	.uleb128 .LFE54-.LVL29
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS15:
	.uleb128 .LVU162
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 .LVU196
	.uleb128 .LVU196
	.uleb128 .LVU199
	.uleb128 .LVU199
	.uleb128 .LVU203
.LLST15:
	.byte	0x6
	.8byte	.LVL29
	.byte	0x4
	.uleb128 .LVL29-.LVL29
	.uleb128 .LVL30-.LVL29
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL30-.LVL29
	.uleb128 .LVL41-.LVL29
	.uleb128 0x1
	.byte	0x69
	.byte	0x4
	.uleb128 .LVL41-.LVL29
	.uleb128 .LVL42-.LVL29
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL42-.LVL29
	.uleb128 .LVL46-.LVL29
	.uleb128 0x1
	.byte	0x69
	.byte	0
.LVUS17:
	.uleb128 .LVU164
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 .LVU201
.LLST17:
	.byte	0x6
	.8byte	.LVL29
	.byte	0x4
	.uleb128 .LVL29-.LVL29
	.uleb128 .LVL30-.LVL29
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL30-.LVL29
	.uleb128 .LVL44-.LVL29
	.uleb128 0x1
	.byte	0x65
	.byte	0
.LVUS19:
	.uleb128 .LVU169
	.uleb128 .LVU171
	.uleb128 .LVU171
	.uleb128 .LVU173
	.uleb128 .LVU174
	.uleb128 .LVU184
	.uleb128 .LVU184
	.uleb128 .LVU185
	.uleb128 .LVU185
	.uleb128 .LVU187
	.uleb128 .LVU187
	.uleb128 .LVU190
	.uleb128 .LVU190
	.uleb128 .LVU192
	.uleb128 .LVU192
	.uleb128 .LVU196
	.uleb128 .LVU196
	.uleb128 .LVU203
.LLST19:
	.byte	0x6
	.8byte	.LVL30
	.byte	0x4
	.uleb128 .LVL30-.LVL30
	.uleb128 .LVL31-.LVL30
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL31-.LVL30
	.uleb128 .LVL32-.LVL30
	.uleb128 0x1
	.byte	0x6a
	.byte	0x4
	.uleb128 .LVL33-.LVL30
	.uleb128 .LVL35-.LVL30
	.uleb128 0x1
	.byte	0x63
	.byte	0x4
	.uleb128 .LVL35-.LVL30
	.uleb128 .LVL36-1-.LVL30
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL36-1-.LVL30
	.uleb128 .LVL36-.LVL30
	.uleb128 0x3
	.byte	0x83
	.sleb128 -1
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL36-.LVL30
	.uleb128 .LVL37-.LVL30
	.uleb128 0x1
	.byte	0x63
	.byte	0x4
	.uleb128 .LVL37-.LVL30
	.uleb128 .LVL39-.LVL30
	.uleb128 0x1
	.byte	0x64
	.byte	0x4
	.uleb128 .LVL39-.LVL30
	.uleb128 .LVL41-.LVL30
	.uleb128 0x3
	.byte	0x84
	.sleb128 -16
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL41-.LVL30
	.uleb128 .LVL46-.LVL30
	.uleb128 0x1
	.byte	0x6a
	.byte	0
.LVUS21:
	.uleb128 .LVU171
	.uleb128 .LVU173
	.uleb128 .LVU174
	.uleb128 .LVU190
	.uleb128 .LVU190
	.uleb128 .LVU191
	.uleb128 .LVU191
	.uleb128 .LVU202
.LLST21:
	.byte	0x6
	.8byte	.LVL31
	.byte	0x4
	.uleb128 .LVL31-.LVL31
	.uleb128 .LVL32-.LVL31
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.LVL31
	.uleb128 .LVL37-.LVL31
	.uleb128 0x5
	.byte	0x87
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL37-.LVL31
	.uleb128 .LVL38-.LVL31
	.uleb128 0x7
	.byte	0x87
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0x23
	.uleb128 0x2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL31
	.uleb128 .LVL45-.LVL31
	.uleb128 0x8
	.byte	0x87
	.sleb128 -2048
	.byte	0x3a
	.byte	0x25
	.byte	0x23
	.uleb128 0x2
	.byte	0x9f
	.byte	0
.LVUS23:
	.uleb128 .LVU176
	.uleb128 .LVU179
	.uleb128 .LVU179
	.uleb128 .LVU191
	.uleb128 .LVU191
	.uleb128 .LVU202
.LLST23:
	.byte	0x6
	.8byte	.LVL34
	.byte	0x4
	.uleb128 .LVL34-.LVL34
	.uleb128 .LVL34-.LVL34
	.uleb128 0x1
	.byte	0x6c
	.byte	0x4
	.uleb128 .LVL34-.LVL34
	.uleb128 .LVL38-.LVL34
	.uleb128 0x6
	.byte	0x87
	.sleb128 0
	.byte	0x88
	.sleb128 0
	.byte	0x21
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL34
	.uleb128 .LVL45-.LVL34
	.uleb128 0x7
	.byte	0x87
	.sleb128 -2048
	.byte	0x88
	.sleb128 0
	.byte	0x21
	.byte	0x9f
	.byte	0
.LVUS25:
	.uleb128 .LVU178
	.uleb128 .LVU203
.LLST25:
	.byte	0x8
	.8byte	.LVL34
	.uleb128 .LVL46-.LVL34
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS27:
	.uleb128 .LVU180
	.uleb128 .LVU185
.LLST27:
	.byte	0x8
	.8byte	.LVL34
	.uleb128 .LVL36-.LVL34
	.uleb128 0xa
	.byte	0x3
	.8byte	.LC0
	.byte	0x9f
	.byte	0
.LVUS0:
	.uleb128 0
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 0
.LLST0:
	.byte	0x6
	.8byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-.LVL0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL2-.LVL0
	.uleb128 .LFE53-.LVL0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 0
	.uleb128 .LVU5
	.uleb128 .LVU5
	.uleb128 0
.LLST1:
	.byte	0x6
	.8byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL1-.LVL0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL1-.LVL0
	.uleb128 .LFE53-.LVL0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0
.LVUS2:
	.uleb128 0
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 0
.LLST2:
	.byte	0x6
	.8byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-.LVL0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL2-.LVL0
	.uleb128 .LFE53-.LVL0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS3:
	.uleb128 .LVU2
	.uleb128 .LVU8
	.uleb128 .LVU8
	.uleb128 .LVU156
	.uleb128 .LVU156
	.uleb128 0
.LLST3:
	.byte	0x6
	.8byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL3-.LVL0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL3-.LVL0
	.uleb128 .LVL27-.LVL0
	.uleb128 0x1
	.byte	0x5b
	.byte	0x4
	.uleb128 .LVL27-.LVL0
	.uleb128 .LFE53-.LVL0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS4:
	.uleb128 .LVU4
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU8
	.uleb128 .LVU9
	.uleb128 .LVU25
	.uleb128 .LVU25
	.uleb128 .LVU33
	.uleb128 .LVU33
	.uleb128 .LVU41
	.uleb128 .LVU41
	.uleb128 .LVU49
	.uleb128 .LVU49
	.uleb128 .LVU57
	.uleb128 .LVU57
	.uleb128 .LVU65
	.uleb128 .LVU65
	.uleb128 .LVU73
	.uleb128 .LVU73
	.uleb128 .LVU81
	.uleb128 .LVU81
	.uleb128 .LVU89
	.uleb128 .LVU89
	.uleb128 .LVU97
	.uleb128 .LVU97
	.uleb128 .LVU105
	.uleb128 .LVU105
	.uleb128 .LVU113
	.uleb128 .LVU113
	.uleb128 .LVU121
	.uleb128 .LVU121
	.uleb128 .LVU129
	.uleb128 .LVU129
	.uleb128 .LVU135
	.uleb128 .LVU135
	.uleb128 .LVU137
	.uleb128 .LVU145
	.uleb128 .LVU156
.LLST4:
	.byte	0x6
	.8byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-.LVL0
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL2-.LVL0
	.uleb128 .LVL3-.LVL0
	.uleb128 0x4
	.byte	0x7c
	.sleb128 -4224
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL4-.LVL0
	.uleb128 .LVL8-.LVL0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL8-.LVL0
	.uleb128 .LVL9-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 1
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL9-.LVL0
	.uleb128 .LVL10-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL10-.LVL0
	.uleb128 .LVL11-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 3
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL11-.LVL0
	.uleb128 .LVL12-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 4
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL12-.LVL0
	.uleb128 .LVL13-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 5
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL13-.LVL0
	.uleb128 .LVL14-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 6
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL14-.LVL0
	.uleb128 .LVL15-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 7
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL15-.LVL0
	.uleb128 .LVL16-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 8
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL16-.LVL0
	.uleb128 .LVL17-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 9
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL17-.LVL0
	.uleb128 .LVL18-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 10
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL18-.LVL0
	.uleb128 .LVL19-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 11
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.LVL0
	.uleb128 .LVL20-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 12
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL20-.LVL0
	.uleb128 .LVL21-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 13
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL21-.LVL0
	.uleb128 .LVL22-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 14
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL22-.LVL0
	.uleb128 .LVL23-.LVL0
	.uleb128 0x3
	.byte	0x74
	.sleb128 -2
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL25-.LVL0
	.uleb128 .LVL27-.LVL0
	.uleb128 0x1
	.byte	0x54
	.byte	0
.LVUS5:
	.uleb128 .LVU6
	.uleb128 .LVU8
.LLST5:
	.byte	0x8
	.8byte	.LVL2
	.uleb128 .LVL3-.LVL2
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS6:
	.uleb128 .LVU9
	.uleb128 .LVU12
	.uleb128 .LVU12
	.uleb128 .LVU143
	.uleb128 .LVU143
	.uleb128 .LVU148
.LLST6:
	.byte	0x6
	.8byte	.LVL4
	.byte	0x4
	.uleb128 .LVL4-.LVL4
	.uleb128 .LVL5-.LVL4
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL5-.LVL4
	.uleb128 .LVL24-.LVL4
	.uleb128 0x5
	.byte	0x78
	.sleb128 0
	.byte	0x3b
	.byte	0x25
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL24-.LVL4
	.uleb128 .LVL25-.LVL4
	.uleb128 0x6
	.byte	0x78
	.sleb128 -2048
	.byte	0x3b
	.byte	0x25
	.byte	0x9f
	.byte	0
.LVUS8:
	.uleb128 .LVU14
	.uleb128 .LVU157
.LLST8:
	.byte	0x8
	.8byte	.LVL6
	.uleb128 .LVL28-.LVL6
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS9:
	.uleb128 .LVU16
	.uleb128 .LVU157
.LLST9:
	.byte	0x8
	.8byte	.LVL7
	.uleb128 .LVL28-.LVL7
	.uleb128 0x1
	.byte	0x52
	.byte	0
.LVUS11:
	.uleb128 .LVU18
	.uleb128 .LVU26
	.uleb128 .LVU26
	.uleb128 .LVU34
	.uleb128 .LVU34
	.uleb128 .LVU42
	.uleb128 .LVU42
	.uleb128 .LVU50
	.uleb128 .LVU50
	.uleb128 .LVU58
	.uleb128 .LVU58
	.uleb128 .LVU66
	.uleb128 .LVU66
	.uleb128 .LVU74
	.uleb128 .LVU74
	.uleb128 .LVU82
	.uleb128 .LVU82
	.uleb128 .LVU90
	.uleb128 .LVU90
	.uleb128 .LVU98
	.uleb128 .LVU98
	.uleb128 .LVU106
	.uleb128 .LVU106
	.uleb128 .LVU114
	.uleb128 .LVU114
	.uleb128 .LVU122
	.uleb128 .LVU122
	.uleb128 .LVU130
	.uleb128 .LVU130
	.uleb128 .LVU138
	.uleb128 .LVU138
	.uleb128 .LVU146
	.uleb128 .LVU146
	.uleb128 .LVU157
.LLST11:
	.byte	0x6
	.8byte	.LVL7
	.byte	0x4
	.uleb128 .LVL7-.LVL7
	.uleb128 .LVL8-.LVL7
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL8-.LVL7
	.uleb128 .LVL9-.LVL7
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL9-.LVL7
	.uleb128 .LVL10-.LVL7
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL10-.LVL7
	.uleb128 .LVL11-.LVL7
	.uleb128 0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL11-.LVL7
	.uleb128 .LVL12-.LVL7
	.uleb128 0x2
	.byte	0x34
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL12-.LVL7
	.uleb128 .LVL13-.LVL7
	.uleb128 0x2
	.byte	0x35
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL13-.LVL7
	.uleb128 .LVL14-.LVL7
	.uleb128 0x2
	.byte	0x36
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL14-.LVL7
	.uleb128 .LVL15-.LVL7
	.uleb128 0x2
	.byte	0x37
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL15-.LVL7
	.uleb128 .LVL16-.LVL7
	.uleb128 0x2
	.byte	0x38
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL16-.LVL7
	.uleb128 .LVL17-.LVL7
	.uleb128 0x2
	.byte	0x39
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL17-.LVL7
	.uleb128 .LVL18-.LVL7
	.uleb128 0x2
	.byte	0x3a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL18-.LVL7
	.uleb128 .LVL19-.LVL7
	.uleb128 0x2
	.byte	0x3b
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL19-.LVL7
	.uleb128 .LVL20-.LVL7
	.uleb128 0x2
	.byte	0x3c
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL20-.LVL7
	.uleb128 .LVL21-.LVL7
	.uleb128 0x2
	.byte	0x3d
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL21-.LVL7
	.uleb128 .LVL23-.LVL7
	.uleb128 0x2
	.byte	0x3e
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL23-.LVL7
	.uleb128 .LVL25-.LVL7
	.uleb128 0x2
	.byte	0x3f
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL25-.LVL7
	.uleb128 .LVL28-.LVL7
	.uleb128 0x2
	.byte	0x40
	.byte	0x9f
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",@progbits
	.4byte	0x3c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x8
	.byte	0
	.2byte	0
	.2byte	0
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.8byte	.LFB55
	.8byte	.LFE55-.LFB55
	.8byte	0
	.8byte	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x8
	.byte	0
	.4byte	0
.LLRL7:
	.byte	0x5
	.8byte	.LBB16
	.byte	0x4
	.uleb128 .LBB16-.LBB16
	.uleb128 .LBE16-.LBB16
	.byte	0x4
	.uleb128 .LBB19-.LBB16
	.uleb128 .LBE19-.LBB16
	.byte	0x4
	.uleb128 .LBB20-.LBB16
	.uleb128 .LBE20-.LBB16
	.byte	0
.LLRL10:
	.byte	0x5
	.8byte	.LBB17
	.byte	0x4
	.uleb128 .LBB17-.LBB17
	.uleb128 .LBE17-.LBB17
	.byte	0x4
	.uleb128 .LBB18-.LBB17
	.uleb128 .LBE18-.LBB17
	.byte	0
.LLRL16:
	.byte	0x5
	.8byte	.LBB21
	.byte	0x4
	.uleb128 .LBB21-.LBB21
	.uleb128 .LBE21-.LBB21
	.byte	0x4
	.uleb128 .LBB36-.LBB21
	.uleb128 .LBE36-.LBB21
	.byte	0
.LLRL18:
	.byte	0x5
	.8byte	.LBB22
	.byte	0x4
	.uleb128 .LBB22-.LBB22
	.uleb128 .LBE22-.LBB22
	.byte	0x4
	.uleb128 .LBB35-.LBB22
	.uleb128 .LBE35-.LBB22
	.byte	0
.LLRL20:
	.byte	0x5
	.8byte	.LBB23
	.byte	0x4
	.uleb128 .LBB23-.LBB23
	.uleb128 .LBE23-.LBB23
	.byte	0x4
	.uleb128 .LBB34-.LBB23
	.uleb128 .LBE34-.LBB23
	.byte	0
.LLRL22:
	.byte	0x5
	.8byte	.LBB24
	.byte	0x4
	.uleb128 .LBB24-.LBB24
	.uleb128 .LBE24-.LBB24
	.byte	0x4
	.uleb128 .LBB33-.LBB24
	.uleb128 .LBE33-.LBB24
	.byte	0
.LLRL24:
	.byte	0x5
	.8byte	.LBB25
	.byte	0x4
	.uleb128 .LBB25-.LBB25
	.uleb128 .LBE25-.LBB25
	.byte	0x4
	.uleb128 .LBB32-.LBB25
	.uleb128 .LBE32-.LBB25
	.byte	0
.LLRL26:
	.byte	0x5
	.8byte	.LBB26
	.byte	0x4
	.uleb128 .LBB26-.LBB26
	.uleb128 .LBE26-.LBB26
	.byte	0x4
	.uleb128 .LBB30-.LBB26
	.uleb128 .LBE30-.LBB26
	.byte	0x4
	.uleb128 .LBB31-.LBB26
	.uleb128 .LBE31-.LBB26
	.byte	0
.LLRL36:
	.byte	0x5
	.8byte	.LBB39
	.byte	0x4
	.uleb128 .LBB39-.LBB39
	.uleb128 .LBE39-.LBB39
	.byte	0x4
	.uleb128 .LBB42-.LBB39
	.uleb128 .LBE42-.LBB39
	.byte	0
.LLRL38:
	.byte	0x7
	.8byte	.Ltext0
	.uleb128 .Letext0-.Ltext0
	.byte	0x7
	.8byte	.LFB55
	.uleb128 .LFE55-.LFB55
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF8:
	.string	"__int16_t"
.LASF22:
	.string	"init_pim"
.LASF16:
	.string	"uintptr_t"
.LASF21:
	.string	"init_operand"
.LASF30:
	.string	"iter"
.LASF19:
	.string	"m5_exit"
.LASF15:
	.string	"uint64_t"
.LASF23:
	.string	"__printf_chk"
.LASF3:
	.string	"unsigned char"
.LASF39:
	.string	"GNU C17 13.3.0 -mlittle-endian -mabi=lp64 -g -O3 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection"
.LASF2:
	.string	"long unsigned int"
.LASF4:
	.string	"short unsigned int"
.LASF42:
	.string	"__stack_chk_fail"
.LASF31:
	.string	"bank_ptr"
.LASF9:
	.string	"__uint32_t"
.LASF28:
	.string	"cols"
.LASF32:
	.string	"main"
.LASF5:
	.string	"unsigned int"
.LASF37:
	.string	"__nptr"
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
.LASF40:
	.string	"print"
.LASF41:
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
.LASF38:
	.string	"__fmt"
.LASF20:
	.string	"strtol"
.LASF36:
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
