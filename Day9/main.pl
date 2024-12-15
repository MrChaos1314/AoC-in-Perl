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

my @numbers;

while(<$fh>){
    chomp;
    my $line = $_;
    @numbers = split(//, $line);
}

my $id = 0;
my $changer = 0;

my @defrag;

foreach my $number (@numbers){
    if($changer == 0){
        for(my $iteration = 0; $iteration < $number; $iteration++){
            push(@defrag, $id);
        }
        $id++;
        $changer = 1;
    }else{
        for(my $iteration = 0; $iteration < $number; $iteration++){
            push(@defrag, ".");
        }
        $changer = 0;
    }
}

#go reverse
for(my $dec_index = 1; $dec_index < scalar @defrag; $dec_index++){
    #go reverse till new number
    if($defrag[$dec_index * -1] ne "."){
        my $cur_num = $defrag[$dec_index * -1];
        for(my $sub_dec_index = $dec_index; $sub_dec_index < scalar @defrag; $sub_dec_index++){
            if($defrag[($sub_dec_index + 1) * -1] ne $defrag[$sub_dec_index * -1]){
                #if change than go from the beginning till reverse till new number
                for(my $char_index = 0; $char_index < $sub_dec_index; $char_index++){
                    if($defrag[$char_index] eq "."){
                        my $free_count = 0;
                        #count freespaces
                        for(my $free_amount = $char_index; $free_amount < scalar @defrag; $free_amount++){
                            if($defrag[$free_amount] ne "."){
                                last;
                            }
                            $free_count++;
                        }
                        say($free_count);
                        if($free_count >= $sub_dec_index - $dec_index + 1 && $sub_dec_index - $dec_index + 1 >= 0){
                            #go from fitting freespace to end of fitting freespace
                            for(my $insert = $char_index; $insert < $char_index + $sub_dec_index - $dec_index + 1; $insert++){
                                $defrag[$insert] = $cur_num;
                            }
                            for(my $replace = $dec_index; $replace < $sub_dec_index +1; $replace++){
                                $defrag[$replace * -1] = ".";
                            }
                            last;
                        }
                    }
                }
                $dec_index = $sub_dec_index;
                defrag_printer();
                last;
            }
        }
    }
}


my $result = 0;

for(my $index = 0; $index < scalar @defrag; $index++){
    print($defrag[$index]);
    if($defrag[$index] ne "."){
        my $temp = $index * $defrag[$index];
        $result = $result + $temp;
    }
}

say($result);

sub defrag_printer{
    for(my $index = 0; $index < scalar @defrag; $index++){
        print($defrag[$index]);
    }
    print("\n");
}
