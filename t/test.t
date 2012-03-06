use open qw/:encoding(UTF-8) :std/;
use strict;
use warnings;

use Capture::Tiny 'capture';

use File::Spec;
use File::Temp;

use GraphViz2::Utils;

use Test::More;

# ------------------------------------------------

BEGIN{ use_ok('GraphViz2'); }

my($count)  = 1; # Counting the use_ok above.
my(%script) = GraphViz2::Utils -> new -> get_scripts;

# The EXLOCK option is for BSD-based systems.

my($temp_dir) = File::Temp -> newdir('temp.XXXX', CLEANUP => 1, EXLOCK => 0, TMPDIR => 1);

my($stdout, $stderr);

for my $key (sort keys %script)
{
		$count++;
		($stdout, $stderr) = capture{system $^X, '-Ilib', $script{$key}, 'svg', File::Spec -> catfile($temp_dir, "$key.svg")};

		ok(length($stderr) == 0, "$script{$key} runs without error");
}

done_testing($count);
