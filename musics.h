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
#ifndef _MUSICS_H
#define _MUSICS_H

#define MUSIC_END               0xff
#define MUSIC_NONE              0xfe

struct music
{
  unsigned pw1;
  unsigned char ctrl1;
  unsigned char ad1;
  unsigned char sr1;
  unsigned char gate_interval1;
  unsigned char non_gate_interval1;
  const unsigned char *notes1;
  unsigned pw2;
  unsigned char ctrl2;
  unsigned char ad2;
  unsigned char sr2;
  unsigned char gate_interval2;
  unsigned char non_gate_interval2;
  const unsigned char *notes2;
};

extern const struct music intro_music;

extern struct current_music;
extern char is_music_start1;
extern char is_music_gate1;
extern unsigned char music_gate_pos1;
extern unsigned char music_note_pos1;
extern char is_music_start2;
extern char is_music_gate2;
extern unsigned char music_gate_pos2;
extern unsigned char music_note_pos2;

void music_set(const struct music *music);
void music_start(void);
void music_stop(void);
void music_play(void);

#endif
