use File::Spec;
use HTML::TreeBuilder;
use HTTP::Tiny;

my($page_name) = 'http://www.graphviz.org/doc/info/shapes.html';
my($client)    = HTTP::Tiny->new->get($page_name);
die "Failed to get $page_name: $$client{reason}. \n" if !$$client{success};

my($root)      = HTML::TreeBuilder -> new();
my($result)    = $root->parse($$client{content}) || die "Can't parse: $file_name";
my(@node)      = $root -> look_down(_tag => 'table');
my @td         = $node[0]->look_down(_tag => 'td');

my @shape = map [$_->[0]->content_list]->[0], grep @$_, map [$_->look_down(_tag => 'a')], @td;

my $file_name = File::Spec->catfile('data', 'node.shapes.dat');
open my $fh, '>', $file_name or die "Can't open(> $file_name): $!";
print $fh map "$_\n", sort @shape;
