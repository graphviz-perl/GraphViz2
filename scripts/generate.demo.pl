#!/usr/bin/env perl

use strict;
use warnings;

use Date::Format;

use File::Spec;

use GraphViz2;
use GraphViz2::Utils;

use Perl6::Slurp;

use Text::Xslate 'mark_raw';

# ------------------------------------------------

my($format)     = shift || 'svg';
my($util)       = GraphViz2::Utils -> new;
my(%annotation) = $util -> get_annotations;
my(%script)     = $util -> get_scripts;
my(%image_file) = $util -> get_files($format);
my($templater)  = Text::Xslate -> new
(
  input_layer => '',
  path        => 'html',
);

my(@data, %data);
my($line, @line);

for my $key (keys %script)
{
	$data{$key} = '';
	$line       = slurp $script{$key};
	@line       = split(/\n/, $line);

	for $line (@line)
	{
		if ($line =~ /(?:create|slurp).+File::Spec -> catfile\((.+?)\)/)
		{
			@data       = split(/\s*,\s*/, $1);
			$data{$key} = $templater -> render
				(
				 'table.tx',
				 {
					 data => [map{ {td => $_} } split(/\n/, slurp(File::Spec -> catfile(map{s/\'//g; $_} @data) ) )],
				 }
				);

			last;
		}
	}
}

my($count) = 0;
my($index) = $templater -> render
(
 'graphviz2.index.tx',
 {
	 data    =>
		 [
		  map
		  {
			  {
				  alt    => mark_raw($script{$_}),
				  count  => ++$count,
				  image  => "./$image_file{$_}",
				  input  => mark_raw($script{$_}),
				  raw    => mark_raw($data{$_}),
				  title  => mark_raw($annotation{$_}),
			  }
		  } sort keys %image_file
		 ],
	 date_stamp => time2str('%Y-%m-%d %T', time),
	 version    => $GraphViz2::VERSION,
 }
);
my($file_name) = File::Spec -> catfile('html', 'index.html');

open(OUT, '>', $file_name);
print OUT $index;
close OUT;

print "Wrote: $file_name to html/. \n";
