use strict;
use utf8;
use warnings;
use warnings qw(FATAL utf8);       # Fatalize encoding glitches.
use open qw(:std :utf8);           # Undeclared streams in UTF-8.
use charnames qw(:full :short);    # Unneeded in v5.16.

use Data::Dumper;
use Test::More;
use GraphViz2;

# ------------------------------------------------

my $GraphViz2 = GraphViz2->new();
my $count     = 0;

my %methods = (
    add_node => { id => 1, args => { name => 'TestNode1', label => 'n1' } },
    add_edge => { id => 2, args => { from => 'TestNode1', to    => '' } },
    default_subgraph  => { id => 3, args => {} },
    escape_some_chars => { id => 4, args => { $GraphViz2, "abc123[]()" } },
    push_subgraph => {
        id   => 5,
        args => {
            name  => 'subgraph_test',
            edge  => {},
            graph => { bgcolor => 'grey', label => 'subgraph_test' }
        }
    },
    pop_subgraph            => { id => 6,  args => {} },
    report_valid_attributes => { id => 7,  args => {} },
    run                     => { id => 8,  args => {} },
    run_map                 => { id => 9,  args => {} },
    run_mapless             => { id => 10, args => {} },
);
foreach my $sub ( sort { $methods{$a}{id} <=> $methods{$b}{id} } keys %methods )
{

    # Check we can call this function/method/sub
    $count++;
    can_ok( $GraphViz2, $sub );

    $count++;
    ok(
        $GraphViz2->$sub( %{ $methods{$sub}{'args'} } ),
        "Run $sub with -> "
          . join(
            ", ", map { "$_:$methods{$sub}{'args'}{$_}" } keys %{ $methods{$sub}{'args'} }
          )
    );
}
done_testing($count);

