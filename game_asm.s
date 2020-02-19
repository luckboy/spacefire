;;
;; Space Fire - Game for Commodore 64.
;; Copyright (C) 2020 Łukasz Szpakowski
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
        .export _game_move_player_up
        .export _game_move_player_down
        .export _game_move_player_left
        .export _game_move_player_right
        .export _game_set_player_sprite
        .export _game_scroll_screen
        .export _game_move_player
        .export _game_player_shoot
        .export _game_move_shots
        .export _game_set_shot_sprites
        .export _game_change_player_state
        .export _game_change_shot_states
        .import _level_pos
        .import _block_pos
        .import _scroll_pos
        .import _is_scroll
        .import _sprite_bg_coll
        .import _current_level
        .import _player
        .import _shots
        .import _shot_alloc_index
        .importzp tmp1, ptr1
        
        .include "c64.inc"
        .include "game.inc"
        .include "graphics.inc"
        .include "levels.inc"

PLAYER_X_MIN = SPRITE_X_OFFSET + 8
PLAYER_X_MAX = SPRITE_X_OFFSET + 40 * 8 - 8 - 24
PLAYER_Y_MIN = SPRITE_Y_OFFSET
PLAYER_Y_MAX = SPRITE_Y_OFFSET + 22 * 8 - 22
PASSING_PLAYER_X_MAX = SPRITE_X_OFFSET + 40 * 8 - 8
SHOT_X_MAX = SPRITE_X_OFFSET + 40 * 8 - 8

        .rodata
        
Ltab_bit_shift_0:
        .byte (0 << 0), (1 << 0)
Ltab_bit_shift_1:
        .byte (0 << 1), (1 << 1)
Ltab_bit_shift_2:
        .byte (0 << 2), (1 << 2)
Ltab_bit_shift_3:
        .byte (0 << 3), (1 << 3)
Ltab_bit_shift_4:
        .byte (0 << 4), (1 << 4)
Ltab_bit_shift_5:
        .byte (0 << 5), (1 << 5)
Ltab_bit_shift_6:
        .byte (0 << 6), (1 << 6)
Ltab_bit_shift_7:
        .byte (0 << 7), (1 << 7)

        .code

.proc _game_move_player_up
        ; if(player.y > PLAYER_Y_MIN)
        lda #PLAYER_Y_MIN
        cmp _player + player::y_coord
        bcs L0101                       ; !(PLAYER_Y_MIN < player.y) -> !(player.y > PLAYER_Y_MIN)
        sec
        lda _player + player::y_coord
        sbc #2
        sta _player + player::y_coord
L0101:  rts
.endproc

.proc _game_move_player_down
        ; if(player.y < PLAYER_Y_MAX)
        lda _player + player::y_coord
        cmp #PLAYER_Y_MAX
        bcs L0201                       ; !(player.y < PLAYER_Y_MAX)
        clc
        lda _player + player::y_coord
        adc #2
        sta _player + player::y_coord
L0201:  rts
.endproc

.proc _game_move_player_left
        ; if(player.x > PLAYER_X_MIN)
        lda #>PLAYER_X_MIN
        cmp _player + player::x_coord + 1
        bne L0301
        lda #<PLAYER_X_MIN
        cmp _player + player::x_coord
L0301:  bcs L0302                       ; !(PLAYER_X_MIN < player.x) -> !(player.x > PLAYER_X_MIN)
        sec
        lda _player + player::x_coord
        sbc #2
        sta _player + player::x_coord
        lda _player + player::x_coord + 1
        sbc #0
        sta _player + player::x_coord + 1
L0302:  rts
.endproc

.proc _game_move_player_right
        ; if(player.x < PLAYER_X_MAX)
        lda _player + player::x_coord + 1
        cmp #>PLAYER_X_MAX
        bne L0401
        lda _player + player::x_coord
        cmp #<PLAYER_X_MAX
L0401:  bcs L0402                       ; !(player.x < PLAYER_X_MAX)
        clc
        lda _player + player::x_coord
        adc #2
        sta _player + player::x_coord
        lda _player + player::x_coord + 1
        adc #0
        sta _player + player::x_coord + 1
L0402:  rts
.endproc

