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

my @numbers;

while(<$fh>){
    chomp;
    my $line = $_;
    @numbers = split(//, $line);
}

my $id = 0;
my $changer = 0;

my @defrag;

foreach my $number (@numbers){
    if($changer == 0){
        for(my $iteration = 0; $iteration < $number; $iteration++){
            push(@defrag, $id);
        }
        $id++;
        $changer = 1;
    }else{
        for(my $iteration = 0; $iteration < $number; $iteration++){
            push(@defrag, ".");
        }
        $changer = 0;
    }
}

for(my $char_index = 0; $char_index < scalar @defrag; $char_index++){
    if($defrag[$char_index] eq "."){
        while($defrag[-1] eq "."){
            splice(@defrag, -1, 1);
        }
        $defrag[$char_index] = $defrag[-1];
        splice(@defrag, -1, 1);
        redo;
    }
}

my $result = 0;

for(my $index = 0; $index < scalar @defrag; $index++){
    my $temp = $index * $defrag[$index];
    $result = $result + $temp;
}

#91411296588 is too low
say($result);
