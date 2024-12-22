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
my $result = 0;
my %edges;
my @sides;
my @fields;

#go through every field which is not already cleared
for(my $row = 0; $row < scalar @records; $row++){
    for(my $column = 0; $column < scalar @{$records[$row]}; $column++){

        #passthrough the char (easier ig?)
        my $char = ${$records[$row]}[$column];
        #check if the current field wasn't used already
        if(!isInHash($row, $column, $char) && $char ne "." && $char ne " "){
            #get every fieldneighbour with the same char and mark it as used
            consumeField($row, $column, $char);

            calc_sides();
            my $field_amount = @fields;
            my $side_amount = @sides; #first sides needs to be calced!!

            $result = $result + ($field_amount * $side_amount);
            say($field_amount, " - ", $side_amount);

            clear_fields();
            print_fields();

            %edges = ();
            @sides = ();
            @fields = ();
        }
    }
}

say($result);

sub calc_sides{
    my @same_direction;
    
    #if too slow consider deleting the key of edges which where used (after foreach)
    foreach my $key (sort keys %edges){
        my @info = split(/,/, $key);
        if($info[2] eq "up"){
            push(@same_direction, $key); 
        }
    }
    getUpSide(\@same_direction);
    @same_direction = ();

    
    foreach my $key (sort keys %edges){
        my @info = split(/,/, $key);
        if($info[2] eq "down"){
            push(@same_direction, $key); 
        }
    }
    getDownSide(\@same_direction);
    @same_direction = ();


    foreach my $key (sort keys %edges){
        my @info = split(/,/, $key);
        if($info[2] eq "left"){
            push(@same_direction, $key); 
        }
    }
    getLeftSide(\@same_direction);
    @same_direction = ();


    foreach my $key (sort keys %edges){
        my @info = split(/,/, $key);
        if($info[2] eq "right"){
            push(@same_direction, $key); 
        }
    }
    getRightSide(\@same_direction);
    @same_direction = ();

    return -1;
}

sub getUpSide(){
    my $up_infos = shift;
    for(my $index = 0; $index < scalar @{$up_infos}; $index++){
        my $key = ${$up_infos}[$index];
        my @info = split(/,/, $key);
        my $cur_row = $info[0];
        my $start = $info[1];
        while(1){
            $index++;
            if($index == scalar @{$up_infos}){
                push(@sides, 1);
                $index--;
                last;
            }
            my $next_key = ${$up_infos}[$index];
            my @next_info = split(/,/, $next_key);
            if($next_info[0] != $cur_row){
                push(@sides, 1); 
                $start = $next_info[1];
                $index--;
                last;
            }
            if($start + 1 != $next_info[1]){
                push(@sides, 1); 
                $start = $next_info[1];
            }else{
                $start++;
            }
        }
    }
}

sub getDownSide(){
    my $up_infos = shift;
    for(my $index = 0; $index < scalar @{$up_infos}; $index++){
        my $key = ${$up_infos}[$index];
        my @info = split(/,/, $key);
        my $cur_row = $info[0];
        my $start = $info[1];
        while(1){
            $index++;
            if($index == scalar @{$up_infos}){
                push(@sides, 1);
                $index--;
                last;
            }
            my $next_key = ${$up_infos}[$index];
            my @next_info = split(/,/, $next_key);
            if($next_info[0] != $cur_row){
                push(@sides, 1); 
                $start = $next_info[1];
                $index--;
                last;
            }
            if($start + 1 != $next_info[1]){
                push(@sides, 1); 
                $start = $next_info[1];
            }else{
                $start++;
            }
        }
    }
}

sub getLeftSide(){
    my $up_infos = shift;
    my @temp = sort {
        my @a_info = split(/,/, $a);
        my @b_info = split(/,/, $b);

        $a_info[0] <=> $b_info[0]
        
            and
        $a_info[1] <=> $b_info[1];

    } @{$up_infos};
    $up_infos = \@temp;
    for(my $index = 0; $index < scalar @{$up_infos}; $index++){
        my $key = ${$up_infos}[$index];
        my @info = split(/,/, $key);
        my $cur_row = $info[0];
        my $start = $info[1];
        while(1){
            $index++;
            if($index == scalar @{$up_infos}){
                push(@sides, 1);
                $index--;
                last;
            }
            my $next_key = ${$up_infos}[$index];
            my @next_info = split(/,/, $next_key);
            if($next_info[1] != $start){
                push(@sides, 1); 
                $cur_row = $next_info[0];
                $index--;
                last;
            }
            if($cur_row + 1 != $next_info[0]){
                push(@sides, 1); 
                $cur_row = $next_info[0];
            }else{
                $cur_row++;
            }
        }
    }
}

sub getRightSide(){
    my $up_infos = shift;
    my @temp = sort {
        my @a_info = split(/,/, $a);
        my @b_info = split(/,/, $b);

        $a_info[0] <=> $b_info[0]
        
            and
        $a_info[1] <=> $b_info[1];

    } @{$up_infos};
    $up_infos = \@temp;
    for(my $index = 0; $index < scalar @{$up_infos}; $index++){
        my $key = ${$up_infos}[$index];
        my @info = split(/,/, $key);
        my $cur_row = $info[0];
        my $start = $info[1];
        while(1){
            $index++;
            if($index == scalar @{$up_infos}){
                push(@sides, 1);
                $index--;
                last;
            }
            my $next_key = ${$up_infos}[$index];
            my @next_info = split(/,/, $next_key);
            if($next_info[1] != $start){
                push(@sides, 1); 
                $cur_row = $next_info[0];
                $index--;
                last;
            }
            if($cur_row + 1 != $next_info[0]){
                push(@sides, 1); 
                $cur_row = $next_info[0];
            }else{
                $cur_row++;
            }
        }
    }
}

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
        $edges{"$cur_y,$cur_x,up"} = "yes";
        return;
        }
        return;
    }
    $edges{"$cur_y,$cur_x,up"} = "yes";
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
        $edges{"$cur_y,$cur_x,down"} = "yes";
        return;
        }
        return;
    }
    $edges{"$cur_y,$cur_x,down"} = "yes";
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
        $edges{"$cur_y,$cur_x,left"} = "yes";
        return;
        }
        return;
    }
    $edges{"$cur_y,$cur_x,left"} = "yes";
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
        $edges{"$cur_y,$cur_x,right"} = "yes";
        return;
        }
        return;
    }
    $edges{"$cur_y,$cur_x,right"} = "yes";
    return;
}

sub print_fields{
    foreach my $row (@records){
        foreach my $column (@{$row}){
            print $column;
        }
        print "\n";
    }
}

sub clear_fields{
    for(my $row = 0; $row < scalar @records; $row++){
        for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
            if(${$records[$row]}[$column] eq "."){
                ${$records[$row]}[$column] = " ";

            }
        }
    }
}
