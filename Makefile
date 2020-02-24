CC = cl65
CFLAGS = -Or
ASFLAGS =
LDFLAGS =
C1541 = c1541
SYS = c64

OBJS = chars.o enemy_descs.o game.o game_asm.o graphics.o levels.o main.o main_menu.o sprites.o util.o

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
game.o: game.c game.h graphics.h levels.h util.h
game_asm.o: game_asm.s game.inc graphics.inc levels.inc
graphics.o: graphics.c graphics.h
levels.o: levels.c levels.h
main.o: main.c game.h graphics.h main_menu.h
main_menu.o: main_menu.c main_menu.h game.h graphics.h util.h
util.o: util.c util.h
