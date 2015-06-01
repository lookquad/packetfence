package pf::pki_provider;
=head1 NAME

pf::pki_provider add documentation

=cut

=head1 DESCRIPTION

pf::pki_provider

=cut

use strict;
use warnings;
use Moo;

has ca_cert_path => (is => 'rw');

has server_cert_path => (is => 'rw');

has ca_cert => (is => 'ro' , builder => 1);

has server_cert => (is => 'ro' , builder => 1);

=head2 _build_ca_cert

Builds an X509 object the ca_cert_path

=cut

sub _build_ca_cert {
    my ($self) = @_;
    return Crypt::OpenSSL::X509->new_from_file($self->ca_cert_path);
}

=head2 _build_ca_cert

Builds an X509 object the server_cert_path

=cut

sub _build_server_cert {
    my ($self) = @_;
    return Crypt::OpenSSL::X509->new_from_file($self->server_cert_path);
}


=head2 _raw_cert_string

Extracts the certificate content minus the ascii armor

=cut

sub _raw_cert_string {
    my ($self, $cert) = @_;
    my $cert_pem = $cert->as_string();
    $cert_pem =~ s/-----END CERTIFICATE-----\n.*//smg;
    $cert_pem =~ s/.*-----BEGIN CERTIFICATE-----\n//smg;
    return $cert_pem;
}

=head2 raw_ca_cert_string

Get the ca certificate content minus the ascii armor

=cut

sub raw_ca_cert_string {
    my ($self) = @_;
    return $self->_raw_cert_string($self->ca_cert);
}

=head2 raw_ca_cert_string

Get the server certificate content minus the ascii armor

=cut

sub raw_server_cert {
    my ($self) = @_;
    return $self->_raw_cert_string($self->server_cert);
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2015 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;
