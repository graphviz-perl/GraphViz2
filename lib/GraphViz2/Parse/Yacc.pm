package GraphViz2::Parse::Yacc;

use strict;
use warnings;
use warnings  qw(FATAL utf8); # Fatalize encoding glitches.

our $VERSION = '2.47';

use GraphViz2;
use Moo;

has graph => (
    default  => sub {
        GraphViz2->new(
            edge   => {color => 'grey'},
            global => {directed => 1, combine_node_and_port => 0},
            graph  => {rankdir => 'TB'},
            node   => {color => 'blue', shape => 'oval'},
        )
    },
    is       => 'rw',
    #isa     => 'GraphViz2',
    required => 0,
);

sub read_file {
  open my $fh, '<:encoding(UTF-8)', $_[0] or die "$_[0]: $!";
  map +((chomp, $_)[1]), <$fh>;
}

sub _quote { my $t = $_[0]; $t =~ s/\\/\\\\/g; $t; }

sub create {
    my ($self, %arg) = @_;
    my (%edges, %labels, $rule);
    for my $line (read_file($arg{file_name}) ) {
        next if ($line !~ /\w/) || ($line !~ /^\s+\d+\s+/);
        $line =~ s/^\s+\d+\s+//;
        $rule = $1 if $line =~ s/([^ ]+) : ?//;
        $line =~ s/\|\s+//;
        my $text = $line =~ /^\s*$/ ? '(empty)' : $line;
        @{$edges{$rule}}{split ' ', $text} = (); # only needs to exist
        push @{$labels{$rule}}, $text;
    }
    for my $f (sort keys %edges) {
        $self->graph->add_node(name => $f, label => [$f, [ map _quote($_).'\l', @{$labels{$f}} ]]);
        $self->graph->add_edge(from => $f, to => $_, headport => 'port1')
            for sort grep $edges{$_}, keys %{$edges{$f} };
    }
    return $self;
}

1;

=head1 NAME

L<GraphViz2::Parse::Yacc> - Visualize a yacc grammar as a graph

=head1 Synopsis

    use GraphViz2;
    use GraphViz2::Parse::Yacc;
    my($graph)  = GraphViz2->new(
        edge   => {color => 'grey'},
        global => {directed => 1, combine_node_and_port => 0},
        graph  => {concentrate => 1, rankdir => 'TB'},
        node   => {color => 'blue', shape => 'oval'},
    );
    my $g = GraphViz2::Parse::Yacc->new(graph => $graph);
    $g->create(file_name => 't/calc3.output');
    my $format = shift || 'svg';
    my $output_file = shift || "output.$format");
    $graph->run(format => $format, output_file => $output_file);

See scripts/parse.yacc.pl (L<GraphViz2/Scripts Shipped with this Module>).

=head1 Description

Takes a yacc grammar and converts it into a graph.

=head1 Constructor and Initialization

=head2 Calling new()

C<new()> is called as C<< my($obj) = GraphViz2::Parse::Yacc->new(k1 => v1, k2 => v2, ...) >>.

It returns a new object of type C<GraphViz2::Parse::Yacc>.

Key-value pairs accepted in the parameter list:

=over 4

=item o graph => $graphviz_object

This option specifies the GraphViz2 object to use. This allows you to configure it as desired.

The default is GraphViz2->new. The default attributes are the same as in the synopsis, above.

This key is optional.

=back

=head1 Methods

=head2 create(file_name => $file_name)

Creates the graph, which is accessible via the graph() method, or via the graph object you passed to new().

Returns $self for method chaining.

$file_name is the name of a yacc output file. See t/calc3.output.

=head2 graph()

Returns the graph object, either the one supplied to new() or the one created during the call to new().

=head1 Thanks

Many thanks are due to the people who chose to make L<Graphviz|http://www.graphviz.org/> Open Source.

And thanks to L<Leon Brocard|http://search.cpan.org/~lbrocard/>, who wrote L<GraphViz>, and kindly gave me co-maint of the module.

=head1 Author

L<GraphViz2> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2011.

Home page: L<http://savage.net.au/index.html>.

=head1 Copyright

Australian copyright (c) 2011, Ron Savage.

All Programs of mine are 'OSI Certified Open Source Software';
you can redistribute them and/or modify them under the terms of
The Perl License, a copy of which is available at:
http://dev.perl.org/licenses/

=cut
