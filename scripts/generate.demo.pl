#!/usr/bin/env perl

use strict;
use warnings;

use Date::Format;

use File::Spec;

use GraphViz2;
use GraphViz2::Config;
use GraphViz2::Filer;

use File::Slurp; # For read_file().

use Text::Xslate 'mark_raw';

# ------------------------------------------------

my($format)     = shift || 'svg';
my($config)     = GraphViz2::Config -> new;
my($util)       = GraphViz2::Filer -> new;
my(%annotation) = $util -> get_annotations;
my(%script)     = $util -> get_scripts;
my(%image_file) = $util -> get_files('html', $format);
my($templater)  = Text::Xslate -> new
(
  input_layer => '',
  path        => $$config{template_path},
);

my(@data, %data);
my($line, @line);

for my $key (keys %script)
{
	$data{$key} = '';
	$line       = read_file $script{$key};
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
					 data => [map{ {td => $_} } split(/\n/, read_file(File::Spec -> catfile(map{s/\'//g; $_} @data) ) )],
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
