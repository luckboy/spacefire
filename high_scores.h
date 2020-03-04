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
#ifndef _HIGH_SCORES_H
#define _HIGH_SCORES_H

struct high_score
{
  char is_selected;
  char name[9];
  unsigned long score;
};

extern struct high_score high_scores[10];

void initialize_high_scores(void);
void finalize_high_scores(void);

void high_scores_draw(void);
void high_scores_loop(void);
char high_scores_can_add_high_score(unsigned long score);
char high_scores_add_high_score(struct high_score *high_score);
void high_scores_unselect(void);

#endif
