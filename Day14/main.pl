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

my @start_pos;
my @velocity;

while(<$fh>){
    chomp;
    my $line = $_;
    my @numbers = $line =~ /(-?\d+)/g;
    my @first_part = @numbers[0..1];
    my @second_part = @numbers[2..3];
    push(@start_pos, \@first_part);
    push(@velocity, \@second_part);
}

#x 101 wide 
#y 103 tall

my %map;
my %robos;

#robos holding robos{id, velocity_x, velocity_y} = pos_x,pos_y

for(my $x = 0; $x < 101; $x++){
    for(my $y = 0; $y < 103; $y++){
        $map{"$x,$y"} = ".";
    }
}

#manufacture with robos
foreach my $position (@start_pos){
    my $value = 0;
    my $x = ${$position}[0];
    my $y = ${$position}[1];
    if($map{"$x,$y"} eq "."){
        $value = 1;
        $map{"$x,$y"} = $value;
    }else{
        $value = $map{"$x,$y"};
        $value++;
        $map{"$x,$y"} = $value;
    }
}

for(1..100){

    print_map();
}

#TODO: make dependend from robos
sub print_map{
    my $start = 0;
    foreach my $key (sort keys %map){
        my @key_parts = split(/,/, $key);
        if($start != $key_parts[0]){
            $start = $key_parts[0];
            print("\n");
        }
        print($map{$key});
    }
    print("\n");
}
