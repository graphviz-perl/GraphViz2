#!/bin/bash

DIR=/tmp

perl -Ilib scripts/anonymous.pl        > $DIR/anonymous.log
perl -Ilib scripts/cluster.pl          > $DIR/cluster.log
perl -Ilib scripts/dbi.schema.pl       > $DIR/dbi.schema.log
perl -Ilib scripts/dependency.pl       > $DIR/dependency.log
perl -Ilib scripts/Heawood.pl          > $DIR/Heawood.log
perl -Ilib scripts/html.labels.pl      > $DIR/html.labels.log
perl -Ilib scripts/jointed.edges.pl    > $DIR/jointed.edges.log
perl -Ilib scripts/macro.1.pl          > $DIR/macro.1.log
perl -Ilib scripts/macro.2.pl          > $DIR/macro.2.log
perl -Ilib scripts/macro.3.pl          > $DIR/macro.3.log
perl -Ilib scripts/macro.4.pl          > $DIR/macro.4.log
perl -Ilib scripts/macro.5.pl          > $DIR/macro.5.log
perl -Ilib scripts/parse.data.pl       > $DIR/parse.data.log
perl -Ilib scripts/parse.html.pl       > $DIR/parse.hml.log
perl -Ilib scripts/parse.isa.pl        > $DIR/parse.isa.log
perl -Ilib scripts/parse.marpa.pl      > $DIR/parse.marpa.log
perl -Ilib scripts/parse.recdescent.pl > $DIR/parse.recdescent.log
perl -Ilib scripts/parse.regexp.pl     > $DIR/parse.regexp.log
perl -Ilib scripts/parse.stt.pl        > $DIR/parse.stt.log
perl -Ilib scripts/parse.xml.bare.pl   > $DIR/parse.xml.bare.log
perl -Ilib scripts/parse.xml.pp.pl     > $DIR/parse.xml.pp.log
perl -Ilib scripts/parse.yacc.pl       > $DIR/parse.yacc.log
perl -Ilib scripts/parse.yapp.pl       > $DIR/parse.yapp.log
perl -Ilib scripts/quote.pl            > $DIR/quote.log
perl -Ilib scripts/sub.graph.pl        > $DIR/sub.graph.log
perl -Ilib scripts/sub.sub.graph.pl    > $DIR/sub.sub.graph.log
perl -Ilib scripts/trivial.pl          > $DIR/trivial.log

perl -Ilib scripts/generate.demo.pl