.proc _game_set_player_sprite
        lda _player + player::x_coord
        sta VIC_SPR0_X
        lda VIC_SPR_HI_X
        and #$fe
        ora _player + player::x_coord + 1
        sta VIC_SPR_HI_X
        lda _player + player::y_coord
        sta VIC_SPR0_Y
        lda _player + player::sprite
        sta SPRITE_PTRS1 + 0
        sta SPRITE_PTRS2 + 0
        lda _player + player::state
        cmp #GAME_PLAYER_DESTROYING
        beq L0501
        lda #$01 ; white
        jmp L0502
L0501:  lda #$07 ; yellow
L0502:  sta VIC_SPR0_COLOR
        rts
.endproc

        .rodata

Ltab_first_xs:
        .byte 30, 30, 20, 20, 10, 10,  0,  0
Ltab_last_xs:
        .byte 39, 39, 30, 30, 20, 20, 10, 10

        .code

.proc _game_scroll_screen
        ldy _level_pos
        lda _current_level + level::chars
        sta ptr1
        lda _current_level + level::chars + 1
        sta ptr1 + 1
        lda (ptr1), y
        bne L06move_screen
        lda _scroll_pos
        beq L06no_scroll
        dec _scroll_pos
        dec _scroll_pos
        lda #1
        sta _is_scroll
        jmp L06set_scroll1
L06no_scroll:
        lda #0
        sta _is_scroll
L06set_scroll1:
        lda #$d0
        ora _scroll_pos
        sta VIC_CTRL2
        rts
L06move_screen:
        lda _block_pos
        beq L06move_screen1
        jmp L06move_screen2
L06move_screen1:
        ldy _scroll_pos
        ldx Ltab_first_xs, y
        lda Ltab_last_xs, y
        sta tmp1
L06move_screen1_loop:
        lda SCREEN1 + 40 * 0 + 1, x
        sta SCREEN2 + 40 * 0, x
        lda SCREEN1 + 40 * 1 + 1, x
        sta SCREEN2 + 40 * 1, x
        lda SCREEN1 + 40 * 2 + 1, x
        sta SCREEN2 + 40 * 2, x
        lda SCREEN1 + 40 * 3 + 1, x
        sta SCREEN2 + 40 * 3, x
        lda SCREEN1 + 40 * 4 + 1, x
        sta SCREEN2 + 40 * 4, x
        lda SCREEN1 + 40 * 5 + 1, x
        sta SCREEN2 + 40 * 5, x
        lda SCREEN1 + 40 * 6 + 1, x
        sta SCREEN2 + 40 * 6, x
        lda SCREEN1 + 40 * 7 + 1, x
        sta SCREEN2 + 40 * 7, x
        lda SCREEN1 + 40 * 8 + 1, x
        sta SCREEN2 + 40 * 8, x
        lda SCREEN1 + 40 * 9 + 1, x
        sta SCREEN2 + 40 * 9, x
        lda SCREEN1 + 40 * 10 + 1, x
        sta SCREEN2 + 40 * 10, x
        lda SCREEN1 + 40 * 11 + 1, x
        sta SCREEN2 + 40 * 11, x
        lda SCREEN1 + 40 * 12 + 1, x
        sta SCREEN2 + 40 * 12, x
        lda SCREEN1 + 40 * 13 + 1, x
        sta SCREEN2 + 40 * 13, x
        lda SCREEN1 + 40 * 14 + 1, x
        sta SCREEN2 + 40 * 14, x
        lda SCREEN1 + 40 * 15 + 1, x
        sta SCREEN2 + 40 * 15, x
        lda SCREEN1 + 40 * 16 + 1, x
        sta SCREEN2 + 40 * 16, x
        lda SCREEN1 + 40 * 17 + 1, x
        sta SCREEN2 + 40 * 17, x
        lda SCREEN1 + 40 * 18 + 1, x
        sta SCREEN2 + 40 * 18, x
        lda SCREEN1 + 40 * 19 + 1, x
        sta SCREEN2 + 40 * 19, x
        lda SCREEN1 + 40 * 20 + 1, x
        sta SCREEN2 + 40 * 20, x
        lda SCREEN1 + 40 * 21 + 1, x
        sta SCREEN2 + 40 * 21, x
        inx
        cpx tmp1
        beq L06no_move_screen1_loop
        jmp L06move_screen1_loop
L06no_move_screen1_loop:
        lda _scroll_pos
        beq L06copy_level_chars_to_screen2
        jmp L06scroll
