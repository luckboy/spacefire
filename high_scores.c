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
#include "graphics.h"
#include "high_scores.h"
#include "util.h"

struct high_score high_scores[10];

void initialize_high_scores(void)
{
  unsigned i;
  for(i = 0; i < 10; i++) {
    high_scores[i].is_selected = 0;
    strcpy(high_scores[i].name, "luckboy");
    high_scores[i].score = 0x100;
  }
}

void finalize_high_scores(void) {}

void high_scores_draw(void)
{
  char *s;
  unsigned i;
  unsigned char x, y;
  unsigned char j;
  VIC.ctrl1 &= 0xef;
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  s = "high scores";
  x = 20 - ((strlen(s) + 1) >> 1);
  j = 0;
  while(*s != 0) {
    SCREEN[(12 - (12 >> 1)) * 40 + x + j] = petscii_to_char(*s);
    s++;
    j++;
  }
  for(i = 0; i < 10; i++) {
    static char buf[32];
    struct high_score *high_score = &high_scores[i];
    x = 20 - ((2 + 1 + 8 + 1 + 6 + 2 + 2) >> 1);
    y = 12 - (12 >> 1) + 2 + i;
    SCREEN[y * 40 + x] = (high_score->is_selected ? '>' : ' ');
    x += 2;
    x8_to_dec_digits_with_speces(i + 1, buf, 2);
    s = buf;
    j = 0;
    while(*s != 0) {
      SCREEN[y * 40 + x + j] = petscii_to_char(*s);
      s++;
      j++;
    }
    x += 3;
    s = high_score->name;
    j = 0;
    while(*s != 0) {
      SCREEN[y * 40 + x + j] = petscii_to_char(*s);
      s++;
      j++;
    }
    x += 9;
    x32_to_dec_digits_for_dec_mode(high_score->score, buf, 6);
    s = buf;
    j = 0;
    while(*s != 0) {
      SCREEN[y * 40 + x + j] = petscii_to_char(*s);
      s++;
      j++;
    }
    x += 7;
    SCREEN[y * 40 + x] = (high_score->is_selected ? '<' : ' ');
  }
  VIC.ctrl1 |= 0x10;
}

void high_scores_loop(void)
{
  char is_fire = 0;
  SEI();
  while(1) {
    char is_pressed = 0;
    unsigned char port_a;
    while(VIC.rasterline != RASTER_OFFSET - 8 || (VIC.ctrl1 & 0x80) != 0);   
    port_a = CIA1.pra;
    if((port_a & 0x10) == 0) {
      is_fire = 1;
    } else {
      is_pressed = is_fire;
      is_fire = 0;
    }
    if(is_pressed) break;
  }
  CLI();
}

char high_scores_can_add_high_score(unsigned long score)
{ return score > high_scores[9].score; }

char high_scores_add_high_score(struct high_score *high_score)
{
  if(high_score->score > high_scores[9].score) {
    int i;
    high_scores[9] = *high_score;
    for(i = 8; i >= 0; i--) {
      if(high_scores[i + 1].score > high_scores[i].score) {
        static struct high_score tmp;
        tmp = high_scores[i];
        high_scores[i] = high_scores[i + 1];
        high_scores[i + 1] = tmp;
      } else
        break;
    }
    return 1;
  }
  return 0;
}

void high_scores_unselect(void)
{
  unsigned char i;
  for(i = 0; i < 10; i++) {
    high_scores[i].is_selected = 0;
  }
}
