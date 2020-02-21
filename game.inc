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

GAME_STATE_DISABLED     = 0
GAME_STATE_LIVE         = 1
GAME_STATE_DESTROYING   = 2

GAME_SHOT_COUNT_MAX     = 3

.struct player
    state   .byte
    x_coord .word
    y_coord .byte
    x_steps .byte 2
    sprite  .byte
    lives   .byte
    score   .dword
    start_explosion_sprite .byte
    end_explosion_sprite .byte
.endstruct

.struct shot
    is_enabled .byte
    x_coord .word
    y_coord .byte
    x_steps .byte 2
    sprite  .byte
.endstruct
