#!/usr/bin/env perl

use File::Spec;

use HTML::TreeBuilder;

use HTTP::Tiny;

# --------------------

my($file_name) = File::Spec -> catfile('data', 'output.formats.html');

if (! -e $file_name)
{
	my($page_name) = 'http://www.graphviz.org/content/output-formats';
	my($client)    = HTTP::Tiny -> new -> get($page_name);

	if ($$client{success})
	{
		open(OUT, '>', $file_name) || die "Can't open(> $file_name): $!";
		print OUT $$client{content};
		close OUT;
	}
	else
	{
		print "Failed to get $page_name: $$client{reason}. \n";
	}
}

my($root)   = HTML::TreeBuilder -> new();
my($result) = $root -> parse_file($file_name) || die "Can't parse: $file_name";
my(@node)   = $root -> look_down(_tag => 'table');
my(@td)     = $node[2] -> look_down(_tag => 'td');

my(@content, @column);
my(@row);
my($td);

for $td (@td)
{
	@content = $td -> content_list;

	for (@content)
	{
		if (ref $_)
		{
			push @column, $_ -> content_list;
		}
		else
		{
			push @column, $content;
		}
	}
}

$root -> delete();

$file_name = File::Spec -> catfile('data', 'output.formats.dat');

open(OUT, '>', $file_name) || die "Can't open(> $file_name): $!";
print OUT map{"$_\n"} sort grep{! /^$/} @column;
close OUT;
