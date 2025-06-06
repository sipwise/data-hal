use strict;
use warnings;

use Module::Build qw();
Module::Build->new(
    add_to_cleanup => [ 'Data-HAL-*' ],
    build_requires => {
        'Data::Visitor::Callback' => 0,
        'File::Slurp' => 0,
        'JSON' => 0,
        'Log::Any::Adapter' => 0,
        'Log::Any::Adapter::FileHandle' => 0,
        'strictures' => 0,
        'Test::Fatal' => 0,
        'Test::More' => 0,
    },
    configure_requires => {
        'Module::Build' => 0.40,
    },
    dist_version_from => 'lib/Data/HAL.pm',
    dynamic_config => 0,
    license => 'perl',
    'meta-spec' => {
        url => 'http://module-build.sourceforge.net/META-spec-v1.4.html',
        version => '1.4',
    },
    module_name => 'Data::HAL',
    no_index => {
        file => [
            'lib/Data/HAL/URI/NamespaceMap.pm',
        ],
    },
    requires => {
        'boolean' => 0,
        'Clone' => 0,
        'Data::Visitor::Callback' => 0,
        'failures' => 0,
        'HTTP::Headers::Util' => 0,
        'JSON' => 0,
        'Log::Any' => 0,
        'MIME::Type' => 0,
        'Moo' => 0,
        'perl' => '5.008',
        'Safe::Isa' => 0,
        'Scalar::Util' => 0,
        'strictures' => 0,
        'Types::Standard' => 0,
        'URI' => 0,
        'URI::IRI' => 0,
        'URI::NamespaceMap' => 0,
        'URI::Template' => 0,
        'XML::RegExp' => 0,
    },
    resources => {
        license => 'http://dev.perl.org/licenses/',
        bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-HAL',
        repository => 'https://github.com/daxim/Data-HAL',
    },
)->create_build_script;
