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
        .export _game_move_enemies_0_3
        .export _game_move_enemies_4_7
        .export _game_move_enemies_8_11
        .export _game_change_enemy_states_0_3
        .export _game_change_enemy_states_4_7
        .export _game_change_enemy_states_8_11
        .export _game_add_enemy_points_0_3
        .export _game_add_enemy_points_4_7
        .export _game_add_enemy_points_8_11
        .export _game_set_enemy_sprites_0_3
        .export _game_set_enemy_sprites_4_7
        .export _game_set_enemy_sprites_8_11
        .export _game_alloc_enemy1
        .export _game_alloc_enemy2
        .export _game_alloc_enemy3
        .export _game_display_score
        .import _level_pos
        .import _block_pos
        .import _scroll_pos
        .import _is_scroll
        .import _is_scroll2
        .import _sprite_bg_coll
        .import _sprite_coll1
        .import _sprite_coll2
        .import _sprite_coll3        
        .import _current_level
        .import _player
        .import _shots
        .import _shot_alloc_index
        .import _enemies
        .import _enemy_alloc_indices
        .import _enemy_explosion
        .import _enemy_descs
        .importzp tmp1, ptr1
        
        .include "c64.inc"
        .include "enemy_descs.inc"
        .include "game.inc"
        .include "graphics.inc"
        .include "levels.inc"

PLAYER_X_MIN            = SPRITE_X_OFFSET + 8
PLAYER_X_MAX            = SPRITE_X_OFFSET + 40 * 8 - 8 - 24
PLAYER_Y_MIN            = SPRITE_Y_OFFSET
PLAYER_Y_MAX            = SPRITE_Y_OFFSET + 22 * 8 - 22
PASSING_PLAYER_X_MAX    = SPRITE_X_OFFSET + 40 * 8 - 8
SHOT_X_MAX              = SPRITE_X_OFFSET + 40 * 8 - 8
ENEMY_X_MIN             = SPRITE_X_OFFSET - 24 + 8
ENEMY_X_MAX             = SPRITE_X_OFFSET + 40 * 8
ENEMY_Y1                = SPRITE_Y_OFFSET + 12 + ((5 * 8) >> 1) - (22 >> 1)
ENEMY_Y2                = SPRITE_Y_OFFSET + 12 + 5 * 8 + 16 + ((5 * 8) >> 1) - (22 >> 1)
ENEMY_Y3                = SPRITE_Y_OFFSET + 12 + 5 * 8 + 16 + 5 * 8 + 16 + ((5 * 8) >> 1) - (22 >> 1)

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

Ltab_state_colors:
        .byte $01, $01, $07
        
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
        ldx _player + player::state
        lda Ltab_state_colors, x
        sta VIC_SPR0_COLOR
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
        lda #2
        cmp _scroll_pos
        bcs L06no_scroll2               ; !(2 < scroll_pos) -> !(scroll_pos > 2)  
        lda #1
        jmp L06set_scroll2_flag
L06no_scroll2:
        lda #0
L06set_scroll2_flag:
        sta _is_scroll2
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
        sta _is_scroll2
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
        jmp L1002
L1001:  lda VIC_SPR_ENA
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
        cmp #GAME_STATE_LIVE
        bne L1101
        lda _sprite_bg_coll
        ora _sprite_coll1
        ora _sprite_coll2
        ora _sprite_coll3
        and #$01
        beq L1102
        lda #GAME_STATE_DESTROYING
        sta _player + player::state
        lda _player + player::start_explosion_sprite
        sta _player + player::sprite
L1102:  lda #1
        rts
L1101:  lda _player + player::state
        cmp #GAME_STATE_DESTROYING
        bne L1103
        inc _player + player::sprite
        lda _player + player::sprite
        cmp _player + player::end_explosion_sprite
        bcs L1103
        lda #1
        rts
L1103:  lda #0
        rts
.endproc

.proc _game_change_shot_states
        lda _sprite_bg_coll
        ora _sprite_coll1
        ora _sprite_coll2
        ora _sprite_coll3
        sta tmp1
        lda _shots + shot::is_enabled + .sizeof(shot) * 0
        beq L1201
        lda tmp1
        and #$02
        beq L1201
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 0
L1201:  lda _shots + shot::is_enabled + .sizeof(shot) * 1
        beq L1202
        lda tmp1
        and #$04
        beq L1202
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 1
L1202:  lda _shots + shot::is_enabled + .sizeof(shot) * 2
        beq L1203
        lda tmp1
        and #$08
        beq L1203
        lda #0
        sta _shots + shot::is_enabled + .sizeof(shot) * 2
L1203:  rts
.endproc

.proc _game_move_enemies_0_3
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 0
        cmp #GAME_STATE_DISABLED
        beq L1301
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 0 + 1
        bne L1302
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 0
L1302:  bcs L1303
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 0
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 0, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 0
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 0 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 0 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 0
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 0
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 0 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 0
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 0
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 0
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 0
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 0
        bcc L1301
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 0
        jmp L1301
