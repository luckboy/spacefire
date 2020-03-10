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
#ifndef _SOUND_EFFECTS_H
#define _SOUND_EFFECTS_H

#define SOUND_EFFECT_COUNT      3

struct sound_effect
{
  unsigned char ctrl;
  const unsigned char *notes;
  unsigned char note_count;
};

extern const struct sound_effect sound_effects[SOUND_EFFECT_COUNT];

extern struct sound_effect current_sound_effect;
extern char sound_effect_flags[SOUND_EFFECT_COUNT];
extern unsigned char sound_effect_num;
extern unsigned char note_pos;

void sound_effect_start(void);
void sound_effect_stop(void);
void sound_effect_play(void);

#endif
