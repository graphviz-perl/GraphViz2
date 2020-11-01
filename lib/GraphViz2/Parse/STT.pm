package GraphViz2::Parse::STT;

use strict;
use warnings;
use warnings  qw(FATAL utf8); # Fatalize encoding glitches.

our $VERSION = '2.47';

use GraphViz2;
use Moo;
use Text::ParseWords;
use Graph::Directed;

my %GRAPHVIZ_ARGS = (
    edge   => {color => 'grey'},
    global => {directed => 1, combine_node_and_port => 0},
    graph  => {rankdir => 'TB'},
    node   => {color => 'blue', shape => 'oval'},
);

has as_graph => (
    is       => 'lazy',
    required => 0,
);
sub _build_as_graph { to_graph($_[0]->stt) }

has graph => (
    is       => 'lazy',
    #isa     => 'GraphViz2',
    required => 0,
);
sub _build_graph {
    GraphViz2->new(%GRAPHVIZ_ARGS)->from_graph(graphvizify($_[0]->as_graph));
}

has stt => (
    is       => 'rw',
    required => 0,
);

sub _quote { my $t = $_[0]; $t =~ s/\\/\\\\/g; $t; }

sub create {
    my ($self, %arg) = @_;
    $self->stt($arg{stt});
    $self->graph->from_graph(graphvizify($self->as_graph));
    return $self;
}

sub to_graph {
    my ($stt) = @_;
    my $g = Graph::Directed->new;
    for my $line (split /\n/, $stt) {
        $line =~ s/^\s*\[?//;
        $line =~ s/\s*(],?)?$//;
        my ($f, $re, $t) = quotewords('\s*,\s*', 0, $line);
        my $re_node_id = "$re:$t";
        $g->set_vertex_attributes($re_node_id, { type => 're', re => $re });
        $g->set_vertex_attribute($_, type => 'state') for $f, $t;
        $g->add_edge($f, $re_node_id);
        $g->add_edge($re_node_id, $t);
    }
    return $g;
}

sub graphvizify {
    my ($g) = @_;
    my %state2res;
    for (grep $g->get_vertex_attribute($_, 'type') eq 're', $g->vertices) {
        my $re_quoted = _quote($g->get_vertex_attribute($_, 're'));
        my ($to) = $g->edges_from($_);
        push @{ $state2res{$to->[1]} }, $_;
        $g->set_vertex_attribute(
            $_,
            graphviz => { label => "/$re_quoted/", color => 'black', shape => 'box' },
        );
    }
    my @groups = map +{
        attributes => { name => "cluster_$_", subgraph => { rank => "TB" } },
        nodes => [ $_, sort @{$state2res{$_}} ],
    }, sort keys %state2res;
    $g->set_graph_attribute(
        graphviz => {
            global => $GRAPHVIZ_ARGS{global},
            graph => { clusterrank => 'local', compound => 1 },
            groups => \@groups,
        }
    );
    $g;
}

1;

=pod

=head1 NAME

L<GraphViz2::Parse::STT> - Visualize a Set::FA::Element state transition table as a graph

=head1 SYNOPSIS

    use GraphViz2::Parse::STT;
    use File::Slurp; # For read_file().
    my $stt = read_file('sample.stt.1.dat');
    # no objects - quicker
    my $gd = GraphViz2::Parse::STT::to_graph($stt);

    # populate a GraphViz2 object with a Graph::Directed of a parser
    my $gv = GraphViz2->from_graph(GraphViz2::Parse::STT::graphvizify($gd));

    # OO interface, using lazy-built attributes
    my $gvp = GraphViz2::Parse::STT->new(stt => $stt);
    my $gd = $gvp->as_graph; # Graph::Directed object
    # or supply a suitable Graph::Directed object
    my $gvp = GraphViz2::Parse::STT->new(as_graph => $gd);
    # then get the GraphViz2 object
    my $gv = $gvp->graph;

    # DEPRECATED ways to get $gvp with populated $gv
    my $gvp = GraphViz2::Parse::STT->new;
    $gvp->create(stt => $stt);
    my $gv = $gvp->graph;
    # or give it a pre-set-up GraphViz2 object
    my $gv = GraphViz2->new(...);
    my $gvp = GraphViz2::Parse::STT->new(graph => $gv);
    # call ->create as above

    # produce a visualisation
    my $format = shift || 'svg';
    my $output_file = shift || "output.$format";
    $gv->run(format => $format, output_file => $output_file);

See F<t/gen.parse.stt.t>.

Note: F<t/sample.stt.2.dat> is output from L<Graph::Easy::Marpa::DFA> V
0.70, and can be used instead of F<t/sample.stt.1.dat> in the above code.

=head1 DESCRIPTION

Takes a L<Set::FA::Element>-style state transition table and converts it
into a L<Graph::Directed> object, or directly into a L<GraphViz2> object.

=head1 FUNCTIONS

This is the recommended interface.

=head2 to_graph

    my $gd = GraphViz2::Parse::STT::to_graph($stt);

Given STT text, returns a L<Graph::Directed> object describing the finite
state machine for it.

=head2 graphvizify

    my $gv = GraphViz2->from_graph(GraphViz2::Parse::STT::graphvizify($gd));

Mutates the given graph object to add to it the C<graphviz> attributes
visualisation "hints" that will make the L<GraphViz2/from_graph> method
visualise this regular expression in the most meaningful way, including
labels and groupings.

It is idempotent as it simply sets the C<graphviz> attribute of the
relevant graph entities.

Returns the graph object for convenience.

=head1 METHODS

This is a L<Moo> class, but with a recommended functional interface.

=head2 Constructor attributes

=head3 stt

Text with a state transition table, with a Perl-ish list of arrayrefs,
each with 3 elements.

That is, it is the I<contents> of the arrayref 'transitions', which is one of the keys in the parameter list
to L<Set::FA::Element>'s new().

A quick summary of each element of this list, where each element is an arrayref with 3 elements:

=over 4

=item o [0] A state name

=item o [1] A regexp

=item o [2] Another state name (which may be the same as the first)

=back

The DFA in L<Set::FA::Element> tests the 'current' state against the state name ([0]), and for each state name
which matches, tests the regexp ([1]) against the next character in the input stream. The first regexp to match
causes the DFA to transition to the state named in the 3rd element of the arrayref ([2]).

See F<t/sample.stt.1.dat> for an example.

This key is optional. You need to provide it by the time you access
either the L</as_graph> or L</graph>.

=head3 as_graph

The L<Graph::Directed> object to use. If not given, will be lazily built
on access, from the L</stt>.

=head3 graph

The L<GraphViz2> object to use. This allows you to configure it as desired.

This key is optional. If provided, the C<create> method will populate it.
If not, it will have these defaults, lazy-built and populated from the
L</as_graph>.

    my $gv = GraphViz2->new(
            edge   => {color => 'grey'},
            global => {directed => 1},
            graph  => {rankdir => 'TB'},
            node   => {color => 'blue', shape => 'oval'},
    );

=head2 create(regexp => $regexp)

DEPRECATED. Mutates the object to set the C<stt> attribute, then
accesses the C<as_graph> attribute (possibly lazy-building it), then
C<graphvizify>s its C<as_graph> attribute with that information, then
C<from_graph>s its C<graph>.

Returns $self for method chaining.

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