L1303:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 0
        ; 2
L1301:  lda _enemies + enemy::state + .sizeof(enemy) * 1
        cmp #GAME_STATE_DISABLED
        beq L1304
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 1 + 1
        bne L1305
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 1
L1305:  bcs L1306
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 1
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 1, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 1
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 1 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 1 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 1
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 1 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 1
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 1
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 1
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 1
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 1
        bcc L1304
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 1
        jmp L1304
L1306:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 1
        ; 3
L1304:  lda _enemies + enemy::state + .sizeof(enemy) * 2
        cmp #GAME_STATE_DISABLED
        beq L1307
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 2 + 1
        bne L1308
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 2
L1308:  bcs L1309
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 2
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 2, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 2
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 2 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 2 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 2
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 2
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 2 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 2
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 2
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 2
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 2
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 2
        bcc L1307
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 2
        jmp L1307
L1309:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 2
        ; 4
L1307:  lda _enemies + enemy::state + .sizeof(enemy) * 3
        cmp #GAME_STATE_DISABLED
        beq L1310
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 3 + 1
        bne L1311
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 3
L1311:  bcs L1312
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 3
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 3, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 3
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 3 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 3 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 3
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 3
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 3 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 3
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 3
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 3
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 3
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 3
        bcc L1310
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 3
        jmp L1310
L1312:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 3
L1310:  rts
.endproc

.proc _game_move_enemies_4_7
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 4
        cmp #GAME_STATE_DISABLED
        beq L1401
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 4 + 1
        bne L1402
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 4
L1402:  bcs L1403
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 4
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 4, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 4
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 4 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 4 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 4
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 4
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 4 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 4
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 4
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 4
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 4
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 4
        bcc L1401
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 4
        jmp L1401
L1403:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 4
        ; 2
L1401:  lda _enemies + enemy::state + .sizeof(enemy) * 5
        cmp #GAME_STATE_DISABLED
        beq L1404
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 5 + 1
        bne L1405
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 5
L1405:  bcs L1406
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 5
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 5, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 5
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 5 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 5 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 5
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 5
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 5 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 5
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 5
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 5
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 5
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 5
        bcc L1404
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 5
        jmp L1404
L1406:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 5
        ; 3
L1404:  lda _enemies + enemy::state + .sizeof(enemy) * 6
        cmp #GAME_STATE_DISABLED
        beq L1407
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 6 + 1
        bne L1408
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 6
L1408:  bcs L1409
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 6
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 6, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 6
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 6 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 6 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 6
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 6
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 6 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 6
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 6
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 6
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 6
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 6
        bcc L1407
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 6
        jmp L1407
L1409:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 6
        ; 4
L1407:  lda _enemies + enemy::state + .sizeof(enemy) * 7
        cmp #GAME_STATE_DISABLED
        beq L1410
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 7 + 1
        bne L1411
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 7
L1411:  bcs L1412
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 7
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 7, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 7
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 7 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 7 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 7
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 7
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 7 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 7
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 7
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 7
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 7
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 7
        bcc L1410
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 7
        jmp L1410
L1412:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 7
L1410:  rts
.endproc

.proc _game_move_enemies_8_11
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 8
        cmp #GAME_STATE_DISABLED
        beq L1501
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 8 + 1
        bne L1502
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 8
L1502:  bcs L1503
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 8
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 8, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 8
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 8 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 8 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 8
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 8
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 8 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 8
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 8
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 8
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 8
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 8
        bcc L1501
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 8
        jmp L1501
L1503:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 8
        ; 2
L1501:  lda _enemies + enemy::state + .sizeof(enemy) * 9
        cmp #GAME_STATE_DISABLED
        beq L1504
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 9 + 1
        bne L1505
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 9
L1505:  bcs L1506
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 9
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 9, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 9
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 9 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 9 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 9
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 9
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 9 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 9
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 9
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 9
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 9
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 9
        bcc L1504
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 9
        jmp L1504
L1506:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 9
        ; 3
L1504:  lda _enemies + enemy::state + .sizeof(enemy) * 10
        cmp #GAME_STATE_DISABLED
        beq L1507
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 10 + 1
        bne L1508
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 10
L1508:  bcs L1509
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 10
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 10, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 10
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 10 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 10 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 10
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 10
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 10 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 10
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 10
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 10
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 10
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 10
        bcc L1507
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 10
        jmp L1507
L1509:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 10
        ; 4
L1507:  lda _enemies + enemy::state + .sizeof(enemy) * 11
        cmp #GAME_STATE_DISABLED
        beq L1510
        lda #>ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 11 + 1
        bne L1511
        lda #<ENEMY_X_MIN
        cmp _enemies + enemy::x_coord + .sizeof(enemy) * 11
