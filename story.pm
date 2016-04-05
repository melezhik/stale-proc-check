use DateTime;
use strict;

my $filter = config()->{'stale-proc-check'}->{filter};
my $filter_re = qr/$filter/;
my $history = config()->{'stale-proc-check'}->{history} || '1 minutes';

Test::More::note("filter: $filter");
Test::More::note("history: $history");

my $cnt = 0;

open(my $fh, '-|', "ps -eo pid,cmd,etime | grep $filter") or die $!;

while (my $line = <$fh>) {

      next unless $line=~/$filter_re/;

      $line=~/(\d+)\s+(.*)\s+(\S+)/ or next;

      my $pid = $1;
      my $cmd = $2;
      my $tm = $3;

      if ($tm=~/(\d+)-(\d\d:\d\d:\d\d)/){

        my $days = $1;

        my ($h,$m,$s)= split ':', $2;

        my $ptime = DateTime->now->add( days => - $days );

        my $check_time = DateTime->now()->subtract( reverse ( split /\s+/, $history ) );

        if ( DateTime->compare( $ptime, $check_time ) == -1 ){
            my %delta = $check_time->subtract_datetime( $ptime )->deltas;
            set_stdout('start_proc_data');
            set_stdout("pid: $pid");
            set_stdout("command: $cmd");
            set_stdout("time: $ptime");
            my $dt_fmt;
            $dt_fmt.="months: $delta{months} "   if $delta{months};
            $dt_fmt.="days: $delta{days} "       if $delta{days};
            $dt_fmt.="minutes: $delta{minutes} " if $delta{minutes};
            $dt_fmt.="seconds: $delta{seconds} " if $delta{seconds};
            set_stdout(
              "delta: $dt_fmt"
            );
            set_stdout('end_proc_data');
            $cnt++;

        }

    }

}

close $fh;


set_stdout("count: $cnt");
