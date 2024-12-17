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

my $part = $ARGV[1];
if(!$part){
    say("if u wanna part 2, pls write 2 after the file (./file.pl data.txt 2)");
}

if(!(open($fh, "<", $fileLocation))){
    say("WTF is going on - is this even a file???");
    exit(1);
}

my @records;
my %records_hash;
keys %records_hash = 2000000;

while(<$fh>){
    chomp;
    my $line = $_;
    @records = split(/ /, $line);
    foreach my $num (@records){
        $records_hash{$num} = 1;
    }
}

my $max = 25;
if($part == 2){
    $max = 75;
}

#for(my $cycle = 0; $cycle < $max; $cycle++){
#    say($cycle);
#    my %already_calced;
#    for(my $index = 0; $index < scalar @records; $index++){
#        my $numbers_len = length($records[$index]);
#        if($records[$index] == 0){
#            $records[$index] = 1;
#        }elsif($numbers_len % 2 == 0){
#            if($already_calced{$records[$index]}){
#                my @calc_info = split(/,/, $already_calced{$records[$index]});
#                splice(@records, $index, 1, $calc_info[0], $calc_info[1]);
#                $index++;
#            }else{
#                my @numbers = split(//,$records[$index]);
#                my $numbers_half = $numbers_len / 2;
#                my $left_nums;
#                my $right_nums;
#                for(my $left = 0; $left < $numbers_half; $left++){
#                    if($left_nums){
#                        $left_nums = $left_nums . $numbers[$left];
#                    }else{
#                        $left_nums = $numbers[$left];
#                    }
#                }
#                for(my $right = $numbers_half; $right < $numbers_len; $right++){
#                    if($right_nums){
#                        $right_nums = $right_nums . $numbers[$right];
#                    }else{
#                        $right_nums = $numbers[$right];
#                    }
#                }
#                
#                $already_calced{$records[$index]} = "$left_nums,$right_nums";
#                splice(@records, $index, 1, $left_nums, $right_nums);
#                $index++;
#            }
#        }else{
#            $records[$index] = $records[$index] * 2024;
#        }
#    }
#    say(Dumper(scalar @records));
#}

for(my $cycle = 0; $cycle < 6; $cycle++){
    say($cycle);
    say(Dumper(\%records_hash));
    my %already_calced;
    my @keys = keys %records_hash;
    foreach my $num (@keys){
        my $num_len = length($num);
        if($records_hash{$num} != 0){
            if($num == 0){
                #this is stupid -> change -> look 3 smallData TODO
                $records_hash{$num} = 1;
            }elsif($num_len % 2 == 0){
                if($already_calced{$num}){
                    my @calc_info = split(/,/, $already_calced{$num});
                    $records_hash{$num} = --$records_hash{$num};
                    if($records_hash{$calc_info[0]}){
                        my $value = $records_hash{$calc_info[0]};
                        $records_hash{$calc_info[0]} = ++$value;
                    }
                    if($records_hash{$calc_info[1]}){
                        my $value = $records_hash{$calc_info[1]};
                        $records_hash{$calc_info[1]} = ++$value;
                    }
                }else{
                    my @numbers = split(//,$num);
                    my $numbers_half = $num_len / 2;
                    my $left_nums;
                    my $right_nums;
                    for(my $left = 0; $left < $numbers_half; $left++){
                        if($left_nums){
                            $left_nums = $left_nums . $numbers[$left];
                        }else{
                            $left_nums = $numbers[$left];
                        }
                    }
                    for(my $right = $numbers_half; $right < $num_len; $right++){
                        if($right_nums){
                            $right_nums = $right_nums . $numbers[$right];
                        }else{
                            $right_nums = $numbers[$right];
                        }
                    }

                    $already_calced{$num} = "$left_nums,$right_nums";
                    $records_hash{$num} = --$records_hash{$num};
                    if($records_hash{$left_nums}){
                        $records_hash{$left_nums} = ++$records_hash{$left_nums};
                    }else{
                        $records_hash{$left_nums} = 1;
                    }
                    if($records_hash{$right_nums}){
                        $records_hash{$right_nums} = ++$records_hash{$right_nums};
                    }else{
                        $records_hash{$right_nums} = 1;
                    }
                }
            }else{
                $records_hash{$num} = --$records_hash{$num};
                if($records_hash{$num * 2024}){
                    $records_hash{$num * 2024} = ++$records_hash{$num * 2024};
                }else{
                    $records_hash{2024 * $num} = 1;
                }
            }
        }
    }
}


my $result = 0;
foreach my $key (keys %records_hash){
    $result += $records_hash{$key}; 
}

say($result);

