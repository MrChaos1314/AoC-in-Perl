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
    my @nums = split(//, $line);
    push(@records, \@nums);
}

my $zeros_ref = get_zero_positions();
my %zeros = %$zeros_ref; 


my $result = 0;

foreach my $zero (sort keys %zeros){
    my @info = split(/,/,$zero);
    my $num = shift(@info);
    my $row = shift(@info);
    my $column = shift(@info);

    my %temp = ("$num,$row,$column" => "yes");
    my %pos;
    my ($whole_ways, $amount_ways, $useless) = walker(\%temp, \%pos, $num);

    say(Dumper(sort keys %$whole_ways));
    say(Dumper($whole_ways));

    #add something to destinct doubles

    $result += calc_ends($whole_ways);

}

print_map();
say($result);


#----------------------------------------# 

sub get_zero_positions{

    my %zero_pos;

    for(my $row = 0; $row < scalar @records; $row++){
        for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
            if(${$records[$row]}[$column] == 0){
                $zero_pos{"${$records[$row]}[$column],$row,$column,none"} = "yes";
            }
        }
    }

    return \%zero_pos;
}

sub walker{
    my $num_info_ref = shift;
    my $pos_ref = shift;
    my $look_at = shift;
    my %num_info = %$num_info_ref;

    if($look_at == 9){
        return $num_info_ref, $pos_ref;
    }

    foreach my $nums (sort keys %num_info){
        my @info = split(/,/, $nums);
        my $num = shift(@info);
        my $row = shift(@info);
        my $column = shift(@info);
        my $direction = shift(@info);
        if($look_at == $num){
            #do checks
            check_up($num_info_ref, $pos_ref, $row, $column, $num+1, $direction);
            check_down($num_info_ref, $pos_ref,$row, $column, $num+1, $direction);
            check_left($num_info_ref, $pos_ref,$row, $column, $num+1, $direction);
            check_right($num_info_ref, $pos_ref,$row, $column, $num+1, $direction);
        }
    }
    walker($num_info_ref, $pos_ref, $look_at + 1);
}

sub killer{
    my $num_info_ref = shift;
    my $look_at = shift;
    my %num_info = %$num_info_ref;

    if($look_at == 9){
        return $num_info_ref;
    }

    foreach my $nums (sort keys %num_info){
        my @info = split(/,/, $nums);
        my $num = shift(@info);
        my $row = shift(@info);
        my $column = shift(@info);
        my $direction = shift(@info);
        if($look_at == $num){
            #do checks
            if(check_up($num_info_ref, $row, $column, $num-1, $direction)){
                next;
            }
            if(check_down($num_info_ref, $row, $column, $num-1, $direction)){
                next;
            }
            if(check_left($num_info_ref, $row, $column, $num-1, $direction)){
                next;
            }
            if(check_right($num_info_ref, $row, $column, $num-1, $direction)){
                next;
            }
        }
    }
    killer($num_info_ref, $look_at - 1);
}

sub check_up{
    my $num_info_ref = shift;
    my $pos_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($row - 1 >= 0 && $row - 1 < scalar @records){
        if(${$records[$row - 1]}[$column] == $needed_num){
            my $temp = $row - 1;
            if($num_info_ref->{"${$records[$temp]}[$column],$temp,$column,up"}){
                my $value = $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,up"};
                $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,up"} = ++$value;
            }else{
                $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,up"} = 1;
            }
            if($pos_ref->{"${$records[$temp]}[$column]"}){
                my $value = $pos_ref->{${$records[$temp]}[$column]};
                $pos_ref->{"${$records[$temp]}[$column]"} = ++$value;
            }else{
                $pos_ref->{"${$records[$temp]}[$column]"} = 1;
            }
        }
    }
}

