#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use 5.10.0;
use POSIX;

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

# having every line in an own array to iterate better with the rules
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

# for getting the results in one array
my @middle_num;

# holds the wrong results
my @wrong_records;

BEGIN: foreach my $record (@records){

    my $record_len = @$record;
    for(my $record_index = 0; $record_index < $record_len; $record_index++){

        foreach my $rule (@ruleset){

            if(${$record}[$record_index] == ${$rule}[0]){
                for(my $index = 0; $index < $record_index; $index++){

                    foreach my $rule (@ruleset){
                        if(${$record}[$index] == ${$rule}[1] && ${$record}[$record_index] == ${$rule}[0]){
                            push(@wrong_records, $record);
                            say(${$record}[$record_index], " - ", ${$record}[$index]);
                            next BEGIN;
                        }
                    }

                }
            }
        }
    }
    push(@middle_num, $record);
    next BEGIN;
}

my $result = 0;
my $count = 0;

foreach my $finding(@middle_num){
    $count++;
    my $finding_len = @$finding;
    my $half_finding_len = floor($finding_len / 2);
    $result += ${$finding}[$half_finding_len];
}

say($result);
say($count);

#begin of part 2


say("Start of Part 2");

my $check = 0;
my @correct_records;


foreach my $record (@wrong_records){
    my @corrected = sort{
            foreach my $rule (@ruleset){

                if($a == ${$rule}[0] && $b == ${$rule}[1]){
                            return -1;
                }elsif($b == ${$rule}[0] && $a == ${$rule}[1]){
                            return 1;
                }
            }
            return 0;
    } @$record;
    push(@correct_records, \@corrected);
}



$result = 0;
$count = 0;

foreach my $finding(@correct_records){
    my $finding_len = @$finding;
    my $half_finding_len = floor($finding_len / 2);
    $result += ${$finding}[$half_finding_len];
}

say($result);
