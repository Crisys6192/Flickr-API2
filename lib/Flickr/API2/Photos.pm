package Flickr::API2::Photos;
use Mouse;
use Flickr::API2::Photo;
extends 'Flickr::API2::Base';

=head1 NAME

Flickr::API2::Photos

=head1 SYNOPSIS

See search() and by_id() methods below.

=head1 METHODS

=head2 by_id

Finds one photo by its id number.

eg. say $api->photos->by_id(3386874895)->title;

=cut

sub by_id {
    my ($self, $id) = @_;
    my $p = Flickr::API2::Photo->new( api => $self->api, id => $id );
    my $info = $p->info->{photo};
    $p->title($info->{title}{_content});
    $p->description($info->{description}{_content});
    $p->owner_name($info->{owner}{realname});
    $p->owner_id($info->{owner}{nsid});
    $p->path_alias($info->{owner}{username});

    return $p;
}

=head2 search

Search for photos, for eg:

my @photos = $flickr->photos->search(tags => 'kitten,pony');

For parameters, see:

http://www.flickr.com/services/api/flickr.photos.search.html

This returns an array of Flickr::API2::Photo objects.

=cut

sub search {
    my $self = shift;
    my %args = @_;
    $args{extras} ||= join(',',
        qw(
            date_upload date_taken owner_name url_s url_m url_l url_o path_alias
        )
    );

    my $r = $self->api->execute_method(
        'flickr.photos.search', \%args
    );
    die("Didn't understand response (or no photos)")
        unless exists $r->{photos};

    return $self->_response_to_photos($r->{photos})
}

__PACKAGE__->meta->make_immutable;
1;
