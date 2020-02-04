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
        .export _petscii_chars
        .export _level_chars
        
        .rodata

_petscii_chars:
; @
; $00
        .byte %00111100
        .byte %01000110
        .byte %01001010
        .byte %01001110
        .byte %01100000
        .byte %01100110
        .byte %00111100
        .byte %00000000
; A
; $01
        .byte %00011000
        .byte %00100100
        .byte %01000010
        .byte %01111110
        .byte %01100110
        .byte %01100110
        .byte %01100110
        .byte %00000000
; B
; $02
        .byte %01111100
        .byte %01000010
        .byte %01000010
        .byte %01111100
        .byte %01100110
        .byte %01100110
        .byte %01111100
        .byte %00000000
; C
; $03
        .byte %00111100
        .byte %01000010
        .byte %01000000
        .byte %01000000
        .byte %01100000
        .byte %01100110
        .byte %00111100
        .byte %00000000
; D
; $04
        .byte %01111100
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %01100110
        .byte %01111100
        .byte %00000000
; E
; $05
        .byte %01111110
        .byte %01000000
        .byte %01000000
        .byte %01111100
        .byte %01100000
        .byte %01100000
        .byte %01111110
        .byte %00000000
; F
; $06
        .byte %01111110
        .byte %01000000
        .byte %01000000
        .byte %01111000
        .byte %01100000
        .byte %01100000
        .byte %01100000
        .byte %00000000
; G
; $07
        .byte %00111100
        .byte %01000010
        .byte %01000000
        .byte %01001110
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; H
; $08
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01111110
        .byte %01100110
        .byte %01100110
        .byte %01100110
        .byte %00000000
; I
; $09
        .byte %00111100
        .byte %00001000
        .byte %00001000
        .byte %00001000
        .byte %00011000
        .byte %00011000
        .byte %00111100
        .byte %00000000
; J
; $0a
        .byte %00000010
        .byte %00000010
        .byte %00000010
        .byte %00000010
        .byte %00000110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; K
; $0b
        .byte %01000010
        .byte %01000010
        .byte %01000100
        .byte %01111000
        .byte %01101100
        .byte %01100110
        .byte %01100110
        .byte %00000000
; L
; $0c
        .byte %01000000
        .byte %01000000
        .byte %01000000
        .byte %01000000
        .byte %01100000
        .byte %01100000
        .byte %01111110
        .byte %00000000
; M
; $0d
        .byte %01100011
        .byte %01010101
        .byte %01001001
        .byte %01001001
        .byte %01100011
        .byte %01100011
        .byte %01100011
        .byte %00000000
; N
; $0e
        .byte %01111010
        .byte %01000110
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %01100110
        .byte %01100110
        .byte %00000000
; O
; $0f
        .byte %00111100
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; P
; $10
        .byte %01111100
        .byte %01000010
        .byte %01000010
        .byte %01111100
        .byte %01100000
        .byte %01100000
        .byte %01100000
        .byte %00000000
; Q
; $11
        .byte %00111100
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000110
; R
; $12
        .byte %01111100
        .byte %01000010
        .byte %01000010
        .byte %01111100
        .byte %01101100
        .byte %01100110
        .byte %01100110
        .byte %00000000
; S
; $13
        .byte %00111100
        .byte %01000010
        .byte %01000000
        .byte %00111100
        .byte %00000110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; T
; $14
        .byte %01111110
        .byte %00001000
        .byte %00001000
        .byte %00001000
        .byte %00011000
        .byte %00011000
        .byte %00011000
        .byte %00000000
; U
; $15
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; V
; $16
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01000010
        .byte %01100110
        .byte %00111100
        .byte %00011000
        .byte %00000000
; W
; $17
        .byte %01000001
        .byte %01000001
        .byte %01000001
        .byte %01001001
        .byte %01111111
        .byte %01110111
        .byte %01100011
        .byte %00000000
; X
; $18
        .byte %01000010
        .byte %01000010
        .byte %00100100
        .byte %00011000
        .byte %00111100
        .byte %01100110
        .byte %01100110
        .byte %00000000
; Y
; $19
        .byte %01000010
        .byte %01000010
        .byte %00100100
        .byte %00011000
        .byte %00011000
        .byte %00011000
        .byte %00011000
        .byte %00000000
; Z
; $1a
        .byte %01111110
        .byte %00000010
        .byte %00000100
        .byte %00001000
        .byte %00110000
        .byte %01100000
        .byte %01111110
        .byte %00000000
