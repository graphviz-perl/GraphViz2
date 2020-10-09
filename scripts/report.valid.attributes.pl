use strict;
use warnings;
use GraphViz2;
use Data::Dumper;

$Data::Dumper::Indent = $Data::Dumper::Terse = $Data::Dumper::Sortkeys = 1;
print Dumper(GraphViz2->new(verbose => 1)->valid_attributes);
