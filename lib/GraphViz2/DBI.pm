package GraphViz2::DBI;

use strict;
use warnings;

use GraphViz2;

use Hash::FieldHash ':all';

fieldhash my %catalog    => 'catalog';
fieldhash my %dbh        => 'dbh';
fieldhash my %graph      => 'graph';
fieldhash my %schema     => 'schema';
fieldhash my %table      => 'table';
fieldhash my %table_info => 'table_info';
fieldhash my %type       => 'type';

our $VERSION = '2.13';

# -----------------------------------------------

sub create
{
	my($self, %arg) = @_;
	my($name) = $arg{name} || '';

	$self -> get_table_info;

	my($table_info) = $self -> table_info;

	my($port, %port);

	for my $table_name (sort keys %$table_info)
	{
		# Port 1 is the table name.

		$port              = 1;
		$port{$table_name} = {};

		for my $column_name (@{$$table_info{$table_name}{column_names} })
		{
			$port{$table_name}{$column_name} = $port++;
		}
	}

	for my $table_name (sort keys %$table_info)
	{
		$self -> graph -> add_node(name => $table_name, label => [$table_name, join('\l', map{"$port{$table_name}{$_}: $_"} sort keys %{$port{$table_name} }) . '\l']);
	}

	for my $table_name (sort keys %$table_info)
	{
		for my $item (sort @{$$table_info{$table_name}{foreign_keys} })
		{
			$self -> graph -> add_edge(from => "$table_name:port2", to => "$$item[1]:port2");
		}
	}

	if ($name)
	{
		$self -> graph -> add_node(name => $name, shape => 'doubleoctagon');

		for my $table_name (sort keys %$table_info)
		{
			$self -> graph -> add_edge(from => $name, to => $table_name);
		}
	}

	return $self;

} # End of create.

# -----------------------------------------------

sub get_table_info
{
	my($self)               = @_;
	my($dbh)                = $self -> dbh;
	$$dbh{FetchHashKeyName} = 'NAME_lc';
	my($vendor)             = uc $dbh -> get_info(17); # SQL_DBMS_NAME.
	my($sth)                = $dbh -> table_info($self -> catalog, $self -> schema, $self -> table, $self -> type);
	my($table_info)         = $sth -> fetchall_arrayref({});

	my($column_sth, @column_name);
	my($table_name, %table_data);

	for my $item (@$table_info)
	{
		$table_name = $$item{'table_name'};

		next if ( ($vendor eq 'ORACLE')     && ($table_name =~ /^bin\$.+\$./) );
		next if ( ($vendor eq 'POSTGRESQL') && ($table_name =~ /^(?:pg_|sql_)/) );
		next if ( ($vendor eq 'SQLITE')     && ($table_name eq 'sqlite_sequence') );

		my($column_sth) = $dbh -> prepare("select * from $table_name where 1 = 0");

		$column_sth -> execute;

		@column_name             = @{$$column_sth{NAME} };
		$table_data{$table_name} =
			{
				column_names => [sort @column_name],
				foreign_keys => [],
			};

		$column_sth -> finish;
	}

	my($column_data);
	my(@foreign_info);

	for my $table_name (sort keys %table_data)
	{
		@foreign_info = ();

		if ($vendor eq 'SQLITE')
		{
			for my $row (@{$dbh -> selectall_arrayref("pragma foreign_key_list($table_name)")})
			{
				push @foreign_info, [$$row[4], $$row[2], $$row[3] ];
			}
		}
		else
		{
			$sth        = $dbh -> foreign_key_info(undef, undef, undef, $self -> catalog, $self -> schema, $table_name) || next;
			$table_info = $sth -> fetchall_arrayref({});

			for $column_data (@$table_info)
			{
				push @foreign_info, [$$column_data{'fk_column_name'}, $$column_data{'uk_table_name'}, $$column_data{'uk_column_name'}];
			}
		}

		$table_data{$table_name}{foreign_keys} = [sort{$$a[1] cmp $$b[1]} @foreign_info];
	}

	$self -> table_info(\%table_data);

} # End of get_table_info.

# -----------------------------------------------

