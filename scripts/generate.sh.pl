#!/usr/bin/env perl

use strict;
use warnings;
use warnings  qw(FATAL utf8);    # Fatalize encoding glitches.

use File::Spec;

use GraphViz2::Filer;
use GraphViz2::Utils;

my $outdir = GraphViz2::Utils->new->config->{output_dir};

# ------------------------------------------------

sub format_output
{
	my($format, @output) = @_;
	open my $fh, '>:encoding(UTF-8)', "scripts/generate.$format.sh" or die "generate.$format.sh: $!";
	print $fh @output;
	print $fh <<EOS;

perl -Ilib scripts/generate.demo.pl $format $outdir
EOS
} # End of format_output;

# ------------------------------------------------

my(%script) = GraphViz2::Filer -> new -> get_scripts;
my($width)  = 0;

for (keys %script)
{
	$width = length($_) if (length($_) > $width);
}

my($offset);

for my $format (qw/svg/)
{
	my(@output) = <<'EOS';
#!/bin/bash

DIR=/tmp

if [ -z $DBI_DSN ]; then
	echo Warning: DBI_DSN not set for scripts/dbi.schema.pl.
fi

EOS

	for my $key (sort keys %script)
	{
		$offset = ' ' x ($width - length($key) );

		push @output, "perl -Ilib t/$key.t $offset$format $outdir/$key.$format > \$DIR/$key.log\n";
	}

	# Warning: Do no pass in \@output, since format_output() patches @output.

	format_output($format, @output);
}
