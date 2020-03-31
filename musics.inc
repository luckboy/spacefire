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

MUSIC_END       = $ff
MUSIC_NONE      = $fe

.struct music
    pw1     .word
    ctrl1   .byte
    ad1     .byte
    sr1     .byte
    gate_interval1 .byte
    non_gate_interval1 .byte
    notes1  .word
    pw2     .word
    ctrl2   .byte
    ad2     .byte
    sr2     .byte
    gate_interval2 .byte
    non_gate_interval2 .byte
    notes2  .word
.endstruct