L1511:  bcs L1512
        ldx _is_scroll2
        sec
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 11
        sbc _enemies + enemy::x_steps + .sizeof(enemy) * 11, x
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 11
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 11 + 1
        sbc #0
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 11 + 1
        ldy _enemies + enemy::y_step_index + .sizeof(enemy) * 11
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 11
        sta ptr1
        lda _enemies + enemy::y_steps + .sizeof(enemy) * 11 + 1
        sta ptr1 + 1
        clc
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 11
        adc (ptr1), y
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 11
        inc _enemies + enemy::y_step_index + .sizeof(enemy) * 11
        lda _enemies + enemy::y_step_index + .sizeof(enemy) * 11
        cmp _enemies + enemy::y_step_count + .sizeof(enemy) * 11
        bcc L1510
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 11
        jmp L1510
L1512:  lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 11
L1510:  rts
.endproc

.proc _game_change_enemy_states_0_3
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 0
        cmp #GAME_STATE_LIVE
        bne L1601
        lda _sprite_coll1
        and #$10
        beq L1602
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 0
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 0
        jmp L1602
L1601:  lda _enemies + enemy::state + .sizeof(enemy) * 0
        cmp #GAME_STATE_DESTROYING
        bne L1602
        inc _enemies + enemy::sprite + .sizeof(enemy) * 0
        lda _enemies + enemy::sprite + .sizeof(enemy) * 0
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1602
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 0
        ; 2
L1602:  lda _enemies + enemy::state + .sizeof(enemy) * 1
        cmp #GAME_STATE_LIVE
        bne L1603
        lda _sprite_coll1
        and #$20
        beq L1604
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 1
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 1
        jmp L1604
L1603:  lda _enemies + enemy::state + .sizeof(enemy) * 1
        cmp #GAME_STATE_DESTROYING
        bne L1604
        inc _enemies + enemy::sprite + .sizeof(enemy) * 1
        lda _enemies + enemy::sprite + .sizeof(enemy) * 1
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1604
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 1
        ; 3
L1604:  lda _enemies + enemy::state + .sizeof(enemy) * 2
        cmp #GAME_STATE_LIVE
        bne L1605
        lda _sprite_coll1
        and #$40
        beq L1606
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 2
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 2
        jmp L1606
L1605:  lda _enemies + enemy::state + .sizeof(enemy) * 2
        cmp #GAME_STATE_DESTROYING
        bne L1606
        inc _enemies + enemy::sprite + .sizeof(enemy) * 2
        lda _enemies + enemy::sprite + .sizeof(enemy) * 2
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1606
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 2
        ; 4
L1606:  lda _enemies + enemy::state + .sizeof(enemy) * 3
        cmp #GAME_STATE_LIVE
        bne L1607
        lda _sprite_coll1
        and #$80
        beq L1608
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 3
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 3
        jmp L1608
L1607:  lda _enemies + enemy::state + .sizeof(enemy) * 3
        cmp #GAME_STATE_DESTROYING
        bne L1608
        inc _enemies + enemy::sprite + .sizeof(enemy) * 3
        lda _enemies + enemy::sprite + .sizeof(enemy) * 3
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1608
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 3
L1608:  rts
.endproc

.proc _game_change_enemy_states_4_7
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 4
        cmp #GAME_STATE_LIVE
        bne L1701
        lda _sprite_coll2
        and #$10
        beq L1702
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 4
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 4
        jmp L1702
L1701:  lda _enemies + enemy::state + .sizeof(enemy) * 4
        cmp #GAME_STATE_DESTROYING
        bne L1702
        inc _enemies + enemy::sprite + .sizeof(enemy) * 4
        lda _enemies + enemy::sprite + .sizeof(enemy) * 4
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1702
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 4
        ; 2
L1702:  lda _enemies + enemy::state + .sizeof(enemy) * 5
        cmp #GAME_STATE_LIVE
        bne L1703
        lda _sprite_coll2
        and #$20
        beq L1704
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 5
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 5
        jmp L1704
L1703:  lda _enemies + enemy::state + .sizeof(enemy) * 5
        cmp #GAME_STATE_DESTROYING
        bne L1704
        inc _enemies + enemy::sprite + .sizeof(enemy) * 5
        lda _enemies + enemy::sprite + .sizeof(enemy) * 5
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1704
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 5
        ; 3
L1704:  lda _enemies + enemy::state + .sizeof(enemy) * 6
        cmp #GAME_STATE_LIVE
        bne L1705
        lda _sprite_coll2
        and #$40
        beq L1706
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 6
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 6
        jmp L1706
L1705:  lda _enemies + enemy::state + .sizeof(enemy) * 6
        cmp #GAME_STATE_DESTROYING
        bne L1706
        inc _enemies + enemy::sprite + .sizeof(enemy) * 6
        lda _enemies + enemy::sprite + .sizeof(enemy) * 6
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1706
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 6
        ; 4
