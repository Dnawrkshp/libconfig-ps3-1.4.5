.SUFFIXES:
ifeq ($(strip $(PSL1GHT)),)
$(error "PSL1GHT must be set in the environment.")
endif

include $(PSL1GHT)/ppu_rules

#---------------------------------------------------------------------------------
ifeq ($(strip $(PLATFORM)),)

export BASEDIR		:= $(CURDIR)

endif
#---------------------------------------------------------------------------------

INCLUDES	:= -I$(BASEDIR)/include -I$(PSL1GHT)/ppu/include
CFLAGS		+= -O2 -Wall -DBIGENDIAN -fno-strict-aliasing $(INCLUDES)

LIBCONFIG	:= src/grammar.o src/libconfig.o src/scanctx.o src/scanner.o src/strbuf.o

%.o: %.c
	@echo "[CC]  $(notdir $<)"
	@$(CC) $(DEPSOPTIONS) -DUSE_MP3 $(CFLAGS) $(INCLUDES) -c $< -o $@


#---------------------------------------------------------------------------------
libconfig.a: $(LIBCONFIG)
#---------------------------------------------------------------------------------

	@echo "[AR]  $(notdir $@)"
	@$(AR) -rcs $@ $^

#---------------------------------------------------------------------------------
install: libconfig.a
#---------------------------------------------------------------------------------

	@echo "[CP]  $(notdir $@)"
	@cp -f libconfig.a $(PORTLIBS)/lib/
	@cp -f include/libconfig.h $(PORTLIBS)/include/
	@rm -f *.d
	@rm -f $(LIBCONFIG)
	@rm -f *.a

#---------------------------------------------------------------------------------
clean:
#---------------------------------------------------------------------------------
	
	rm -f *.d
	rm -f src/*.o
	rm -f *.a
