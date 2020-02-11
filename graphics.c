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
#include <conio.h>
#include <string.h>
#include "graphics.h"

static unsigned char saved_vic_bank;
static unsigned char saved_vic_ctrl1;
static unsigned char saved_vic_ctrl2;
static unsigned char saved_vic_addr;
static unsigned char saved_border_color;
static unsigned char saved_bg_color;
static unsigned char saved_fg_color;

void initialize_graphics(void)
{
  unsigned i;
  saved_vic_bank = CIA2.pra & 0x03;
  saved_vic_ctrl1 = VIC.ctrl1;
  saved_vic_ctrl2 = VIC.ctrl2;
  saved_vic_addr = VIC.addr;
  saved_border_color = VIC.bordercolor;
  saved_bg_color = VIC.bgcolor0;
  saved_fg_color = *((unsigned char *) 0x286);
  memcpy(CHARS + 0x00 * 8, petscii_chars, 8 * 64);
  memcpy(CHARS + 0xc0 * 8, level_chars, 8 * 64);
  memcpy(SPRITES, sprites, 64 * SPRITE_COUNT);
  CIA2.pra = (CIA2.pra & ~0x03) | 0x02;
  VIC.ctrl1 = 0x0b;
  VIC.ctrl2 = 0xd8;
  VIC.addr = (((((unsigned) SCREEN) - 0x4000) >> 10) << 4) | (((((unsigned) (CHARS)) - 0x4000) >> 11) << 1); 
  VIC.spr_ena = 0x00;
  VIC.bordercolor = COLOR_BLACK;
  VIC.bgcolor0 = COLOR_BLACK;
  VIC.bgcolor1 = COLOR_GRAY1;
  VIC.bgcolor2 = COLOR_GRAY3;
  VIC.spr_mcolor0 = COLOR_GRAY2;
  VIC.spr_mcolor1 = COLOR_GRAY3;
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  VIC.ctrl1 = 0x1b;
}

void finalize_graphics(void)
{
  unsigned i;
  for(i = 0; i < 40 * 25; i++) {
    COLOR_RAM[i] = saved_fg_color;
  }
  VIC.bgcolor0 = saved_bg_color;
  VIC.bordercolor = saved_border_color;
  VIC.addr = saved_vic_addr;
  VIC.ctrl2 = saved_vic_ctrl2;
  VIC.ctrl1 = saved_vic_ctrl1;
  CIA2.pra = (CIA2.pra & ~0x03) | saved_vic_bank;
  clrscr();
}
