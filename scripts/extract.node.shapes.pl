use File::Spec;
use HTML::TreeBuilder;
use HTTP::Tiny;

my($page_name) = 'http://www.graphviz.org/doc/info/shapes.html';
my($client)    = HTTP::Tiny->new->get($page_name);
die "Failed to get $page_name: $$client{reason}. \n" if !$$client{success};

my($root)      = HTML::TreeBuilder -> new();

# We want the contents of some <figcaption> tags.
# <figcaption> is valid HTML5, but HTML::TreeBuilder discards non-HTML4 tags.
# Tell the parser to allow us to see tags it doesn't know yet:
$root->ignore_unknown(0);

my($result)    = $root->parse($$client{content}) || die "Can't parse: $file_name";

my(@node) = $root->look_down(_tag => 'figcaption', class => 'gv-shape-caption');
my @shape = map { $_->as_text() } @node;

my $file_name = File::Spec->catfile('data', 'node.shapes.dat');
open my $fh, '>', $file_name or die "Can't open(> $file_name): $!";
print $fh map "$_\n", sort @shape;
