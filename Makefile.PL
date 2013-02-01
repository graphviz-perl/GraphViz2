use ExtUtils::MakeMaker;

if (open my $fh, '|dot', )
{
	close $fh;
}
else
{
	die "Please install Graphviz from http://www.graphviz.org/.\n";
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
 ($] ge '5.005') ?
 (
  AUTHOR   => 'Ron Savage (ron@savage.net.au)',
  ABSTRACT => "A wrapper for AT&T's Graphviz",
    ) : (),
 clean =>
 {
	 FILES => 'blib/* Makefile MANIFEST GraphViz2-*'
 },
 dist =>
 {
	 COMPRESS => 'gzip',
	 SUFFIX   => 'gz'
 },
	DISTNAME  => 'GraphViz2',
	NAME      => 'GraphViz2',
	LICENSE   => 'artistic_2',
 PL_FILES  => {},
 PREREQ_PM =>
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
 	Test::More                => 0.94,
# 	Test::Pod                   => 1.45, # Make it optional. See t/pod.t
	Text::Xslate                => 1.2000,
	Tree::DAG_Node              => 1.06,
	Try::Tiny                   => 0.09,
	utf8                        => 0,
	warnings                    => 0,
	XML::Bare                   => 0,
	XML::Tiny                   => 2.06,
 },
 VERSION_FROM => 'lib/GraphViz2.pm',
);
