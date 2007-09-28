use strict;
use warnings;

use DBI;

package main;

sub DBI::db::printf {
    my ($self, $base, @params) = @_;
    
    $base =~ s/%([dfs\%])/
        $1 eq '%' ? '%' :
            @params
                ? DBI::Printf::_printf_quote($self, $1, shift @params)
                    : die "too few parameters\n"
                        /eg;
    die "too many parameters\n" if @params;
    $base;
}

package DBI::Printf;

sub _printf_quote {
    my ($dbh, $type, $param) = @_;
    no warnings;
    
    if ($type eq 'd') {
        $param = int($param);
    } elsif ($type eq 'f') {
        $param = $param + 0;
    } elsif ($type eq 's') {
        $param = $dbh->quote($param);
    } else {
        die "unknown type: $type\n";
    }
    $param;
}

our $VERSION = 0.03;

1;

__END__

=head1 NAME

DBI::Printf - A printf-style prepared statement

=head1 SYNOPSIS

  use DBI::Printf;

  my $sql = $dbh->printf(
      'select * from t where str=%s or int=%d or float=%f',
      'string',
      1,
      1.1e1);

=head1 DESCRIPTION

C<DBI::Printf> is a printf-style prepared statement.  It adds a C<printf> method to DBI::db package.

=head1 METHODS

=head2 printf(stmt, [values])

Builds a SQL statement from given statement with placeholders and values.  Following placeholders are supported.

  %s - string
  %d - integer
  %f - floating point

=head1 AUTHOR

Copyright (c) 2007 Kazuho Oku  All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
