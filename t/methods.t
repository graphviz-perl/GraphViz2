use strict;
use utf8;
use warnings;
use warnings qw(FATAL utf8);	   # Fatalize encoding glitches.

use File::Spec;
use File::Temp;
use GraphViz2;
use Graph;
use Test::More;
use Test::Snapshot;

# ------------------------------------------------

# The EXLOCK option is for BSD-based systems.

my($temp_dir)	= File::Temp -> newdir('temp.XXXX', CLEANUP => 1, EXLOCK => 0, TMPDIR => 1);
my $GraphViz2	= GraphViz2->new(
	im_meta => {URL => 'http://savage.net.au/maps/demo.4.html'}
);
my @methods	= (
	[ add_node => { args => [ name => 'TestNode1', label => 'n1' ] } ],
	[ add_edge => { args => [ from => 'TestNode1', to	=> '' ] } ],
	[ default_subgraph  => { } ],
	[ push_subgraph => {
		args => [
			name  => 'subgraph_test',
			edge  => {},
			graph => { bgcolor => 'grey', label => 'subgraph_test' }
		]
	} ],
	[ pop_subgraph => { } ],
	[ valid_attributes => { } ],
	[ run_map => {
		subname => 'run',
		args => [
			format => 'png',
			output_file => File::Spec -> catfile($temp_dir, 'test_more_run_map.png'),
			im_output_file => File::Spec -> catfile($temp_dir, 'test_more_run_map.map'),
			im_format => 'cmapx',
		],
	} ],
	[ run_mapless => {
		subname => 'run',
		args => [
			format => 'png',
			output_file => File::Spec -> catfile($temp_dir, 'test_more_run_mapless.png'),
		],
	} ],
);

foreach my $tuple ( @methods ) {
        my ($sub, $data) = @$tuple;
	my $subname = GraphViz2::_dor($data->{subname}, $sub);
	can_ok( $GraphViz2, $subname );
	ok
		$GraphViz2->$subname( @{ $data->{args} || [] } ),
		"Run $subname with -> " . ((explain $data->{args})[0] || '')
		;
}

is GraphViz2::escape_some_chars(q{\\\\"}, '\\{\\}\\|<>\\s"'), '\\\\\\"', 'quoting';

my $g = Graph->new(multiedged => 1, multivertexed => 1);
$g->set_edge_attribute_by_id(qw(a b), 'x', graphviz => { label => 'E1' });
$g->set_edge_attribute_by_id(qw(a b), 'y', graphviz => { label => 'E2' });
$g->set_vertex_attribute_by_id(qw(a), 'w', graphviz => { label => 'L1' });
$g->set_vertex_attribute_by_id(qw(a), 'z', graphviz => { label => 'L2' });
my $gv = GraphViz2->from_graph($g);
is_deeply_snapshot $gv->node_hash, 'mve nodes';
is_deeply_snapshot $gv->edge_hash, 'mve edges';

done_testing;
