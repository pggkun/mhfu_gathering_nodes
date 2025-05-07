.psp

.include "./src/gpu_macros.asm"

VERTEX equ 0x089210E0 ;Done
ICON equ 0x089210C0 ;Done
BUTTON_ICON equ 0x089210A0 ;Done
TRIGGER equ 0x089210B0 ;Done
PLAYER_ID equ 0x08921090 ;Done
LAST_ITEM equ 0x08921080 ;Done

BASE_ID equ 0x099998F4 ;Done?

MINING equ 0x51
BUG_CATCHING equ 0x52

INVENTORY equ 0x09A04C46 ;Done

BUTTONS_ADDR equ 0x08A62D88 ;Done
BUTTON_CIRCLE equ 0x00002000

sceGeListEnQueue equ 0x0890E200 ;Done

.createfile "./bin/GATHERING_NODES_US.bin", 0x08921110 ;Done (old 0x891E430)
    addiu sp, sp, -0xC    
    sw    v0, 0($sp)     
    sw    v1, 4($sp)     
    sw    ra, 8($sp)

load_p1:
    li t0, BASE_ID
    lw a0, 0(t0)
    j finish_p_load
    nop

finish_p_load:
    li a1, 0x09FFF4BE
    li a2, 0x09FFF4A0

    jal	0x09A6F490  ;Done
    nop

    li      t0, BASE_ID
    lw      t1, 0(t0)
    lbu      t3, 0x325(t1) 
    bgt     t3, 0x1, subtract_alpha
    nop

    li t0, 0xFFFF
    beq v0, t0, subtract_alpha  ; todo: replace to sub alpha
    nop                 

    lui  t1, 0xFFFF       
    and  t0, v1, t1       
    bnez t0, subtract_alpha     ; todo: replace to sub alpha
    nop

    j add_alpha

subtract_alpha:
    li t0, VERTEX
    lbu t1, 0x5(t0)

    beqz t1, skip_alpha_operations
    nop

    li t2, 0x0F
    beq t1, t2, skip_alpha_operations
    nop

    addiu   t1, t1, -0x40

    beq t1, 0xFFFFFFFF, adjust_to_min
    nop

    sb      t1, 0x5(t0)
    sb      t1, 0x11(t0)

    j skip_alpha_operations
    nop

adjust_to_min:
    li      t1, 0x0F
    sb      t1, 0x5(t0)
    sb      t1, 0x11(t0)

    j skip_alpha_operations
    nop

add_alpha:

    li t0, VERTEX
    lbu t1, 0x5(t0)

    blt t1, 0x0F, set_minimum
    nop

    li t2, 0xFF
    beq t1, t2, skip_alpha_operations
    nop

    addiu   t1, t1, 0x40

    beq t1, 0x10F, adjust_to_max
    nop

    sb      t1, 0x5(t0)
    sb      t1, 0x11(t0)

    j skip_alpha_operations
    nop

adjust_to_max:
    li      t1, 0xFF
    sb      t1, 0x5(t0)
    sb      t1, 0x11(t0)

    j skip_alpha_operations
    nop

set_minimum:
    li t0, VERTEX
    li t1, 0x0F
    sb t1, 0x5(t0)
    sb t1, 0x11(t0)

skip_alpha_operations:
    li t0, VERTEX
    li t1, 0xFF
    sb t1, 0x4(t0);
    sb t1, 0x10(t0);

    li t0, 0x4
    beq t0, v1, bug
    nop

    li t0, 0x3
    beq t0, v1, mine
    nop

    j unknown
    nop

bug:
    jal get_current_bugnet
    nop

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

    li      t1,  LAST_ITEM
    lh      t3, 0(t1)
    li      t0, BASE_ID
    lw      t2, 0(t0)
    sh      t3, 0x694(t2)


    li t0, BASE_ID
    lw t1, 0(t0)

    ;la      t2, CURRENT_ITEM
    ;lh      t3, 0x694(t1)
    beqz    t3, end_icon
    nop

    lb      t4, 0x299(t1)
    beq     t4, BUG_CATCHING, end_icon
    nop

    lb      t3, 0x325(t1) 
    bgt     t3, 0x1,  end_icon
    nop

    li      t3, BUG_CATCHING
    sb      t3, 0x299(t1)

    ;la      t2, 0x90AF355
    li      t3, 0x0
    sb      t3, 0x1D5(t1)
    sb      t3, 0x1D6(t1)

    j end_icon
    nop

