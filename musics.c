/*
 * Space Fire - Game for Commodore 64.
 * Copyright (C) 2020 Łukasz Szpakowski
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <c64.h>
#include "sound.h"
#include "musics.h"

const unsigned char intro_music_notes1[21] = {
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 10,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 10,
  12 * 4 + 8,
  MUSIC_END
};

const unsigned char intro_music_notes2[2] = {
  12 * 4 + 4,
  MUSIC_END
};

const struct music intro_music = {
  0x0800,
  0x41,
  0x11,
  0xf1,
  5,
  5,
  intro_music_notes1,
  0,
  0x11,
  0x11,
  0xf1,
  15,
  5,
  intro_music_notes2
};

const unsigned char game_music_notes1[21] = {
  12 * 4 + 10,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 10,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 8,
  MUSIC_END
};

const unsigned char game_music_notes2[2] = {
  12 * 4 + 4,
  MUSIC_END
};

const struct music game_music = {
  0x0800,
  0x41,
  0x11,
  0xf1,
  5,
  5,
  game_music_notes1,
  0,
  0x11,
  0x11,
  0xf1,
  15,
  5,
  game_music_notes2
};

const unsigned char high_score_music_notes1[16] = {
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 8,
  12 * 4 + 8,
  12 * 4 + 4,
  12 * 4 + 8,
  MUSIC_END
};

const unsigned char high_score_music_notes2[2] = {
  12 * 4 + 4,
  MUSIC_END
};

const struct music high_score_music = {
  0x0800,
  0x41,
  0x11,
  0xf1,
  10,
  5,
  high_score_music_notes1,
  0,
  0x11,
  0x11,
  0xf1,
  20,
  10,
  high_score_music_notes2
};

const unsigned char game_over_music_notes1[26] = {
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 6,
  12 * 4 + 6,
  12 * 4 + 8,
  12 * 4 + 6,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  12 * 4 + 4,
  MUSIC_END
};

const unsigned char game_over_music_notes2[2] = {
  MUSIC_NONE,
  MUSIC_END
};

const struct music game_over_music = {
  0x0800,
  0x41,
  0x11,
  0xf1,
  5,
  5,
  game_over_music_notes1,
  0,
  0x11,
  0x11,
  0xf1,
  5,
  5,
  game_over_music_notes2
};

struct music current_music;
char is_music_start1;
char is_music_gate1;
unsigned char music_gate_pos1;
unsigned char music_note_pos1;
char is_music_start2;
char is_music_gate2;
unsigned char music_gate_pos2;
unsigned char music_note_pos2;

void music_set(const struct music *music)
{ current_music = *music; }

void music_start(void)
{
  SID.v1.ad = current_music.ad1;
  SID.v1.sr = current_music.sr1;
  SID.v1.pw = current_music.pw1;
  SID.v2.ad = current_music.ad2;
  SID.v2.sr = current_music.sr2;
  SID.v2.pw = current_music.pw2;
  is_music_start1 = 1;
  is_music_gate1 = 1;
  music_gate_pos1 = 0;
  music_note_pos1 = 0;
  is_music_start2 = 1;
  is_music_gate2 = 1;
  music_gate_pos2 = 0;
  music_note_pos2 = 0;
}

void music_stop(void)
{
  SID.v1.ad = 0;
  SID.v1.sr = 0;
  SID.v1.ctrl = 0;
  SID.v2.ad = 0;
  SID.v2.sr = 0;
  SID.v2.ctrl = 0;
}
