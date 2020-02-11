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
        .export _sprites
        
        .rodata
_sprites:
        .byte %00111100, %00000000, %00000000 ; 1
        .byte %11101011, %00000000, %00000000 ; 2
        .byte %11111110, %11000000, %00000000 ; 3
        .byte %11111111, %10110000, %00000000 ; 4
        .byte %00111111, %10101100, %00000000 ; 5
        .byte %00111111, %10111011, %00000000 ; 6
        .byte %00111111, %10111110, %11000000 ; 7
        .byte %00111111, %10111111, %10110000 ; 8
        .byte %00111111, %11111111, %11101100 ; 9
        .byte %10111111, %01000001, %11111011 ; 10
        .byte %10111111, %00000000, %11111111 ; 11
        .byte %10111111, %01000001, %11110111 ; 12
        .byte %00111111, %11111111, %11011100 ; 13
        .byte %00111111, %01111111, %01110000 ; 14
        .byte %00111111, %01111101, %11000000 ; 15
        .byte %00111111, %01110111, %00000000 ; 16
        .byte %00111111, %01011100, %00000000 ; 17
        .byte %11111111, %01110000, %00000000 ; 18
        .byte %11111101, %11000000, %00000000 ; 19
        .byte %11010111, %00000000, %00000000 ; 20
        .byte %00111100, %00000000, %00000000 ; 21
        .byte %00000000