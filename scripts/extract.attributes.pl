use File::Spec;
use HTML::TreeBuilder;
use HTTP::Tiny;

my($page_name) = 'http://www.graphviz.org/doc/info/attrs.html';
my($client)    = HTTP::Tiny -> new -> get($page_name);
die "Failed to get $page_name: $$client{reason}. \n" if !$$client{success};

my($root)    = HTML::TreeBuilder -> new();
my($result)  = $root->parse($$client{content}) || die "Can't parse: $page_name";
my(@node)    = $root -> look_down(_tag => 'table');
my @td       = $node[0]->look_down(_tag => 'td');
my($column)  = 0;
my(%context) =
	(
	 C => 'cluster',
	 E => 'edge',
	 G => 'graph',
	 N => 'node',
	 S => 'subgraph',
	);

my(@column, @user);

for my $c0 (map { $_->as_text() } @td) {
	# Column 0 = 'Name', column 1 = 'Used By':
	if ($column == 0) {
		push @column, $c0;
	} elsif ($column == 1) {
		push @user, join(', ', map{$context{$_} } split(//, $c0) );
	}
	$column = ($column + 1) % 6;
}

my $file_name = File::Spec -> catfile('data', 'attributes.dat');
open my $fh, '>', $file_name or die "Can't open(> $file_name): $!";
print $fh map "$column[$_] => $user[$_]\n", 0 .. $#column;
