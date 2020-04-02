CC = cl65
CFLAGS = -Or
ASFLAGS =
LDFLAGS =
C1541 = c1541
SYS = c64

OBJS = chars.o enemy_descs.o game.o game_asm.o graphics.o high_scores.o levels.o main.o main_menu.o \
	musics.o musics_asm.o sound.o sound_effects.o sound_effects_asm.o sprites.o tab_freqs.o util.o

.c.o:
	$(CC) -c -t $(SYS) $(CFLAGS) -o $@ $<

.s.o:
	$(CC) -c -t $(SYS) $(ASFLAGS) -o $@ $<

all: spacefire

spacefire: $(OBJS)
	$(CC) -t $(SYS) -o $@ $^

spacefire.d64: all
	$(C1541) -format spacefire,AA  d64 $@
	$(C1541) -attach $@ -write spacefire spacefire

clean:
	rm -f spacefire $(OBJS) *.d64 *~

enemy_descs.o: enemy_descs.c enemy_descs.h graphics.h
game.o: game.c game.h enemy_descs.h graphics.h high_scores.h levels.h musics.h util.h
game_asm.o: game_asm.s game.inc enemy_descs.inc graphics.inc levels.inc
graphics.o: graphics.c graphics.h
high_scores.o: high_scores.c high_scores.h graphics.h musics.h util.h
levels.o: levels.c levels.h
main.o: main.c game.h graphics.h high_scores.h main_menu.h
main_menu.o: main_menu.c main_menu.h game.h graphics.h high_scores.h musics.h util.h
musics.o: musics.c musics.h sound.h
musics_asm.o: musics_asm.s musics.inc
sound.o: sound.c sound.h
sound_effects.o: sound_effects.c sound_effects.h sound.h
sound_effects_asm.o: sound_effects_asm.s sound_effects.inc
util.o: util.c util.h
