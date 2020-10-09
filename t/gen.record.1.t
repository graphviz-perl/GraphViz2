#!/usr/bin/env perl
#
# Note: t/test.t searches for the next line.
# Annotation: Nested records using strings as labels.

use strict;
use warnings;

use File::Spec;

use GraphViz2;

my($id)    = '1';
my($graph) = GraphViz2 -> new
(
	edge   => {color => 'grey'},
	global => {directed => 1},
	graph  => {label => "Record demo $id - Nested records using strings as labels"},
	node   => {shape => 'record'},
);

$graph -> add_node(name => 'struct1', label => '<f0> left|<f1> mid dle|<f2> right');
$graph -> add_node(name => 'struct2', label => '<f0> one|<f1> two');
$graph -> add_node(name => 'struct3', label => "hello\\nworld |{ b |{c|<here> d|e}| f}| g | h");

$graph -> add_edge(from => 'struct1:f1', to => 'struct2:f0',   color => 'blue');
$graph -> add_edge(from => 'struct1:f2', to => 'struct3:here', color => 'red');

if (@ARGV) {
  my($format)      = shift || 'svg';
  my($output_file) = shift || File::Spec -> catfile('html', "record.$id.$format");
  $graph -> run(format => $format, output_file => $output_file);
} else {
  # run as a test
  require Test::More;
  require Test::Snapshot;
  $graph->run(format => 'dot');
  Test::Snapshot::is_deeply_snapshot($graph->dot_input, 'dot file');
  Test::More::done_testing();
}
