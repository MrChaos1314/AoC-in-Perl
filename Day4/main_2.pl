#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use 5.10.0;

#get file for data
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

#put every line of data file in array
my @records;
while(<$fh>){
    chomp;
    my $line = $_;
    my @chars = split(//, $line);
    push(@records, \@chars);
}

my $records_len = @records;
my $chars_len = @{$records[0]};

my $counter = 0;

for(my $column = 0; $column < $records_len; $column++){
    for(my $row = 0; $row < $chars_len; $row++){
        if(${$records[$column]}[$row] eq "X"){
            ${$records[$column]}[$row] = " ";
        }
        if(${$records[$column]}[$row] eq "M"){

            if(checkDiagLeftUp($column, $row)){
                if($column - 2 >= 0){
                    if(${$records[$column - 2]}[$row] eq "M"){
                        if(checkDiagLeftDown($column - 2, $row)){
                            $counter++;
                            ${$records[$column - 1]}[$row - 1] = " ";
                            next;
                        }
                    }
                }

                if($row - 2 >= 0){
                    if(${$records[$column]}[$row - 2] eq "M"){
                        if(checkDiagRightUp($column, $row - 2)){
                            ${$records[$column - 1]}[$row - 1] = " ";
                            $counter++;
                            next;
                        }
                    }
                }
            }

            if(checkDiagRightDown($column, $row)){

                if(${$records[$column]}[$row + 2] eq "M"){
                    if(checkDiagLeftDown($column, $row + 2)){
                        ${$records[$column + 1]}[$row + 1] = " ";
                        $counter++;
                        next;
                    }
                }

                if(${$records[$column + 2]}[$row] eq "M"){
                    if(checkDiagRightUp($column + 2, $row)){
                        ${$records[$column + 1]}[$row + 1] = " ";
                        $counter++;
                        next;
                    }
                }
            }
        }
    } 
}

debug();
say($counter);

sub debug{
    for(my $column = 0; $column < $records_len; $column++){
        for(my $row = 0; $row < $chars_len; $row++){

            #this part does wierd shit
            if(${$records[$column]}[$row + 2] &&${$records[$column + 1]}[$row + 1] && ${$records[$column + 2]}[$row + 2] && ${$records[$column + 2]}[$row]){
                if(${$records[$column]}[$row] eq "M" && ${$records[$column]}[$row + 2] eq "M" && ${$records[$column + 1]}[$row + 1] eq "A" && ${$records[$column + 2]}[$row + 2] eq "S" && ${$records[$column + 2]}[$row] eq "S"){
                                        ${$records[$column + 1]}[$row + 1] = "U";
                                        $counter++;
                }
            }

            if(${$records[$column]}[$row + 2] &&${$records[$column + 1]}[$row + 1] && ${$records[$column + 2]}[$row + 2] && ${$records[$column + 2]}[$row]){
                if(${$records[$column]}[$row] eq "M" && ${$records[$column]}[$row + 2] eq "M" && ${$records[$column - 1]}[$row + 1] eq "A" && ${$records[$column - 2]}[$row + 2] eq "S" && ${$records[$column - 2]}[$row] eq "S"){
                                        ${$records[$column - 1]}[$row - 1] = "U";
                                        $counter++;
                }
            }
            if(${$records[$column]}[$row + 2] &&${$records[$column + 1]}[$row + 1] && ${$records[$column + 2]}[$row + 2] && ${$records[$column + 2]}[$row]){
                if(${$records[$column]}[$row] eq "M" && ${$records[$column + 2]}[$row] eq "M" && ${$records[$column + 1]}[$row - 1] eq "A" && ${$records[$column]}[$row - 2] eq "S" && ${$records[$column + 2]}[$row - 2] eq "S"){
                                        ${$records[$column + 1]}[$row + 1] = "U";
                                        $counter++;
                }
            }

            #this part does wierd shit
            if(${$records[$column]}[$row + 2] &&${$records[$column + 1]}[$row + 1] && ${$records[$column + 2]}[$row + 2] && ${$records[$column + 2]}[$row]){
                if(${$records[$column]}[$row] eq "M" && ${$records[$column + 2]}[$row] eq "M" && ${$records[$column + 1]}[$row + 1] eq "A" && ${$records[$column]}[$row + 2] eq "S" && ${$records[$column + 2]}[$row + 2] eq "S"){
                                        ${$records[$column + 1]}[$row + 1] = "U";
                                        $counter++;
                }
            }

            print(${$records[$column]}[$row]);
        }
        print("\n");
    }
}

sub checkDiagLeftUp{
    my $y = shift;
    my $x = shift;

    if($x - 1 < 0 || $y - 1 < 0){ return 0}
    if(${$records[$y - 1]}[$x - 1] eq "A"){

        if($x - 2 < 0 || $y - 2 < 0){ return 0}
        if(${$records[$y - 2]}[$x - 2] eq "S"){

            return 1;
        }
    }

    return 0;
}

sub checkDiagRightUp{
    my $y = shift;
    my $x = shift;

    if($y - 1 < 0){ return 0}
    if(${$records[$y - 1]}[$x + 1] eq "A"){

        if($y - 2 < 0){ return 0}
        if(${$records[$y - 2]}[$x + 2] eq "S"){

            return 1;
        }
    }

    return 0;
}

sub checkDiagLeftDown{
    my $y = shift;
    my $x = shift;

        if($x - 1 < 0){ return 0}
    if(${$records[$y + 1]}[$x - 1] eq "A"){

            if($x - 2 < 0){ return 0}
        if(${$records[$y + 2]}[$x - 2] eq "S"){
            return 1;
        }
    }

    return 0;
}

sub checkDiagRightDown{
    my $y = shift;
    my $x = shift;

    if(${$records[$y + 2]}[$x + 2]){
        if(${$records[$y + 1]}[$x + 1] eq "A"){

            if(${$records[$y + 2]}[$x + 2] eq "S"){

                return 1;
            }
        }
    }

    return 0;
}
