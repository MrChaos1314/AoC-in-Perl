#!/usr/bin/perl


use warnings;
use strict;
use Data::Dumper;
use 5.10.0;

use lib '.';
use General;

my $mapFile = "./map.txt";

my $general = General->new({
        mapFile => $mapFile,
    });

outer: while(1){
    while(!$general->is_up_blocked){
        if($general->is_out_of_bounce){
            last outer;
        }
        $general->go_up;
    }
    while(!$general->is_right_blocked){
        if($general->is_out_of_bounce){
            last outer;
        }
        $general->go_right;
    }
    while(!$general->is_down_blocked){
        if($general->is_out_of_bounce){
            last outer;
        }
        $general->go_down;
    }
    while(!$general->is_left_blocked){
        if($general->is_out_of_bounce){
            last outer;
        }
        $general->go_left;
    }
}

$general->print_map();
print $general->count_marks();
