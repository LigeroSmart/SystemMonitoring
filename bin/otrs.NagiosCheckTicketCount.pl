#!/usr/bin/perl
# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std;

use Kernel::System::ObjectManager;

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'otrs.NagiosCheckTicketCount',
    },
);

# get options
my %Options;
getopts( 'hNc:', \%Options );
if ( $Options{h} ) {
    print
        "Usage: $FindBin::Script [-N (runs as Nagioschecker)] [-c /path/to/config_file]\n";
    print "\n";

    exit;
}

if ( !$Options{c} ) {
    print STDERR "ERROR: Need -c CONFIGFILE\n";

    exit 1;
}
elsif ( !-e $Options{c} ) {
    print STDERR "ERROR: No such file $Options{c}\n";

    exit 1;
}

# read config file
my %Config;
open( my $IN, '<', $Options{c} ) || die "ERROR: Can't open $Options{c}: $!\n";    ## no critic
my $Content = '';
while (<$IN>) {
    $Content .= $_;
}
if ( !eval {$Content} ) {
    print STDERR "ERROR: Invalid config file $Options{c}: $@\n";

    exit 1;
}

# search tickets
my $TicketCount = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
    %{ $Config{Search} },
    Limit  => 100_000,
    Result => 'COUNT',
    UserID => 1,
);

# no checker mode
if ( !$Options{N} ) {
    print "$TicketCount\n";

    exit 0;
}

# cleanup config file
my %Map = (
    max_crit_treshhold => 'max_crit_treshold',
    max_warn_treshhold => 'max_warn_treshold',
    min_crit_treshhold => 'min_crit_treshold',
    min_warn_treshhold => 'min_warn_treshold',
);
for my $Type ( sort keys %Map ) {
    if ( defined $Config{$Type} ) {
        print STDERR "NOTICE: Typo in config name, use $Map{$Type} instead of $Type\n";
        $Config{ $Map{$Type} } = $Config{$Type};
        delete $Config{$Type};
    }
}

# do critical and warning check
for my $Type (qw(crit_treshold warn_treshold)) {
    if ( defined $Config{ 'min_' . $Type } ) {
        if ( $Config{ 'min_' . $Type } >= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print
                    "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";

                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print
                    "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";

                exit 1;
            }
        }
    }
    if ( defined $Config{ 'max_' . $Type } ) {
        if ( $Config{ 'max_' . $Type } <= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print
                    "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";

                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print
                    "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";

                exit 1;
            }
        }
    }
}

# return OK
print
    "$Config{checkname} OK $Config{OK_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";

exit 0;
