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
#include <6502.h>
#include <c64.h>
#include <string.h>
#include "game.h"
#include "graphics.h"
#include "high_scores.h"
#include "main_menu.h"
#include "musics.h"
#include "util.h"

#define UP_DOWN_INTERVAL        8

static unsigned char cursor;

void initialize_main_menu(void) { cursor = 0; }

void finalize_main_menu(void) {}

static void draw_cursor(void)
{
  unsigned i = (cursor << 1) * 40;
  SCREEN[8 * 80 + i + 20 - 8] = '>';
  SCREEN[8 * 80 + i + 20 + 7] = '<';
}

static void draw_spaces(void)
{
  unsigned i = (cursor << 1) * 40;
  SCREEN[8 * 80 + i + 20 - 8] = ' ';
  SCREEN[8 * 80 + i + 20 + 7] = ' ';
}

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
  draw_cursor();
  VIC.ctrl1 |= 0x10;
}

void main_menu_loop(void)
{
  char is_exit = 0;
  char is_fire = 0;
  unsigned char up_count = 0;
  unsigned char down_count = 0;
  music_set(&intro_music);
  music_start();
  SEI();
  while(!is_exit) {
    unsigned char port_a;
    char is_pressed = 0;
    while(VIC.rasterline != RASTER_OFFSET - 8 || (VIC.ctrl1 & 0x80) != 0);
    port_a = CIA1.pra;
    if((port_a & 0x01) == 0) {
      down_count = 0;
      if(up_count == 0) {
        if(cursor > 0) {
          draw_spaces();
          cursor--;
          draw_cursor();
        }
      }
      up_count++;
      if(up_count >= UP_DOWN_INTERVAL) up_count = 0;
    } else
      up_count = 0;
    if((port_a & 0x02) == 0) {
      up_count = 0;
      if(down_count == 0) {
        if(cursor < 2) {
          draw_spaces();
          cursor++;
          draw_cursor();
        }
      }
      down_count++;
      if(down_count >= UP_DOWN_INTERVAL) down_count = 0;
    } else
      down_count = 0;
    if((port_a & 0x10) == 0) {
      is_fire = 1;
    } else {
      is_pressed = is_fire;
      is_fire = 0;
    }
    if(is_pressed) {
      switch(cursor) {
      case 0:
        CLI();
        music_stop();
        game_loop();
        main_menu_draw();
        music_set(&intro_music);
        music_start();
        SEI();
        break;
      case 1:
        CLI();
        music_stop();
        high_scores_draw();
        high_scores_loop();
        main_menu_draw();
        music_set(&intro_music);
        music_start();
        SEI();
        break;
      case 2:
        is_exit = 1;
        break;
      }
    }
    while(VIC.rasterline != RASTER_OFFSET + 25 * 8);
    music_play();
  }
  CLI();
  music_stop();
}
