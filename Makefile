##
##
## A Makefile template for compiling ATS programs
##
##

######
#
# Note that
# certain installations require the following changes:
#
# atscc -> patscc
# (atsopt) -> patsopt
# ATSHOME -> PATSHOME
#
# If you are not using OS X you have to provide bin paths here.
######
#
# ATSHOMEQ="$(ATSHOME)"
#
######
#
# OS X installation. Utilities available in path.
ATSCC=patscc
ATSOPT=patsopt
#
######
#
#
# HX: Please uncomment the one you want, or skip it entirely
#
ATSCCFLAGS=
# ATSCCFLAGS=-O2
#
# '-flto' enables link-time optimization such as inlining lib functions
#
#ATSCCFLAGS=-O2 -flto
#
#
######
#
cleanall::
#
######
#
# Please uncomment the following three lines and replace the name [foo]
# with the name of the file you want to compile
#
main: main.dats ; \
  $(ATSCC) $(ATSCCFLAGS) -o $@ $< || echo $@ ": ERROR!!!"
cleanall:: ; $(RMF) foo
#
######
#
# You may find these rules useful
#
# %_sats.o: %.sats ; $(ATSCC) $(ATSCCFLAGS) -c $< || echo $@ ": ERROR!!!"
# %_dats.o: %.dats ; $(ATSCC) $(ATSCCFLAGS) -c $< || echo $@ ": ERROR!!!"
#
######
#
RMF=rm -f
#
######
#
clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.o
clean:: ; $(RMF) *_?ats.c
#
cleanall:: clean
#
###### end of [Makefile] ######