mine:
    jal get_current_pickaxe
    nop

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


    li      t1,  LAST_ITEM
    lh      t3, 0(t1)
    li      t0, BASE_ID
    lw      t2, 0(t0)
    sh      t3, 0x694(t2)

    li t0, BASE_ID
    lw t1, 0(t0)

    ;lh      t3, 0x694(t1)
    beqz    t3, end_icon
    nop

    lb      t4, 0x299(t1)
    beq     t4, MINING, end_icon
    nop

    lb      t3, 0x325(t1) 
    bgt     t3, 0x1, end_icon
    nop

    li      t3, MINING
    sb      t3, 0x299(t1)

    ;la      t2, 0x90AF355
    li      t3, 0x0
    sb      t3, 0x1D5(t1)
    sb      t3, 0x1D6(t1)

    j end_icon
    nop

unknown:
    li		t0, 0x00600030
    li		t1, ICON	
    sw		t0, 0x0(t1)

    li		t0, 0x00780048
    sw		t0, 0xc(t1)

    ;li      t2, CURRENT_ITEM

    li      t0, BASE_ID
    lw      t1, 0(t0)

    ;lh      t2, 0x694(t1)

    li      t0,  LAST_ITEM
    li      t3, 0xFFFF
    sh      t3, 0(t0)

    ;sh      t3, 0x694(t1)

    j end_icon
    nop

release_trigger:
    la      t2, TRIGGER
    li      t3, 0x0
    sb      t3, 0(t2)

end_icon:
    li		t1, ICON
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

    li		t0, 0x00E1
    sh		t0, 0x6(t1)

    li		t0, 0x00000050
    sw		t0, 0x8(t1)

    li		t0, 0x010000FC
    sw		t0, 0xc(t1)	

    li		t0, 0x0101
    sh		t0, 0x12(t1)	

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

    li t0, VERTEX
    lbu t1, 0x5(t0)
    bne t1, 0xFF, return
    nop

    li		a0, gpu_code_icon
    li		a2, 0
    li		a3, 0
    jal		sceGeListEnQueue; 
    li		a1, 0x0
    

    li      t0, LAST_ITEM
    lh      t1, 0(t0)

    beqz    t1, return 
    nop

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


    lui	v0,0x894 ;Done
    lhu	a1,-0x4878(v0) ;Done

    j 0x08845CEC ;Done
    nop

get_current_bugnet:
    li      t0, INVENTORY - 4
    li      t1, 0x0

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

    li      t2, 0x09A04CA6 ; Done
    bne     t0, t2, loop
    nop

return_item:
    li      t0,  LAST_ITEM
    sh      t1, 0(t0)

    ;li      t0, BASE_ID
    ;lw      t2, 0(t0)
    
    ;;li      t2, CURRENT_ITEM
    ;sh      t1, 0x694(t2)

    jr ra
    nop

get_current_pickaxe:
    li      t0, INVENTORY - 4
    li      t1, 0x0

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

    li      t2, 0x09A04CA6 ; Done
    bne     t0, t2, p_loop
    nop

p_return_item:
    li      t0,  LAST_ITEM
    sh      t1, 0(t0)

    ;li      t0, BASE_ID
    ;lw      t2, 0(t0)
    
    ;;li      t2, CURRENT_ITEM
    ;sh      t1, 0x694(t2)

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
	.word	0xA0156ba0 ; Texture address 0: low=156ba0  ;TODO: replace
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09 ;TODO: replace
	.word	0xB8000808 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB0166bb0 ; CLUT addr: low=166bb0 ;TODO: replace
	.word	0xB1090000 ; CLUT addr: high=09 ;TODO: replace
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x1280011A ; SetVertexType: through, u16 texcoords, ABGR 4444 colors, s16 positions
	.word	0x10080000 ; BASE: high=08
	vaddr	VERTEX - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
    finish
	end

gpu_code_icon:
    .word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0xC0000000 ; Tex map mode: uvgen=texcoords, uvproj=pos
	.word	0xC7000000 ; TexWrap wrap s, wrap t
	.word	0xC6000000 ; TexFilter min: nearest, mag: nearest
	.word	0x10080000 ; BASE: high=08

	.word	0xC2000001 ; TexMode swizzle, 0 levels, shared clut
	.word	0xC3000005 ; TexFormat CLUT8
	.word	0xA01874a0; Texture address 0: low=1874a0 ;TODO: replace
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09 ;TODO: replace
	.word	0xB8000808 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB01974b0 ; CLUT addr: low=1974b0 ;TODO: replace
	.word	0xB1090000 ; CLUT addr: high=09 ;TODO: replace
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x1280011A ; SetVertexType: through, u16 texcoords, ABGR 4444 colors, s16 positions
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
	.word	0xA0156ba0 ; Texture address 0: low=156ba0 ;TODO: replace
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09 ;TODO: replace
	.word	0xB8000808 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB0166bb0 ; CLUT addr: low=166bb0 ;TODO: replace
	.word	0xB1090000 ; CLUT addr: high=09 ;TODO: replace
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x1280011A ; SetVertexType: through, u16 texcoords, ABGR 4444 colors, s16 positions
	.word	0x10080000 ; BASE: high=08
	vaddr	BUTTON_ICON - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
    finish
	end
.close