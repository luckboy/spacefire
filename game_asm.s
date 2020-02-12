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
        .import _level_pos
        .import _block_pos
        .import _scroll_pos
        .import _player
        .import _current_level
        .importzp tmp1, ptr1
        
        .include "c64.inc"
        .include "game.inc"
        .include "graphics.inc"
        .include "levels.inc"

PLAYER_X_MIN = SPRITE_X_OFFSET + 8
PLAYER_X_MAX = SPRITE_X_OFFSET + 40 * 8 - 8 - 24
PLAYER_Y_MIN = SPRITE_Y_OFFSET
PLAYER_Y_MAX = SPRITE_Y_OFFSET + 22 * 8 - 22

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
        sta SPR_POINTERS1 + 0
        sta SPR_POINTERS2 + 0
        lda #$01 ; white
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
        lda _scroll_pos
        beq L06no_scroll
        dec _scroll_pos
        dec _scroll_pos
L06no_scroll:
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
        ora #((SCREEN2 -$4000) >> 10) << 4 
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
        ora #((SCREEN1 -$4000) >> 10) << 4 
        sta VIC_VIDEO_ADR
        lda #0
        sta _block_pos
        inc _level_pos
L06scroll:
        lda _scroll_pos
        beq L06scroll_start
        dec _scroll_pos
        dec _scroll_pos
        jmp L06set_scroll
L06scroll_start:
        lda #6
        sta _scroll_pos
L06set_scroll:
        lda #$d0
        ora _scroll_pos
        sta VIC_CTRL2
        rts
.endproc
