# Annotation: Test exit code and STDERR from driver

use strict;
use warnings;
use GraphViz2;
use Test::More;
use Test::Exception;

lives_ok {
  _new_graph()->run();
} 'no warning, normal run';

lives_ok {
    _new_graph()
        ->add_node(name => 'C', width => 1, label => 'much_too_long', fixedsize => 'true')
        ->add_edge(from => 'B', to => 'C')
        ->run();
} 'warning, no exception';

throws_ok {
    my $graph = _new_graph();
    shift @{$graph->command};
    $graph->run();
} qr/syntax error/, 'invalid input exception';

done_testing();

sub _new_graph {
    my $graph = GraphViz2->new(
        global => {directed => 1},
        graph  => {rankdir => 'TB'},
    );
    $graph->add_node(name => 'A');
    $graph->add_node(name => 'B');
    $graph->add_edge(from => 'A', to => 'B');
    return $graph;
}