; [
; $1b
        .byte %00111100
        .byte %00100000
        .byte %00100000
        .byte %00100000
        .byte %00110000
        .byte %00110000
        .byte %00111100
        .byte %00000000
; pound
; $1c
        .byte %00000110
        .byte %00001001
        .byte %00010000
        .byte %01111100
        .byte %00110000
        .byte %01100110
        .byte %11111100
        .byte %00000000
; ]
; $1d
        .byte %00111100
        .byte %00000100
        .byte %00000100
        .byte %00000100
        .byte %00001100
        .byte %00001100
        .byte %00111100
        .byte %00000000
; ^
; $1e
        .byte %00011000
        .byte %00101100
        .byte %01001010
        .byte %00001000
        .byte %00011000
        .byte %00011000
        .byte %00011000
        .byte %00000000
; ->
; $1f
        .byte %00000000
        .byte %00001000
        .byte %00000100
        .byte %01111110
        .byte %00001100
        .byte %00011000
        .byte %00000000
        .byte %00000000
; space
; $20
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; !
; $21
        .byte %00001000
        .byte %00001000
        .byte %00001000
        .byte %00001000
        .byte %00011000
        .byte %00000000
        .byte %00011000
        .byte %00000000
; "
; $22
        .byte %00100100
        .byte %00100100
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; #
; $23
        .byte %01000010
        .byte %01000010
        .byte %11111111
        .byte %01000010
        .byte %11111111
        .byte %01100110
        .byte %01100110
        .byte %00000000
; $
; $24
        .byte %00001000
        .byte %00111110
        .byte %01001000
        .byte %00111100
        .byte %00011110
        .byte %01111100
        .byte %00011000
        .byte %00000000
; %
; $25
        .byte %01100010
        .byte %01100010
        .byte %00000100
        .byte %00001000
        .byte %00110000
        .byte %01100110
        .byte %01100110
        .byte %00000000
; &
; $26
        .byte %00111100
        .byte %01000010
        .byte %00100100
        .byte %00011000
        .byte %00111000
        .byte %01100110
        .byte %00111100
        .byte %00000000
; '
; $27
        .byte %00001000
        .byte %00001000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; (
; $28
        .byte %00011100
        .byte %00100000
        .byte %00100000
        .byte %00100000
        .byte %00110000
        .byte %00110000
        .byte %00011100
        .byte %00000000
; )
; $29
        .byte %00111000
        .byte %00000100
        .byte %00000100
        .byte %00000100
        .byte %00001100
        .byte %00001100
        .byte %00111000
        .byte %00000000
; *
; $2a
        .byte %00000000
        .byte %01000010
        .byte %00100100
        .byte %01111110
        .byte %00111100
        .byte %01100110
        .byte %00000000
        .byte %00000000
; +
; $2b
        .byte %00000000
        .byte %00001000
        .byte %00001000
        .byte %01111110
        .byte %00011000
        .byte %00011000
        .byte %00000000
        .byte %00000000
; ,
; $2c
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00110000
; -
; $2d
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %01111110
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; .
; $2e
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00000000
; /
; $2e
        .byte %00000010
        .byte %00000010
        .byte %00000100
        .byte %00001000
        .byte %00110000
        .byte %01100000
        .byte %01100000
        .byte %00000000
; 0
; $30
        .byte %00111100
        .byte %01000010
        .byte %01000010
        .byte %01011010
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; 1
; $31
        .byte %00001000
        .byte %00011000
        .byte %00101000
        .byte %00001000
        .byte %00011000
        .byte %00011000
        .byte %00111100
        .byte %00000000
; 2
; $32
        .byte %00111100
        .byte %01000010
        .byte %00000010
        .byte %00001100
        .byte %00110000
        .byte %01100000
        .byte %01111110
        .byte %00000000
; 3
; $33
        .byte %00111100
        .byte %01000010
        .byte %00000010
        .byte %00111100
        .byte %00000110
        .byte %11000110
        .byte %00111100
        .byte %00000000
; 4
; $34
        .byte %00001110
        .byte %00010010
        .byte %00100010
        .byte %01111110
        .byte %00000110
        .byte %00000110
        .byte %00000110
        .byte %00000000
; 5
; $35
        .byte %01111110
        .byte %01000000
        .byte %01000000
        .byte %01111100
        .byte %00000110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; 6
; $36
        .byte %00111100
        .byte %01000010
        .byte %01000000
        .byte %01111100
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; 7
; $37
        .byte %01111110
        .byte %00000010
        .byte %00000100
        .byte %00001000
        .byte %00110000
        .byte %01100000
        .byte %01100000
        .byte %00000000
