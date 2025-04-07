.psp

.include "./src/gpu_macros.asm"

VERTEX equ 0x0891E400
ICON equ 0x0891E3E0

sceGeListEnQueue equ 0x0890BC50


.createfile "./bin/GATHERING_NODES_JP.bin", 0x0891E430
    addiu sp, sp, -0xC    ; Abre espaço na pilha
    sw    v0, 0($sp)     ; Salva $v0
    sw    v1, 4($sp)     ; Salva $v1
    sw    ra, 8($sp)     ; Salva $ra


    li a0, 0x090AF180
    li a1, 0x09FFF4BE
    li a2, 0x09FFF4A0

    jal	0x09A6A690
    nop

    li t0, 0xFFFF
    beq v0, t0, return
    nop

    lui  t1, 0xFFFF       ; t1 = 0xFFFF0000
    and  t0, v1, t1       ; t0 = v1 & 0xFFFF0000
    bnez t0, return
    nop

    li t0, 0x4
    beq t0, v1, bug
    nop

    li t0, 0x3
    beq t0, v1, mine
    nop

    j unknown
    nop

bug:
    li		t0, 0x00180090
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x003000A8
    sw		t0, 0xc(t1)	
    
    j end_icon
    nop

mine:
    li		t0, 0x00300018
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00480030
    sw		t0, 0xc(t1)	
    
    j end_icon
    nop

unknown:
    li		t0, 0x00600030
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00780048
    sw		t0, 0xc(t1)	

end_icon:

    li		t0, 0x00E5FFFF
    sw		t0, 0x4(t1)

    li		t0, 0x00000054
    sw		t0, 0x8(t1)

    li		t0, 0x00FDFFFF
    sw		t0, 0x10(t1)	

    li		t0, 0x0000006C
    sw		t0, 0x14(t1)


    ;base
    li		t0, 0x00E000DC	
    li		t1, VERTEX	
    sw		t0, 0x0(t1)

    li		t0, 0x00E1FFFF
    sw		t0, 0x4(t1)

    li		t0, 0x00000050
    sw		t0, 0x8(t1)

    li		t0, 0x00FF00FB
    sw		t0, 0xc(t1)	

    li		t0, 0x0100FFFF
    sw		t0, 0x10(t1)	

    li		t0, 0x0000006F
    sw		t0, 0x14(t1)

    li		a0, gpu_code
    li		a2, 0
    li		a3, 0
    jal		sceGeListEnQueue; 
    li		a1, 0x0

return:
    
    lw    v0, 0($sp)     ; Recupera $v0
    lw    v1, 4($sp)     ; Recupera $v1
    lw    ra, 8($sp)     ; Recupera $v1
    addiu sp, sp, 0xC     ; Fecha o espaço na pilha


    beq	v0, v1, original_jump
    nop

    j 0x088273C4
    nop

original_jump:
    move t0, t1 
    j 0x08827600
    nop

    ;j 0x0882762C
    nop

.align 0X10
gpu_code:
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0xC0000000 ; Tex map mode: uvgen=texcoords, uvproj=pos
	.word	0xC7000000 ; TexWrap wrap s, wrap t
	.word	0xC6000000 ; TexFilter min: nearest, mag: nearest
	.word	0x10080000 ; BASE: high=08

	.word	0xC2000001 ; TexMode swizzle, 0 levels, shared clut
	.word	0xC3000005 ; TexFormat CLUT8
	.word	0xA01527a0 ; Texture address 0: low=1527a0
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09
	.word	0xB8000808 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB01627b0 ; CLUT addr: low=1627b0
	.word	0xB1090000 ; CLUT addr: high=09
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x12800116 ; SetVertexType: through, u16 texcoords, ABGR 1555 colors, s16 positions| vertex use 1280011E
	.word	0x10080000 ; BASE: high=08
	vaddr	VERTEX - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714


    .word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0xC0000000 ; Tex map mode: uvgen=texcoords, uvproj=pos
	.word	0xC7000000 ; TexWrap wrap s, wrap t
	.word	0xC6000000 ; TexFilter min: nearest, mag: nearest
	.word	0x10080000 ; BASE: high=08

	.word	0xC2000001 ; TexMode swizzle, 0 levels, shared clut
	.word	0xC3000005 ; TexFormat CLUT8
	.word	0xA01830a0; Texture address 0: low=1527a0
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09
	.word	0xB8000808 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB01930b0 ; CLUT addr: low=1627b0
	.word	0xB1090000 ; CLUT addr: high=09
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x12800116 ; SetVertexType: through, u16 texcoords, ABGR 1555 colors, s16 positions| vertex use 1280011E
	.word	0x10080000 ; BASE: high=08
	vaddr	ICON - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
	finish
	end
.close