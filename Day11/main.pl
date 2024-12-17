#!/usr/bin/perl

use warnings;
use strict;
use 5.10.0;
use Data::Dumper;
use Storable qw(dclone);

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
my %already_calced;

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


for(my $cycle = 0; $cycle < $max; $cycle++){
    say($cycle);
    my %records_fake = %{dclone \%records_hash};
    foreach my $num (keys %records_fake){
        my $num_len = length($num);
        if($records_fake{$num} != 0){
                if($num == 0){
                    if($records_hash{1}){
                        my $value = $records_hash{1};
                        $value = $value + 1 * $records_fake{$num};
                        $records_hash{1} = $value;
                    }else{
                        $records_hash{1} = 1;
                        my $value = $records_hash{1};
                        $value = $value + 1 * $records_fake{$num} - 1;
                        $records_hash{1} = $value;
                    }
                    my $dec = $records_hash{$num};
                    $dec = $dec - 1 * $records_fake{$num};
                    $records_hash{$num} = $dec;
                }elsif($num_len % 2 == 0){
                    if($already_calced{$num}){
                        my @calc_info = split(/,/, $already_calced{$num});
                        my $left = $calc_info[0];
                        my $right = $calc_info[1];
                        if($records_hash{$left}){
                            my $value = $records_hash{$left};
                            $value = $value + 1 * $records_fake{$num};
                            $records_hash{$left} = $value;
                        }else{
                            $records_hash{$left} = 1;
                            my $value = $records_hash{$left};
                            $value = $value + 1 * $records_fake{$num} - 1;
                            $records_hash{$left} = $value;
                        }
                        if($records_hash{$right}){
                            my $value = $records_hash{$right};
                            $value = $value + 1 * $records_fake{$num};
                            $records_hash{$right} = $value;
                        }else{
                            $records_hash{$right} = 1;
                            my $value = $records_hash{$right};
                            $value = $value + 1 * $records_fake{$num} - 1;
                            $records_hash{$right} = $value;
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
                        if($records_hash{$left_nums}){
                            my $value = $records_hash{$left_nums};
                            $value = $value + 1 * $records_fake{$num};
                            $records_hash{$left_nums} = $value;
                        }else{
                            $records_hash{$left_nums} = 1;
                            my $value = $records_hash{$left_nums};
                            $value = $value + 1 * $records_fake{$num} - 1;
                            $records_hash{$left_nums} = $value;
                        }
                        if($records_hash{$right_nums}){
                            my $value = $records_hash{$right_nums};
                            $value = $value + 1 * $records_fake{$num};
                            $records_hash{$right_nums} = $value;
                        }else{
                            $records_hash{$right_nums} = 1;
                            my $value = $records_hash{$right_nums};
                            $value = $value + 1 * $records_fake{$num} - 1;
                            $records_hash{$right_nums} = $value;
                        }
                    }
                        my $dec = $records_hash{$num};
                        $dec = $dec - 1 * $records_fake{$num};
                        $records_hash{$num} = $dec;
                }else{
                    if($records_hash{$num * 2024}){
                        my $value = $records_hash{$num * 2024};
                        $value = $value + 1 * $records_fake{$num};
                        $records_hash{$num * 2024} = $value;
                    }else{
                        $records_hash{2024 * $num} = 1;
                        my $value = $records_hash{$num * 2024};
                        $value = $value + 1 * $records_fake{$num} - 1;
                        $records_hash{$num * 2024} = $value;
                        say($records_hash{$num});
                    }
                        my $dec = $records_hash{$num};
                        $dec = $dec - 1 * $records_fake{$num};
                        $records_hash{$num} = $dec;
                }
        }
    }
}

print(Dumper(\%already_calced));

my $result = 0;
foreach my $key (keys %records_hash){
    $result += $records_hash{$key}; 
}

say($result);

