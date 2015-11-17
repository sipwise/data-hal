package Data::HAL::URI::NamespaceMap;
use strictures;
use Data::HAL::URI qw();
use Moo; # extends
use URI::IRI qw();
use URI::Template qw();
use XML::RegExp qw();
extends 'URI::NamespaceMap';

our $VERSION = '1.000';

sub uri {
    my ($self, $abbr) = @_;
    if (my ($prefix, $reference) = $abbr =~ m/\A ($XML::RegExp::NCName) : (.*) \z/msx) {
        if ($self->namespace_uri($prefix)) {
            return Data::HAL::URI->new(
                _original => $abbr,
                uri => URI::Template
                    ->new($self->namespace_uri($prefix)->as_string)
                    ->process(rel => URI::IRI->new($reference)->canonical->as_string),
            );
        }
    }
    return;
}

sub add_mapping {
  my ($self,$name,$href) = @_;
  my $map = $self->namespace_map;
  if ($map) {
    return $map->{$name} = $href;
  } else {
    return $self->SUPER::add_mapping($name,$href);
  }
}

1;
