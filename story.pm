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

        #warn("$days -- $h,$m,$s");

        #my $ptime = DateTime->now()->add( days => -$days, hours => -$h, $minutes => -$m, seconds => -$s);

        my $ptime = DateTime->now->add( days => - $days );

        my $check_time = DateTime->now()->subtract( reverse ( split /\s+/, $history ) );

        if ( DateTime->compare( $ptime, $check_time ) == -1 ){
            set_stdout('start_proc_data');
            set_stdout("pid: $pid");
            set_stdout("command: $cmd");
            set_stdout("time: $ptime");
            set_stdout('end_proc_data');
            $cnt++;
            #warn "ptime: $ptime check_time: $check_time";
        }

    }

}

close $fh;


set_stdout("count: $cnt");
