#!/usr/bin/perl


use warnings;
use strict;
use Data::Dumper;
use 5.10.0;

use lib '.';
use General;

my $mapFile = "./map.txt";

#Feld -> (bool) Makiert, 
#Karte -> (int) MaxBreite, (int) MaxLength
#General -> walkDirection, Position, goLeft/Right/Up/Down(), changeWalkDirection()

my $general = General->new({
        mapFile => $mapFile,
    });

my $count = 0;
my $test = 0;

for(my $option = 0; $option < $general->get_gridcells(); $option++){

    my %loopChecker;
    OUTER: while(1){
        while(!$general->is_up_blocked){

            if($general->is_out_of_bounce){
                last OUTER;
            }

            $general->go_up;

            my @position = $general->get_position;
            my $general_position = join(",", @position);
            $general_position = $general_position . "up";
            
            if(%loopChecker){
                if($loopChecker{$general_position}){
                    if($loopChecker{$general_position} eq "true"){
                        $count++;
                        last OUTER;      
                    }
                }else{
                    $loopChecker{$general_position} = "true";
                } 
            }else{
                $loopChecker{$general_position} = "true";
            }
        }
        while(!$general->is_right_blocked){

            if($general->is_out_of_bounce){
                last OUTER;
            }

            $general->go_right;

            my @position = $general->get_position;
            my $general_position = join(",", @position);
            $general_position = $general_position . "right";
            if(%loopChecker){
                if($loopChecker{$general_position}){
                    if($loopChecker{$general_position} eq "true"){
                        $count++;
                        last OUTER;      
                    }
                }
                else{
                    $loopChecker{$general_position} = "true";
                } 
            }else{
                $loopChecker{$general_position} = "true";
            }
        }
        while(!$general->is_down_blocked){

            if($general->is_out_of_bounce){
                last OUTER;
            }

            $general->go_down;

            my @position = $general->get_position;
            my $general_position = join(",", @position);
            $general_position = $general_position . "down";
            if(%loopChecker){
                if($loopChecker{$general_position}){
                    if($loopChecker{$general_position} eq "true"){
                        $count++;
                        last OUTER;      
                    }
                }else{
                    $loopChecker{$general_position} = "true";
                } 
            }else{
                $loopChecker{$general_position} = "true";
            }
        }
        while(!$general->is_left_blocked){

            if($general->is_out_of_bounce){
                last OUTER;
            }
            $general->go_left;

            my @position = $general->get_position;
            my $general_position = join(",", @position);
            $general_position = $general_position . "left";
            if(%loopChecker){
                if($loopChecker{$general_position}){
                    if($loopChecker{$general_position} eq "true"){
                        $count++;
                        last OUTER;      
                    }
                }
                else{
                    $loopChecker{$general_position} = "true";
                } 
            }else{
                $loopChecker{$general_position} = "true";
            }
        }
    }

    $test++;
    $general->print_map();
    $general->next_map();
    say("----------------");
    say("count: ", $count, " - cycle: ", $test);
    say("----------------");
}
