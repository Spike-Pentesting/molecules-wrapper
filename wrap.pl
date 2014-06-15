#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

sub load_file($) {
    my $file = shift;
    open my $FILE, "<$file"
        or die("Something went very wrong, cannot open $file");
    my @LINES = <$FILE>;
    close $FILE;
    return @LINES;
}

sub write_file($@) {
    my $file = shift @_;
    my @OUT  = @_;
    open my $OUTPUT, ">$file"
        or die("Something went very wrong, cannot write $file");
    print $OUTPUT @OUT;
    close $OUTPUT;
    chmod 0755, $file;
}

my @Wrap_scripts = <scripts/*>;
say "Modifying:";
say "\t" . $_ for @Wrap_scripts;

foreach my $script (@Wrap_scripts) {
    my $Molecules_script = $script;
    $Molecules_script =~ s/\_wrap//g;
    $Molecules_script = "molecules/" . $Molecules_script;
    my @MOLECULE_FILE = load_file($Molecules_script);
    my @WRAP_FILE     = load_file($script);
    my $c             = 0;
    my $counter       = 0;
    my $guard         = quotemeta("/etc/profile");
    my $guard_2       = qr/exit 0/;
    say "Molecules file <$Molecules_script> is " . @MOLECULE_FILE . " lines";
    (   $_ =~ $guard
        ? ( say( "\tFound $guard at " . $c . ", good" ) and $c++ and last )
        : $c++
    ) for (@MOLECULE_FILE);
    (   $_ =~ $guard_2
        ? ( say( "\tFound $guard_2 at " . $counter . ", good" )
                and $counter++
                and last )
        : $counter++
    ) for ( reverse @MOLECULE_FILE );
    $counter = scalar(@MOLECULE_FILE) - $counter;
    $counter = @MOLECULE_FILE if ( $counter == 0 );
    my $split_array = 0;
    ( $_ =~ quotemeta("######END######")
        ? ( say "\tFound another hook on file at $split_array" and last )
        : $split_array++ )
        for (@WRAP_FILE);

    my @WRAP_FILE_2 = splice @WRAP_FILE, $split_array,
        ( ( scalar @WRAP_FILE ) - $split_array ); #Divide arrays, start from -> ##END##
    die("\tSomething went wrong with $Molecules_script, i could not find $guard in molecules scripts"
    ) unless $c != @MOLECULE_FILE;
    splice @MOLECULE_FILE, $c, 0, @WRAP_FILE; # Put the first part inside the first index
    splice @MOLECULE_FILE, $counter + @WRAP_FILE, 0, @WRAP_FILE_2; #Put the second part at the second guard

    $script =~ s/scripts\///g;
    write_file( "/tmp/" . $script, @MOLECULE_FILE );
}

