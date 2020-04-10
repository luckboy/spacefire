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
        .export _music_play
        .import _tab_freqs
        .import _current_music
        .import _is_music_start1
        .import _is_music_gate1
        .import _music_gate_pos1
        .import _music_note_pos1
        .import _is_music_start2
        .import _is_music_gate2
        .import _music_gate_pos2
        .import _music_note_pos2
        .importzp ptr1

        .include "c64.inc"
        .include "musics.inc"

        .code

.proc _music_play
        ; 1
        lda _is_music_start1
        bne L01start1
        lda _is_music_gate1
        beq L01no_gate1
        inc _music_gate_pos1
        lda _music_gate_pos1
        cmp _current_music + music::gate_interval1
        bcs L01gate1                     ; !(music_gate_pos1 < current_music.gate_interval1)
        jmp L01ret1
L01gate1:
        lda _current_music + music::notes1
        sta ptr1
        lda _current_music + music::notes1 + 1
        sta ptr1 + 1
        ldy _music_note_pos1
        lda (ptr1), y
        cmp #MUSIC_NONE
        beq L01no_release1
        lda _current_music + music::ctrl1
        and #$fe
        sta SID_Ctl1
L01no_release1:
        lda #0
        sta _is_music_gate1
        sta _music_gate_pos1
        jmp L01ret1
L01no_gate1:
        inc _music_gate_pos1
        lda _music_gate_pos1
        cmp _current_music + music::non_gate_interval1
        bcc L01ret1                     ; !(music_gate_pos1 >= current_music.non_gate_interval1)
        inc _music_note_pos1
        lda _current_music + music::notes1
        sta ptr1
        lda _current_music + music::notes1 + 1
        sta ptr1 + 1
        ldy _music_note_pos1
        lda (ptr1), y
        cmp #MUSIC_END
        bne L01play1
        lda #0
        sta _music_note_pos1
        ldy _music_note_pos1
L01play1:
L01start1:
        lda _current_music + music::notes1
        sta ptr1
        lda _current_music + music::notes1 + 1
        sta ptr1 + 1
        ldy _music_note_pos1
        lda (ptr1), y
        cmp #MUSIC_NONE
        beq L01no_play1
        asl
        tax
        lda _tab_freqs, x
        sta SID_S1Lo
        lda _tab_freqs + 1, x
        sta SID_S1Hi
        lda _current_music + music::ctrl1
        sta SID_Ctl1
L01no_play1:
        lda #1
        sta _is_music_gate1
        lda #0
        sta _music_gate_pos1
        sta _is_music_start1
        ; 2
L01ret1:lda _is_music_start2
        bne L01start2
        lda _is_music_gate2
        beq L01no_gate2
        inc _music_gate_pos2
        lda _music_gate_pos2
        cmp _current_music + music::gate_interval2
        bcs L01gate2                     ; !(music_gate_pos2 < current_music.gate_interval2)
        jmp L01ret2
L01gate2:
        lda _current_music + music::notes2
        sta ptr1
        lda _current_music + music::notes2 + 1
        sta ptr1 + 1
        ldy _music_note_pos2
        lda (ptr1), y
        cmp #MUSIC_NONE
        beq L01no_release2
        lda _current_music + music::ctrl2
        and #$fe
        sta SID_Ctl2
L01no_release2:
        lda #0
        sta _is_music_gate2
        sta _music_gate_pos2
        jmp L01ret2
L01no_gate2:
        inc _music_gate_pos2
        lda _music_gate_pos2
        cmp _current_music + music::non_gate_interval2
        bcc L01ret2                     ; !(music_gate_pos2 >= current_music.non_gate_interval2)
        inc _music_note_pos2
        lda _current_music + music::notes2
        sta ptr1
        lda _current_music + music::notes2 + 1
        sta ptr1 + 1
        ldy _music_note_pos2
        lda (ptr1), y
        cmp #MUSIC_END
        bne L01play2
        lda #0
        sta _music_note_pos2
        ldy _music_note_pos2
L01play2:
L01start2:
        lda _current_music + music::notes2
        sta ptr1
        lda _current_music + music::notes2 + 1
        sta ptr1 + 1
        ldy _music_note_pos2
        lda (ptr1), y
        cmp #MUSIC_NONE
        beq L01no_play2
        asl
        tax
        lda _tab_freqs, x
        sta SID_S2Lo
        lda _tab_freqs + 1, x
        sta SID_S2Hi
        lda _current_music + music::ctrl2
        sta SID_Ctl2
L01no_play2:
        lda #1
        sta _is_music_gate2
        lda #0
        sta _music_gate_pos2
        sta _is_music_start2
L01ret2:rts
.endproc
