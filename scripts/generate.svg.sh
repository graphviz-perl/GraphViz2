#!/bin/bash

DIR=/tmp

if [ -z $DBI_DSN ]; then
	echo Warning: DBI_DSN not set for scripts/dbi.schema.pl.
fi

perl -Ilib t/gen.Heawood.t           svg ../graphviz-perl.github.io/gen.Heawood.svg > $DIR/gen.Heawood.log
perl -Ilib t/gen.anonymous.t         svg ../graphviz-perl.github.io/gen.anonymous.svg > $DIR/gen.anonymous.log
perl -Ilib t/gen.circo.t             svg ../graphviz-perl.github.io/gen.circo.svg > $DIR/gen.circo.log
perl -Ilib t/gen.cluster.t           svg ../graphviz-perl.github.io/gen.cluster.svg > $DIR/gen.cluster.log
perl -Ilib t/gen.html.labels.1.t     svg ../graphviz-perl.github.io/gen.html.labels.1.svg > $DIR/gen.html.labels.1.log
perl -Ilib t/gen.html.labels.2.t     svg ../graphviz-perl.github.io/gen.html.labels.2.svg > $DIR/gen.html.labels.2.log
perl -Ilib t/gen.html.labels.3.t     svg ../graphviz-perl.github.io/gen.html.labels.3.svg > $DIR/gen.html.labels.3.log
perl -Ilib t/gen.jointed.edges.t     svg ../graphviz-perl.github.io/gen.jointed.edges.svg > $DIR/gen.jointed.edges.log
perl -Ilib t/gen.macro.1.t           svg ../graphviz-perl.github.io/gen.macro.1.svg > $DIR/gen.macro.1.log
perl -Ilib t/gen.macro.2.t           svg ../graphviz-perl.github.io/gen.macro.2.svg > $DIR/gen.macro.2.log
perl -Ilib t/gen.macro.3.t           svg ../graphviz-perl.github.io/gen.macro.3.svg > $DIR/gen.macro.3.log
perl -Ilib t/gen.macro.4.t           svg ../graphviz-perl.github.io/gen.macro.4.svg > $DIR/gen.macro.4.log
perl -Ilib t/gen.macro.5.t           svg ../graphviz-perl.github.io/gen.macro.5.svg > $DIR/gen.macro.5.log
perl -Ilib t/gen.map.3.t             svg ../graphviz-perl.github.io/gen.map.3.svg > $DIR/gen.map.3.log
perl -Ilib t/gen.map.4.t             svg ../graphviz-perl.github.io/gen.map.4.svg > $DIR/gen.map.4.log
perl -Ilib t/gen.parse.regexp.t      svg ../graphviz-perl.github.io/gen.parse.regexp.svg > $DIR/gen.parse.regexp.log
perl -Ilib t/gen.parse.stt.t         svg ../graphviz-perl.github.io/gen.parse.stt.svg > $DIR/gen.parse.stt.log
perl -Ilib t/gen.parse.yacc.t        svg ../graphviz-perl.github.io/gen.parse.yacc.svg > $DIR/gen.parse.yacc.log
perl -Ilib t/gen.parse.yapp.t        svg ../graphviz-perl.github.io/gen.parse.yapp.svg > $DIR/gen.parse.yapp.log
perl -Ilib t/gen.plaintext.t         svg ../graphviz-perl.github.io/gen.plaintext.svg > $DIR/gen.plaintext.log
perl -Ilib t/gen.quote.t             svg ../graphviz-perl.github.io/gen.quote.svg > $DIR/gen.quote.log
perl -Ilib t/gen.rank.sub.graph.1.t  svg ../graphviz-perl.github.io/gen.rank.sub.graph.1.svg > $DIR/gen.rank.sub.graph.1.log
perl -Ilib t/gen.rank.sub.graph.2.t  svg ../graphviz-perl.github.io/gen.rank.sub.graph.2.svg > $DIR/gen.rank.sub.graph.2.log
perl -Ilib t/gen.rank.sub.graph.3.t  svg ../graphviz-perl.github.io/gen.rank.sub.graph.3.svg > $DIR/gen.rank.sub.graph.3.log
perl -Ilib t/gen.rank.sub.graph.4.t  svg ../graphviz-perl.github.io/gen.rank.sub.graph.4.svg > $DIR/gen.rank.sub.graph.4.log
perl -Ilib t/gen.record.1.t          svg ../graphviz-perl.github.io/gen.record.1.svg > $DIR/gen.record.1.log
perl -Ilib t/gen.record.2.t          svg ../graphviz-perl.github.io/gen.record.2.svg > $DIR/gen.record.2.log
perl -Ilib t/gen.record.3.t          svg ../graphviz-perl.github.io/gen.record.3.svg > $DIR/gen.record.3.log
perl -Ilib t/gen.record.4.t          svg ../graphviz-perl.github.io/gen.record.4.svg > $DIR/gen.record.4.log
perl -Ilib t/gen.sub.graph.t         svg ../graphviz-perl.github.io/gen.sub.graph.svg > $DIR/gen.sub.graph.log
perl -Ilib t/gen.sub.graph.frames.t  svg ../graphviz-perl.github.io/gen.sub.graph.frames.svg > $DIR/gen.sub.graph.frames.log
perl -Ilib t/gen.sub.sub.graph.t     svg ../graphviz-perl.github.io/gen.sub.sub.graph.svg > $DIR/gen.sub.sub.graph.log
perl -Ilib t/gen.trivial.t           svg ../graphviz-perl.github.io/gen.trivial.svg > $DIR/gen.trivial.log
perl -Ilib t/gen.unnamed.sub.graph.t svg ../graphviz-perl.github.io/gen.unnamed.sub.graph.svg > $DIR/gen.unnamed.sub.graph.log
perl -Ilib t/gen.utf8.1.t            svg ../graphviz-perl.github.io/gen.utf8.1.svg > $DIR/gen.utf8.1.log
perl -Ilib t/gen.utf8.2.t            svg ../graphviz-perl.github.io/gen.utf8.2.svg > $DIR/gen.utf8.2.log

perl -Ilib scripts/generate.demo.pl svg ../graphviz-perl.github.io
