#                              -*- Mode: Perl -*- 
# Logfile.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Mon Mar 25 09:58:31 1996
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Thu May 23 16:13:17 1996
# Language        : Perl
# Update Count    : 179
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1996, Universität Dortmund, all rights reserved.
# 
# $Locker: pfeifer $
# $Log: Base.pm,v $
# Revision 0.1.1.10  1996/05/23 14:15:01  pfeifer
# patch11: Added $Logfile::MAXWIDTH.
#
# Revision 0.1.1.9  1996/04/02 08:27:24  pfeifer
# patch9: Added multidimensional indexes.
#
# Revision 0.1.1.8  1996/04/01 09:35:59  pfeifer
# patch8: More flexible report generation. Fields to list are now
# patch8: completely configurable.
#
# Revision 0.1.1.7  1996/03/27 16:06:28  pfeifer
# patch7: Added List and Reverse option.
#
# Revision 0.1.1.6  1996/03/27 14:41:41  pfeifer
# patch6: Renamed Tools::Logfile to Logfile.
#
# Revision 0.1.1.5  1996/03/27 11:10:17  pfeifer
# patch5: Added support fro Tom Christiansens GetDate.
#
# Revision 0.1.1.4  1996/03/26 15:17:17  pfeifer
# patch4: Added Time/String.pm in data section.
#
# Revision 0.1.1.3  1996/03/26 14:53:22  pfeifer
# patch3: Now can take advantage of the ParseDate module by David Muir
# patch3: Sharnoff.
#
# Revision 0.1.1.2  1996/03/26 13:50:13  pfeifer
# patch2: Renamed module to Logfile and Logfile.pm to
# patch2: Logfile/Base.pm
#
# Revision 0.1.1.1  1996/03/25 11:19:14  pfeifer
# patch1:
#
# 

package Logfile::Base;
use Carp;

$Logfile::VERSION = $Logfile::VERSION = 0.112;
$Logfile::MAXWIDTH = 40;

$Logfile::nextfh = 'fh000';

sub new {
    my $type = shift;
    my %par  = @_;
    my $self = {};
    my $file = $par{File};

    if (ref $par{Group}) {
        $self->{Group} = $par{Group};
    } else {
        $self->{Group} = [$par{Group}];
    }       
    if ($file) {
        *S = $self->{Fh} = "${type}::".++$Logfile::nextfh;
        if ($file =~ /\.gz$/) {
            open(S, "gzip -cd $file|") 
                or die "Could not open $file: $!\n";
        } else {
            open(S, "<$file") 
                or die "Could not open $file: $!\n";
        }
    } else {
        $self->{Fh} = *STDIN;
    }
    bless $self, $type || ref($type);
    $self->readfile;
    close S if $self->{File};
    $self;
}

sub norm { $_[2]; }             # dummy

sub group {
    my ($self, $group) = @_;

    if (ref($group)) {
        join $;, @{$group};
    } else {
        $group;
    }
}

sub key {
    my ($self, $group, $rec) = @_;
    my $key = '';

    if (ref($group)) {
        $key = join $;, map($self->norm($_, $rec->{$_}), @{$group});
    } else {
        $key = $self->norm($group, $rec->{$group});
    }
    $key;
}

sub readfile {
    my $self  = shift;
    my $fh    = $self->{Fh};
    my @group = @{$self->{Group}};
    my $group;

    while (!eof($fh)) {
        my $rec = $self->next;
        last unless $rec;
        for $group (@group) {
            my $gname = $self->group($group);
            my $key = $self->key($group, $rec);
            if (defined $self->{$gname}->{$key}) {
                $self->{$gname}->{$key}->add($rec,$group); # !!
            } else {
                $self->{$gname}->{$key} = $rec->copy;
            }
        }
    }
}

sub report {
    my $self  = shift;
    my %par = @_;
    my $group = $self->group($par{Group});
    my $sort  = $par{Sort} || $group;
    my $rever = (($sort =~ /Date|Hour/) xor $par{Reverse});
    my $list  = $par{List};
    my ($keys, $key, $val, %keys);
    my $mklen  = length($group); 
    my $direction = ($rever)?'increasing':'decreasing';
    my (@list, %absolute);
    my @mklen = map(length($_), split($;, $group));

    croak "No index for $group\n" unless $self->{$group};

    if ($list) {
        if (ref($list)) {
            @list = @{$list};
        } else {
            @list = ($list);
        }
    } else {
        @list = (Records);
    }

    @absolute{@list} = (0) x @list;
    $sort =~ s/$;.*//;
    #print STDERR "sort = $sort\n";
    while (($key,$val) = each %{$self->{$group}}) {
        $keys{$key} = $val->{$sort};
        if ($key =~ /$;/) {
            my  @key = split $;, $key;
            for (0 .. $#key) {
                $mklen[$_] = length($key[$_])
                    if length($key[$_]) > $mklen[$_];
            }
            $mklen = $#mklen;
            grep ($mklen += $_, @mklen);
        } else {
            $mklen = length($key) if length($key) > $mklen;
        }
        for (@list) {
          $absolute{$_} += $val->{$_} if defined $val->{$_};
        }
    }
    # chop keys to $Logfile::MAXWIDTH chars maximum;
    grep (($_=($_>$Logfile::MAXWIDTH)?$Logfile::MAXWIDTH:$_), @mklen);
    if ($group =~ /$;/) {
        my @key =  split $;, $group;
        for (0 .. $#key) {
            printf "%-${mklen[$_]}s ", $key[$_];
        }
    } else {
        printf ("%-${mklen}s ", $group);
    }
    for (@list) {
        printf("%16s ", $_);
    }
    print "\n";
    print '=' x ($mklen + (@list * 17));
    print "\n";
    #for $key (keys %keys) {
    #    print STDERR "** $key $keys{$key}\n";
    #}
    for $key (sort {&srt($rever, $keys{$a}, $keys{$b})} 
              keys %keys) {
        my $val = $self->{$group}->{$key};
        if ($key =~ /$;/) {
            my @key =  split $;, $key;
            for (0 .. $#key) {
                printf "%-${mklen[$_]}s ", substr($key[$_],0,$mklen[$_]);
            }
        } else {
            printf "%-${mklen}s ", $key;
        }
        for $list (@list) {
            my $ba = (defined $val->{$list})?$val->{$list}:0;
            if ($absolute{$list} > 0) {
                my $br = $ba/$absolute{$list}*100;
                printf "%9d%6.2f%% ", $ba, $br;
            } else {
                printf "%16s", $ba;
            }
        }
        print "\n";
        last if defined $par{Top} && --$par{Top} <= 0;
    }
    print "\f";
}

