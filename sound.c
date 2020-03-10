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

void initialize_sound(void)
{
  SID.v1.freq = 0;
  SID.v1.pw = 0;
  SID.v1.ctrl = 0;
  SID.v1.ad = 0;
  SID.v1.sr = 0;
  SID.v2.freq = 0;
  SID.v2.pw = 0;
  SID.v2.ctrl = 0;
  SID.v2.ad = 0;
  SID.v2.sr = 0;
  SID.v3.freq = 0;
  SID.v3.pw = 0;
  SID.v3.ctrl = 0;
  SID.v3.ad = 0;
  SID.v3.sr = 0;
  SID.flt_freq = 0;
  SID.flt_ctrl = 0;
  SID.amp = 0x0f;
}

void finalize_sound(void)
{
  SID.v1.freq = 0;
  SID.v1.pw = 0;
  SID.v1.ctrl = 0;
  SID.v1.ad = 0;
  SID.v1.sr = 0;
  SID.v2.freq = 0;
  SID.v2.pw = 0;
  SID.v2.ctrl = 0;
  SID.v2.ad = 0;
  SID.v2.sr = 0;
  SID.v3.freq = 0;
  SID.v3.pw = 0;
  SID.v3.ctrl = 0;
  SID.v3.ad = 0;
  SID.v3.sr = 0;
  SID.flt_freq = 0;
  SID.flt_ctrl = 0;
  SID.amp = 0;
}