L1706:  lda _enemies + enemy::state + .sizeof(enemy) * 7
        cmp #GAME_STATE_LIVE
        bne L1707
        lda _sprite_coll2
        and #$80
        beq L1708
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 7
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 7
        jmp L1708
L1707:  lda _enemies + enemy::state + .sizeof(enemy) * 7
        cmp #GAME_STATE_DESTROYING
        bne L1708
        inc _enemies + enemy::sprite + .sizeof(enemy) * 7
        lda _enemies + enemy::sprite + .sizeof(enemy) * 7
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1708
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 7
L1708:  rts
.endproc

.proc _game_change_enemy_states_8_11
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 8
        cmp #GAME_STATE_LIVE
        bne L1801
        lda _sprite_coll1
        and #$10
        beq L1802
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 8
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 8
        jmp L1802
L1801:  lda _enemies + enemy::state + .sizeof(enemy) * 8
        cmp #GAME_STATE_DESTROYING
        bne L1802
        inc _enemies + enemy::sprite + .sizeof(enemy) * 8
        lda _enemies + enemy::sprite + .sizeof(enemy) * 8
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1802
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 8
        ; 2
L1802:  lda _enemies + enemy::state + .sizeof(enemy) * 9
        cmp #GAME_STATE_LIVE
        bne L1803
        lda _sprite_coll1
        and #$20
        beq L1804
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 9
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 9
        jmp L1804
L1803:  lda _enemies + enemy::state + .sizeof(enemy) * 9
        cmp #GAME_STATE_DESTROYING
        bne L1804
        inc _enemies + enemy::sprite + .sizeof(enemy) * 9
        lda _enemies + enemy::sprite + .sizeof(enemy) * 9
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1804
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 9
        ; 3
L1804:  lda _enemies + enemy::state + .sizeof(enemy) * 10
        cmp #GAME_STATE_LIVE
        bne L1805
        lda _sprite_coll1
        and #$40
        beq L1806
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 10
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 10
        jmp L1806
L1805:  lda _enemies + enemy::state + .sizeof(enemy) * 10
        cmp #GAME_STATE_DESTROYING
        bne L1806
        inc _enemies + enemy::sprite + .sizeof(enemy) * 10
        lda _enemies + enemy::sprite + .sizeof(enemy) * 10
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1806
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 10
        ; 4
L1806:  lda _enemies + enemy::state + .sizeof(enemy) * 11
        cmp #GAME_STATE_LIVE
        bne L1807
        lda _sprite_coll1
        and #$80
        beq L1808
        lda #GAME_STATE_DESTROYING
        sta _enemies + enemy::state + .sizeof(enemy) * 11
        lda _enemy_explosion + enemy_explosion::start_explosion_sprite
        sta _enemies + enemy::sprite + .sizeof(enemy) * 11
        jmp L1808
L1807:  lda _enemies + enemy::state + .sizeof(enemy) * 11
        cmp #GAME_STATE_DESTROYING
        bne L1808
        inc _enemies + enemy::sprite + .sizeof(enemy) * 11
        lda _enemies + enemy::sprite + .sizeof(enemy) * 11
        cmp _enemy_explosion + enemy_explosion::end_explosion_sprite
        bcc L1808
        lda #GAME_STATE_DISABLED
        sta _enemies + enemy::state + .sizeof(enemy) * 11
L1808:  rts
.endproc

.proc _game_add_enemy_points_0_3
        lda _player + player::state
        cmp #GAME_STATE_LIVE
        beq L19add
        jmp L19no_add
L19add: sed
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 0
        cmp #GAME_STATE_DESTROYING
        bne L1901
        lda _enemies + enemy::sprite + .sizeof(enemy) * 0
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L1901
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 0
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 2
L1901:  lda _enemies + enemy::state + .sizeof(enemy) * 1
        cmp #GAME_STATE_DESTROYING
        bne L1902
        lda _enemies + enemy::sprite + .sizeof(enemy) * 1
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L1902
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 1
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 3
L1902:  lda _enemies + enemy::state + .sizeof(enemy) * 2
        cmp #GAME_STATE_DESTROYING
        bne L1903
        lda _enemies + enemy::sprite + .sizeof(enemy) * 2
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L1903
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 2
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 4
L1903:  lda _enemies + enemy::state + .sizeof(enemy) * 3
        cmp #GAME_STATE_DESTROYING
        bne L1904
        lda _enemies + enemy::sprite + .sizeof(enemy) * 3
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L1904
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 3
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
L1904:  cld
L19no_add:
        rts
.endproc

.proc _game_add_enemy_points_4_7
        lda _player + player::state
        cmp #GAME_STATE_LIVE
        beq L20add
        jmp L20no_add
