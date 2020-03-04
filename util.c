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
#include "util.h"

unsigned char petscii_to_char(char c)
{
  if(c >= 0x40 && c <= 0x5f)
    return c - 0x40;
  else
    return c;
}

void x8_to_dec_digits(unsigned char x, char *buf, unsigned char count)
{
  unsigned char i;
  char *s = buf + count;
  *s = 0;
  s--;
  for(i = count; i > 0; i--) {
    *s = (x % 10) + '0';
    x /= 10; 
    s--;
  }
}

void x8_to_dec_digits_with_speces(unsigned char x, char *buf, unsigned char count)
{
  unsigned char i;
  char *s = buf + count;
  *s = 0;
  s--;
  for(i = count; i > 0; i--) {
    if(x != 0 || i == count)
      *s = (x % 10) + '0';
    else
      *s = ' ';
    x /= 10;
    s--;
  }
}

void x32_to_dec_digits_for_dec_mode(unsigned long x, char *buf, unsigned char count)
{
  unsigned char i;
  char *s = buf + count;
  *s = 0;
  s--;
  for(i = count; i > 0; i--) {
    *s = (x & 0xf) + '0';
    x >>= 4; 
    s--;
  }
}
