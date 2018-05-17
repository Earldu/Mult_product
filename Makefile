CPP = /usr/bin/cpp/ -B -C -P -traditional


case:
	vcs -l vcs.log -o vsim\
	    -notice\
	    -full64\
	    -timescale=1ns/100ps\
	    -f source.flist\
	    -debug_all \
	    +v2k\
	    -fsdb \
	    +acc \
	    +libext+.v\
	    +define+DUMP_FSDB\
	    +incdir+./include\
	    +incdir+./tb\
	    +incdir+./rtl\
	    -P ${NOVAS_HOME}/share/PLI/VCS/${PLATFORM}/novas.tab\
	       ${NOVAS_HOME}/share/PLI/VCS/${PLATFORM}/pli.a  



clean:
	rm -rf vsim.daidir/ csrc/ verdiLog/ vcs.log ucli.key tb.fsdb novas_dump.log novas.conf novas.rc TestBench.fsdb vsim


