use Config;

use File::Spec;
use File::Temp;

use Module::Build;

# -----------------------------------------------

sub is_dot_installed
{
	# 1: Create a temp file containing DOT commands.
	# The EXLOCK option is for BSD-based systems.
	# newdir() croaks() if it fails, which is what we want.
	# Hence there is no need to use Try::Tiny.

	my($temp_dir) = File::Temp -> newdir('temp.XXXX', CLEANUP => 1, EXLOCK => 0, TMPDIR => 1);
	my($gv_file)  = File::Spec -> catfile($temp_dir, 'test.gv');

	# We use the deprecated 2-argument form of open in case
	# this code is run on an ancient version of Perl.

	open(OUT, ">$gv_file")                   || die "Can't create temp file: $!\n";
	print OUT "digraph graph_14 {node_14}\n" || die "Can't write to temp file: $!\n";
	close OUT                                || die "Can't close temp file: $!\n";

	# 2: Run dot to create an SVG file.

	my $stdout = `dot -Tsvg $gv_file`;

	# 3: If that failed, we die.

	die "Please install Graphviz from http://www.graphviz.org/\n" if ($stdout !~ m|</svg>|);

} # End of is_dot_installed.

# -----------------------------------------------

sub is_perl_recent
{
	# We want Perl V 5.12 or later, because we 'use feature qw/say unicode_strings/'.

	my(@version) = split(/\./, $Config{version});

	die "Please install Perl V 5.12 or later\n" if ($version[1] < 12);

} # End of is_perl_recent.

# -----------------------------------------------

is_dot_installed();
is_perl_recent();

Module::Build -> new
(
 module_name    => 'GraphViz2',
 license        => 'artistic_2',
 dist_abstract  => "A wrapper for AT&T's Graphviz",
 dist_author    => 'Ron Savage <ron@savage.net.au>',
 build_requires =>
 {
 	 Test::More=> 0.94,
# 	 Test::Pod  => 1.45, # Make it optional. See t/pod.t
 },
 configure_requires =>
 {
 	 Module::Build => 0.3800,
 },
 requires =>
 {
	Algorithm::Dependency       => 1.110,
	Capture::Tiny               => 0.10,
	Class::ISA                  => 0.36,
	Class::Load                 => 0.17,
	Date::Format                => 2.24,
	Data::Section::Simple       => 0.02,
	DBI                         => 1.616,
	File::Basename              => 2.77,
	File::Spec                  => 3.33,
	File::Temp                  => 0.22,
	File::Which                 => 1.09,
	Hash::FieldHash             => 0.10,
	HTML::Entities::Interpolate => 1.04,
	HTML::TreeBuilder           => 4.2,
	HTTP::Tiny                  => 0.012,
	IPC::Run                    => 0.90,
	Log::Handler                => 0.71,
	parent                      => 0.225,
	Parse::RecDescent           => 1.965001,
	perl                        => '5.14.2', # For the utf stuff.
	Perl6::Slurp                => 0.03,
	Scalar::Util                => 1.23,
	Set::Array                  => 0.23,
	strict                      => 0,
	Text::Xslate                => 1.2000,
	Tree::DAG_Node              => 1.06,
	Try::Tiny                   => 0.09,
	utf8                        => 0,
	warnings                    => 0,
	XML::Bare                   => 0,
	XML::Tiny                   => 2.06,
 },
) -> create_build_script();
