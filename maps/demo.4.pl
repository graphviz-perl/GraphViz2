#!/usr/bin/env perl
#
# Note: t/test.t searches for the next line.
# Annotation: Demonstrates a graph with a 'plaintext' shape.

use strict;
use warnings;

use File::Spec;

use GraphViz2;

use Log::Handler;

# ---------------

my($logger) = Log::Handler -> new;

$logger -> add
	(
	 screen =>
	 {
		 maxlevel		=> 'debug',
		 message_layout	=> '%m',
		 minlevel		=> 'error',
	 }
	);

my($id)		= 4;
my($graph)	= GraphViz2 -> new
				(
					edge   => {color => 'grey'},
					global =>
					{
						directed	=> 1,
						name		=> 'mainmap',
						URL			=> "http://savage.net.au/",	# Note: URL must be in caps and quotes must be doubles.
					},
					graph	=> {rankdir => 'TB'},
					logger	=> $logger,
					node	=> {shape => 'oval'},
				);

$graph -> add_node(name => 'command',	URL => "http://savage.net.au/maps/demo.1.html");
$graph -> add_node(name => 'output',	URL => "/maps/demo.1.1.html");
$graph -> add_edge(from => 'command',	to => 'output');


my($format)			= shift || 'svg';
my($output_file)	= shift || "demo.$id.$format";
my($output_file_1)	= shift || "demo.$id.map";

$graph -> run(format => $format, output_file => $output_file, format_1 => $format, output_file_1 => $output_file_1);