sub check_down{
    my $num_info_ref = shift;
    my $pos_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($row + 1 >= 0 && $row + 1 < scalar @records){
        if(${$records[$row + 1]}[$column] == $needed_num){
            my $temp = $row + 1;
            if($num_info_ref->{"${$records[$temp]}[$column],$temp,$column,down"}){
                my $value = $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,down"};
                $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,down"} = ++$value;
            }else{
                $num_info_ref->{"${$records[$temp]}[$column],$temp,$column,down"} = 1;
            }
            if($pos_ref->{${$records[$temp]}[$column]}){
                my $value = $pos_ref->{${$records[$temp]}[$column]};
                $pos_ref->{${$records[$temp]}[$column]} = ++$value;
            }else{
                $pos_ref->{${$records[$temp]}[$column]} = 1;
            }
        }
    }
}

sub check_left{
    my $num_info_ref = shift;
    my $pos_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($column - 1 >= 0 && $column - 1 < scalar @records){
        if(${$records[$row]}[$column - 1] == $needed_num){
            my $temp = $column - 1;
            if($num_info_ref->{"${$records[$row]}[$temp],$row,$temp,left"}){
                my $value = $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,left"};
                $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,left"} = ++$value;
            }else{
                $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,left"} = 1;
            }
            if($pos_ref->{${$records[$row]}[$temp]}){
                my $value = $pos_ref->{${$records[$row]}[$temp]};
                $pos_ref->{${$records[$row]}[$temp]} = ++$value;
            }else{
                $pos_ref->{${$records[$row]}[$temp]} = 1;
            }
        }
    }
}

sub check_right{
    my $num_info_ref = shift;
    my $pos_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($column + 1 >= 0 && $column + 1 < scalar @records){
        if(${$records[$row]}[$column + 1] == $needed_num){
            my $temp = $column + 1;
            if($num_info_ref->{"${$records[$row]}[$temp],$row,$temp,right"}){
                my $value = $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,right"};
                $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,right"} = ++$value;
            }else{
                $num_info_ref->{"${$records[$row]}[$temp],$row,$temp,right"} = 1;
            }
            if($pos_ref->{${$records[$row]}[$temp]}){
                my $value = $pos_ref->{${$records[$row]}[$temp]};
                $pos_ref->{${$records[$row]}[$temp]} = ++$value;
            }else{
                $pos_ref->{${$records[$row]}[$temp]} = 1;
            }
        }
    }
}

sub check_up_kill{
    my $num_info_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($row - 1 >= 0 && $row - 1 < scalar @records){
        if(${$records[$row - 1]}[$column] == $needed_num){
            return 1;
        }else{
            return 0;
        }
    }
}

sub check_down_kill{
    my $num_info_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($row + 1 >= 0 && $row + 1 < scalar @records){
        if(${$records[$row + 1]}[$column] == $needed_num){
            return 1;
        }else{
            return 0;
        }
    }
}

sub check_left_kill{
    my $num_info_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($column - 1 >= 0 && $column - 1 < scalar @records){
        if(${$records[$row]}[$column - 1] == $needed_num){
            return 1;
        }else{
            return 0;
        }
    }
}

sub check_right_kill{
    my $num_info_ref = shift;
    my $row = shift;
    my $column = shift;
    my $needed_num = shift;

    if($column + 1 >= 0 && $column + 1 < scalar @records){
        if(${$records[$row]}[$column + 1] == $needed_num){
            return 1;
        }else{
            return 0;
        }
    }
}


sub calc_ends{
    my $topo_info_ref = shift;
    my $result = 0;
    foreach my $num_infos (reverse sort keys %$topo_info_ref){
        my @info = split(/,/, $num_infos);
        my $num = shift(@info);
        if($num != 9){
            last;
        }
        $result += $topo_info_ref->{$num_infos};
    }
    return $result;

}

sub print_map{
    for(my $row = 0; $row < scalar @records; $row++){
        for(my $column = 0; $column < scalar @{$records[$row]}; $column++){
            print ${$records[$row]}[$column];
        }
        print("\n");
    }
}

