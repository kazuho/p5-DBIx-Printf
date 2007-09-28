use strict;
use warnings;

use Test::More tests => 16;

BEGIN { use_ok('DBIx::Printf'); }

my $dbh = DBI->connect('DBI:Mock:', '', '');

is($dbh->printf('select 1'), 'select 1', 'no args');
is($dbh->printf('select %%s'), 'select %s', '%% -> %');
is($dbh->printf('select %%%d', 1), 'select %1', '%%%s -> %(string)');

is($dbh->printf('select %d', 1), 'select 1', 'single %d');
is($dbh->printf('select %d', "1.3' or 1"), 'select 1', '%d with garbage');
is($dbh->printf('select %d', ''), 'select 0', '%d with empty string');
is($dbh->printf('select %d', 'abc'), 'select 0', '%d with not a number at all');

is($dbh->printf('select %f', 1), 'select 1', 'single %f');
is($dbh->printf('select %f', 1.3e1), 'select 13', 'single %f given a fp');
is($dbh->printf('select %f', '1.3e1'), 'select 13', 'single %f given a fp str');
is($dbh->printf('select %f', "'or 1"), 'select 0', 'single %f given a garbage');

is($dbh->printf('select %s', "don't"), "select 'don''t'", '%s');

is($dbh->printf('select %d,%d,%d', 1, 2, 3), 'select 1,2,3', 'multiple args');

undef $@;
eval {
    $dbh->printf('select 1', 1);
};
ok($@, 'too many parameters');
undef $@;
eval {
    $dbh->printf('select %d');
};
ok($@, 'too few parameters');
