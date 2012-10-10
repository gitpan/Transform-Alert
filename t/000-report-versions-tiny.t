use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.08\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = 'v5.10.1';
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('App::Daemon','0.01') };
eval { $v .= pmver('Class::Load','0.01') };
eval { $v .= pmver('Config::General','2.38') };
eval { $v .= pmver('Data::Dump','1.10') };
eval { $v .= pmver('Devel::SimpleTrace','0.07') };
eval { $v .= pmver('Email::Abstract','3.000') };
eval { $v .= pmver('Email::Sender::Simple','any version') };
eval { $v .= pmver('Email::Simple','2.004') };
eval { $v .= pmver('File::Slurp','9999.14') };
eval { $v .= pmver('List::AllUtils','0.01') };
eval { $v .= pmver('Log::Log4perl','1.15') };
eval { $v .= pmver('Mail::IMAPClient','3.03') };
eval { $v .= pmver('Module::Metadata','1.000000') };
eval { $v .= pmver('Moo','0.009001') };
eval { $v .= pmver('MooX::Types::MooseLike','0.15') };
eval { $v .= pmver('Net::SNMP','v6.0.0') };
eval { $v .= pmver('Net::SNMPTrapd','0.01') };
eval { $v .= pmver('Net::Syslog','0.04') };
eval { $v .= pmver('Net::Syslogd','0.01') };
eval { $v .= pmver('Path::Class','0.17') };
eval { $v .= pmver('String::Escape','2010.002') };
eval { $v .= pmver('Template','2.20') };
eval { $v .= pmver('Test::CheckDeps','0.002') };
eval { $v .= pmver('Test::LeakTrace','0.01') };
eval { $v .= pmver('Test::Most','0.01') };
eval { $v .= pmver('Test::UseAllModules','0.10') };
eval { $v .= pmver('namespace::clean','0.06') };
eval { $v .= pmver('sanity','0.91') };
eval { $v .= pmver('version','0.9901') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
