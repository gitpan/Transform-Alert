use sanity;
use Test::Most tests => 9;
use Test::LeakTrace;

use Path::Class;
use lib dir(qw{ t lib })->stringify;
use TestDaemon;

my ($ta, $log_file) = TestDaemon->new(qw{ syslog syslog });

# let's start the loop with a message
use Net::Syslog 0.04;  # 0.04 has rfc3164 flag

my $msg = 'Two-three-oh-five-eight-four-three-oh-oh-nine-two-one-three-six-nine-three-nine-five-one';
$ta->heartbeat;  # starts the daemon for the first time
my $syslog = Net::Syslog->new(
   Name       => 'TransformAlert',
   Facility   => 'local3',
   Priority   => 'info',
   SyslogHost => '127.0.0.244',
   SyslogPort => 51437,
   rfc3164    => 1,
);
$syslog->send($msg);

lives_ok { $ta->heartbeat } 'heartbeat';

# check the log for the right phrases
my $log = $log_file->slurp;

foreach my $str (
   'severity   => "Informational",',
   'remoteaddr => "127.0.0.',  # some OSs might force the address back to 127.0.0.1
   'priority   => 158,',
   'message    => "'.$msg.'",',
   'facility   => "local3",',
   'Sending alert for "syslog"',
   'Munger cancelled output',
) {
   ok($log =~ qr/\Q$str\E/, "Found - $str");
}

$msg = 'Oh-dot-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-oh-four-three-three-six-eight-oh-eight-oh-six-eight-nine-nine-four-two';
$syslog->send($msg);
$ta->heartbeat;

no_leaks_ok {
   $syslog->send($msg);
   $ta->heartbeat;
} 'no memory leaks';

$log_file->remove;
