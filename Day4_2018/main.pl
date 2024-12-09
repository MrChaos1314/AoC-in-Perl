#!/usr/bin/perl


use warnings;
use strict;
use 5.10.0;

use Data::Dumper;


my $fh;
if(!$ARGV[0]){
    say("give the file u wanna solve!");
    exit(1);
}

my $fileLocation = $ARGV[0];

if(!(open($fh, "<", $fileLocation))){
    say("Brother what are u opening for a file");
    exit(1);
}

my @records;
while(<$fh>){
    chomp;
    my $line = $_;
    push(@records, $line);

}

#sort yyyy-mm-dd if same than sort hours than sort minutes
@records = sort{$a =~ s/.*?(\d+-\d+-\d+).*/$1/rgm cmp $b =~ s/.*?(\d+-\d+-\d+).*/$1/rgm or $a =~ s/.*?(\d+:\d+).*/$1/rgm cmp $b =~ s/.*?(\d+:\d+).*/$1/rgm} @records;

my %sleepMap;

my $guard;
my $sleepy = 0;

#asign every guard its total sleep_minutes
foreach my $entry(@records){


    #match Guard
    if($entry =~ /Guard #(\d+)/){
        $guard = $1;
    }
        if($guard == 2411){
            say($entry);
        }

    #match falls Asleep
    if($entry =~ /falls/){
        if($entry =~ /\d+:(\d+)/){
            $sleepy = $1;
        }
    }

    #match wakes up
    if($entry =~ /wakes/){
        if($entry =~ /\d+:(\d+)/){
            my $temp = $1;

            $temp = $temp - $sleepy;

            if($sleepMap{$guard}){
                my $newValue = $sleepMap{$guard} + $temp;
                $sleepMap{$guard} = $newValue;
            }else{
                $sleepMap{$guard} = $temp;
            }
        }
    }
}

print(Dumper(\%sleepMap));

#get guard with total sleep minutes
my $guard_id;
my $big_number;

foreach my ($k,$v) (%sleepMap){
    if($big_number){
        if($v > $big_number){
            $big_number = $v;
            $guard_id = $k;
        }
    }else{
        $big_number = $v;
    } 
}


my $long_nap = -1;
my $nap = 0;

#search longest nap
foreach my $entry(@records){
    $entry =~ /Guard #(\d+)/;
    my $guard;

    if(defined($1)){
        $guard = $1;
    }

    if($guard == $guard_id){
        #match Guard - we don't care
        if($entry =~ /Guard/gm){
        }

        #match falls Asleep
        if($entry =~ /falls/){
            if($entry =~ /\d+:(\d+)/){
                $nap = $1;
            }
        }

        #match wakes up
        if($entry =~ /wakes/){
            if($entry =~ /\d+:(\d+)/){
                my $temp = $1;
                $temp = $temp - $nap; 
                if($temp > $long_nap){
                    $long_nap = $temp;
                }
                $nap = 0;
            }
        }
    }
}

say($guard_id, " * ", $long_nap, " = ", $long_nap * $guard_id);
