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
        .export _sound_effect_play
        .import _tab_freqs
        .import _sound_effects
        .import _current_sound_effect
        .import _sound_effect_flags
        .import _sound_effect_num
        .import _note_pos
        .importzp ptr1

        .include "c64.inc"
        .include "sound_effects.inc"

        .rodata

Ltab_sound_effect_xs:
        .byte .sizeof(sound_effect) * 0
        .byte .sizeof(sound_effect) * 1
        .byte .sizeof(sound_effect) * 2

        .code
        
.proc _sound_effect_play
        lda _sound_effect_flags + 2
        beq L01sound_effect_flag2
        lda #3
        jmp L01check_sound_effect
L01sound_effect_flag2:
        lda _sound_effect_flags + 1
        beq L01sound_effect_flag1
        lda #2
        jmp L01check_sound_effect
L01sound_effect_flag1:
        lda _sound_effect_flags + 0
        beq L01no_sound_effect
        lda #1
        jmp L01check_sound_effect
L01no_sound_effect:
        lda #0
L01check_sound_effect:
        cmp _sound_effect_num
        bcc L01play                     ; !(A >= sound_effect_num)
        sta _sound_effect_num
        tay
        bne L01start                    ; A != 0
        jmp L01ret
L01start:
        dey
        ldx Ltab_sound_effect_xs, y
        lda _sound_effects + sound_effect::ctrl, x
        sta _current_sound_effect + sound_effect::ctrl
        lda _sound_effects + sound_effect::notes, x
        sta _current_sound_effect + sound_effect::notes
        lda _sound_effects + sound_effect::notes + 1, x
        sta _current_sound_effect + sound_effect::notes + 1
        lda _sound_effects + sound_effect::note_count, x
        sta _current_sound_effect + sound_effect::note_count
        lda #0
        sta _note_pos
        lda _current_sound_effect + sound_effect::notes
        sta ptr1
        lda _current_sound_effect + sound_effect::notes + 1
        sta ptr1 + 1
        ldy _note_pos
        lda (ptr1), y
        asl
        tax
        lda _tab_freqs, x
        sta SID_S3Lo
        lda _tab_freqs, x
        sta SID_S3Hi
        lda _current_sound_effect + sound_effect::ctrl
        sta SID_Ctl3
        jmp L01ret
L01play:lda _sound_effect_num
        beq L01ret
        inc _note_pos
        lda _note_pos
        cmp _current_sound_effect + sound_effect::note_count
        bcs L01stop                     ; !(note_pos < current_sound_effect.note_count)
        lda _current_sound_effect + sound_effect::notes
        sta ptr1
        lda _current_sound_effect + sound_effect::notes + 1
        sta ptr1 + 1
        ldy _note_pos
        lda (ptr1), y
        asl
        tax
        lda _tab_freqs, x
        sta SID_S3Lo
        lda _tab_freqs, x
        sta SID_S3Hi
        jmp L01ret
L01stop:lda #0
        sta _sound_effect_num
        lda _current_sound_effect + sound_effect::ctrl
        and #$fe
        sta SID_Ctl3
L01ret: lda #0
        sta _sound_effect_flags + 0
        sta _sound_effect_flags + 1
        sta _sound_effect_flags + 2
        rts
.endproc
