use File::Spec;
use HTML::TreeBuilder;
use HTTP::Tiny;

my($page_name) = 'https://www.graphviz.org/doc/info/arrows.html';
my($client)    = HTTP::Tiny -> new -> get($page_name);
die "Failed to get $page_name: $$client{reason}. \n" if !$$client{success};

my($root)      = HTML::TreeBuilder -> new();
my $result     = $root->parse($$client{content}) || die "Can't parse: $page_name";
my(@node)      = $root -> look_down(_tag => 'table');
my @td         = $node[1]->look_down(_tag => 'td');

my @shape = grep length, map $_->as_text, @td;

my $file_name = File::Spec -> catfile('data', 'arrow.shapes.dat');
open my $fh, '>', $file_name or die "Can't open(> $file_name): $!";
print $fh map "$_\n", sort @shape;
