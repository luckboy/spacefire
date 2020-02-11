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
        .import _player
        
        .include "c64.inc"
        .include "game.inc"
        .include "graphics.inc"

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
        lda #$01 ; white
        sta VIC_SPR0_COLOR
        rts
.endproc
