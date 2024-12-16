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

my ($num, $size, $rev_start, $rev_end);
my ($start, $end);
my $cur_index;

($num, $size, $rev_start, $rev_end) = get_reverse_numblock(-1);

while($rev_end){
    say($rev_end, " - ",scalar @defrag * -1 + 1);

    $cur_index = $rev_end + scalar @defrag;
    my $last_index = $rev_start + scalar @defrag;

    ($start, $end) = get_freespace($cur_index, $size);

    if($start != -1 && $end != -1){
        for(my $change_index = $start; $change_index <= $end; $size--, $change_index++){
            if($size == 0){
                last;
            }
            $defrag[$change_index] = $num;
        }
        for(my $rev_change_index = $rev_start; $rev_change_index > $rev_end; $rev_change_index--){
            $defrag[$rev_change_index] = ".";
        }
    }


    ($num, $size, $rev_start, $rev_end) = get_reverse_numblock($rev_end);
}



sub defrag_printer{
    for(my $index = 0; $index < scalar @defrag; $index++){
        print($defrag[$index]);
    }
    print("\n");
}

sub get_reverse_numblock{
    my $start = shift; 
    my $num_to_count = $defrag[$start];
    for(my $reverse_index = $start; $reverse_index > scalar @defrag * -1; $reverse_index--){
        if($defrag[$reverse_index] ne $num_to_count){
            my $size = abs($reverse_index - $start);
            return $num_to_count, $size, $start, $reverse_index; 
        } 
    }
}

sub get_freespace{
    my $len = shift; #index of $reverse
    my $size = shift;
    #from beginning looking for "."
    for(my $index = 0; $index < $len; $index++){
        #found dot then count them
        if($defrag[$index] eq "."){
            my $count = 0;
            #counting block of dots
            for(my $num_index = $index; $index < $len; $num_index++){
                #return the position of the dots if size is enough
                if($defrag[$num_index] ne "." && $size <= $count){
                    return $index, $num_index - 1; 
                }elsif($defrag[$num_index] ne "."){
                #not enough size so this is over - continue searching
                
                    $index = $num_index - 1; #-1 because it will be counted up - alternativly continue with label
                    last;
                }
                $count++;
            }
        }
    }

    #there are no freespaces for the current num_block
    return -1, -1;
}


my $result = 0;

for(my $index = 0; $index < scalar @defrag; $index++){
    print($defrag[$index]);
    if($defrag[$index] ne "."){
        my $temp = $index * $defrag[$index];
        $result = $result + $temp;
    }
}
print("\n");

say($result);



#this chunky could work but too much to debug properly
##go reverse
#for(my $dec_index = 1; $dec_index < scalar @defrag; $dec_index++){
#    #go reverse till new number
#    if($defrag[$dec_index * -1] ne "."){
#        my $cur_num = $defrag[$dec_index * -1];
#        for(my $sub_dec_index = $dec_index; $sub_dec_index < scalar @defrag; $sub_dec_index++){
#            if($defrag[($sub_dec_index + 1) * -1] ne $defrag[$sub_dec_index * -1]){
#                #if change than go from the beginning till reverse till new number
#                for(my $char_index = 0; $char_index < $sub_dec_index; $char_index++){
#                    if($defrag[$char_index] eq "."){
#                        my $free_count = 0;
#                        #count freespaces
#                        for(my $free_amount = $char_index; $free_amount < scalar @defrag; $free_amount++){
#                            if($defrag[$free_amount] ne "."){
#                                last;
#                            }
#                            $free_count++;
#                        }
#                        say($free_count);
#                        if($free_count >= $sub_dec_index - $dec_index + 1 && $sub_dec_index - $dec_index + 1 >= 0){
#                            #go from fitting freespace to end of fitting freespace
#                            for(my $insert = $char_index; $insert < $char_index + $sub_dec_index - $dec_index + 1; $insert++){
#                                $defrag[$insert] = $cur_num;
#                            }
#                            for(my $replace = $dec_index; $replace < $sub_dec_index +1; $replace++){
#                                $defrag[$replace * -1] = ".";
#                            }
#                            last;
#                        }
#                    }
#                }
#                $dec_index = $sub_dec_index;
#                defrag_printer();
#                last;
#            }
#        }
#    }
#}
