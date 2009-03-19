use inc::Module::Install;
name 'Module-Install-Repository';
all_from 'lib/Module/Install/Repository.pm';
auto_set_repository;

build_requires 'Test::More';
use_test_base;
auto_include_deps;
author_tests('xt');
WriteAll;