L06copy_level_chars_to_screen2:
        ldy _level_pos
        ; 1
        lda _current_level + level::chars + 0 * 2
        sta ptr1
        lda _current_level + level::chars + 0 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0601
        sta SCREEN2 + 40 * (0 * 2 + 0) + 39
        sta SCREEN2 + 40 * (0 * 2 + 1) + 39
        jmp L0602
L0601:  sta SCREEN2 + 40 * (0 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (0 * 2 + 1) + 39
        ; 2
L0602:  lda _current_level + level::chars + 1 * 2
        sta ptr1
        lda _current_level + level::chars + 1 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0603
        sta SCREEN2 + 40 * (1 * 2 + 0) + 39
        sta SCREEN2 + 40 * (1 * 2 + 1) + 39
        jmp L0604
L0603:  sta SCREEN2 + 40 * (1 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (1 * 2 + 1) + 39
        ; 3
L0604:  lda _current_level + level::chars + 2 * 2
        sta ptr1
        lda _current_level + level::chars + 2 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0605
        sta SCREEN2 + 40 * (2 * 2 + 0) + 39
        sta SCREEN2 + 40 * (2 * 2 + 1) + 39
        jmp L0606
L0605:  sta SCREEN2 + 40 * (2 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (2 * 2 + 1) + 39
        ; 4
L0606:  lda _current_level + level::chars + 3 * 2
        sta ptr1
        lda _current_level + level::chars + 3 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0603
        sta SCREEN2 + 40 * (3 * 2 + 0) + 39
        sta SCREEN2 + 40 * (3 * 2 + 1) + 39
        jmp L0608
L0607:  sta SCREEN2 + 40 * (3 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (3 * 2 + 1) + 39
        ; 5
L0608:  lda _current_level + level::chars + 4 * 2
        sta ptr1
        lda _current_level + level::chars + 4 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0609
        sta SCREEN2 + 40 * (4 * 2 + 0) + 39
        sta SCREEN2 + 40 * (4 * 2 + 1) + 39
        jmp L0610
L0609:  sta SCREEN2 + 40 * (4 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (4 * 2 + 1) + 39
        ; 6
L0610:  lda _current_level + level::chars + 5 * 2
        sta ptr1
        lda _current_level + level::chars + 5 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0611
        sta SCREEN2 + 40 * (5 * 2 + 0) + 39
        sta SCREEN2 + 40 * (5 * 2 + 1) + 39
        jmp L0612
L0611:  sta SCREEN2 + 40 * (5 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (5 * 2 + 1) + 39
        ; 7
L0612:  lda _current_level + level::chars + 6 * 2
        sta ptr1
        lda _current_level + level::chars + 6 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0613
        sta SCREEN2 + 40 * (6 * 2 + 0) + 39
        sta SCREEN2 + 40 * (6 * 2 + 1) + 39
        jmp L0614
L0613:  sta SCREEN2 + 40 * (6 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (6 * 2 + 1) + 39
        ; 8
L0614:  lda _current_level + level::chars + 7 * 2
        sta ptr1
        lda _current_level + level::chars + 7 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0615
        sta SCREEN2 + 40 * (7 * 2 + 0) + 39
        sta SCREEN2 + 40 * (7 * 2 + 1) + 39
        jmp L0616
L0615:  sta SCREEN2 + 40 * (7 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (7 * 2 + 1) + 39
        ; 9
L0616:  lda _current_level + level::chars + 8 * 2
        sta ptr1
        lda _current_level + level::chars + 8 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0617
        sta SCREEN2 + 40 * (8 * 2 + 0) + 39
        sta SCREEN2 + 40 * (8 * 2 + 1) + 39
        jmp L0618
L0617:  sta SCREEN2 + 40 * (8 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (8 * 2 + 1) + 39
        ; 10
L0618:  lda _current_level + level::chars + 9 * 2
        sta ptr1
        lda _current_level + level::chars + 9 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0619
        sta SCREEN2 + 40 * (9 * 2 + 0) + 39
        sta SCREEN2 + 40 * (9 * 2 + 1) + 39
        jmp L0620
L0619:  sta SCREEN2 + 40 * (9 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (9 * 2 + 1) + 39
        ; 11
L0620:  lda _current_level + level::chars + 10 * 2
        sta ptr1
        lda _current_level + level::chars + 10 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0621
        sta SCREEN2 + 40 * (10 * 2 + 0) + 39
        sta SCREEN2 + 40 * (10 * 2 + 1) + 39
        jmp L0622
L0621:  sta SCREEN2 + 40 * (10 * 2 + 0) + 39
        ora #$20
        sta SCREEN2 + 40 * (10 * 2 + 1) + 39
L0622:  lda VIC_VIDEO_ADR
        and #$0f
        ora #((SCREEN2 - (VIC_BANK << 14)) >> 10) << 4 
        sta VIC_VIDEO_ADR
        lda #1
        sta _block_pos
        jmp L06scroll
L06move_screen2:
        ldy _scroll_pos
        ldx Ltab_first_xs, y
        lda Ltab_last_xs, y
        sta tmp1
L06move_screen2_loop:
        lda SCREEN2 + 40 * 0 + 1, x
        sta SCREEN1 + 40 * 0, x
        lda SCREEN2 + 40 * 1 + 1, x
        sta SCREEN1 + 40 * 1, x
        lda SCREEN2 + 40 * 2 + 1, x
        sta SCREEN1 + 40 * 2, x
        lda SCREEN2 + 40 * 3 + 1, x
        sta SCREEN1 + 40 * 3, x
        lda SCREEN2 + 40 * 4 + 1, x
        sta SCREEN1 + 40 * 4, x
        lda SCREEN2 + 40 * 5 + 1, x
        sta SCREEN1 + 40 * 5, x
        lda SCREEN2 + 40 * 6 + 1, x
        sta SCREEN1 + 40 * 6, x
        lda SCREEN2 + 40 * 7 + 1, x
        sta SCREEN1 + 40 * 7, x
        lda SCREEN2 + 40 * 8 + 1, x
        sta SCREEN1 + 40 * 8, x
        lda SCREEN2 + 40 * 9 + 1, x
        sta SCREEN1 + 40 * 9, x
        lda SCREEN2 + 40 * 10 + 1, x
        sta SCREEN1 + 40 * 10, x
        lda SCREEN2 + 40 * 11 + 1, x
        sta SCREEN1 + 40 * 11, x
        lda SCREEN2 + 40 * 12 + 1, x
        sta SCREEN1 + 40 * 12, x
        lda SCREEN2 + 40 * 13 + 1, x
        sta SCREEN1 + 40 * 13, x
        lda SCREEN2 + 40 * 14 + 1, x
        sta SCREEN1 + 40 * 14, x
        lda SCREEN2 + 40 * 15 + 1, x
        sta SCREEN1 + 40 * 15, x
        lda SCREEN2 + 40 * 16 + 1, x
        sta SCREEN1 + 40 * 16, x
        lda SCREEN2 + 40 * 17 + 1, x
        sta SCREEN1 + 40 * 17, x
        lda SCREEN2 + 40 * 18 + 1, x
        sta SCREEN1 + 40 * 18, x
        lda SCREEN2 + 40 * 19 + 1, x
        sta SCREEN1 + 40 * 19, x
        lda SCREEN2 + 40 * 20 + 1, x
        sta SCREEN1 + 40 * 20, x
        lda SCREEN2 + 40 * 21 + 1, x
        sta SCREEN1 + 40 * 21, x
        inx
        cpx tmp1
        beq L06no_move_screen2_loop
        jmp L06move_screen2_loop
L06no_move_screen2_loop:
        lda _scroll_pos
        beq L06copy_level_chars_to_screen1
        jmp L06scroll
L06copy_level_chars_to_screen1:
        ldy _level_pos
        ; 1
        lda _current_level + level::chars + 0 * 2
        sta ptr1
        lda _current_level + level::chars + 0 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0623
        sta SCREEN1 + 40 * (0 * 2 + 0) + 39
        sta SCREEN1 + 40 * (0 * 2 + 1) + 39
        jmp L0624
L0623:  ora #$10
        sta SCREEN1 + 40 * (0 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (0 * 2 + 1) + 39
        ; 2
L0624:  lda _current_level + level::chars + 1 * 2
        sta ptr1
        lda _current_level + level::chars + 1 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0625
        sta SCREEN1 + 40 * (1 * 2 + 0) + 39
        sta SCREEN1 + 40 * (1 * 2 + 1) + 39
        jmp L0626
L0625:  ora #$10
        sta SCREEN1 + 40 * (1 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (1 * 2 + 1) + 39
        ; 3
L0626:  lda _current_level + level::chars + 2 * 2
        sta ptr1
        lda _current_level + level::chars + 2 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0627
        sta SCREEN1 + 40 * (2 * 2 + 0) + 39
        sta SCREEN1 + 40 * (2 * 2 + 1) + 39
        jmp L0628
L0627:  ora #$10
        sta SCREEN1 + 40 * (2 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (2 * 2 + 1) + 39
        ; 4
L0628:  lda _current_level + level::chars + 3 * 2
        sta ptr1
        lda _current_level + level::chars + 3 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0629
        sta SCREEN1 + 40 * (3 * 2 + 0) + 39
        sta SCREEN1 + 40 * (3 * 2 + 1) + 39
        jmp L0630
L0629:  ora #$10
        sta SCREEN1 + 40 * (3 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (3 * 2 + 1) + 39
        ; 5
L0630:  lda _current_level + level::chars + 4 * 2
        sta ptr1
        lda _current_level + level::chars + 4 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0631
        sta SCREEN1 + 40 * (4 * 2 + 0) + 39
        sta SCREEN1 + 40 * (4 * 2 + 1) + 39
        jmp L0632
L0631:  ora #$10
        sta SCREEN1 + 40 * (4 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (4 * 2 + 1) + 39
        ; 6
L0632:  lda _current_level + level::chars + 5 * 2
        sta ptr1
        lda _current_level + level::chars + 5 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0633
        sta SCREEN1 + 40 * (5 * 2 + 0) + 39
        sta SCREEN1 + 40 * (5 * 2 + 1) + 39
        jmp L0634
L0633:  ora #$10
        sta SCREEN1 + 40 * (5 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (5 * 2 + 1) + 39
        ; 7
L0634:  lda _current_level + level::chars + 6 * 2
        sta ptr1
        lda _current_level + level::chars + 6 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0635
        sta SCREEN1 + 40 * (6 * 2 + 0) + 39
        sta SCREEN1 + 40 * (6 * 2 + 1) + 39
        jmp L0636
L0635:  ora #$10
        sta SCREEN1 + 40 * (6 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (6 * 2 + 1) + 39
        ; 8
L0636:  lda _current_level + level::chars + 7 * 2
        sta ptr1
        lda _current_level + level::chars + 7 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0637
        sta SCREEN1 + 40 * (7 * 2 + 0) + 39
        sta SCREEN1 + 40 * (7 * 2 + 1) + 39
        jmp L0638
L0637:  ora #$10
        sta SCREEN1 + 40 * (7 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (7 * 2 + 1) + 39
        ; 9
L0638:  lda _current_level + level::chars + 8 * 2
        sta ptr1
        lda _current_level + level::chars + 8 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0639
        sta SCREEN1 + 40 * (8 * 2 + 0) + 39
        sta SCREEN1 + 40 * (8 * 2 + 1) + 39
        jmp L0640
L0639:  ora #$10
        sta SCREEN1 + 40 * (8 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (8 * 2 + 1) + 39
        ; 10
L0640:  lda _current_level + level::chars + 9 * 2
        sta ptr1
        lda _current_level + level::chars + 9 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0641
        sta SCREEN1 + 40 * (9 * 2 + 0) + 39
        sta SCREEN1 + 40 * (9 * 2 + 1) + 39
        jmp L0642
L0641:  ora #$10
        sta SCREEN1 + 40 * (9 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (9 * 2 + 1) + 39
        ; 11
L0642:  lda _current_level + level::chars + 10 * 2
        sta ptr1
        lda _current_level + level::chars + 10 * 2 + 1
        sta ptr1 + 1
        lda (ptr1),y
        cmp #$20 ; space
        bne L0643
        sta SCREEN1 + 40 * (10 * 2 + 0) + 39
        sta SCREEN1 + 40 * (10 * 2 + 1) + 39
        jmp L0644
L0643:  ora #$10
        sta SCREEN1 + 40 * (10 * 2 + 0) + 39
        ora #$20
        sta SCREEN1 + 40 * (10 * 2 + 1) + 39
L0644:  lda VIC_VIDEO_ADR
        and #$0f
        ora #((SCREEN1 - (VIC_BANK << 14)) >> 10) << 4 
        sta VIC_VIDEO_ADR
        lda #0
        sta _block_pos
        inc _level_pos
L06scroll:
        lda _scroll_pos
        beq L06scroll_start
        dec _scroll_pos
        dec _scroll_pos
        jmp L06set_scroll2
L06scroll_start:
        lda #6
        sta _scroll_pos
L06set_scroll2:
        lda #1
        sta _is_scroll
        lda #$d0
        ora _scroll_pos
        sta VIC_CTRL2
        rts
.endproc

.proc _game_move_player
        ; if(player.x < PASSING_PLAYER_X_MAX)
        lda _player + player::x_coord + 1
        cmp #>PASSING_PLAYER_X_MAX
        bne L0701
        lda _player + player::x_coord
        cmp #<PASSING_PLAYER_X_MAX
L0701:  bcs L0702                               ; !(player.x < PASSING_PLAYER_X_MAX)
        ldx _is_scroll
        clc
        lda _player + player::x_coord
        adc _player + player::x_steps, x
        sta _player + player::x_coord
        lda _player + player::x_coord + 1
        adc #0
        sta _player + player::x_coord + 1
        lda #1
        rts
L0702:  lda #0
        rts
.endproc

        .rodata

Ltab_shot_xs:
        .byte .sizeof(shot) * 0
        .byte .sizeof(shot) * 1
        .byte .sizeof(shot) * 2
        
        .code

.proc _game_player_shoot
        ldx _shot_alloc_index
        ldy Ltab_shot_xs, x
        lda #1
        sta _shots + shot::is_enabled, y
        lda _player + player::x_coord
        sta _shots + shot::x_coord, y
        lda _player + player::x_coord + 1
        sta _shots + shot::x_coord + 1, y
        clc
        lda _shots + shot::x_coord, y
        adc #24
        sta _shots + shot::x_coord, y
        lda _shots + shot::x_coord + 1, y
        adc #0
        sta _shots + shot::x_coord + 1, y
        lda _player + player::y_coord
        sta _shots + player::y_coord, y
        inc _shot_alloc_index
        lda _shot_alloc_index
        cmp #GAME_SHOT_COUNT_MAX
        bcc L0801
        lda #0
        sta _shot_alloc_index
L0801:  rts
.endproc

.proc _game_move_shots
        ; 1
        lda _shots + shot::is_enabled + .sizeof(shot) * 0
        beq L0901
        lda _shots + shot::x_coord + .sizeof(shot) * 0 + 1
        cmp #>SHOT_X_MAX
        bne L0902
        lda _shots + shot::x_coord + .sizeof(shot) * 0
        cmp #<SHOT_X_MAX
L0902:  bcs L0903
        ldx _is_scroll
        clc
        lda _shots + shot::x_coord + .sizeof(shot) * 0
        adc _shots + shot::x_steps + .sizeof(shot) * 0, x
        sta _shots + shot::x_coord + .sizeof(shot) * 0
        lda _shots + shot::x_coord + .sizeof(shot) * 0 + 1
        adc #0
        sta _shots + shot::x_coord + .sizeof(shot) * 0 + 1
        jmp L0901
L0903:  lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 0
        ; 2
L0901:  lda _shots + shot::is_enabled + .sizeof(shot) * 1
        beq L0904
        lda _shots + shot::x_coord + .sizeof(shot) * 1 + 1
        cmp #>SHOT_X_MAX
        bne L0905
        lda _shots + shot::x_coord + .sizeof(shot) * 1
        cmp #<SHOT_X_MAX
L0905:  bcs L0906
        ldx _is_scroll
        clc
        lda _shots + shot::x_coord + .sizeof(shot) * 1
        adc _shots + shot::x_steps + .sizeof(shot) * 1, x
        sta _shots + shot::x_coord + .sizeof(shot) * 1
        lda _shots + shot::x_coord + .sizeof(shot) * 1 + 1
        adc #0
        sta _shots + shot::x_coord + .sizeof(shot) * 1 + 1
        jmp L0904
L0906:  lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 1
        ; 3
L0904:  lda _shots + shot::is_enabled + .sizeof(shot) * 2
        beq L0907
        lda _shots + shot::x_coord + .sizeof(shot) * 2 + 1
        cmp #>SHOT_X_MAX
        bne L0908
        lda _shots + shot::x_coord + .sizeof(shot) * 2
        cmp #<SHOT_X_MAX
L0908:  bcs L0909
        ldx _is_scroll
        clc
        lda _shots + shot::x_coord + .sizeof(shot) * 2
        adc _shots + shot::x_steps + .sizeof(shot) * 2, x
        sta _shots + shot::x_coord + .sizeof(shot) * 2
        lda _shots + shot::x_coord + .sizeof(shot) * 2 + 1
        adc #0
        sta _shots + shot::x_coord + .sizeof(shot) * 2 + 1
        jmp L0907
L0909:  lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 2
L0907:  rts
.endproc

.proc _game_set_shot_sprites
        ; 1
        lda _shots + shot::is_enabled + .sizeof(shot) * 0
        beq L1001
        lda VIC_SPR_ENA
        ora #$02
        sta VIC_SPR_ENA
        lda _shots + shot::x_coord + .sizeof(shot) * 0
        sta VIC_SPR1_X
        lda VIC_SPR_HI_X
        and #$fd
        ldx _shots + shot::x_coord + .sizeof(shot) * 0 + 1
        ora Ltab_bit_shift_1, x
        sta VIC_SPR_HI_X
        lda _shots + shot::y_coord + .sizeof(shot) * 0
        sta VIC_SPR1_Y
        lda _shots + shot::sprite + .sizeof(shot) * 0
        sta SPRITE_PTRS1 + 1
        sta SPRITE_PTRS2 + 1
        lda #$07 ; yellow
        sta VIC_SPR1_COLOR
L1001:  jmp L1002
        lda VIC_SPR_ENA
        and #$fd
        sta VIC_SPR_ENA
        ; 2
L1002:  lda _shots + shot::is_enabled + .sizeof(shot) * 1
        beq L1003
        lda VIC_SPR_ENA
        ora #$04
        sta VIC_SPR_ENA
        lda _shots + shot::x_coord + .sizeof(shot) * 1
        sta VIC_SPR2_X
        lda VIC_SPR_HI_X
        and #$fb
        ldx _shots + shot::x_coord + .sizeof(shot) * 1 + 1
        ora Ltab_bit_shift_2, x
        sta VIC_SPR_HI_X
        lda _shots + shot::y_coord + .sizeof(shot) * 1
        sta VIC_SPR2_Y
        lda _shots + shot::sprite + .sizeof(shot) * 1
        sta SPRITE_PTRS1 + 2
        sta SPRITE_PTRS2 + 2
        lda #$07 ; yellow
        sta VIC_SPR2_COLOR
        jmp L1004
L1003:  lda VIC_SPR_ENA
        and #$fb
        sta VIC_SPR_ENA
        ; 3
L1004:  lda _shots + shot::is_enabled + .sizeof(shot) * 2
        beq L1005
        lda VIC_SPR_ENA
        ora #$08
        sta VIC_SPR_ENA
        lda _shots + shot::x_coord + .sizeof(shot) * 2
        sta VIC_SPR3_X
        lda VIC_SPR_HI_X
        and #$f7
        ldx _shots + shot::x_coord + .sizeof(shot) * 2 + 1
        ora Ltab_bit_shift_3, x
        sta VIC_SPR_HI_X
        lda _shots + shot::y_coord + .sizeof(shot) * 2
        sta VIC_SPR3_Y
        lda _shots + shot::sprite + .sizeof(shot) * 2
        sta SPRITE_PTRS1 + 3
        sta SPRITE_PTRS2 + 3
        lda #$07 ; yellow
        sta VIC_SPR3_COLOR
        jmp L1006
L1005:  lda VIC_SPR_ENA
        and #$f7
        sta VIC_SPR_ENA
L1006:  rts
.endproc

.proc _game_change_player_state
        lda _player + player::state
        cmp #GAME_PLAYER_LIVE
        bne L1101
        lda _sprite_bg_coll
        and #$01
        beq L1102
        lda #GAME_PLAYER_DESTROYING
        sta _player + player::state
        lda _player + player::start_explosion_sprite
        sta _player + player::sprite
L1102:  lda #1
        rts
L1101:  lda _player + player::state
        cmp #GAME_PLAYER_DESTROYING
        bne L1103
        inc _player + player::sprite
        lda _player + player::sprite
        cmp _player + player::end_explosion_sprite
        beq L1103
        lda #1
        rts
L1103:  lda #0
        rts
.endproc

.proc _game_change_shot_states
        lda _shots + shot::is_enabled + .sizeof(shot) * 0
        beq L1201
        lda _sprite_bg_coll
        and #$02
        beq L1201
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 0
L1201:  lda _shots + shot::is_enabled + .sizeof(shot) * 1
        beq L1202
        lda _sprite_bg_coll
        and #$04
        beq L1202
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 1
L1202:  lda _shots + shot::is_enabled + .sizeof(shot) * 2
        beq L1203
        lda _sprite_bg_coll
        and #$08
        beq L1203
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 2
L1203:  rts
.endproc
