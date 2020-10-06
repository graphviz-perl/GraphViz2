#!/bin/bash

DIR=/tmp

if [ -z $DBI_DSN ]; then
	echo Warning: DBI_DSN not set for scripts/dbi.schema.pl.
fi

perl -Ilib scripts/Heawood.pl           svg ../graphviz-perl.github.io/Heawood.svg > $DIR/Heawood.log
perl -Ilib scripts/anonymous.pl         svg ../graphviz-perl.github.io/anonymous.svg > $DIR/anonymous.log
perl -Ilib scripts/circo.pl             svg ../graphviz-perl.github.io/circo.svg > $DIR/circo.log
perl -Ilib scripts/cluster.pl           svg ../graphviz-perl.github.io/cluster.svg > $DIR/cluster.log
perl -Ilib scripts/html.labels.1.pl     svg ../graphviz-perl.github.io/html.labels.1.svg > $DIR/html.labels.1.log
perl -Ilib scripts/html.labels.2.pl     svg ../graphviz-perl.github.io/html.labels.2.svg > $DIR/html.labels.2.log
perl -Ilib scripts/html.labels.3.pl     svg ../graphviz-perl.github.io/html.labels.3.svg > $DIR/html.labels.3.log
perl -Ilib scripts/jointed.edges.pl     svg ../graphviz-perl.github.io/jointed.edges.svg > $DIR/jointed.edges.log
perl -Ilib scripts/macro.1.pl           svg ../graphviz-perl.github.io/macro.1.svg > $DIR/macro.1.log
perl -Ilib scripts/macro.2.pl           svg ../graphviz-perl.github.io/macro.2.svg > $DIR/macro.2.log
perl -Ilib scripts/macro.3.pl           svg ../graphviz-perl.github.io/macro.3.svg > $DIR/macro.3.log
perl -Ilib scripts/macro.4.pl           svg ../graphviz-perl.github.io/macro.4.svg > $DIR/macro.4.log
perl -Ilib scripts/macro.5.pl           svg ../graphviz-perl.github.io/macro.5.svg > $DIR/macro.5.log
perl -Ilib scripts/parse.regexp.pl      svg ../graphviz-perl.github.io/parse.regexp.svg > $DIR/parse.regexp.log
perl -Ilib scripts/parse.stt.pl         svg ../graphviz-perl.github.io/parse.stt.svg > $DIR/parse.stt.log
perl -Ilib scripts/parse.yacc.pl        svg ../graphviz-perl.github.io/parse.yacc.svg > $DIR/parse.yacc.log
perl -Ilib scripts/parse.yapp.pl        svg ../graphviz-perl.github.io/parse.yapp.svg > $DIR/parse.yapp.log
perl -Ilib scripts/plaintext.pl         svg ../graphviz-perl.github.io/plaintext.svg > $DIR/plaintext.log
perl -Ilib scripts/quote.pl             svg ../graphviz-perl.github.io/quote.svg > $DIR/quote.log
perl -Ilib scripts/rank.sub.graph.1.pl  svg ../graphviz-perl.github.io/rank.sub.graph.1.svg > $DIR/rank.sub.graph.1.log
perl -Ilib scripts/rank.sub.graph.2.pl  svg ../graphviz-perl.github.io/rank.sub.graph.2.svg > $DIR/rank.sub.graph.2.log
perl -Ilib scripts/rank.sub.graph.3.pl  svg ../graphviz-perl.github.io/rank.sub.graph.3.svg > $DIR/rank.sub.graph.3.log
perl -Ilib scripts/rank.sub.graph.4.pl  svg ../graphviz-perl.github.io/rank.sub.graph.4.svg > $DIR/rank.sub.graph.4.log
perl -Ilib scripts/record.1.pl          svg ../graphviz-perl.github.io/record.1.svg > $DIR/record.1.log
perl -Ilib scripts/record.2.pl          svg ../graphviz-perl.github.io/record.2.svg > $DIR/record.2.log
perl -Ilib scripts/record.3.pl          svg ../graphviz-perl.github.io/record.3.svg > $DIR/record.3.log
perl -Ilib scripts/record.4.pl          svg ../graphviz-perl.github.io/record.4.svg > $DIR/record.4.log
perl -Ilib scripts/sub.graph.pl         svg ../graphviz-perl.github.io/sub.graph.svg > $DIR/sub.graph.log
perl -Ilib scripts/sub.graph.frames.pl  svg ../graphviz-perl.github.io/sub.graph.frames.svg > $DIR/sub.graph.frames.log
perl -Ilib scripts/sub.sub.graph.pl     svg ../graphviz-perl.github.io/sub.sub.graph.svg > $DIR/sub.sub.graph.log
perl -Ilib scripts/trivial.pl           svg ../graphviz-perl.github.io/trivial.svg > $DIR/trivial.log
perl -Ilib scripts/unnamed.sub.graph.pl svg ../graphviz-perl.github.io/unnamed.sub.graph.svg > $DIR/unnamed.sub.graph.log
perl -Ilib scripts/utf8.1.pl            svg ../graphviz-perl.github.io/utf8.1.svg > $DIR/utf8.1.log
perl -Ilib scripts/utf8.2.pl            svg ../graphviz-perl.github.io/utf8.2.svg > $DIR/utf8.2.log

perl -Ilib scripts/generate.demo.pl svg ../graphviz-perl.github.io
