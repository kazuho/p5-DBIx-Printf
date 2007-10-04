use strict;
use warnings;

use DBI;

package main;

sub DBI::db::printf {
    my ($self, $base, @params) = @_;
    
    $base =~ s/\%(d|f|s|t|\%)/
        DBIx::Printf::_printf_quote($self, $1, \@params)
                /eg;
    die "too many parameters\n" if @params;
    $base;
}

package DBIx::Printf;

our $VERSION = 0.05;

sub _printf_quote {
    my ($dbh, $type, $params) = @_;
    my $out;
    
    return '%' if $type eq '%';
    
    return _printf_quote_simple($dbh, $type, $params);
}

sub _printf_quote_simple {
    no warnings;
    my ($dbh, $type, $params) = @_;
    
    die "too few parameters\n" unless @$params;
    my $param = shift @$params;
    
    if ($type eq 'd') {
        $param = int($param);
    } elsif ($type eq 'f') {
        $param = $param + 0;
    } elsif ($type eq 's') {
        $param = $dbh->quote($param);
    } elsif ($type eq 't') {
        # pass thru
    } else {
        die "unknown type: $type\n";
    }
    
    $param;
}

1;

__END__

=head1 NAME

DBIx::Printf - A printf-style prepared statement

=head1 SYNOPSIS

  use DBIx::Printf;

  my $sql = $dbh->printf(
      'select * from t where str=%s or int=%d or float=%f',
      'string',
      1,
      1.1e1);

=head1 DESCRIPTION

C<DBIx::Printf> is a printf-style prepared statement.  It adds a C<printf> method to DBI::db package.

=head1 METHODS

=head2 printf(stmt, [values])

Builds a SQL statement from given statement with placeholders and values.  Following placeholders are supported.

  %d - integer
  %f - floating point
  %s - string
  %t - do not quote, pass thru

=head1 AUTHOR

Copyright (c) 2007 Kazuho Oku  All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
