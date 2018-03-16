use strictures;
use Test::More import => [qw(done_testing is)];
use Data::HAL qw();
use boolean qw(true);

my $resource_name = "domain";
my $dispatch_path = "/api/domains/";
my $request_path = "api/domains/";
my $total_count = 2;
my $rows = 1;
my $page = 1;

my @embedded = ();
my @links = ();
foreach my $id (1..1) {
    my %resource = (
        domain => "domain".$id,
    );
    my $hal = Data::HAL->new(
        links => [
            Data::HAL::Link->new(
                relation => 'curies',
                href => 'http://purl.org/sipwise/ngcp-api/#rel-{rel}',
                name => 'ngcp',
                templated => true,
            ),
            Data::HAL::Link->new(relation => 'collection', href => sprintf("/api/%s/", $resource_name)),
            Data::HAL::Link->new(relation => 'profile', href => 'http://purl.org/sipwise/ngcp-api/'),
            Data::HAL::Link->new(relation => 'self', href => sprintf("%s%d", $dispatch_path, $id)),
            #( map { $_->attribute->internal ? () : Data::HAL::Link->new(relation => 'ngcp:domainpreferences', href => sprintf("/api/domainpreferences/%d", $_->id), name => $_->attribute->attribute) } $item->provisioning_voip_domain->voip_dom_preferences->all ),
            Data::HAL::Link->new(relation => 'ngcp:domainpreferences', href => sprintf("/api/domainpreferences/%d", $id)),
            #$self->get_journal_relation_link($item->id),
        ],
        relation => 'ngcp:'.$resource_name,
    );
    $resource{id} = int($id);
    $hal->resource({%resource});
    #$hal->_forcearray(1);
    push @embedded,$hal;

    my $link = Data::HAL::Link->new(
        relation => 'ngcp:'.$resource_name,
        href     => sprintf('/%s%d', $request_path, $id),
    );
    #$link->_forcearray(1);
    push @links, $link;
}
push @links,
    Data::HAL::Link->new(
        relation => 'curies',
        href => 'http://purl.org/sipwise/ngcp-api/#rel-{rel}',
        name => 'ngcp',
        templated => true,
    ),
    Data::HAL::Link->new(relation => 'profile', href => 'http://purl.org/sipwise/ngcp-api/'),
    Data::HAL::Link->new(relation => 'self', href => sprintf('/%s?page=%s&rows=%s', $request_path, $page, $rows));
if(($total_count / $rows) > $page ) {
    push @links, Data::HAL::Link->new(relation => 'next', href => sprintf('/%s?page=%d&rows=%d', $request_path, $page + 1, $rows));
}
if($page > 1) {
    push @links, Data::HAL::Link->new(relation => 'prev', href => sprintf('/%s?page=%d&rows=%d', $request_path, $page - 1, $rows));
}

my $hal = Data::HAL->new(
    embedded => [@embedded],
    links => [@links],
);
$hal->resource({
    total_count => $total_count,
});

is(join(": ",$hal->http_headers(skip_links => 1))."\n",<<EOS,"sample http headers");
Content-Type: application/hal+json; profile="http://purl.org/sipwise/ngcp-api/"; charset=utf-8
EOS
is($hal->as_json,<<EOS,"sample json");
{
   "_embedded" : {
      "ngcp:domain" : {
         "_links" : {
            "collection" : {
               "href" : "/api/domain/"
            },
            "curies" : {
               "href" : "http://purl.org/sipwise/ngcp-api/#rel-{rel}",
               "name" : "ngcp",
               "templated" : true
            },
            "ngcp:domainpreferences" : {
               "href" : "/api/domainpreferences/1"
            },
            "profile" : {
               "href" : "http://purl.org/sipwise/ngcp-api/"
            },
            "self" : {
               "href" : "/api/domains/1"
            }
         },
         "domain" : "domain1",
         "id" : 1
      }
   },
   "_links" : {
      "curies" : {
         "href" : "http://purl.org/sipwise/ngcp-api/#rel-{rel}",
         "name" : "ngcp",
         "templated" : true
      },
      "next" : {
         "href" : "/api/domains/?page=2&rows=1"
      },
      "ngcp:domain" : {
         "href" : "/api/domains/1"
      },
      "profile" : {
         "href" : "http://purl.org/sipwise/ngcp-api/"
      },
      "self" : {
         "href" : "/api/domains/?page=1&rows=1"
      }
   },
   "total_count" : 2
}
EOS

done_testing;