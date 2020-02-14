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

SPRITE_X_OFFSET = 24
SPRITE_Y_OFFSET = 50

RASTER_OFFSET   = 51

VIC_BANK        = 1
SCREEN1         := $6000
SCREEN2         := $6400
SPR_POINTERS1   := SCREEN1 + $3f8
SPR_POINTERS2   := SCREEN2 + $3f8
CHARS           := $6800
SPRITES         := $7000