L20add: sed
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 4
        cmp #GAME_STATE_DESTROYING
        bne L2001
        lda _enemies + enemy::sprite + .sizeof(enemy) * 4
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2001
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 4
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 2
L2001:  lda _enemies + enemy::state + .sizeof(enemy) * 5
        cmp #GAME_STATE_DESTROYING
        bne L2002
        lda _enemies + enemy::sprite + .sizeof(enemy) * 5
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2002
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 5
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 3
L2002:  lda _enemies + enemy::state + .sizeof(enemy) * 6
        cmp #GAME_STATE_DESTROYING
        bne L2003
        lda _enemies + enemy::sprite + .sizeof(enemy) * 6
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2003
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 6
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 4
L2003:  lda _enemies + enemy::state + .sizeof(enemy) * 7
        cmp #GAME_STATE_DESTROYING
        bne L2004
        lda _enemies + enemy::sprite + .sizeof(enemy) * 7
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2004
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 7
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
L2004:  cld
L20no_add:
        rts
.endproc

.proc _game_add_enemy_points_8_11
        lda _player + player::state
        cmp #GAME_STATE_LIVE
        beq L21add
        jmp L21no_add
L21add: sed
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 8
        cmp #GAME_STATE_DESTROYING
        bne L2101
        lda _enemies + enemy::sprite + .sizeof(enemy) * 8
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2101
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 8
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 2
L2101:  lda _enemies + enemy::state + .sizeof(enemy) * 9
        cmp #GAME_STATE_DESTROYING
        bne L2102
        lda _enemies + enemy::sprite + .sizeof(enemy) * 9
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2102
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 9
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 3
L2102:  lda _enemies + enemy::state + .sizeof(enemy) * 10
        cmp #GAME_STATE_DESTROYING
        bne L2103
        lda _enemies + enemy::sprite + .sizeof(enemy) * 10
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2103
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 10
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
        ; 4
L2103:  lda _enemies + enemy::state + .sizeof(enemy) * 11
        cmp #GAME_STATE_DESTROYING
        bne L2104
        lda _enemies + enemy::sprite + .sizeof(enemy) * 11
        cmp _enemy_explosion + enemy_explosion::start_explosion_sprite
        bne L2104
        clc
        lda _player + player::score
        adc _enemies + enemy::points + .sizeof(enemy) * 11
        sta _player + player::score
        lda _player + player::score + 1
        adc #0
        sta _player + player::score + 1
        lda _player + player::score + 2
        adc #0
        sta _player + player::score + 2
L2104:  cld
L21no_add:
        rts
.endproc

.proc _game_set_enemy_sprites_0_3
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 0
        cmp #GAME_STATE_DISABLED
        beq L2201
        lda VIC_SPR_ENA
        ora #$10
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 0
        sta VIC_SPR4_X
        lda VIC_SPR_HI_X
        and #$ef
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 0 + 1
        ora Ltab_bit_shift_4, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 0
        sta VIC_SPR4_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 0
        sta SPRITE_PTRS1 + 4
        sta SPRITE_PTRS2 + 4
        ldx _enemies + enemy::state + .sizeof(enemy) * 0
        lda Ltab_state_colors, x
        sta VIC_SPR4_COLOR
        jmp L2202
L2201:  lda VIC_SPR_ENA
        and #$ef
        sta VIC_SPR_ENA
        ; 2
L2202:  lda _enemies + enemy::state + .sizeof(enemy) * 1
        cmp #GAME_STATE_DISABLED
        beq L2203
        lda VIC_SPR_ENA
        ora #$20
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 1
        sta VIC_SPR5_X
        lda VIC_SPR_HI_X
        and #$df
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 1 + 1
        ora Ltab_bit_shift_5, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 1
        sta VIC_SPR5_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 1
        sta SPRITE_PTRS1 + 5
        sta SPRITE_PTRS2 + 5
        ldx _enemies + enemy::state + .sizeof(enemy) * 1
        lda Ltab_state_colors, x
        sta VIC_SPR5_COLOR
        jmp L2204
L2203:  lda VIC_SPR_ENA
        and #$df
        sta VIC_SPR_ENA
        ; 3
L2204:  lda _enemies + enemy::state + .sizeof(enemy) * 2
        cmp #GAME_STATE_DISABLED
        beq L2205
        lda VIC_SPR_ENA
        ora #$40
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 2
        sta VIC_SPR6_X
        lda VIC_SPR_HI_X
        and #$bf
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 2 + 1
        ora Ltab_bit_shift_6, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 2
        sta VIC_SPR6_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 2
        sta SPRITE_PTRS1 + 6
        sta SPRITE_PTRS2 + 6
        ldx _enemies + enemy::state + .sizeof(enemy) * 2
        lda Ltab_state_colors, x
        sta VIC_SPR6_COLOR
        jmp L2206
L2205:  lda VIC_SPR_ENA
        and #$bf
        sta VIC_SPR_ENA
        ; 4
