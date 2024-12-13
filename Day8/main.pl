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

#store coordinates with node to filter out double ones to get unique
my %result;

#row = y
#column = x

for(my $row = 0; $row < scalar @records; $row++){
    my @record = @{$records[$row]};
    for(my $column = 0; $column < scalar @record; $column++){
        if($record[$column] ne "."){
            my $cur_antenna = $record[$column];
            my $is_first_cycle = 1;
            for(my $row_continue = $row; $row_continue < scalar @records; $row_continue++){
                for(my $column_continue = 0; $column_continue < scalar @record; $column_continue++){
                    #starting at current point which is != "."
                    if($is_first_cycle){
                        $is_first_cycle = 0;
                        $column_continue = $column + 1; # to prevent checking current with current which is unnecessary
                    }
                    #checking for a antenna pair to calc the nodes
                    if(${$records[$row_continue]}[$column_continue] eq $cur_antenna){
                        my $new_y = $row_continue - $row;
                        my $new_x = $column_continue - $column;
                        $new_y = abs($new_y);
                        $new_x = abs($new_x);

                        #differenciate which direction goes the line
                        #line goes up-right
                        my $sub_of_vector_right_y = $row - $new_y;
                        my $sub_of_vector_right_x = $column + $new_x;

                        my $add_to_vector_right_y = $row_continue + $new_y;
                        my $add_to_vector_right_x = $column_continue - $new_x;

                        #line goes up-left
                        my $sub_of_vector_left_y = $row - $new_y;
                        my $sub_of_vector_left_x = $column - $new_x;

                        my $add_to_vector_left_y = $row_continue + $new_y;
                        my $add_to_vector_left_x = $column_continue + $new_x;

                        #if bigger than up-right
                        if($column >= $column_continue){
                            if($sub_of_vector_right_y >= 0 && $sub_of_vector_right_x >= 0 && $sub_of_vector_right_y < scalar @records && $sub_of_vector_right_x < scalar @record){
                                $result{"$sub_of_vector_right_y,$sub_of_vector_right_x"} = 1;
                            }
                            if($add_to_vector_right_y < scalar @records && $add_to_vector_right_x < scalar @record && $add_to_vector_right_y >= 0 && $add_to_vector_right_x >= 0){
                                $result{"$add_to_vector_right_y,$add_to_vector_right_x"} = 1;
                            }
                        }else{
                            if($sub_of_vector_left_y >= 0 && $sub_of_vector_left_x >= 0 && $sub_of_vector_left_y < scalar @records && $sub_of_vector_left_x < scalar @record){
                                $result{"$sub_of_vector_left_y,$sub_of_vector_left_x"} = 1;
                            }
                            if($add_to_vector_left_y < scalar @records && $add_to_vector_left_x < scalar @record && $add_to_vector_left_y >= 0 && $add_to_vector_left_x >= 0){
                                $result{"$add_to_vector_left_y,$add_to_vector_left_x"} = 1;
                            }
                        }
                    }
                }
            }
        }
    }
}

say(Dumper(\%result));

foreach my $k (keys %result){
    my @coor = split(/,/, $k);
    ${$records[$coor[0]]}[$coor[1]] = "#";
}

foreach my $row (@records){
    foreach my $data (@$row){
        print($data);
    }
    print("\n");
}

say(scalar keys(%result));
