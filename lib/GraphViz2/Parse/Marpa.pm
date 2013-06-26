package GraphViz2::Parse::Marpa;

use strict;
use warnings;

use GraphViz2;

use Hash::FieldHash ':all';

fieldhash my %graph => 'graph';

our $VERSION = '2.11';

# -----------------------------------------------

sub create
{
	my($self, %arg) = @_;
	my($grammar) = $arg{grammar};

	# Phase 1: Process all Marpa rule descriptors.

	my($count) = 0;

	my($name);
	my(%rule);

	for my $line (split(/\n/, $grammar) )
	{
		$line =~ s/^\s+//;
		$line =~ s/\s+$//;

		if ($line =~ /^(?:{|})/)
		{
			if ($line =~ /^{/)
			{
				$count++;
			}

			next;
		}

		if ($line =~ /^lhs\s*=>\s*(.+)$/)
		{
			$name = $1;

			# Expect: qw/xyz/, or 'xyz' or "xyz".

			if ($name =~ m|qw(.)(.+)\1|)
			{
				$name = $2;
			}
			elsif ($name =~ /("|')(.+)\1/)
			{
				$name = $2;
			}
			else
			{
				next;
			}

			$rule{$count} =
				{
					action => '',
					lhs    => $name,
					rhs    => [],
				};
		}
		elsif ($line =~ m|^rhs\s*=>\s*\[qw(.)(.+)\1]|)
		{	# Expect qw/x y z/.
			$rule{$count}{rhs} = [split /\s+/, $2];
		}
		elsif ($line =~ /^action\s*=>\s*(.+)$/)
		{
			$name = $1;

			# Expect: qw/xyz/, or 'xyz' or "xyz".

			if ($name =~ m|qw(.)(.+)\1|)
			{
				$name = $2;
			}
			elsif ($name =~ /("|')(.+)\1/)
			{
				$name = $2;
			}
			else
			{
				next;
			}

			$rule{$count}{action} = $name;
		}
	}

	# Phase 2: Generate 1 node per rule.
	# The sorts are for debugging.

	my($lhs_name);

	for $count (sort keys %rule)
	{
		$lhs_name = $rule{$count}{lhs};

		$self -> graph -> add_node(name => "${lhs_name}_$count", label => ["lhs: ${lhs_name}_$count", 'rhs list:', map{"${_}_$count"} @{$rule{$count}{rhs} }]);
	}

	# Phase 3: Generate edges from rhs's to lhs's.

	my($counter);
	my($lhs_name_1);
	my($port);
	my($rhs_name);

	for $count (sort keys %rule)
	{
		$lhs_name = $rule{$count}{lhs};

		# Port 1 is 'lhs $node_name', and port 2 is 'rhs list:'.
		# The next port, 3, will be the first component of the rhs.

		$port = 2;

		# Outer loop: Process each rhs name.

		for $rhs_name (@{$rule{$count}{rhs} })
		{
			$port++;

			# Inner loop: Find matching lhs name.

			for $counter (sort keys %rule)
			{
				$lhs_name_1 = $rule{$counter}{lhs};

				if ($lhs_name_1 eq $rhs_name)
				{
					$self -> graph -> add_edge(from => "${lhs_name}_$count:port$port", to => "${lhs_name_1}_$counter:port1");
				}
			}
		}
	}

	return $self;

}	# End of create.

# -----------------------------------------------

sub _init
{
	my($self, $arg) = @_;
	$$arg{graph}    ||= GraphViz2 -> new
		(
		 edge   => {color => 'grey'},
		 global => {directed => 1},
		 graph  => {rankdir => 'TB'},
		 logger => '',
		 node   => {color => 'blue', shape => 'oval'},
		);
	$self = from_hash($self, $arg);

	return $self;

} # End of _init.

# -----------------------------------------------

sub new
{
	my($class, %arg) = @_;
	my($self)        = bless {}, $class;
	$self            = $self -> _init(\%arg);

	return $self;

}	# End of new.

# -----------------------------------------------

1;

=pod

=head1 NAME

L<GraphViz2::Parse::Marpa> - Visualize a Marpa grammar as a graph

=head1 Synopsis

	#!/usr/bin/env perl

	use strict;
	use warnings;

	use File::Spec;

	use GraphViz2;
	use GraphViz2::Parse::Marpa;

	use Log::Handler;

	use Perl6::Slurp;

	# ------------------------------------------------

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

	my($graph)  = GraphViz2 -> new
		(
		 edge   => {color => 'grey'},
		 global => {directed => 1},
		 graph  => {rankdir => 'TB'},
		 logger => $logger,
		 node   => {color => 'blue', shape => 'oval'},
		);
	my($g)      = GraphViz2::Parse::Marpa -> new(graph => $graph);
	my $grammar = slurp(File::Spec -> catfile('t', 'sample.marpa.1.dat') );

	$g -> create(grammar => $grammar);

	my($format)      = shift || 'svg';
	my($output_file) = shift || File::Spec -> catfile('html', "parse.marpa.$format");

	$graph -> run(format => $format, output_file => $output_file);

See scripts/parse.marpa.pl (L<GraphViz2/Scripts Shipped with this Module>).

=head1 Description

Takes a L<Marpa> grammar and converts it into a graph.

You can write the result in any format supported by L<Graphviz|http://www.graphviz.org/>.

Here is the list of L<output formats|http://www.graphviz.org/content/output-formats>.

=head1 Distributions

This module is available as a Unix-style distro (*.tgz).

See L<http://savage.net.au/Perl-modules/html/installing-a-module.html>
for help on unpacking and installing distros.

=head1 Installation

Install L<GraphViz2> as you would for any C<Perl> module:

Run:

	cpanm GraphViz2

or run:

	sudo cpan GraphViz2

or unpack the distro, and then either:

	perl Build.PL
	./Build
	./Build test
	sudo ./Build install

or:

	perl Makefile.PL
	make (or dmake or nmake)
	make test
	make install

=head1 Constructor and Initialization

=head2 Calling new()

C<new()> is called as C<< my($obj) = GraphViz2::Parse::Marpa -> new(k1 => v1, k2 => v2, ...) >>.

It returns a new object of type C<GraphViz2::Parse::Marpa>.

Key-value pairs accepted in the parameter list:

=over 4

=item o graph => $graphviz_object

This option specifies the GraphViz2 object to use. This allows you to configure it as desired.

The default is GraphViz2 -> new. The default attributes are the same as in the synopsis, above,
except for the graph label of course.

This key is optional.

=back

=head1 Methods

=head2 create(grammar => $grammar)

Creates the graph, which is accessible via the graph() method, or via the graph object you passed to new().

Returns $self for method chaining.

$grammar is the set of hashrefs which make up the rule descriptors for the L<Marpa> grammar.

That is, it is the I<contents> of the arrayref 'rules', which is one of the keys in the parameter list to L<Marpa::Grammar>'s new().
See t/sample.marpa.1.dat for an example.

Nodes are given the names of the 'lhs' keys within each rule descriptor (a hashref), with numeric suffixes to separate nodes
which would otherwise have the same name. The numbers are just 1 .. N counting the hashrefs processed in the grammar.

=head2 graph()

Returns the graph object, either the one supplied to new() or the one created during the call to new().

=head1 FAQ

See L<GraphViz2/FAQ> and L<GraphViz2/Scripts Shipped with this Module>.

=head1 Thanks

Many thanks are due to the people who chose to make L<Graphviz|http://www.graphviz.org/> Open Source.

And thanks to L<Leon Brocard|http://search.cpan.org/~lbrocard/>, who wrote L<GraphViz>, and kindly gave me co-maint of the module.

=head1 Version Numbers

Version numbers < 1.00 represent development versions. From 1.00 up, they are production versions.

=head1 Machine-Readable Change Log

The file CHANGES was converted into Changelog.ini by L<Module::Metadata::Changes>.

=head1 Support

Email the author, or log a bug on RT:

L<https://rt.cpan.org/Public/Dist/Display.html?Name=GraphViz2>.

=head1 Author

L<GraphViz2> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2011.

Home page: L<http://savage.net.au/index.html>.

=head1 Copyright

Australian copyright (c) 2011, Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