L2206:  lda _enemies + enemy::state + .sizeof(enemy) * 3
        cmp #GAME_STATE_DISABLED
        beq L2207
        lda VIC_SPR_ENA
        ora #$80
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 3
        sta VIC_SPR7_X
        lda VIC_SPR_HI_X
        and #$7f
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 3 + 1
        ora Ltab_bit_shift_7, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 3
        sta VIC_SPR7_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 3
        sta SPRITE_PTRS1 + 7
        sta SPRITE_PTRS2 + 7
        ldx _enemies + enemy::state + .sizeof(enemy) * 3
        lda Ltab_state_colors, x
        sta VIC_SPR7_COLOR
        jmp L2208
L2207:  lda VIC_SPR_ENA
        and #$7f
        sta VIC_SPR_ENA
L2208:  rts
.endproc

.proc _game_set_enemy_sprites_4_7
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 4
        cmp #GAME_STATE_DISABLED
        beq L2301
        lda VIC_SPR_ENA
        ora #$10
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 4
        sta VIC_SPR4_X
        lda VIC_SPR_HI_X
        and #$ef
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 4 + 1
        ora Ltab_bit_shift_4, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 4
        sta VIC_SPR4_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 4
        sta SPRITE_PTRS1 + 4
        sta SPRITE_PTRS2 + 4
        ldx _enemies + enemy::state + .sizeof(enemy) * 4
        lda Ltab_state_colors, x
        sta VIC_SPR4_COLOR
        jmp L2302
L2301:  lda VIC_SPR_ENA
        and #$ef
        sta VIC_SPR_ENA
        ; 2
L2302:  lda _enemies + enemy::state + .sizeof(enemy) * 5
        cmp #GAME_STATE_DISABLED
        beq L2303
        lda VIC_SPR_ENA
        ora #$20
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 5
        sta VIC_SPR5_X
        lda VIC_SPR_HI_X
        and #$df
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 5 + 1
        ora Ltab_bit_shift_5, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 5
        sta VIC_SPR5_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 5
        sta SPRITE_PTRS1 + 5
        sta SPRITE_PTRS2 + 5
        ldx _enemies + enemy::state + .sizeof(enemy) * 5
        lda Ltab_state_colors, x
        sta VIC_SPR5_COLOR
        jmp L2304
L2303:  lda VIC_SPR_ENA
        and #$df
        sta VIC_SPR_ENA
        ; 3
L2304:  lda _enemies + enemy::state + .sizeof(enemy) * 6
        cmp #GAME_STATE_DISABLED
        beq L2305
        lda VIC_SPR_ENA
        ora #$40
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 6
        sta VIC_SPR6_X
        lda VIC_SPR_HI_X
        and #$bf
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 6 + 1
        ora Ltab_bit_shift_6, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 6
        sta VIC_SPR6_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 6
        sta SPRITE_PTRS1 + 6
        sta SPRITE_PTRS2 + 6
        ldx _enemies + enemy::state + .sizeof(enemy) * 6
        lda Ltab_state_colors, x
        sta VIC_SPR6_COLOR
        jmp L2306
L2305:  lda VIC_SPR_ENA
        and #$bf
        sta VIC_SPR_ENA
        ; 4
L2306:  lda _enemies + enemy::state + .sizeof(enemy) * 7
        cmp #GAME_STATE_DISABLED
        beq L2307
        lda VIC_SPR_ENA
        ora #$80
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 7
        sta VIC_SPR7_X
        lda VIC_SPR_HI_X
        and #$7f
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 7 + 1
        ora Ltab_bit_shift_7, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 7
        sta VIC_SPR7_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 7
        sta SPRITE_PTRS1 + 7
        sta SPRITE_PTRS2 + 7
        ldx _enemies + enemy::state + .sizeof(enemy) * 7
        lda Ltab_state_colors, x
        sta VIC_SPR7_COLOR
        jmp L2308
L2307:  lda VIC_SPR_ENA
        and #$7f
        sta VIC_SPR_ENA
L2308:  rts
.endproc

.proc _game_set_enemy_sprites_8_11
        ; 1
        lda _enemies + enemy::state + .sizeof(enemy) * 8
        cmp #GAME_STATE_DISABLED
        beq L2401
        lda VIC_SPR_ENA
        ora #$10
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 8
        sta VIC_SPR4_X
        lda VIC_SPR_HI_X
        and #$ef
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 8 + 1
        ora Ltab_bit_shift_4, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 8
        sta VIC_SPR4_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 8
        sta SPRITE_PTRS1 + 4
        sta SPRITE_PTRS2 + 4
        ldx _enemies + enemy::state + .sizeof(enemy) * 8
        lda Ltab_state_colors, x
        sta VIC_SPR4_COLOR
        jmp L2402
L2401:  lda VIC_SPR_ENA
        and #$ef
        sta VIC_SPR_ENA
        ; 2
