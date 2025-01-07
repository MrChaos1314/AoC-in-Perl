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
    say(Dumper @numbers);
    push(@start_pos, \@first_part);
    push(@velocity, \@second_part);
}

close($fh);

#x 0..102 tall
#y 0..100 wide 

my $width = 6;
my $length = 10;

my %map;    #map{x,y} = number of robots;
my @map_array;
my %robos;  #robos{id, velocity_x, velocity_y} = pos_x,pos_y


#write infos to the robos
for(my $index = 0; $index < scalar @velocity; $index++){

    my $vel_x = ${$velocity[$index]}[0];
    my $vel_y = ${$velocity[$index]}[1];

    my $pos_x = ${$start_pos[$index]}[0];
    my $pos_y = ${$start_pos[$index]}[1];

    $robos{"$index,$vel_y,$vel_x"} = "$pos_y,$pos_x";
}

#first reset init the map
reset_map();
print_map();
set_robos_on_map();
print_map();


for(1..100){
    reset_map();
    calc_set_new_robo_pos();
    set_robos_on_map();
    print_map();
}

calc_quadrant();

##########################################################

sub print_map{
    my $start = 0;
    foreach my $key (sort extend_map_sort  keys %map){
        my @key_parts = split(/,/, $key);
        if($start != $key_parts[0]){
            $start = $key_parts[0];
            print("\n");
        }
        print($map{$key});
    }
    print("\n\n");
}

sub extend_map_sort{
    my @a_info = split(/,/, $a);
    my $y_a = $a_info[0];
    my $x_a = $a_info[1];

    my @b_info = split(/,/, $b);
    my $y_b = $b_info[0];
    my $x_b = $b_info[1];


    $y_a <=> $y_b

        or

    $x_a <=> $x_b;
}

sub reset_map{
    for(my $y = 0; $y <= $width; $y++){
        for(my $x = 0; $x <= $length; $x++){
            $map{"$y,$x"} = ".";
        }
    }
}

#set robos on the map with current pos
sub set_robos_on_map{
    foreach my $robo_key (keys %robos){

        my $value = 0;

        my @pos_y_x = split(/,/, $robos{$robo_key});
        my $y = $pos_y_x[0];
        my $x = $pos_y_x[1];

        if($map{"$y,$x"} eq "."){
            $value = 1;
            $map{"$y,$x"} = $value;
        }else{
            $value = $map{"$y,$x"};
            $value++;
            $map{"$y,$x"} = $value;
        }
    }
}


#y 0..$length tall
#x 0..$width wide 

sub calc_set_new_robo_pos{
    foreach my $robo_key (keys %robos){
        my @robo_velocity = split(/,/, $robo_key);
        #0 index is the robo id!!
        my $vel_y = $robo_velocity[1];
        my $vel_x = $robo_velocity[2];

        my @old_pos = split(/,/, $robos{$robo_key});

        my $old_y = $old_pos[0];
        my $old_x = $old_pos[1];

        #calc pos for x and y with the given velocity of the robot

        my $new_y = $old_y + $vel_y;
        if($new_y < 0){
            $new_y += $width + 1;        
        }elsif($new_y > $width){
            $new_y -= $width + 1;
        }

        my $new_x = $old_x + $vel_x;
        if($new_x < 0){
            $new_x += $length + 1; 
        }elsif($new_x > $length){
            $new_x -= $length + 1;
        }

        #set the velocity to the robot
        $robos{$robo_key} = "$new_y,$new_x";
    }
}

sub calc_quadrant{
    my @temp;
    my $value = 0;
    foreach my $map_key (sort extend_map_sort keys %map){

        my @info = split(/,/, $map_key);
        my $change_check = $info[0];
        if($value != $change_check){
            $value = $change_check;
            my @copy = @temp;
            push(@map_array, \@copy);
            @temp = ();
        }

        push(@temp, $map{$map_key});
    }
        my @copy = @temp;
        push(@map_array, \@copy);
        @temp = ();

    # TODO: go trough map array and calc the safty factor for each quadrant 
}
