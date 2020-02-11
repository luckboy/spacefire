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
#include <stdio.h>
#include "game.h"
#include "graphics.h"
#include "levels.h"
#include "util.h"

unsigned char start_level_index;
unsigned char current_level_index;
struct level current_level;
struct player player;

void initialize_game(void)
{ start_level_index = 0; }

void finalize_game(void) {}

static void set_level(void)
{
  player.state = GAME_PLAYER_LIVE;
  player.x = SPRITE_X_OFFSET + 8;
  player.y = SPRITE_Y_OFFSET + 11 * 8 - (24 >> 1);
  player.sprite = (((unsigned) (SPRITES + 0)) - 0x4000) >> 6;
}

static void draw_level(void)
{
  static char buf[128];
  char *s;
  unsigned char x, y;
  unsigned i;
  VIC.ctrl1 &= 0xef;
  for(y = 0; y < 11; y++) {
    for(x = 0; x < 20; x++) {
      char c = current_level.chars[y][x];
      if(c != ' ') {
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 0)] = c | 0x00;
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 1)] = c | 0x10;
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 0)] = c | 0x20;
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 1)] = c | 0x30;
      } else {
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 1)] = ' ';
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 1)] = ' ';
      }
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;      
    }
  }
  for(i = 40 * 22; i < 40 * 25; i++) {
    SCREEN1[i] = ' ';
    SCREEN2[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  sprintf(buf, "lives: %01u", (unsigned) player.lives);
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  sprintf(buf, "level: %02u", (unsigned) (current_level_index + 1));
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + 20 - 5 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + 20 - 5 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  sprintf(buf, "score: %08lx", player.score);
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + 40 - 15 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + 40 - 15 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  VIC.ctrl2 = 0xd6;
  VIC.spr_ena = 0x01;
  SPR_POINTERS1[0] = player.sprite;
  SPR_POINTERS2[0] = player.sprite;
  VIC.spr0_x = player.x & 0xff;
  VIC.spr0_y = player.y;
  VIC.spr_hi_x = player.x >> 8;
  VIC.spr_exp_x = 0x00;
  VIC.spr_exp_y = 0x00;
  VIC.spr_mcolor = 0xff;
  VIC.spr0_color = COLOR_WHITE;
  VIC.ctrl1 |= 0x10;
}

static char play_level(void)
{
  SEI();
  while(1) {
    while(VIC.rasterline != RASTER_OFFSET - 4 || (VIC.ctrl1 & 0x80) != 0);
    VIC.ctrl2 = 0xd6;
    if(player.state == GAME_PLAYER_LIVE) {
      unsigned char port_a = CIA1.pra;
      if((port_a & 0x01) == 0) game_move_player_up();
      if((port_a & 0x02) == 0) game_move_player_down();
      if((port_a & 0x04) == 0) game_move_player_left();
      if((port_a & 0x08) == 0) game_move_player_right();
    }
    game_set_player_sprite();
    while(VIC.rasterline != RASTER_OFFSET + 23 * 8 - 4);
    VIC.ctrl2 = 0xd8;
  }
  CLI();
  return 1;
}

static void draw_blank_screen(void)
{
  unsigned i;
  VIC.ctrl1 &= 0xef;
  VIC.spr_ena = 0x00;
  VIC.addr = (VIC.addr & 0x0f) | (((((unsigned) SCREEN) - 0x4000) >> 10) << 4);
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  VIC.ctrl1 &= 0xef;
}

void game_loop(void)
{
  unsigned char i;
  player.lives = 3;
  player.score = 0;
  for(i = start_level_index; i < LEVEL_COUNT; i++) {
    char is_game_over = 0;
    current_level_index = i;
    current_level = levels[i];
    while(1) {
      set_level();
      draw_level();
      if(play_level()) {
        draw_blank_screen();
        break;
      }
      draw_blank_screen();
      if(player.lives > 0) {
        player.lives--;
      } else {
        is_game_over = 1;
        break;
      }
    }
    if(is_game_over) break;
  }
}
