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
my $result;
my @edges;
my @fields;

#go through every field which is not already cleared
for(my $row = 0; $row < scalar @records; $row++){
    for(my $column = 0; $column < scalar @{$records[$row]}; $column++){

        #passthrough the char (easier ig?)
        my $char = ${$records[$row]}[$column];
        say($char);
        #check if the current field wasn't used already
        if(!isInHash($row, $column, $char) && $char ne "." && $char ne ""){
            #get every fieldneighbour with the same char and mark it as used
            consumeField($row, $column, $char);

            my $field_amount = @fields;
            my $edge_amount = @edges;

            say($field_amount, " - ", $edge_amount);

            $result = $result + ($field_amount * $edge_amount);

            print_fields();
            clear_fields();

            @edges = ();
            @fields = ();
        }
    }
}

say($result);

sub isInHash{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;
    foreach my $key (keys %occurence){
        my @info = split(/,/, $key);
        my $info_y = shift(@info);
        my $info_x = shift(@info);
        my $info_char = shift(@info);
        if($info_x == $cur_x && $info_y == $cur_y && $info_char eq $char){
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
    ${$records[$cur_y]}[$cur_x] = ".";

    push(@fields, 1);

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

    if($new_y < scalar @records && $new_y >= 0){
        if(${$records[$new_y]}[$new_x] eq $char){
            if(${$records[$new_y]}[$new_x] eq "."){
                return;
            }else{
                consumeField($new_y, $new_x, $char);
                return;
            }
        }
        if(${$records[$new_y]}[$new_x] ne "."){
        push(@edges, 1);
        return;
        }
        return;
    }
    push(@edges, 1);
    return;
}

sub check_down{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;

    my $new_y = $cur_y + 1;
    my $new_x = $cur_x;

    if($new_y < scalar @records && $new_y >= 0){
        if(${$records[$new_y]}[$new_x] eq $char){
            if(${$records[$new_y]}[$new_x] eq "."){
                return;
            }else{
                consumeField($new_y, $new_x, $char);
                return;
            }
        }
        if(${$records[$new_y]}[$new_x] ne "."){
        push(@edges, 1);
        return;
        }
        return;
    }
    push(@edges, 1);
    return;

}

sub check_left{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;

    my $new_y = $cur_y;
    my $new_x = $cur_x - 1;

    if($new_x < scalar @{$records[$cur_y]} && $new_x >= 0){
        if(${$records[$new_y]}[$new_x] eq $char){
            if(${$records[$new_y]}[$new_x] eq "."){
                return;
            }else{
                consumeField($new_y, $new_x, $char);
                return;
            }
        }
        if(${$records[$new_y]}[$new_x] ne "."){
        push(@edges, 1);
        return;
        }
        return;
    }
    push(@edges, 1);
    return;
}

sub check_right{
    my $cur_y = shift;
    my $cur_x = shift;
    my $char = shift;

    my $new_y = $cur_y;
    my $new_x = $cur_x + 1;

    if($new_x < scalar @{$records[$new_y]} && $new_x >= 0){
        if(${$records[$new_y]}[$new_x] eq $char){
            if(${$records[$new_y]}[$new_x] eq "."){
                return;
            }else{
                consumeField($new_y, $new_x, $char);
                return;
            }
        }
        if(${$records[$new_y]}[$new_x] ne "."){
        push(@edges, 1);
        return;
        }
        return;
    }
    push(@edges, 1);
    return;
}

sub print_fields{
    foreach my $row (@records){
        foreach my $column (@{$row}){
            print $column;
        }
        print "\n";
    }
    say("");
}

sub clear_fields{
    for(my $row = 0; $row < scalar @records; $row++){
        for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
            if(${$records[$row]}[$column] eq "."){
                ${$records[$row]}[$column] = "";

            }
        }
    }
}
