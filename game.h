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

#define GAME_STATE_DISABLED     0
#define GAME_STATE_LIVE         1
#define GAME_STATE_DESTROYING   2

#define GAME_SHOT_COUNT_MAX     3
#define GAME_ENEMY_COUNT_MAX    12

struct player
{
  unsigned char state;
  unsigned x;
  unsigned char y;
  unsigned char x_steps[2];
  unsigned char sprite;
  unsigned char lives;
  unsigned long score;
  unsigned char start_explosion_sprite;
  unsigned char end_explosion_sprite;
};

struct shot
{
  char is_enabled;
  unsigned x;
  unsigned char y;
  unsigned char x_steps[2];
  unsigned char sprite;
};

struct enemy
{
  unsigned char state;
  unsigned x;
  unsigned char y;
  unsigned char x_steps[2];
  const signed char *y_steps;
  unsigned char y_step_count;
  unsigned char y_step_index;
  unsigned char sprite;
  unsigned char points;
};

struct enemy_explosion
{
  unsigned char start_explosion_sprite;
  unsigned char end_explosion_sprite;
};

extern unsigned char level_pos;
extern unsigned char block_pos;
extern unsigned char scroll_pos;
extern char is_scroll;
extern char is_scroll2;

extern unsigned char sprite_bg_coll;
extern unsigned char sprite_coll1;
extern unsigned char sprite_coll2;
extern unsigned char sprite_coll3;

extern unsigned char start_level_index;
extern unsigned char current_level_index;
extern struct level current_level;
extern struct player player;
extern struct shot shots[GAME_SHOT_COUNT_MAX];
extern unsigned char shot_alloc_index;
extern struct enemy enemies[GAME_ENEMY_COUNT_MAX];
extern unsigned char enemy_alloc_indices[3];
extern struct enemy_explosion enemy_explosion;

void initialize_game(void);
void finalize_game(void);

void game_loop(void);

void game_move_player_up(void);
void game_move_player_down(void);
void game_move_player_left(void);
void game_move_player_right(void);
void game_set_player_sprite(void);
void game_scroll_screen(void);
char game_move_player(void);
void game_player_shoot(void);
void game_move_shots(void);
void game_set_shot_sprites(void);
char game_change_player_state(void);
void game_change_shot_states(void);
void game_move_enemies_0_3(void);
void game_move_enemies_4_7(void);
void game_move_enemies_8_11(void);
void game_change_enemy_states_0_3(void);
void game_change_enemy_states_4_7(void);
void game_change_enemy_states_8_11(void);
void game_add_enemy_points_0_3(void);
void game_add_enemy_points_4_7(void);
void game_add_enemy_points_8_11(void);
void game_set_enemy_sprites_0_3(void);
void game_set_enemy_sprites_4_7(void);
void game_set_enemy_sprites_8_11(void);
void game_alloc_enemy1(void);
void game_alloc_enemy2(void);
void game_alloc_enemy3(void);
void game_display_score(void);

#endif
