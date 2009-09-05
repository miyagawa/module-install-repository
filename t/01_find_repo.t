use strict;
use warnings;
use Test::More tests => 3;

use Module::Install::Repository;

use File::Temp qw(tempdir);
use Path::Class;

sub fake_execute {
    my ($s) = @_;
    return {
        'hg paths' => "default = http://example.com/foo/bar/\n",
        'git remote show -n origin' => <<'END'
* remote origin
  URL: git@github.com:miyagawa/module-install-repository.git
  Remote branch merged with 'git pull' while on branch master
    master
  Tracked remote branch
    master
END
    }->{ $s };
}

sub fake_execute2 {
      my ($s) = @_;
      return {
          'git remote show -n origin' => <<'END',
* remote origin
  URL: origin          
END
          'git remote show -n github' => <<'END',
* remote github
  URL: git@github.com:2shortplanks/test-enhancedis.git
    master
  Tracked remote branch
    master
END
    }->{ $s };
  
}

sub test {
    my ($basename, $func) = @_;

    my $dir = tempdir(CLEANUP => 1);
    dir("$dir/$basename")->mkpath;
    chdir($dir);

    return Module::Install::Repository::_find_repo($func);
}

is(test('.git',\&fake_execute), 'git://github.com/miyagawa/module-install-repository.git', 'Git origin');
is(test('.git',\&fake_execute2), 'git://github.com/2shortplanks/test-enhancedis.git', 'Git github');
is(test('.hg',\&fake_execute), 'http://example.com/foo/bar/', 'Mercurial');
