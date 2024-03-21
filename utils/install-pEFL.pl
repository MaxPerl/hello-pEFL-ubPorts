use strict;
use warnings;
use Cwd;

my ($installdir) = @ARGV;

print "Download pEFL\n";
system('wget https://cpan.metacpan.org/authors/id/P/PE/PERLMAX/pEFL-0.72.tar.gz');

print "Extract pEFL\n";
system('tar -xf ./pEFL-0.72.tar.gz');

system('rm ./pEFL-0.72.tar.gz');

print "change directory\n";
chdir("./pEFL-0.72");

print "Build pEFL\n";

open my $fh, "<", "./Makefile.PL";
my $line = '';
foreach my $l (<$fh>) {
	$line = $line . $l;
}

$line =~ s/'perl',/'perl', CC => \"aarch64-linux-gnu-gcc-9\", LD => \"aarch64-linux-gnu-gcc-9\", CCFLAGS => "-Dusecrosscompile -Dtargethost=arm -Dtargetarch=arm-linux -Dcc=aarch64-linux-gnu-gcc-9", /;
$line =~ s/all => \{/all => \{CC => \"aarch64-linux-gnu-gcc-9\", LD => \"aarch64-linux-gnu-gcc-9\", CCFLAGS => "-Dusecrosscompile -Dtargethost=arm -Dtargetarch=arm-linux -Dcc=aarch64-linux-gnu-gcc-9", /;
print "MAKEFILE : $line \n";
close $fh;

open my $fh2, ">", "./Makefile.PL";
print $fh2 $line;
close $fh2;
system("perl ./Makefile.PL PREFIX=$installdir");
system("make");
system("make install");
