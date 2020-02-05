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
#include <string.h>
#include "graphics.h"
#include "main_menu.h"
#include "util.h"

void main_menu_draw(void)
{
  static char *logo[8] = {
    "  CAAAADCADCADCAA   ",
    "  EADBAFBABB  BAA   ",
    "  AAFB  B BEAFEAA   ",
    "                    ",
    "     CAABAADCAA     ",
    "     BAABBAFBAA     ",
    "     B  BBEAEAA     ",
    "                    "
  };
  static char *menu_items[3] = {
    "start",
    "high scores",
    "quit"
  };
  unsigned char x, y;
  unsigned i;
  VIC.ctrl1 &= 0xef;
  for(y = 0; y < 8; y++) {
    for(x = 0; x < 20; x++) {
      char c = logo[y][x];
      if(c != ' ') {
        SCREEN[((y << 1) + 0) * 40 + ((x << 1) + 0)] = c | 0x00;
        SCREEN[((y << 1) + 0) * 40 + ((x << 1) + 1)] = c | 0x10;
        SCREEN[((y << 1) + 1) * 40 + ((x << 1) + 0)] = c | 0x20;
        SCREEN[((y << 1) + 1) * 40 + ((x << 1) + 1)] = c | 0x30;
      } else {
        SCREEN[((y << 1) + 0) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN[((y << 1) + 0) * 40 + ((x << 1) + 1)] = ' ';
        SCREEN[((y << 1) + 1) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN[((y << 1) + 1) * 40 + ((x << 1) + 1)] = ' ';
      }
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;
    }
  }
  for(i = 8 * 80; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  for(i = 0; i < 3; i++) {
    const char *s = menu_items[i];
    unsigned char j;
    unsigned char screen_x = 20 - ((strlen(s) + 1) >> 1);
    j = 0;
    while(*s != 0) {
      SCREEN[8 * 80 + (i << 1) * 40 + screen_x + j] = petscii_to_char(*s);
      s++;
      j++;
    }
  }
  VIC.ctrl1 |= 0x10;
}

void main_menu_loop(void)
{
  while(1);
}
