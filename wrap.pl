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

sub get_index($@) {
    my $guard   = shift @_;
    my @ARRAY   = @_;
    my $counter = 0;
    (   $_ =~ $guard
        ? ( say( "\tFound $guard at " . $counter . ", good" )
                and $counter++
                and last )
        : $counter++
    ) for (@ARRAY);    #calculating $guard index
    return ( scalar @ARRAY ) + 1 if ( $counter == @ARRAY );
    return $counter;
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
    my $guard         = quotemeta("/etc/profile");      #put at the start
   # my $backup_guard  = quotemeta("#!/bin/bash");
    my $guard_2       = qr/exit 0/;                     #put at the end
    say "Molecules file <$Molecules_script> is " . @MOLECULE_FILE . " lines";
    my $c = get_index( $guard, @MOLECULE_FILE );    #calculating $guard index
    #$c = get_index( $backup_guard, @MOLECULE_FILE )
     #   if ( ( $c - 1 ) == @MOLECULE_FILE );
    my $counter = get_index( $guard_2, reverse @MOLECULE_FILE )
         ;    #calculating $guard_2 index
#     my $counter=@MOLECULE_FILE;
    $counter
      = ( $counter == 0 )
     ? scalar(@MOLECULE_FILE)
     : ( scalar(@MOLECULE_FILE) - $counter )
     ;    #Resetting index, since we reversed the array
    my $split_array = get_index( quotemeta("######END######"), @WRAP_FILE )
        ;    # calculating index of the ###END### tag
    $split_array--;
    say "\t Splitting array at $split_array";
    my @WRAP_FILE_2 = splice @WRAP_FILE, $split_array,
        ( ( scalar @WRAP_FILE ) - $split_array )
        ;    #Divide arrays, using ##END## as pivot
    die("\tSomething went wrong with $Molecules_script, i could not find $guard in molecules scripts"
        )
        unless $c != @MOLECULE_FILE
        ;    #At least, we should find $guard , $guard_2 is not necessary
    splice @MOLECULE_FILE, $c, 0,
        @WRAP_FILE;    # Put the first part inside the first index
    splice @MOLECULE_FILE, $counter + @WRAP_FILE, 0,
        @WRAP_FILE_2;    #Put the second part at the second guard

    $script =~ s/scripts\///g;
    write_file( "/tmp/" . $script, @MOLECULE_FILE );
}

