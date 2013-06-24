#!/usr/bin/env perl
#
# Note: t/test.t searches for the next line.
# Annotation: Deeply nested records using strings as labels.

use strict;
use warnings;

use File::Spec;

use GraphViz2;

use Log::Handler;

# -----------------------------------------------

my($logger) = Log::Handler -> new;

$logger -> add
(
	screen =>
	{
		maxlevel       => 'debug',
		message_layout => '%m',
		minlevel       => 'error',
	}
);

my($id)    = '3';
my($graph) = GraphViz2 -> new
(
	edge   => {color => 'grey'},
	global => {directed => 1},
	graph  => {label => "Record demo $id - Deeply nested records using strings as labels"},
	logger => $logger,
	node   => {shape => 'record'},
);

$graph -> add_node(name => 'Alphabet',
label => '<p_a> p_a@a |{<p_b> p_b@b | c |{<p_d> p_d@d | e | f |{ g |<p_h> p_h@h | i | j |{ k | l | m |<p_n> p_n@n | o | p}| q | r |<p_s> p_s@s | t }| u | v |<p_w> p_w@w }| x |<p_y> p_y@y }| z');

$graph -> add_edge(from => 'Alphabet:p_a', to => 'Alphabet:p_n', color => 'maroon');
$graph -> add_edge(from => 'Alphabet:p_b', to => 'Alphabet:p_s', color => 'blue');
$graph -> add_edge(from => 'Alphabet:p_d', to => 'Alphabet:p_w', color => 'red');
$graph -> add_edge(from => 'Alphabet:p_h', to => 'Alphabet:p_y', color => 'green');

my($format)      = shift || 'svg';
my($output_file) = shift || File::Spec -> catfile('html', "record.$id.$format");

$graph -> run(format => $format, output_file => $output_file);