L2402:  lda _enemies + enemy::state + .sizeof(enemy) * 9
        cmp #GAME_STATE_DISABLED
        beq L2403
        lda VIC_SPR_ENA
        ora #$20
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 9
        sta VIC_SPR5_X
        lda VIC_SPR_HI_X
        and #$df
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 9 + 1
        ora Ltab_bit_shift_5, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 9
        sta VIC_SPR5_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 9
        sta SPRITE_PTRS1 + 5
        sta SPRITE_PTRS2 + 5
        ldx _enemies + enemy::state + .sizeof(enemy) * 9
        lda Ltab_state_colors, x
        sta VIC_SPR5_COLOR
        jmp L2404
L2403:  lda VIC_SPR_ENA
        and #$df
        sta VIC_SPR_ENA
        ; 3
L2404:  lda _enemies + enemy::state + .sizeof(enemy) * 10
        cmp #GAME_STATE_DISABLED
        beq L2405
        lda VIC_SPR_ENA
        ora #$40
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 10
        sta VIC_SPR6_X
        lda VIC_SPR_HI_X
        and #$bf
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 10 + 1
        ora Ltab_bit_shift_6, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 10
        sta VIC_SPR6_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 10
        sta SPRITE_PTRS1 + 6
        sta SPRITE_PTRS2 + 6
        ldx _enemies + enemy::state + .sizeof(enemy) * 10
        lda Ltab_state_colors, x
        sta VIC_SPR6_COLOR
        jmp L2406
L2405:  lda VIC_SPR_ENA
        and #$bf
        sta VIC_SPR_ENA
        ; 4
L2406:  lda _enemies + enemy::state + .sizeof(enemy) * 11
        cmp #GAME_STATE_DISABLED
        beq L2407
        lda VIC_SPR_ENA
        ora #$80
        sta VIC_SPR_ENA
        lda _enemies + enemy::x_coord + .sizeof(enemy) * 11
        sta VIC_SPR7_X
        lda VIC_SPR_HI_X
        and #$7f
        ldx _enemies + enemy::x_coord + .sizeof(enemy) * 11 + 1
        ora Ltab_bit_shift_7, x
        sta VIC_SPR_HI_X
        lda _enemies + enemy::y_coord + .sizeof(enemy) * 11
        sta VIC_SPR7_Y
        lda _enemies + enemy::sprite + .sizeof(enemy) * 11
        sta SPRITE_PTRS1 + 7
        sta SPRITE_PTRS2 + 7
        ldx _enemies + enemy::state + .sizeof(enemy) * 11
        lda Ltab_state_colors, x
        sta VIC_SPR7_COLOR
        jmp L2408
L2407:  lda VIC_SPR_ENA
        and #$7f
        sta VIC_SPR_ENA
L2408:  rts
.endproc

        .rodata

Ltab_enemy_desc_xs:
        .byte .sizeof(enemy_desc) * 0
        .byte .sizeof(enemy_desc) * 1
        .byte .sizeof(enemy_desc) * 2
        .byte .sizeof(enemy_desc) * 3

Ltab_enemy_xs:
        .byte .sizeof(enemy) * 0
        .byte .sizeof(enemy) * 1
        .byte .sizeof(enemy) * 2
        .byte .sizeof(enemy) * 3

        .code

.proc _game_alloc_enemy1
        lda _current_level + level::enemies + 2 * 0
        sta ptr1
        lda _current_level + level::enemies + 2 * 0 + 1
        sta ptr1 + 1
        ldy _level_pos
        lda (ptr1), y
        cmp #$20 ; space
        beq L25no_alloc
        sec
        sbc #$31 ; 1
        tay
        ldx Ltab_enemy_desc_xs, y
        ldy _enemy_alloc_indices + 0
        lda Ltab_enemy_xs, y
        tay
        lda #GAME_STATE_LIVE
        sta _enemies + enemy::state + .sizeof(enemy) * 0, y
        lda #<ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 0, y
        lda #>ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 0 + 1, y
        lda #ENEMY_Y1
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 0, y
        lda _enemy_descs + enemy_desc::x_step, x
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 0 + 0, y
        clc
        adc #2
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 0 + 1, y
        lda _enemy_descs + enemy_desc::y_steps, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 0, y
        lda _enemy_descs + enemy_desc::y_steps + 1, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 0 + 1, y
        lda _enemy_descs + enemy_desc::y_step_count, x
        sta _enemies + enemy::y_step_count + .sizeof(enemy) * 0, y
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 0, y
        lda _enemy_descs + enemy_desc::sprite, x
        sta _enemies + enemy::sprite + .sizeof(enemy) * 0, y
        lda _enemy_descs + enemy_desc::points, x
        sta _enemies + enemy::points + .sizeof(enemy) * 0, y
        inc _enemy_alloc_indices + 0 
        lda _enemy_alloc_indices + 0
        cmp #4
        bcc L25ret                      ; !(enemy_alloc_indices[0] >= 4)
        lda #0
        sta _enemy_alloc_indices + 0
