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

my %occurence;

for(my $row = 0; $row < scalar @records; $row++){
    for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
        my $char = ${$records[$row]}[$column];
        if(!isInHash($row, $column, $char)){
            consumeField($row, $column, $char);
        }
    }
}

sub isInHash{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;
    foreach my $key (%occurence){
        my @info = split(/,/, $key);
        my $info_y = shift(@info);
        my $info_x = shift(@info);
        my $info_char = shift(@info);
        if($info_x eq $cur_x && $info_y eq $cur_y && $info_char && $char){
            return 1;
        }
    }
    return 0;
}

sub consumeField{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;

    #consume self
    $occurence{"$cur_y,$cur_x,$char"} = "yes";

    #check surrounding and consume it too
    check_up($cur_y, $cur_x, $char);
    check_down($cur_y, $cur_x, $char);
    check_left($cur_y, $cur_x, $char);
    check_right($cur_y, $cur_x, $char);
}

sub check_up{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;

    my $new_y = $cur_y - 1;
    my $new_x = $cur_x;

    #TODO: think about what is needed and needs to be checked
    if(${$records[$new_y]}[$new_x] eq $char){
        if($occurence{"$new_y,$new_x,$char"}){

        }else{
            $occurence{"$new_y,$new_x,$char"} = "yes";
        }
    }
}

sub check_down{
    my $cur_y = shift;
    my $cur_x = shift;

}

sub check_left{
    my $cur_y = shift;
    my $cur_x = shift;

}

sub check_right{
    my $cur_y = shift;
    my $cur_x = shift;

}