sub srt {
    my $rev = shift;
    my ($y,$x);
    if ($rev) {
        ($x,$y) = @_;
    } else {
        ($y,$x) = @_;
    }

    if ($x =~ /[^\d.]|^$/o or $y =~ /[^\d.]|^$/o) {
        lc $y cmp lc $x;
    } else {
        $x <=> $y;
    }
}

sub keys {
    my $self  = shift;
    my $group = shift;

    keys %{$self->{$group}};
}

sub all {
    my $self  = shift;
    my $group = shift;

    %{$self->{$group}};
}

package Logfile::Base::Record;

BEGIN {
    eval "use GetDate;";
    $Logfile::HaveGetDate = ($@ eq "");
    unless ($Logfile::HaveGetDate) {
        eval "use Time::ParseDate;";
        $Logfile::HaveParseDate = ($@ eq "");
    }
};

unless ($Logfile::HaveGetDate or $Logfile::HaveParseDate) {
    eval join '', <DATA>;
}

use Net::Country;

sub new {
    my $type = shift;
    my %par  = @_;
    my $self = {};
    my ($sec,$min,$hours,$mday,$mon,$year, $time);

    %{$self} = %par;

    if ($par{Date}) {
        if ($Logfile::HaveGetDate) {
            $par{Date} =~ s!(\d\d\d\d):!$1 !o;
            $par{Date} =~ s!/! !go;
            $time = getdate($par{Date});
        } elsif ($Logfile::HaveParseDate) {

            $time = parsedate($par{Date},
                                   FUZZY => 1,
                              NO_RELATIVE => 1);
        } else {
            $time = &Time::String::to_time($par{Date});
        }
        ($sec,$min,$hours,$mday,$mon,$year) = localtime($time);
        $self->{Hour}  = sprintf "%02d", $hours;
        $self->{Date}  = sprintf("%02d%02d%02d", $year, $mon+1, $mday);
    }
    if ($par{Host}) {
        my $host = $self->{Host}   = lc($par{Host});
        if ($host =~ /[^\d.]/) {
            if ($host =~ /\./) {
                $self->{Domain} = Net::Country::Name((split /\./, $host)[-1]);
            } else {
                $self->{Domain} = 'Local';
            }
        } else {
            $self->{Domain} = 'Unresolved';
        }
    }
    $self->{Records} = 1;

    bless $self, $type;
}

sub add {
    my $self   = shift;
    my $other  = shift;
    my $ignore = shift;

    for (keys %{$other}) {
        next if $_ eq $ignore;
        next unless defined $other->{$_};
        next unless length($other->{$_});
        next if $other->{$_} =~ /\D/;
        $self->{$_} += $other->{$_};
    }

    $self;
}

sub copy {
    my $self = shift;
    my %new  = %{$self};

    bless \%new, ref($self);
}

sub requests {$_[0]->{Records};}

1;

__DATA__

package Time::String;

use Time::Local;

@moname = (Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec);

$monreg = '(' . join('|', @moname) . ')';

{ my $i = 0;
  for (@moname) {
      $monnum{lc($_)} = $i++;
  }
}

sub to_time {
    my $date = shift;
    my($sec,$min,$hours,$mday,$mon,$year);

    #print "$date => ";
    if ($date =~ s!\b(\d+)/(\d+)/(\d+)\b! !) {
        ($mon, $mday, $year) = ($1, $2, $3);
        $mon--;
    } elsif ($date =~ s!\b(\d+)/(\w+)/(\d+)\b! !) {
        ($mday, $mon, $year) = ($1, $monnum{lc($2)}, $3);
    } elsif ($date =~ s!\b(\d+)\s+(\w+)\s+(\d+)\b! !) {
        ($mday, $mon, $year) = ($1, $monnum{lc($2)}, $3);
    } elsif ($date =~ s!\b$monreg\b(\s+(\d+))?! !io) {
        $mon = $monnum{lc($1)};
        $mday = $3;             # possibly not set
        if ($date =~ s/19(\d\d)/ /) {
            $year = $1;
        }
    }
    if ($date =~ s!\b(\d+):(\d+)(:(\d+))?! !) {
        ($hours, $min, $sec) = ($1, $2, $4);
    }
    $year -= 1900 if $year > 1900;
    
    #print "($sec,$min,$hours,$mday,$mon,$year);";

    my $gmtime = timegm($sec,$min,$hours,$mday,$mon,$year);
    if ($date =~ s!([-+]\d+)! !) {
        $gmtime += $1*36;
    }
    $gmtime;
}

1;
