.psp

.include "./src/gpu_macros.asm"

VERTEX equ 0x0891E400
ICON equ 0x0891E3E0
BUTTON_ICON equ 0x0891E3C0
TRIGGER equ 0x0891E3D0

ACTION_ID equ 0x090AF419
MINING equ 0x51
BUG_CATCHING equ 0x52
CURRENT_ITEM equ 0x090AF814

INVENTORY equ 0x09A00846

BUTTONS_ADDR equ 0x08A5DD38
BUTTON_CIRCLE equ 0x00002000

sceGeListEnQueue equ 0x0890BC50

.createfile "./bin/GATHERING_NODES_JP.bin", 0x0891E430
    addiu sp, sp, -0xC    
    sw    v0, 0($sp)     
    sw    v1, 4($sp)     
    sw    ra, 8($sp)


    li a0, 0x090AF180
    li a1, 0x09FFF4BE
    li a2, 0x09FFF4A0

    jal	0x09A6A690
    nop

    li t0, 0xFFFF
    beq v0, t0, return
    nop

    lui  t1, 0xFFFF       
    and  t0, v1, t1       
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


    li		t2, BUTTONS_ADDR
	lw		t3, 0(t2)

	li		t4, BUTTON_CIRCLE
	and		t5, t3, t4
	bne		t5, t4, release_trigger
	nop

    la      t2, TRIGGER
    lb      t3, 0(t2)
    beq     t3, 0xFF, end_icon
    nop

    li      t3, 0xFF
    sb      t3, 0(t2)


    ;todo: loop through bugnets on inventory
    ;la      t2, CURRENT_ITEM
    ;li      t3, 0x96
    ;sb      t3, 0(t2)
    jal get_current_bugnet
    nop

    la      t2, CURRENT_ITEM
    lh      t3, 0(t2)
    beqz    t3, end_icon
    nop


    la      t2, ACTION_ID
    lb      t4, 0(t2)
    beq     t4, BUG_CATCHING, end_icon
    nop

    li      t3, BUG_CATCHING
    sb      t3, 0(t2)

    la      t2, 0x90AF355
    li      t3, 0x0
    sb      t3, 0(t2)
    sb      t3, 1(t2)
    	

    ;alterar para	
    
    j end_icon
    nop

mine:
    li		t0, 0x00300018
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00480030
    sw		t0, 0xc(t1)


    li		t2, BUTTONS_ADDR
	lw		t3, 0(t2)

	li		t4, BUTTON_CIRCLE
	and		t5, t3, t4
	bne		t5, t4, release_trigger
	nop

    la      t2, TRIGGER
    lb      t3, 0(t2)
    beq     t3, 0xFF, end_icon
    nop

    li      t3, 0xFF
    sb      t3, 0(t2)


    ;todo: loop through pickaxes on inventory
    ;la      t2, CURRENT_ITEM
    ;li      t3, 0x92
    ;sb      t3, 0(t2)
    jal get_current_pickaxe
    nop

    la      t2, CURRENT_ITEM
    lh      t3, 0(t2)
    beqz    t3, end_icon
    nop


    la      t2, ACTION_ID
    lb      t4, 0(t2)
    beq     t4, MINING, end_icon
    nop

    li      t3, MINING
    sb      t3, 0(t2)
    
    la      t2, 0x90AF355
    li      t3, 0x0
    sb      t3, 0(t2)
    sb      t3, 1(t2)
    
    j end_icon
    nop

unknown:
    li		t0, 0x00600030
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00780048
    sw		t0, 0xc(t1)
    j end_icon
    nop

release_trigger:
    la      t2, TRIGGER
    li      t3, 0x0
    sb      t3, 0(t2)

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

    li		t0, 0x010000FC
    sw		t0, 0xc(t1)	

    li		t0, 0x0101FFFF
    sw		t0, 0x10(t1)	

    li		t0, 0x00000070
    sw		t0, 0x14(t1)

    ;circle button ICON    
    li		t0, 0x00000000
    li		t1, BUTTON_ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00DBFFFF
    li		t1, BUTTON_ICON	
    sw		t0, 0x4(t1)

    li		t0, 0x00000064
    li		t1, BUTTON_ICON	
    sw		t0, 0x8(t1)

    li		t0, 0x00100010
    li		t1, BUTTON_ICON	
    sw		t0, 0xc(t1)

    li		t0, 0x00EAFFFF
    li		t1, BUTTON_ICON	
    sw		t0, 0x10(t1)

    li		t0, 0x00000073
    li		t1, BUTTON_ICON	
    sw		t0, 0x14(t1)    

    li		a0, gpu_code
    li		a2, 0
    li		a3, 0
    jal		sceGeListEnQueue; 
    li		a1, 0x0

    ;bnez    v1, return
    ;nop

    li		a0, gpu_code2
    li		a2, 0
    li		a3, 0
    jal		sceGeListEnQueue; 
    li		a1, 0x0

return:
    
    lw    v0, 0($sp)     
    lw    v1, 4($sp)     
    lw    ra, 8($sp)     
    addiu sp, sp, 0xC


    lui	v0,0x894
    lhu	a1,-0x7478(v0)

    j 0x08845C9C
    nop

get_current_bugnet:
    li      t0, INVENTORY - 4

loop:
    addiu   t0, t0, 4
    lh      t1, 0(t0)
    beq     t1, 0x94, return_item
    nop

    beq     t1, 0x95, return_item
    nop

    beq     t1, 0x96, return_item
    nop

    beq     t1, 0x4c9, return_item
    nop

    la      t2, 0x09A008A6 ; last item
    bne     t0, t2, loop
    nop

return_item:
    la      t2, CURRENT_ITEM
    sh      t1, 0(t2)

    jr ra
    nop

get_current_pickaxe:
    li      t0, INVENTORY - 4

p_loop:
    addiu   t0, t0, 4
    lh      t1, 0(t0)
    beq     t1, 0x90, p_return_item
    nop

    beq     t1, 0x91, p_return_item
    nop

    beq     t1, 0x92, p_return_item
    nop

    beq     t1, 0x4cA, p_return_item
    nop

    la      t2, 0x09A008A6 ; last item
    bne     t0, t2, p_loop
    nop

p_return_item:
    la      t2, CURRENT_ITEM
    sh      t1, 0(t2)

    jr ra
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

gpu_code2:
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
	vaddr	BUTTON_ICON - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
    finish
	end
.close