sub _init
{
	my($self, $arg) = @_;
	$$arg{catalog}  ||= undef; # Caller can set.
	$$arg{dbh}      = $$arg{dbh} || die 'Error: You must supply a dbh';
	$$arg{graph}    ||= GraphViz2 -> new
		(
		 edge   => {color => 'grey'},
		 global => {directed => 1},
		 graph  => {rankdir => 'TB'},
		 logger => '',
		 node   => {color => 'blue', shape => 'oval'},
		);
	$$arg{schema}     ||= undef;   # Caller can set.
	$$arg{table}      ||= '%';     # Caller can set.
	$$arg{table_info} = {};
	$$arg{type}       ||= 'TABLE'; # Caller can set.
	$self             = from_hash($self, $arg);

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

L<GraphViz2::DBI> - Visualize a database schema as a graph

=head1 Synopsis

	#!/usr/bin/env perl

	use strict;
	use warnings;

	use DBI;

	use GraphViz2;
	use GraphViz2::DBI;

	use Log::Handler;

	# ---------------

	exit 0 if (! $ENV{DBI_DSN});

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

	my($graph) = GraphViz2 -> new
		(
		 edge   => {color => 'grey'},
		 global => {directed => 1},
		 graph  => {rankdir => 'TB'},
		 logger => $logger,
		 node   => {color => 'blue', shape => 'oval'},
		);
	my($attr)              = {};
	$$attr{sqlite_unicode} = 1 if ($ENV{DBI_DSN} =~ /SQLite/i);
	my($dbh)               = DBI -> connect($ENV{DBI_DSN}, $ENV{DBI_USER}, $ENV{DBI_PASS}, $attr);

	$dbh -> do('PRAGMA foreign_keys = ON') if ($ENV{DBI_DSN} =~ /SQLite/i);

	my($g) = GraphViz2::DBI -> new(dbh => $dbh, graph => $graph);

	$g -> create(name => '');

	my($format)      = shift || 'svg';
	my($output_file) = shift || File::Spec -> catfile('html', "dbi.schema.$format");

	$graph -> run(format => $format, output_file => $output_file);

See scripts/dbi.schema.pl (L<GraphViz2/Scripts Shipped with this Module>).

=head1 Description

Takes a database handle, and graphs the schema.

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

C<new()> is called as C<< my($obj) = GraphViz2::DBI -> new(k1 => v1, k2 => v2, ...) >>.

It returns a new object of type C<GraphViz2::DBI>.

Key-value pairs accepted in the parameter list:

=over 4

=item o dbh => $dbh

This options specifies the database handle to use.

This key is mandatory.

=item o graph => $graphviz_object

This option specifies the GraphViz2 object to use. This allows you to configure it as desired.

The default is GraphViz2 -> new. The default attributes are the same as in the synopsis, above,
except for the graph label of course.

This key is optional.

=back

=head1 Methods

=head2 create(name => $name)

Creates the graph, which is accessible via the graph() method, or via the graph object you passed to new().

Returns $self to allow method chaining.

$name is the string which will be placed in the root node of the tree. It may be omitted, in which case the root node is omitted.

=head2 graph()

Returns the graph object, either the one supplied to new() or the one created during the call to new().

=head1 FAQ

=head2 Does GraphViz2::DBI work with SQLite databases?

Yes. As of V 2.07, this module uses SQLite's "pragma foreign_key_list($table_name)" to emulate L<DBI>'s
$dbh -> foreign_key_info(...).

=head2 What is returned by SQLite's "pragma foreign_key_list($table_name)"?

	Fields returned are:
	0: COUNT   (0, 1, ...)
	1: KEY_SEQ (0, or column # (1, 2, ...) within multi-column key)
	2: FKTABLE_NAME
	3: PKCOLUMN_NAME
	4: FKCOLUMN_NAME
	5: UPDATE_RULE
	6: DELETE_RULE
	7: 'NONE' (Constant string)

=head2 Are any sample scripts shipped with this module?

Yes. See L<GraphViz2/FAQ> and L<GraphViz2/Scripts Shipped with this Module>.

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
