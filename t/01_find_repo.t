use strict;
use warnings;
use Test::More tests => 1;

use Module::Install::Repository;

use File::Temp qw(tempdir);
use Path::Class;

sub fake_execute {
    my ($s) = @_;
    return {
        'hg paths' => "default = http://example.com/foo/bar/\n"
    }->{ $s };
}

sub test {
    my ($basename) = @_;

    my $dir = tempdir(CLEANUP => 1);
    dir("$dir/$basename")->mkpath;
    chdir($dir);

    return Module::Install::Repository::_find_repo(\&fake_execute);
}

is(test('.hg'), 'http://example.com/foo/bar/', 'Mercurial');
