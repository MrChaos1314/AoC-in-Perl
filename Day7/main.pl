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

my @start_options = ([0], [1]);
for(my $solution_index = 0; $solution_index < scalar @solutions; $solution_index++){
    my $solution = $solutions[$solution_index];
    my $equation = $equations[$solution_index];
    my $math_map = calc_options(\@start_options, scalar @{$equation});
    for(my $map_index = 0; $map_index < scalar @{$math_map}; $map_index++){
        for(my $equation_index = 0; $equation_index < scalar @{$equation}; $equation_index++){
            #go through equations
        }
        #check if result is fine 
        for(){

        }
        #add array which holds the correct results 
    }
}


#0 = + ; 1 = * | simpler handling
my @options;

sub calc_options{
    my $temp = shift;
    my $cycle = shift;
    my @options = @$temp;


    if($cycle == 1){
        return \@options, $cycle;
    }else{

        my @temp;
        foreach my $option_ref (@options){
            for(my $adder = 0; $adder < 2; $adder++){
                    my @more_options;
                    push(@more_options, @$option_ref);
                    push(@more_options, $adder);
                    push(@temp, \@more_options);
                }
        }
        return calc_options(\@temp, $cycle - 1);
    }
}
