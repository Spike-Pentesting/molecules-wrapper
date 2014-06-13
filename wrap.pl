#!/usr/bin/perl
use feature 'say';
use Cwd;
my $cwd=cwd();
my @Wrap_scripts = <scripts/*>;
say "Modifying:";
say "\t" . $_ for @Wrap_scripts;

foreach my $script (@Wrap_scripts) {
    my $Molecules_script = $script;
    $Molecules_script =~ s/\_wrap//g;
    $Molecules_script = "molecules/" . $Molecules_script;
    open my $FILE, "<$Molecules_script";
    my @MOLECULE_FILE = <$FILE>;
    close $FILE;
    open my $FILE, "<$script";
    my @WRAP_FILE = <$FILE>;
    close $FILE;
    my $c     = 0;
    my $guard = quotemeta("/etc/profile");
    say "Molecules file <$Molecules_script> is " . @MOLECULE_FILE . " lines";
    for (@MOLECULE_FILE) {
        if ( $_ =~ $guard ) {
            say "Found $guard at " . $c.", good";
            $c++;
            last;
        }
        $c++;
    }
    die("Something went wrong with $Molecules_script, i could not find $guard in molecules scripts"
    ) unless $c != @MOLECULE_FILE;
    splice @MOLECULE_FILE, $c, 0, @WRAP_FILE;
    $script =~ s/scripts\///g;
    open my $OUTPUT, ">$cwd/gen/" . $script;
    print $OUTPUT @MOLECULE_FILE;
    close $OUTPUT;
    chmod 755, "$cwd/gen/" . $script;
}