L25no_alloc:
L25ret: rts
.endproc

.proc _game_alloc_enemy2
        lda _current_level + level::enemies + 2 * 1
        sta ptr1
        lda _current_level + level::enemies + 2 * 1 + 1
        sta ptr1 + 1
        ldy _level_pos
        lda (ptr1), y
        cmp #$20 ; space
        beq L26no_alloc
        sec
        sbc #$31 ; 1
        tay
        ldx Ltab_enemy_desc_xs, y
        ldy _enemy_alloc_indices + 1
        lda Ltab_enemy_xs, y
        tay
        lda #GAME_STATE_LIVE
        sta _enemies + enemy::state + .sizeof(enemy) * 4, y
        lda #<ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 4, y
        lda #>ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 4 + 1, y
        lda #ENEMY_Y2
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 4, y
        lda _enemy_descs + enemy_desc::x_step, x
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 4 + 0, y
        clc
        adc #2
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 4 + 1, y
        lda _enemy_descs + enemy_desc::y_steps, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 4, y
        lda _enemy_descs + enemy_desc::y_steps + 1, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 4 + 1, y
        lda _enemy_descs + enemy_desc::y_step_count, x
        sta _enemies + enemy::y_step_count + .sizeof(enemy) * 4, y
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 4, y
        lda _enemy_descs + enemy_desc::sprite, x
        sta _enemies + enemy::sprite + .sizeof(enemy) * 4, y
        lda _enemy_descs + enemy_desc::points, x
        sta _enemies + enemy::points + .sizeof(enemy) * 4, y
        inc _enemy_alloc_indices + 1
        lda _enemy_alloc_indices + 1
        cmp #4
        bcc L26ret                      ; !(enemy_alloc_indices[1] >= 4)
        lda #0
        sta _enemy_alloc_indices + 1
L26no_alloc:
L26ret: rts
.endproc

.proc _game_alloc_enemy3
        lda _current_level + level::enemies + 2 * 2
        sta ptr1
        lda _current_level + level::enemies + 2 * 2 + 1
        sta ptr1 + 1
        ldy _level_pos
        lda (ptr1), y
        cmp #$20 ; space
        beq L27no_alloc
        sec
        sbc #$31 ; 1
        tay
        ldx Ltab_enemy_desc_xs, y
        ldy _enemy_alloc_indices + 2
        lda Ltab_enemy_xs, y
        tay
        lda #GAME_STATE_LIVE
        sta _enemies + enemy::state + .sizeof(enemy) * 8, y
        lda #<ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 8, y
        lda #>ENEMY_X_MAX
        sta _enemies + enemy::x_coord + .sizeof(enemy) * 8 + 1, y
        lda #ENEMY_Y3
        sta _enemies + enemy::y_coord + .sizeof(enemy) * 8, y
        lda _enemy_descs + enemy_desc::x_step, x
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 8 + 0, y
        clc
        adc #2
        sta _enemies + enemy::x_steps + .sizeof(enemy) * 8 + 1, y
        lda _enemy_descs + enemy_desc::y_steps, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 8, y
        lda _enemy_descs + enemy_desc::y_steps + 1, x
        sta _enemies + enemy::y_steps + .sizeof(enemy) * 8 + 1, y
        lda _enemy_descs + enemy_desc::y_step_count, x
        sta _enemies + enemy::y_step_count + .sizeof(enemy) * 8, y
        lda #0
        sta _enemies + enemy::y_step_index + .sizeof(enemy) * 8, y
        lda _enemy_descs + enemy_desc::sprite, x
        sta _enemies + enemy::sprite + .sizeof(enemy) * 8, y
        lda _enemy_descs + enemy_desc::points, x
        sta _enemies + enemy::points + .sizeof(enemy) * 8, y
        inc _enemy_alloc_indices + 2
        lda _enemy_alloc_indices + 2
        cmp #4
        bcc L27ret                      ; !(enemy_alloc_indices[2] >= 4)
        lda #0
        sta _enemy_alloc_indices + 2
L27no_alloc:
L27ret: rts
.endproc

.proc _game_display_score
        lda _player + player::score
        and #$0f
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 5
        sta SCREEN2 + 40 * 23 + 34 + 5
        lda _player + player::score
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 4
        sta SCREEN2 + 40 * 23 + 34 + 4
        lda _player + player::score + 1
        and #$0f
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 3
        sta SCREEN2 + 40 * 23 + 34 + 3
        lda _player + player::score + 1
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 2
        sta SCREEN2 + 40 * 23 + 34 + 2
        lda _player + player::score + 2
        and #$0f
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 1
        sta SCREEN2 + 40 * 23 + 34 + 1
        lda _player + player::score + 2
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30 ; 0
        sta SCREEN1 + 40 * 23 + 34 + 0
        sta SCREEN2 + 40 * 23 + 34 + 0
        rts
.endproc
