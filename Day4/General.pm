#!/usr/bin/perl
package General;

use strict;
use warnings;
use 5.10.0;

use Data::Dumper;

sub new{
    my ($class,$args) = @_;
    my $self = {
        mapFile => $args->{mapFile},
        fake_position => $args->{fake_position} || [0,0],
    };

    my $object = bless($self, $class);

    #map must be set before looking for position

    $self->{direction} = "up";
    $object->_set_map;
    $object->_set_position;

    return $object;
}

sub _set_map{
    my $self = shift;
    my $fileLocation = $self->{mapFile};

    my $fh;
    if(!(open($fh, "<", $fileLocation))){
        say "aaaaaaaaaaaaaaaaaaaaaaaa";
        return 1;
    }

    my @result = ();

    while(<$fh>){
        my $line = $_;
        chomp($line);

        my @charLine = split(//, $line);
        push(@result, \@charLine);
        
    }


    $self->{map} = \@result;
}

sub _set_position{
    my $self = shift;
    my $map = $self->{map};

    my @rows =  @$map;
    my $rows_len = @rows;

    my $row_len = @{$rows[0]};

    for(my $rows_index = 0; $rows_index < $rows_len; $rows_index++){
        my @row = @{$rows[$rows_index]};
        for(my $row_index = 0; $row_index < $row_len; $row_index++){
            my $char = $row[$row_index];        
            if($char eq "^"){
                $self->{position} = [$rows_index, $row_index];
                $self->{prev_position} = [$rows_index, $row_index];
            }
        }
    }
}

sub get_map{
    my $self = shift;
    my $mapRef = $self->{map};
    return (@$mapRef);
}

sub print_map{
    my $self = shift;
    my $rows = $self->{map};
    foreach my $row (@$rows){
        say(@$row);
    }
}

sub get_position{
    my $self = shift;
    my $positionRef = $self->{position};
    return (@$positionRef);
}

sub print_position{
    my $self = shift;
    my $positionRef = $self->{position};
    my $x_pos = $positionRef->[0];
    my $y_pos = $positionRef->[1];
    say("position: [$x_pos, $y_pos]");
}

sub print_direction{
    my $self = shift;
    my $directionStr = $self->{direction};
    say($directionStr);
}

sub _set_mark{
    my $self = shift;
    my $rowsRef = $self->{map};
    my $positionRef = $self->{prev_position};
    my @position = @$positionRef;
    my $row = $rowsRef->[$position[0]];
    $row->[$position[1]] = "X";
}

sub go_right{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos;
    my $next_x_pos = $cur_x_pos + 1;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$cur_y_pos];
    $row->[$cur_x_pos] = "X";

    my $next_pos_row = $rowsRef->[$next_y_pos];
    $next_pos_row->[$next_x_pos] = "^";

    $self->{prev_position} = [$cur_y_pos, $cur_x_pos];
    $self->{position} = [$next_y_pos, $next_x_pos];
    _set_mark($self);
}

sub go_left{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos;
    my $next_x_pos = $cur_x_pos - 1;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$cur_y_pos];
    $row->[$cur_x_pos] = "X";

    my $next_pos_row = $rowsRef->[$next_y_pos];
    $next_pos_row->[$next_x_pos] = "^";


    $self->{prev_position} = [$cur_y_pos, $cur_x_pos];
    $self->{position} = [$next_y_pos, $next_x_pos];
    _set_mark($self);
}


sub go_up{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos - 1;
    my $next_x_pos = $cur_x_pos;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$cur_y_pos];
    $row->[$cur_x_pos] = "X";

    my $next_pos_row = $rowsRef->[$next_y_pos];
    $next_pos_row->[$next_x_pos] = "^";


    $self->{prev_position} = [$cur_y_pos, $cur_x_pos];
    $self->{position} = [$next_y_pos, $next_x_pos];
    _set_mark($self);
}

sub go_down{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos + 1;
    my $next_x_pos = $cur_x_pos;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$cur_y_pos];
    $row->[$cur_x_pos] = "X";

    my $next_pos_row = $rowsRef->[$next_y_pos];
    $next_pos_row->[$next_x_pos] = "^";


    $self->{prev_position} = [$cur_y_pos, $cur_x_pos];
    $self->{position} = [$next_y_pos, $next_x_pos];
    _set_mark($self);
}

sub is_up_blocked{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos - 1;
    my $next_x_pos = $cur_x_pos;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$next_y_pos];
    if($row->[$next_x_pos] eq "#"){
        return 1;
    }

    return 0;
}

sub is_down_blocked{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos + 1;
    my $next_x_pos = $cur_x_pos;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$next_y_pos];
    if(!($row->[$next_x_pos])){
        return 0;
    }
    if($row->[$next_x_pos] eq "#"){
        return 1;
    }

    return 0;
}

sub is_left_blocked{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos;
    my $next_x_pos = $cur_x_pos - 1;

    my $rowsRef = $self->{map};

    my $row = $rowsRef->[$next_y_pos];
    if($row->[$next_x_pos] eq "#"){
        return 1;
    }

    return 0;
}


sub is_right_blocked{
    my $self = shift;
    my $map = $self->{map};

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $next_y_pos = $cur_y_pos;
    my $next_x_pos = $cur_x_pos + 1;

    my $rowsRef = $self->{map};
    my $row = $rowsRef->[$next_y_pos];

        if($row->[$next_x_pos] eq "#"){
            return 1;
        }

    return 0;
}

sub is_out_of_bounce{
    my $self = shift;

    my $cur_pos = $self->{position};
    my $cur_y_pos = @$cur_pos[0];
    my $cur_x_pos = @$cur_pos[1];

    my $map = $self->{map};

    my @rows =  @$map;
    my $rows_len = @rows;
    my $row_len = @{$rows[0]};


    if($cur_x_pos <= 0 || $cur_x_pos >= $rows_len || $cur_y_pos <= 0 || $cur_y_pos >= $row_len){
        return 1;
    }

    return 0;
}

sub count_marks{
    my $self = shift;
    my $map = $self->{map};

    my @rows =  @$map;
    my $rows_len = @rows;

    my $row_len = @{$rows[0]};

    my $result;
    for(my $rows_index = 0; $rows_index < $rows_len; $rows_index++){
        my @row = @{$rows[$rows_index]};
        for(my $row_index = 0; $row_index < $row_len; $row_index++){
            my $char = $row[$row_index];        
            if($char eq "X"){
                $result++;
            }
        }
    }
    return $result;
}

sub get_gridcells{
    my $self = shift;
    my $map = $self->{map};

    my @rows =  @$map;
    my $rows_len = @rows;
    my $row_len = @{$rows[0]};

    $self->{gridcells} = $rows_len * $row_len;
    return $self->{gridcells};
}

sub next_map{
    my $self = shift;
    _set_map($self);
    _set_position($self);
    my $map = $self->{map};

    my $cur_pos = $self->{fake_position};
    my $cur_x_pos = @$cur_pos[0];
    my $cur_y_pos = @$cur_pos[1];

    my @rows =  @$map;
    my $rows_len = @rows;
    my $row_len = @{$rows[0]};

    if($cur_y_pos >= $rows_len){
        say("Worked???");
    }
    if($cur_x_pos >= $row_len){
        $cur_x_pos = 0;
        $cur_y_pos++;
    }


    my $rowsRef = $self->{map};

        my $row = $rowsRef->[$cur_y_pos];
        $row->[$cur_x_pos] = "#";


    $cur_x_pos++;
    $self->{fake_position} = [$cur_x_pos, $cur_y_pos];
}

1;
