all: genesys
really_all: regs843 gl843 regs846 gl646 gl846 gl841

XSANEDIR=../sane-backends-1.0.24
SANEDIR=../sane-backends
SRCDIR=$(SANEDIR)/backend
LIBDIR=$(SRCDIR)/.libs
SANEI=$(SANEDIR)/sanei/.libs

LIBS=-lusb -lpthread -lrt -lreadline -lncurses -lm
LIBS=-lusb-1.0 -lpthread -lrt -lreadline -lncurses -lm

.c.o:
	gcc -DUNIT_TESTING -ggdb -I$(SRCDIR) -I$(SANEDIR)/include -c $<

genesys: genesys.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

regs843: regs843.o $(LIBDIR)/libgenesys_la-genesys_gl843.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

regs846: regs846.o $(LIBDIR)/libgenesys_la-genesys_gl846.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl124: gl124.o $(LIBDIR)/libgenesys_la-genesys_gl124.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

regdump124: regdump124.o $(LIBDIR)/libgenesys_la-genesys_gl124.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl646: gl646.o $(LIBDIR)/libgenesys_la-genesys_gl646.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl841: gl841.o $(LIBDIR)/libgenesys_la-genesys_gl841.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl843: gl843.o $(LIBDIR)/libgenesys_la-genesys_gl843.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl846: gl846.o $(LIBDIR)/libgenesys_la-genesys_gl846.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

gl847: gl847.o $(LIBDIR)/libgenesys_la-genesys_gl847.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

stats: stats.o $(LIBDIR)/libsane-genesys.so.1
	gcc -ggdb -o $@ $< $(LIBDIR)/sane_strstatus.o -I$(SANEDIR)/include -L$(LIBDIR) -L$(SANEI) -L$(SANEDIR)/lib/.libs -lgenesys -lsanei -llib $(LIBS)

# SANE binaries
COMMON=$(SRCDIR)/genesys.c $(SRCDIR)/genesys_devices.c

$(LIBDIR)/libgenesys_la-genesys_gl646.o: $(COMMON) $(SRCDIR)/genesys_gl646.h $(SRCDIR)/genesys_gl646.c
	(cd $(SRCDIR) && make)
$(LIBDIR)/libgenesys_la-genesys_gl841.o: $(COMMON) $(SRCDIR)/genesys_gl841.h $(SRCDIR)/genesys_gl841.c
	(cd $(SRCDIR) && make)
$(LIBDIR)/libgenesys_la-genesys_gl843.o: $(COMMON) $(SRCDIR)/genesys_gl843.h $(SRCDIR)/genesys_gl843.c
	(cd $(SRCDIR) && make)
$(LIBDIR)/libgenesys_la-genesys_gl846.o: $(COMMON) $(SRCDIR)/genesys_gl846.h $(SRCDIR)/genesys_gl846.c
	(cd $(SRCDIR) && make)
$(LIBDIR)/libgenesys_la-genesys_gl847.o: $(COMMON) $(SRCDIR)/genesys_gl847.h $(SRCDIR)/genesys_gl847.c
	(cd $(SRCDIR) && make)
$(LIBDIR)/libgenesys_la-genesys_gl124.o: $(COMMON) $(SRCDIR)/genesys_gl124.c $(SRCDIR)/genesys_gl124.h
	(cd $(SRCDIR) && make)

clean:
	rm -f *.o regdump124 gl124 regs843 gl843 regs846 gl846 gl841 gl847 gl646

# DO NOT DELETE
