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
#ifndef _GAME_H
#define _GAME_H

#include "levels.h"

#define GAME_PLAYER_LIVE        0
#define GAME_PLAYER_DESTROYING  1
#define GAME_PLAYER_DESTROYED   2

struct player
{
  unsigned char state;
  unsigned x;
  unsigned char y;
  unsigned char sprite;
  unsigned char lives;
  unsigned long score;
};

extern unsigned char start_level_index;
extern unsigned char current_level_index;
extern struct level current_level;
extern struct player player;

void initialize_game(void);
void finalize_game(void);

void game_loop(void);

void game_move_player_up(void);
void game_move_player_down(void);
void game_move_player_left(void);
void game_move_player_right(void);
void game_set_player_sprite(void);

#endif
