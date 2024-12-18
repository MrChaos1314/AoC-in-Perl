#!/usr/bin/perl

use warnings;
use strict;
use 5.10.0;
use Data::Dumper;

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

print(Dumper(\@records));

my %occurence;

for(my $row = 0; $row < scalar @records; $row++){
    for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
        if(!isInHash()){
            consumeField();
        }
    }
}

sub isInHash{
    my $cur_x = shift;
    my $cur_y = shift;
    foreach my $key (%occurence){
        my @info = split(/,/, $key);
        my $info_x = shift(@info);
        my $info_y = shift(@info);
        if($info_x eq $cur_x && $info_y eq $cur_y){
            return 1;
        }
    }
    return 0;
}

sub consumeField{
    my $cur_x = shift;
    my $cur_y = shift;
    my $checker = 1;
    #consume self

    my $value = "hier weitermachen";
    $occurence{"$cur_x,$cur_y,${$records[$cur_x]}[$cur_y]"} = $value;
    #check surrounding and consume it too
    while($checker){
        check_up($cur_x, $cur_y);
        check_down($cur_x, $cur_y);
        check_left($cur_x, $cur_y);
        check_right($cur_x, $cur_y);
    }
}