; 8
; $38
        .byte %00111100
        .byte %01000010
        .byte %01000010
        .byte %00111100
        .byte %01100110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; 9
; $39
        .byte %00111100
        .byte %01000010
        .byte %01000010
        .byte %00111110
        .byte %00000110
        .byte %01100110
        .byte %00111100
        .byte %00000000
; :
; $3a
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00000000
; ;
; $3b
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00000000
        .byte %00000000
        .byte %00011000
        .byte %00110000
; <
; $3c
        .byte %00001110
        .byte %00010000
        .byte %00100000
        .byte %01100000
        .byte %00110000
        .byte %00011000
        .byte %00001110
        .byte %00000000
; =
; $3d
        .byte %00000000
        .byte %00000000
        .byte %01111110
        .byte %00000000
        .byte %01111110
        .byte %00000000
        .byte %00000000
        .byte %00000000
; >
; $3e
        .byte %01110000
        .byte %00001000
        .byte %00000100
        .byte %00000110
        .byte %00001100
        .byte %00011000
        .byte %01110000
        .byte %00000000
; ?
; $3f
        .byte %00111100
        .byte %01000010
        .byte %00000010
        .byte %00001100
        .byte %00011000
        .byte %00000000
        .byte %00011000
        .byte %00000000

_level_chars:
; @
; $c0
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; A
; $c1
        .byte %10101010
        .byte %11111111
        .byte %11111111
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; B
; $c2
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
; C
; $c3
        .byte %00000000
        .byte %00000000
        .byte %00000010
        .byte %00000010
        .byte %00001011
        .byte %00001011
        .byte %00101110
        .byte %00101110
; D
; $c4
        .byte %10100000
        .byte %11111010
        .byte %11111111
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; E
; $c5
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10101010
        .byte %10101010
        .byte %00101010
        .byte %00101010
; F
; $c6
        .byte %10111010
        .byte %11101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; G
; $c7
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; H
; $c8
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; I
; $c9
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; J
; $ca
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; K
; $cb
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; L
; $cc
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; M
; $cd
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; N
; $ce
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; O
; $cf
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; @
; $d0
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; A
; $d1
        .byte %10101010
        .byte %11111111
        .byte %11111111
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; B
; $d2
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
; C
; $d3
        .byte %00001010
        .byte %10101111
        .byte %11111111
        .byte %11111010
        .byte %11101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; D
; $d4
        .byte %00000000
        .byte %00000000
        .byte %10000000
        .byte %10000000
        .byte %10100000
        .byte %10100000
        .byte %10101000
        .byte %10101000
; E
; $d5
        .byte %10100110
        .byte %10101011
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
; F
; $d6
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10011000
        .byte %10011000
; G
; $d7
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; H
; $d8
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; I
; $d9
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; J
; $da
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; K
; $db
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; L
; $dc
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; M
; $dd
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; N
; $de
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; O
; $df
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; @
; $e0
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; A
; $e1
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %01010101
        .byte %01010101
        .byte %10101010
; B
; $e2
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
; C
; $e3
        .byte %00101110
        .byte %00101110
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
        .byte %10111010
; D
; $e4
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %01101010
        .byte %10111010
; E
; $e5
        .byte %00101010
        .byte %00101010
        .byte %00001010
        .byte %00001010
        .byte %00000010
        .byte %00000010
        .byte %00000000
        .byte %00000000
; F
; $e6
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101001
        .byte %10100101
        .byte %01010101
        .byte %01011010
        .byte %10100000
; G
; $e7
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; H
; $e8
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; I
; $e9
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; J
; $ea
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; K
; $eb
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; L
; $ec
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; M
; $ed
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; N
; $ee
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; O
; $ef
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; @
; $f0
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; A
; $f1
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %01010101
        .byte %01010101
        .byte %10101010
; B
; $f2
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
; C
; $f3
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101001
        .byte %10100110
; D
; $f4
        .byte %10101000
        .byte %10101000
        .byte %10101010
        .byte %10101010
        .byte %10100110
        .byte %10100110
        .byte %10100110
        .byte %10100110
; E
; $f5
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %10101010
        .byte %01010101
        .byte %10100101
        .byte %00001010
; F
; $f6
        .byte %10011000
        .byte %10011000
        .byte %01100000
        .byte %01100000
        .byte %10000000
        .byte %10000000
        .byte %00000000
        .byte %00000000
; G
; $f7
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; H
; $f8
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; I
; $f9
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; J
; $fa
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; K
; $fb
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; L
; $fc
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; M
; $fd
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; N
; $fe
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
; O
; $ff
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
