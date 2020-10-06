#!/bin/bash

DIR=/tmp

if [ -z $DBI_DSN ]; then
	echo Warning: DBI_DSN not set for scripts/dbi.schema.pl.
fi

perl -Ilib scripts/Heawood.pl           png ../graphviz-perl.github.io/Heawood.png > $DIR/Heawood.log
perl -Ilib scripts/anonymous.pl         png ../graphviz-perl.github.io/anonymous.png > $DIR/anonymous.log
perl -Ilib scripts/circo.pl             png ../graphviz-perl.github.io/circo.png > $DIR/circo.log
perl -Ilib scripts/cluster.pl           png ../graphviz-perl.github.io/cluster.png > $DIR/cluster.log
perl -Ilib scripts/html.labels.1.pl     png ../graphviz-perl.github.io/html.labels.1.png > $DIR/html.labels.1.log
perl -Ilib scripts/html.labels.2.pl     png ../graphviz-perl.github.io/html.labels.2.png > $DIR/html.labels.2.log
perl -Ilib scripts/html.labels.3.pl     png ../graphviz-perl.github.io/html.labels.3.png > $DIR/html.labels.3.log
perl -Ilib scripts/jointed.edges.pl     png ../graphviz-perl.github.io/jointed.edges.png > $DIR/jointed.edges.log
perl -Ilib scripts/macro.1.pl           png ../graphviz-perl.github.io/macro.1.png > $DIR/macro.1.log
perl -Ilib scripts/macro.2.pl           png ../graphviz-perl.github.io/macro.2.png > $DIR/macro.2.log
perl -Ilib scripts/macro.3.pl           png ../graphviz-perl.github.io/macro.3.png > $DIR/macro.3.log
perl -Ilib scripts/macro.4.pl           png ../graphviz-perl.github.io/macro.4.png > $DIR/macro.4.log
perl -Ilib scripts/macro.5.pl           png ../graphviz-perl.github.io/macro.5.png > $DIR/macro.5.log
perl -Ilib scripts/parse.regexp.pl      png ../graphviz-perl.github.io/parse.regexp.png > $DIR/parse.regexp.log
perl -Ilib scripts/parse.stt.pl         png ../graphviz-perl.github.io/parse.stt.png > $DIR/parse.stt.log
perl -Ilib scripts/parse.yacc.pl        png ../graphviz-perl.github.io/parse.yacc.png > $DIR/parse.yacc.log
perl -Ilib scripts/parse.yapp.pl        png ../graphviz-perl.github.io/parse.yapp.png > $DIR/parse.yapp.log
perl -Ilib scripts/plaintext.pl         png ../graphviz-perl.github.io/plaintext.png > $DIR/plaintext.log
perl -Ilib scripts/quote.pl             png ../graphviz-perl.github.io/quote.png > $DIR/quote.log
perl -Ilib scripts/rank.sub.graph.1.pl  png ../graphviz-perl.github.io/rank.sub.graph.1.png > $DIR/rank.sub.graph.1.log
perl -Ilib scripts/rank.sub.graph.2.pl  png ../graphviz-perl.github.io/rank.sub.graph.2.png > $DIR/rank.sub.graph.2.log
perl -Ilib scripts/rank.sub.graph.3.pl  png ../graphviz-perl.github.io/rank.sub.graph.3.png > $DIR/rank.sub.graph.3.log
perl -Ilib scripts/rank.sub.graph.4.pl  png ../graphviz-perl.github.io/rank.sub.graph.4.png > $DIR/rank.sub.graph.4.log
perl -Ilib scripts/record.1.pl          png ../graphviz-perl.github.io/record.1.png > $DIR/record.1.log
perl -Ilib scripts/record.2.pl          png ../graphviz-perl.github.io/record.2.png > $DIR/record.2.log
perl -Ilib scripts/record.3.pl          png ../graphviz-perl.github.io/record.3.png > $DIR/record.3.log
perl -Ilib scripts/record.4.pl          png ../graphviz-perl.github.io/record.4.png > $DIR/record.4.log
perl -Ilib scripts/sub.graph.pl         png ../graphviz-perl.github.io/sub.graph.png > $DIR/sub.graph.log
perl -Ilib scripts/sub.graph.frames.pl  png ../graphviz-perl.github.io/sub.graph.frames.png > $DIR/sub.graph.frames.log
perl -Ilib scripts/sub.sub.graph.pl     png ../graphviz-perl.github.io/sub.sub.graph.png > $DIR/sub.sub.graph.log
perl -Ilib scripts/trivial.pl           png ../graphviz-perl.github.io/trivial.png > $DIR/trivial.log
perl -Ilib scripts/unnamed.sub.graph.pl png ../graphviz-perl.github.io/unnamed.sub.graph.png > $DIR/unnamed.sub.graph.log
perl -Ilib scripts/utf8.1.pl            png ../graphviz-perl.github.io/utf8.1.png > $DIR/utf8.1.log
perl -Ilib scripts/utf8.2.pl            png ../graphviz-perl.github.io/utf8.2.png > $DIR/utf8.2.log

perl -Ilib scripts/generate.demo.pl png ../graphviz-perl.github.io
