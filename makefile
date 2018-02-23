calc: flexprog bisonprog
	gcc -o calc calc.tab.c lex.yy.c -lfl -w

flexprog:
	flex calc.l

bisonprog:
	bison -dv calc.y


