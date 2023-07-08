BINS = steamwm.so

CFLAGS      := -O3 -Wall
LDFLAGS     := -s


all: $(BINS)

clean:
	-rm -f $(BINS) steam.log

steamwm.so: steamwm.cpp
	g++ --shared -fPIC -fvisibility=hidden $(CFLAGS) -m64 -o lib64/$@ $< -lX11 -static-libgcc -static-libstdc++ $(LDFLAGS)
	g++ --shared -fPIC -fvisibility=hidden $(CFLAGS) -m32 -o lib32/$@ $< -lX11 -static-libgcc -static-libstdc++ $(LDFLAGS)

install:
	mkdir -p $(HOME)/lib/lib32
	mkdir -p $(HOME)/lib/lib64
	cp lib32/steamwm.so $(HOME)/lib/lib32
	cp lib64/steamwm.so $(HOME)/lib/lib64
	mkdir -p $(HOME)/bin
	cp steam.sh $(HOME)/bin
