package GraphViz2::Parse::Regexp;

use strict;
use warnings;
use warnings  qw(FATAL utf8); # Fatalize encoding glitches.

our $VERSION = '2.47';

use IPC::Run3; # For run3().
use GraphViz2;
use Moo;

has graph => (
	default  => sub {
		GraphViz2->new(
			edge   => {color => 'grey'},
			global => {directed => 1},
			graph  => {rankdir => 'TB'},
			node   => {color => 'blue', shape => 'oval'},
		)
        },
	is       => 'rw',
	#isa     => 'GraphViz2',
	required => 0,
);

my %STATE2LABEL = (
  PLUS => '+',
  STAR => '*',
);

sub create {
    my ($self, %arg) = @_;
    run3
            [$^X, '-Mre=debug', '-e', q|qr/$ARGV[0]/|, $arg{regexp}],
            undef,
            \my $stdout,
            \my $stderr,
            ;

    my (%following, %states, $last_id);
    for my $line ( split /\n/, $stderr ) {
        next unless my ($id, $state) = $line =~ /(\d+):\s+(.+)$/;
        $states{$id}         = $state;
        $following{$last_id} = $id if $last_id;
        $last_id             = $id;
    }
    die 'Error compiling regexp' if !defined $last_id;

    my $gv = $self->graph;
    my %done;
    my @todo = (1);
    while (@todo) {
        my $id = pop @todo;
        next unless $id;
        next if $done{$id}++;
        my $state     = $states{$id};
        my $following = $following{$id};
        my ($next) = $state =~ /\((\d+)\)$/;

        push @todo, $following;
        push @todo, $next if $next;

        my $match;

        if ( ($match) = $state =~ /^EXACTF?L? <(.+)>/ ) {
            $gv->add_node( name => $id, label => $match, shape => 'box' );
            $gv->add_edge( from => $id, to => $next ) if $next != 0;
            $done{$following}++ unless $next;
        } elsif ( ($match) = $state =~ /^ANYOF\[(.+)\]/ ) {
            $gv->add_node( name => $id, label => '[' . $match . ']', shape => 'box' );
            $gv->add_edge( from => $id, to => $next ) if $next != 0;
            $done{$following}++ unless $next;
        } elsif ( ($match) = $state =~ /^OPEN(\d+)/ ) {
            $gv->add_node( name => $id, label => 'START \$' . $match );
            $gv->add_edge( from => $id, to => $following );
        } elsif ( ($match) = $state =~ /^CLOSE(\d+)/ ) {
            $gv->add_node( name => $id, label => 'END \$' . $match );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( $state =~ /^END/ ) {
            $gv->add_node( name => $id, label => 'END' );
        } elsif ( $state =~ /^BRANCH/ ) {
            my $branch = $next;
            my @children;
            push @children, $following;
            while ($branch && $states{$branch} =~ /^BRANCH|TAIL/ ) {
                $done{$branch}++;
                push @children, $following{$branch};
                ($branch) = $states{$branch} =~ /(\d+)/;
            }
            $gv->add_node( name => $id, label => '', shape => 'diamond' );
            foreach my $child (@children) {
                push @todo, $child;
                $gv->add_edge( from => $id, to => $child );
            }
        } elsif ( my ($repetition) = $state =~ /^(PLUS|STAR)/ ) {
            $gv->add_node( name => $id, label => 'REPEAT' );
            $gv->add_edge( from => $id, to => $id, label => $STATE2LABEL{$repetition} );
            $gv->add_edge( from => $id, to => $following, style => 'dashed' );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( my ( $type, $min, $max )
            = $state =~ /^CURLY([NMX]?)\[?\d*\]?\s*\{(\d+),(\d+)\}/ )
        {
            $gv->add_node( name => $id, label => 'REPEAT' );
            $gv->add_edge(
                from => $id, to   => $id,
                label => '{' . $min . ", " . $max . '}'
            );
            $gv->add_edge( from => $id, to => $following );
            $gv->add_edge( from => $id, to => $next, style => 'dashed' );
        } elsif ( $state =~ /^BOL/ ) {
            $gv->add_node( name => $id, label => '^' );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( $state =~ /^EOL/ ) {
            $gv->add_node( name => $id, label => "\$" );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( $state =~ /^NOTHING/ ) {
            $gv->add_node( name => $id, label => 'Match empty string' );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( $state =~ /^MINMOD/ ) {
            $gv->add_node( name => $id, label => 'Next operator\nnon-greedy' );
            $gv->add_edge( from => $id, to => $next );
        } elsif ( $state =~ /^SUCCEED/ ) {
            $gv->add_node( name => $id, label => 'SUCCEED' );
            $done{$following}++;
        } elsif ( $state =~ /^UNLESSM/ ) {
            $gv->add_node( name => $id, label => 'UNLESS' );
            $gv->add_edge( from => $id, to => $following );
            $gv->add_edge( from => $id, to => $next, style => 'dashed' );
        } elsif ( $state =~ /^IFMATCH/ ) {
            $gv->add_node( name => $id, label => 'IFMATCH' );
            $gv->add_edge( from => $id, to => $following );
            $gv->add_edge( from => $id, to => $next, style => 'dashed' );
        } elsif ( $state =~ /^IFTHEN/ ) {
            $gv->add_node( name => $id, label => 'IFTHEN' );
            $gv->add_edge( from => $id, to => $following );
            $gv->add_edge( from => $id, to => $next, style => 'dashed' );
        } elsif ( $state =~ /^([A-Z_0-9]+)/ ) {
            my ($state) = ( $1, $2 );
            $self->graph->add_node( name => $id, label => $state );
            $self->graph->add_edge( from => $id, to => $next ) if $next != 0;
        } else {
            $self->graph->add_node( name => $id, label => $state );
        }
    }

	return $self;

}

1;

=pod

=head1 NAME

L<GraphViz2::Parse::Regexp> - Visualize a Perl regular expression as a graph

=head1 SYNOPSIS

	use GraphViz2;
	use GraphViz2::Parse::Regexp;
	my $graph = GraphViz2->new(
		edge   => {color => 'grey'},
		global => {directed => 1},
		graph  => {rankdir => 'TB'},
		node   => {color => 'blue', shape => 'oval'},
	);
	my $gvre = GraphViz2::Parse::Regexp->new(graph => $graph);
	$gvre->create(regexp => '(([abcd0-9])|(foo))');
	my $format = shift || 'svg';
	my $output_file = shift || "parse.regexp.$format";
	$graph->run(format => $format, output_file => $output_file);

See scripts/parse.regexp.pl (L<GraphViz2/Scripts Shipped with this Module>).

=head1 DESCRIPTION

Takes a Perl regular expression and converts it into a L<GraphViz2> object.

=head1 Constructor and Initialization

=head2 Calling new()

C<new()> is called as C<< my($obj) = GraphViz2::Parse::Regexp->new(k1 => v1, k2 => v2, ...) >>.

It returns a new object of type C<GraphViz2::Parse::Regexp>.

Key-value pairs accepted in the parameter list:

=over 4

=item o graph => $graphviz_object

This option specifies the GraphViz2 object to use. This allows you to configure it as desired.

The default is GraphViz2->new. The default attributes are the same as in the synopsis, above.

This key is optional.

=back

=head1 METHODS

=head2 create(regexp => $regexp)

Creates the graph, which is accessible via the graph() method, or via the graph object you passed to new().

Returns $self for method chaining.

=head2 graph()

Returns the graph object, either the one supplied to new() or the one created during the call to new().

=head1 THANKS

Many thanks are due to the people who chose to make L<Graphviz|http://www.graphviz.org/> Open Source.

And thanks to L<Leon Brocard|http://search.cpan.org/~lbrocard/>, who wrote L<GraphViz>, and kindly gave me co-maint of the module.

=head1 AUTHOR

L<GraphViz2> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2011.

Home page: L<http://savage.net.au/index.html>.

=head1 COPYRIGHT

Australian copyright (c) 2011, Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Perl License, a copy of which is available at:
	http://dev.perl.org/licenses/

=cut
