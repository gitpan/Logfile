package Logfile::Apache;
require Logfile::Base;

@ISA = qw ( Logfile::Base ) ;

sub next {
    my $self = shift;
    my $fh = $self->{Fh};

    my ($line,$host,$user,$pass,$rest,
	$date,$req,$code,$bytes,$file,$proto,$hour);

    while ($line = <$fh>) {
	#print "$line\n";
	($host,$user,$date,$rest) = 
	    $line =~ m,^([^\s]+)\s+-\s+([^ ]+)\s+\[(.*?)\]\s+(.*),;
        next unless $rest;
	($date,$hour) = split ':', $date;
        $rest =~ s/"//g;
        ($req, $file, $proto, $code, $bytes) = split ' ', $rest;
        last if $date;
    }

    return undef unless $date;
    $user =~ s/\s+//g;
    #print "($host,$user,$file,$date,$req,$code,$bytes)\n";
    #print $line unless $req;
    Logfile::Base::Record->new(Host  => $host,
                          Date  => $date,
                          File  => $file,
                          Bytes => $bytes,
                          User => $user,
                          );
}

sub norm {
    my ($self, $key, $val) = @_;

    if ($key eq File) {
        $val =~ s/\?.*//;           # remove that !!!
        $val = '/' unless $val;
        $val =~ s/\.\w+$//;
        $val =~ s!%([\da-f][\da-f])!chr(hex($1))!eig;
        $val =~ s!~(\w+)/.*!~$1!;
        # proxy
        $val =~ s!^((http|ftp|wais)://[^/]+)/.*!$1!;
        # confine to depth 3
        my @val = split /\//, $val;
        $#val = 2 if $#val > 2;
        #printf STDERR "$val => %s\n", join('/', @val) || '/';
        join('/', @val) || '/';
    } elsif ($key eq Bytes) {
        $val =~ s/\D.*//;
    } else {
        $val;
    }
}

1;
