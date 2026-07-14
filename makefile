SHELL=/bin/bash

all:
	$(CC) -flto sqinit.c -o init -static -Wall -Wextra
	envsubst '$$PREFIX' < sqroottouki.in > sqroottouki
install: all
	install -Dm744 init ${DESTDIR}${PREFIX}/mkusi/init
	install -Dm755 sqroottouki ${DESTDIR}/usr/bin/sqroottouki
	install -Dm755 mksqshroot ${DESTDIR}/usr/bin/mksqshroot
	install -Dm755 mkusi.sh ${DESTDIR}/usr/bin/mkusi
