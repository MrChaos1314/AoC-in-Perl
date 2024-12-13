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

my @solutions;
my @equations;

while(<$fh>){
    chomp;
    my $line = $_;
    my @solution;
    my @equation;
    if($line =~ s/(\d+): //){
        push(@solution, $1); 
        push(@solutions, \@solution);
    }
    push(@equation, split(/ /, $line));
    push(@equations, \@equation);
}

my @start_options = ([0], [1], [2]);
my $count = 0;
my $result = 0;

AGAIN: for(my $solution_index = 0; $solution_index < scalar @solutions; $solution_index++){
    $count++;
    say($count);
    my $solution = $solutions[$solution_index];
    my $equation = $equations[$solution_index];
    my ($math_map, $cycle) = calc_options(\@start_options, scalar @{$equation} - 1);
    my @math = @$math_map;
    foreach my $math_parts (@math){
        my $calc = ${$equation}[0];
        for(my $math_index = 0; $math_index < scalar @{$math_parts}; $math_index++){
            if(${$math_parts}[$math_index] == 0){
                $calc = $calc + ${$equation}[$math_index + 1];
            }elsif(${$math_parts}[$math_index] == 1){
                $calc = $calc * ${$equation}[$math_index + 1];
            }elsif(${$math_parts}[$math_index] == 2){
                $calc = $calc . ${$equation}[$math_index + 1];
            }
        }
        if($calc == ${$solution}[0]){
            if($result == 0){
                $result = $calc;
                next AGAIN;
            }else{
                $result = $result + $calc;
                next AGAIN;
            }
        }
    }
}

say($result);


#0 = + ; 1 = * | simpler handling
sub calc_options{
    my $temp = shift;
    my $cycle = shift;
    my @options = @$temp;


    if($cycle == 1){
        return \@options, $cycle;
    }else{

        my @temp;
        foreach my $option_ref (@options){
            for(my $adder = 0; $adder < 3; $adder++){
                my @more_options;
                push(@more_options, @$option_ref);
                push(@more_options, $adder);
                push(@temp, \@more_options);
            }
        }
        return calc_options(\@temp, $cycle - 1);
    }
}
