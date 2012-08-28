use strict;
use warnings;

package Package::Anon;
BEGIN {
  $Package::Anon::AUTHORITY = 'cpan:FLORA';
}
{
  $Package::Anon::VERSION = '0.04';
}
# ABSTRACT: Anonymous packages

use XSLoader;

XSLoader::load(
    'Package::Anon',
    $Package::Anon::{VERSION} ? ${ $Package::Anon::{VERSION} } : (),
);

use Scalar::Util ();


sub add_method {
    my ($self, $name, $code) = @_;
    my $gv = $self->install_glob($name);
    *$gv = $code;
    return;
}


sub install_glob {
    my ($self, $name) = @_;
    my $gv = $self->create_glob($name);
    $self->{$name} = *$gv;
    return $gv;
}


1;

__END__
=pod

=encoding utf-8

=head1 NAME

Package::Anon - Anonymous packages

=head1 SYNOPSIS

  my $stash = Package::Anon->new;
  $stash->add_method(bar => sub { 42 });

  my $obj = $stash->bless({});

  $obj->foo; # 42

=head1 METHODS

=head2 new ($name?)

  my $stash = Package::Anon->new;

  my $stash = Package::Anon->new('Foo');

Create a new anonymous package. If the optional C<$name> argument is provided,
it will be used to set the stash's name. Note that the name is there merely as
an aid for debugging - the stash won't be reachable from the global symbol table
by the given name.

With no C<$name> given, C<__ANON__> will be used.

=head2 bless ($reference)

  my $instance = $stash->bless({});

Bless a C<$reference> into the anonymous package.

=head2 blessed ($obj)

  my $stash = Package::Anon->blessed($obj);

Returns a Package::Anon instance for the package the given C<$obj> is blessed
into, or undef if C<$obj> isn't an object.

=head2 add_method ($name, $code)

  $stash->add_method(foo => sub { 42 });

Register a new method in the anonymous package.

=head2 create_glob ($name)

  my $gv = $stash->create_glob('foo');

Creates a new glob with the name C<$name>, pointing to C<$stash> as its
stash.

The created glob will not be installed into the C<$stash>.

=head2 install_glob ($name)

  my $gv = $stash->install_glob('foo');

Same as C<create_glob>, but will install the created glob under the given
C<$name> within the C<$stash>.

=head1 SYMBOL TABLE MANIPULATION

C<add_method> is provided as a convenience method to add code symbols to slots
in the anonymous stash. Other kinds of symbol table manipulations can be
performed as well, but have to be done by hand.

Currently, C<Package::Anon> instances are blessed stash references, so the
following is possible:

  $stash->{$symbol_name} = *$gv;

However, the exact details of how to get a hold of the actual stash reference
might change in the future.

=head1 AUTHORS

=over 4

=item *

Florian Ragwitz <rafl@debian.org>

=item *

Ricardo Signes <rjbs@cpan.org>

=item *

Jesse Luehrs <doy@tozt.net>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

