use strict;
use warnings;
use warnings  qw(FATAL utf8);    # Fatalize encoding glitches.

use GraphViz2::Filer;
use GraphViz2::Utils;

my $format = shift || die "Usage: $0 svg";
my $utils = GraphViz2::Utils->new;
my $outdir = $utils->config->{output_dir};
my %script = GraphViz2::Filer->new->get_scripts;

for my $key (sort keys %script) {
  my $file = "t/$key.t";
  local @ARGV = ($format, "$outdir/$key.$format");
  print "$file @ARGV\n";
  do "./$file";
  die if $@;
}

$utils->generate_demo_index;
