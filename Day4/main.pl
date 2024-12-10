#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use 5.10.0;


my $fh;
my $fileLocation = $ARGV[0];

if(!$fileLocation){
    say("pls give a file!");
    exit(1);
}

if(!(open($fh, "<", $fileLocation))){
    say("WTF is going on - is this even a file???");
    exit(1);
}

my @records;
while(<$fh>){
    chomp;
    my $line = $_;
    my @chars = split(//, $line);
    push(@records, \@chars);
}

my $records_len = @records;
my $chars_len = @{$records[0]};

say($chars_len);
my $counter = 0;

for(my $column = 0; $column < $records_len; $column++){
    for(my $row = 0; $row < $chars_len; $row++){

        if(${$records[$column]}[$row] eq "X"){
            $counter += checkLeft($column, $row);
            $counter += checkRight($column, $row);
            $counter += checkUp($column, $row);
            $counter += checkDown($column, $row);
            $counter += checkDiagLeftUp($column, $row);
            $counter += checkDiagRightUp($column, $row);
            $counter += checkDiagLeftDown($column, $row);
            $counter += checkDiagRightDown($column, $row);
        }
    } 
}

#say(Dumper(@records));
say($counter);

sub checkLeft{
    my $y = shift;
    my $x = shift;

    if(${$records[$y]}[$x - 1] eq "M"){

        if($x - 1 < 0){ return 0}
        if(${$records[$y]}[$x - 2] eq "A"){

            if($x - 2 < 0){ return 0}
            if(${$records[$y]}[$x - 3] eq "S"){

                if($x - 3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}

sub checkRight{
    my $y = shift;
    my $x = shift;

    if(${$records[$y]}[$x + 1] eq "M"){
        if(${$records[$y]}[$x + 2] eq "A"){
            if(${$records[$y]}[$x + 3] eq "S"){
                return 1;
            }
        }
    }

    return 0;
}

sub checkDown{
    my $y = shift;
    my $x = shift;

    if(${$records[$y + 1]}[$x] eq "M"){
        if(${$records[$y + 2]}[$x] eq "A"){
            if(${$records[$y + 3]}[$x] eq "S"){
                return 1;
            }
        }
    }

    return 0;
}

sub checkUp{
    my $y = shift;
    my $x = shift;

    if(${$records[$y - 1]}[$x] eq "M"){

        if($y - 1 < 0){ return 0}
        if(${$records[$y - 2]}[$x] eq "A"){

            if($y - 2 < 0){ return 0}
            if(${$records[$y - 3]}[$x] eq "S"){

                if($y - 3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}

sub checkDiagLeftUp{
    my $y = shift;
    my $x = shift;

    if(${$records[$y - 1]}[$x - 1] eq "M"){

        if($x - 1 < 0 || $y - 1 < 0){ return 0}
        if(${$records[$y - 2]}[$x - 2] eq "A"){
            
            if($x < 0 || $y < 0){ return 0}
            if(${$records[$y - 3]}[$x - 3] eq "S"){

                if($x-3 < 0 || $y-3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}

sub checkDiagRightUp{
    my $y = shift;
    my $x = shift;

    if(${$records[$y - 1]}[$x + 1] eq "M"){

        if($x + 1 < 0 || $y - 1 < 0){ return 0}
        if(${$records[$y - 2]}[$x + 2] eq "A"){

            if($x + 2 < 0 || $y - 2 < 0){ return 0}
            if(${$records[$y - 3]}[$x + 3] eq "S"){

                if($x + 3 < 0 || $y - 3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}

sub checkDiagLeftDown{
    my $y = shift;
    my $x = shift;

    if(${$records[$y + 1]}[$x - 1] eq "M"){

        if($x - 1 < 0 || $y + 1 < 0){ return 0}
        if(${$records[$y + 2]}[$x - 2] eq "A"){

            if($x - 2 < 0 || $y + 2 < 0){ return 0}
            if(${$records[$y + 3]}[$x - 3] eq "S"){

                if($x - 3 < 0 || $y + 3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}

sub checkDiagRightDown{
    my $y = shift;
    my $x = shift;

    if(${$records[$y + 1]}[$x + 1] eq "M"){

        if($x + 1 < 0 || $y + 1 < 0){ return 0}
        if(${$records[$y + 2]}[$x + 2] eq "A"){

            if($x + 2 < 0 || $y + 2 < 0){ return 0}
            if(${$records[$y + 3]}[$x + 3] eq "S"){
                
                if($x + 3 < 0 || $y + 3 < 0){ return 0}
                return 1;
            }
        }
    }

    return 0;
}
