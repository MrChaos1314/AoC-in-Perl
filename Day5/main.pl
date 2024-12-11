#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use 5.10.0;

my $fh;

if(!($ARGV[0])){
    say("What is going on here? Give the file!");
    exit 1;
}

my $fileLocation = $ARGV[0];

if(!(open($fh, "<", $fileLocation))){
    say("Something went definetly wrong with accessing the file.");
    exit 1;
}

my @ruleset;
my @records;

while(<$fh>){
    chomp($_);
    my $line = $_;
    if($line =~ /(\d+)\|(\d+)/){
        my @temp;
        push(@temp, $1);
        push(@temp, $2);
        push(@ruleset, \@temp);
    }else{
        my @temp = split(/,/, $line);
        push(@records, \@temp);
    }
}

my $records_len = @records;
my $ruleset_len = @ruleset;

my @middle_num;

foreach my $record (@records){

    my $record_len = @$record;
    BEGIN: for(my $record_index = 0; $record_index < $record_len; $record_index++){

        foreach my $rule (@ruleset){
            if(${$record}[$record_index] == ${$rule}[0]){
                for(my $index = 0; $index < $record_index; $index++){
                    foreach my $rule (@ruleset){
                        if(${$record}[$index] == ${$rule}[1]){
                            next BEGIN;
                        }else{
                            #look where to actually push;
                            push(@middle_num, $record);
                        }
                    }
                }
            }
        }
    }
}

say(Dumper(@middle_num));


