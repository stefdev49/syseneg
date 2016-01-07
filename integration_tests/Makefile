all: gl124

# path to the directory where sane-backends is compiled with :
# CFLAGS="-DUNIT_TESTING -ggdb" ./configure \
# --prefix=/usr \
# --sysconfdir=/etc \
# --libdir=/usr/lib64 \
# --enable-parport-directio \
# --enable-pnm-backend \
# --enable-libusb_1_0 \
# --enable-pthread \
# --enable-locking \
# --with-group=scanner \
# --without-snmp
# 
SANEDIR=../../sane-backends
SRCDIR=$(SANEDIR)/backend
LIBDIR=$(SRCDIR)/.libs
SANEI=$(SANEDIR)/sanei/.libs

LIBS=-lusb-1.0 -lpthread -lrt -lreadline -lncurses -lm

.c.o:
	gcc -DUNIT_TESTING -ggdb -I$(SRCDIR) -I$(SANEDIR)/include -c $<

gl124: gl124.o $(LIBDIR)/libgenesys_la-genesys_gl124.o $(LIBDIR)/libsane-genesys.so.1
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
	rm -f *.o gl124
