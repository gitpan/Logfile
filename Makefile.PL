#!perl
#                              -*- Mode: Perl -*- 
# Makefile.PL -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Tue Mar 26 16:20:48 1996
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Mon Sep 16 09:53:04 1996
# Language        : Perl
# Update Count    : 28
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1996, Universität Dortmund, all rights reserved.
# 
# $Locker: pfeifer $
# $Log: Makefile.PL,v $
# Revision 0.1.1.7  1997/01/20 09:05:27  pfeifer
# patch15: Changed code for determining if a Date parser is available.
#
# Revision 0.1.1.6  1996/04/02 08:26:56  pfeifer
# patch9: Fixed typos.
#
# Revision 0.1.1.5  1996/03/27 14:41:55  pfeifer
# patch6: Renamed Tools::Logfile to Logfile.
#
# Revision 0.1.1.4  1996/03/27 11:10:11  pfeifer
# patch5: Added support fro Tom Christiansen's GetDate.
#
# 

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
my $version = &get_version;

&rewrite('lib/Logfile/Base.pm', $version);

# we do not use Date::GetDate since it dumps core with perl 5.002 (!?)
eval "use GetDate;";
if ($@ eq "") {
  print "You have GetDate by Tom Christiansen.\n";
  print "Good!\n";
} else {
  eval "use Date::GetDate;";
  if ($@ eq "") {
    print "You have Date::GetDate by Tom Christiansen.\n";
    print "Good!\n";
  } else {
    eval "use Time::ParseDate; use Time::JulianDay;";
    if ($@ eq "") {
      print "You have the Time-modules by David Muir Sharnoff\n";
      print "Good!\n";
    } else {
      print "You dont' have the Time-modules by David Muir Sharnoff\n";
      print "Consider installing it!\n";
      print "I will use my crude version though\n";
    }    
  }
}

WriteMakefile(
              'NAME'	=> 'Logfile',
              'VERSION' => $version,
              'LIBS'	=> [''],   # e.g., '-lm' 
              'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
              'INC'	=> '',     # e.g., '-I/usr/include/other' 
              'dist'    => { COMPRESS=>"gzip", SUFFIX=>"gz" },
#              'MAN3PODS'=> {'pod/Logfile.pod' => 'Logfile.3'},
              );

sub rewrite {
    my ($file, $version) = @_;
    rename $file, $file.'.bak' or die "Could not rename $file: $!";
    open(IN, $file.'.bak') || die "Could not open $file.bak: $!";
    open(OUT, ">$file") || die "Could not open $file: $!";
    while (<IN>) {
        if (/^\$Logfile::VERSION = /) {
            print OUT "\$Logfile::VERSION = \$Logfile::VERSION = $version;\n";
        } else {
            print OUT;
        }
    }
    close(IN);
    close(OUT);
    unlink $file.'.bak';
}

sub get_version
{
    my ($version, $revision) = (5.0, 0);
    
    open(PATCH, "./patchlevel.h") || die "Could not open patchlevel.h: $!";
    while (<PATCH>) {
        if (/VERSION ([\d.]+)/) {
            $version = $1;
        }
        if (/PATCHLEVEL (\d+)/) {
            $revision = $1;
        }
    }
    sprintf("%5.3f", $version + $revision/1000);
}
