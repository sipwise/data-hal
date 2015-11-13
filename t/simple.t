use strictures;
use Test::More import => [qw(done_testing ok)];
use Data::HAL qw();
use boolean qw(true false);

my $curies_link = Data::HAL::Link->new(
        relation => 'curies',
        href => 'http://purl.org/sipwise/ngcp-api/#rel-{rel}',
        name => 'ngcp',
        templated => true,
    );

my $data = {
    resource => {foo => 23, bar => 42},
    links    => [
            $curies_link,
        ],
};

my $hal = Data::HAL->new(%{ $data });
ok($hal->as_json);

my $hal2 = Data::HAL->from_json($hal->as_json);
ok($hal2->as_json);

ok(1,"tests run");

done_testing;
