package pf::detect::parser::suricata_http;

=head1 NAME

pf::detect::parser::suricata_http

=cut

=head1 DESCRIPTION

pfdetect parser class for Suricata HTTP MD5 checksum mode

=cut

use strict;
use warnings;

use JSON;
use Moo;

use pf::api::queue;
use pf::iplog;
use pf::log;

extends qw(pf::detect::parser);

sub parse {
    my ( $self, $line ) = @_;
    my $logger = pf::log::get_logger();

    # Received line should be JSON encoded
    $line =~ s/^.*?{/{/s;
    my $data = decode_json($line);

    # Extracting basic information required to process any further
    # MD5 hash is mainly what we are working with
    if ( !defined($data->{'md5'}) || !$data->{'md5'} ) {
        $logger->debug("Trying to parse a Suricata HTTP line that does not contain a MD5 hash value. Nothing to do");
        return 0;   # Returning 0 to pfdetect indicates "job's done"
    }
    my $md5_hash = $data->{'md5'};

    # Destination IP is the client IP address on which we want to act and from which we get the MAC address
    if ( !defined($data->{'dstip'}) || !$data->{'dstip'} ) {
        $logger->debug("Trying to parse a Suricata HTTP line that does not contain a destination IP. Nothing to do");
        return 0;   # Returning 0 to pfdetect indicates "job's done"
    }
    my $mac = pf::iplog::ip2mac($data->{'dstip'});
    if ( !defined($mac) || !$mac ) {
        $logger->debug("Trying to parse a Suricata HTTP line without a valid client MAC address. Nothing to do");
        return 0;   # Returning 0 to pfdetect indicates "job's done"
    }
    $data->{'mac'} = $mac;  # Adding processed MAC address to the data hash to avoid having to processing it again later on

    # We do the process async using API rather than going through pfdetect since it requires external resources evaluation that may take some time
    my $apiclient = pf::api::queue->new;
    $apiclient->notify('trigger_violation', ( 'mac' => $mac, 'tid' => $md5_hash, 'type' => 'suricata_md5' ));   # Process Suricata MD5 based violations
    $apiclient->notify('metadefender_process', $data);  # Process Metadefender MD5 hash lookup
    
    return 0;   # Returning 0 to pfdetect indicates "job's done"
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2016 Inverse inc.

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
