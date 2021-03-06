package Data::HAL::URI;
use strictures;
use Moo; # has
use Types::Standard qw(InstanceOf Str);
use URI qw();

our $VERSION = '1.000';

my %uri_require_attempted = ();
my %uri_implements = ();
BEGIN {
    ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    no warnings 'redefine';
    *URI::implementor = sub {
        my($scheme, $impclass) = @_;
        if (!$scheme || $scheme !~ /\A$URI::scheme_re\z/o) {
            require URI::_generic;
            return "URI::_generic";
        }

        $scheme = lc($scheme);

        if ($impclass) {
        # Set the implementor class for a given scheme
            my $old = $uri_implements{$scheme};
            $impclass->_init_implementor($scheme);
            $uri_implements{$scheme} = $impclass;
            return $old;
        }

        my $ic = $uri_implements{$scheme};
        return $ic if $ic;

        # scheme not yet known, look for internal or
        # preloaded (with 'use') implementation
        $ic = "URI::$scheme";  # default location

        # turn scheme into a valid perl identifier by a simple transformation...
        $ic =~ s/\+/_P/g;
        $ic =~ s/\./_O/g;
        $ic =~ s/\-/_/g;

        ## no critic (TestingAndDebugging::ProhibitNoStrict,TestingAndDebugging::ProhibitProlongedStrictureOverride)
        no strict 'refs';
        # check we actually have one for the scheme:
        unless (@{"${ic}::ISA"}) {
            if (not exists $uri_require_attempted{$ic}) {
                # Try to load it
                my $_old_error = $@;
                ## no critic (BuiltinFunctions::ProhibitStringyEval)
                eval "require $ic";
                ## no critic (Variables::RequireLocalizedPunctuationVars)
                die $@ if $@ && $@ !~ /Can\'t locate.*in \@INC/;
                $@ = $_old_error;
                $uri_require_attempted{$ic} = 1;
            }
            ## no critic (Subroutines::ProhibitExplicitReturnUndef)
            return undef unless @{"${ic}::ISA"};
        }

        $ic->_init_implementor($scheme);
        $uri_implements{$scheme} = $ic;
        $ic;
    };
}

has('_original', is => 'rw', isa => Str);
# just records what was passed to the constructor, this is a work-around for
# URI->new being a lossy operation
has(
    'uri',
    is      => 'ro',
    isa     => InstanceOf['URI'],
    default => sub {
        my ($self) = @_;
        return URI->new($self->_original);
    },
    handles => [qw(abs as_iri canonical clone eq fragment implementor new_abs opaque path rel scheme secure
                STORABLE_freeze STORABLE_thaw)],
    lazy    => 1,
    # MT#5615 setting required=>1 breaks on Debian Squeeze
    required => 0,
);

sub BUILDARGS {
    my (undef, @arg) = @_;
    return 1 == @arg ? {_original => $arg[0]} : {@arg};
}

sub as_string {
    my ($self, $root) = @_;
    if (
        $self->eq($self->_original)
        ||
        $root && $root->_nsmap && $self->uri->eq($root->_nsmap->uri($self->_original)->as_string)
    ) {
        return $self->_original;
    } else {
        return $self->uri->as_string;
    }
}

1;

__END__

=encoding UTF-8

=head1 NAME

Data::HAL::URI - URI wrapper

=head1 VERSION

This document describes Data::HAL::URI version 1.000

=head1 SYNOPSIS

    my $relation = $resource->relation->as_string;

=head1 DESCRIPTION

This is a wrapper for L<URI> objects.

=head1 INTERFACE

=head2 Composition

None, but L<URI> methods are delegated through the L</uri> attribute.

=head2 Constructors

=head3 C<new>

    my $u = Data::HAL::URI->new('http://example.com/something');

Takes a string argument, returns a C<Data::HAL::URI> object.

=head2 Attributes

=head3 C<uri>

Type C<URI>, B<required>, B<readonly>, can only be set from the L</new> constructor.

This attribute delegates all methods to L<URI> except L</as_string>.

=head2 Methods

=head3 C<as_string>

Returns the original argument to the constructor if still equal to the L</uri>, where equality also takes CURIE
expansion into account, or otherwise the L</uri> as string.

The unaltered behaviour is still available through the L</uri> accessor, e.g.:

    $resource->relation->uri->as_string

=head2 Exports

None.

=head1 DIAGNOSTICS

None.

=head1 CONFIGURATION AND ENVIRONMENT

Requires no configuration files or environment variables.

=head1 AUTHOR

Lars Dɪᴇᴄᴋᴏᴡ C<< <daxim@cpan.org> >>

=head1 LICENSE

Copyright © 2013 Lars Dɪᴇᴄᴋᴏᴡ C<< <daxim@cpan.org> >>

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.18.0.
