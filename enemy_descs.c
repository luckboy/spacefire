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
#include "enemy_descs.h"
#include "graphics.h"

static signed char no_steps[1] = { 0 };

static signed char steps[24] = {
  2, 2, 2, 1, 1, 1,
  -1, -1, -1, -2, -2, -2,
  -2, -2, -2, -1, -1, -1,
  1, 1, 1, 2, 2, 2
};

struct enemy_desc enemy_descs[ENEMY_DESC_COUNT] = {
  {
    0,
    no_steps,
    1,
    (((unsigned) (SPRITES + 64 * 18)) - (VIC_BANK << 14)) >> 6,
    10
  },
  {
    0,
    steps,
    24,
    (((unsigned) (SPRITES + 64 * 19)) - (VIC_BANK << 14)) >> 6,
    20
  },
  {
    2,
    no_steps,
    1,
    (((unsigned) (SPRITES + 64 * 20)) - (VIC_BANK << 14)) >> 6,
    30
  },
  {
    2,
    steps,
    24,
    (((unsigned) (SPRITES + 64 * 21)) - (VIC_BANK << 14)) >> 6,
    40
  }
};
