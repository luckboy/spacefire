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
#include "sound_effects.h"

static const unsigned char notes1[8] = {
  12 * 4 + 8,
  12 * 4 + 7,
  12 * 4 + 6,
  12 * 4 + 5,
  12 * 4 + 4,
  12 * 4 + 3,
  12 * 4 + 2,
  12 * 4 + 1
};

static const unsigned char notes2[4] = {
  12 * 4 + 9,
  12 * 4 + 10,
  12 * 4 + 10,
  12 * 4 + 9
};

static const unsigned char notes3[16] = {
  12 * 4 + 9,
  12 * 4 + 10,
  12 * 4 + 10,
  12 * 4 + 9,
  12 * 4 + 8,
  12 * 4 + 9,
  12 * 4 + 9,
  12 * 4 + 8,
  12 * 4 + 7,
  12 * 4 + 8,
  12 * 4 + 8,
  12 * 4 + 7,
  12 * 4 + 6,
  12 * 4 + 7,
  12 * 4 + 7,
  12 * 4 + 6
};

const struct sound_effect sound_effects[SOUND_EFFECT_COUNT] = {
  {
    0x81,
    notes1,
    8
  },
  {
    0x81,
    notes2,
    4
  },
  {
    0x81,
    notes3,
    16
  }
};

struct sound_effect current_sound_effect;
char sound_effect_flags[SOUND_EFFECT_COUNT];
unsigned char sound_effect_num;
unsigned char sound_effect_note_pos;


void sound_effect_start(void)
{
  unsigned char i;
  SID.v3.ad = 0x11;
  SID.v3.sr = 0xf1;
  sound_effect_num = 0;
  for(i = 0; i < SOUND_EFFECT_COUNT; i++) {
    sound_effect_flags[i] = 0;
  }
}

void sound_effect_stop(void)
{
  SID.v3.ad = 0;
  SID.v3.sr = 0;
  SID.v3.ctrl = 0;
}
