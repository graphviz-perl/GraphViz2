#!/usr/bin/env perl
#
# Note: t/test.t searches for the next line.
# Annotation: Demonstrates (1) newlines and double-quotes in node names and labels, (2) justification - with a Graphviz bug.

use strict;
use warnings;

use File::Spec;

use GraphViz2;

my($graph) = GraphViz2 -> new
	(
	 edge   => {color => 'grey'},
	 global => {directed => 1},
	 graph  => {rankdir => 'TB'},
	 node   => {shape => 'oval'},
	);

$graph -> add_node(name => "Embedded\\nnewline\\nnode\\nname");
$graph -> add_node(name => "Embedded newline label name", label => "Embedded\\nnewline\\nlabel");
$graph -> add_node(name => "Embedded\\ndouble-quote\\nnode\\nname\\n\\\"");
$graph -> add_node(name => "Embedded\\double-quote\\label", label => qq|Embedded\\ndouble-quote\\nlabel\\n\"|);
$graph -> add_node(name => 'Line justification 1', label => "A short line\\rA much longer line");
$graph -> add_node(name => 'Line justification 2', label => "A much longer line\\rA short line");

if (@ARGV) {
  my($format)      = shift || 'svg';
  my($output_file) = shift || File::Spec -> catfile('html', "quote.$format");
  $graph -> run(format => $format, output_file => $output_file);
} else {
  # run as a test
  require Test::More;
  require Test::Snapshot;
  $graph->run(format => 'dot');
  Test::Snapshot::is_deeply_snapshot($graph->dot_input, 'dot file');
  Test::More::done_testing();
}
