#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Dancer2;

my $opa_url = $ENV{'OPA_URL'} || 'http://demo-API-opa:8181/v1/data/auth/policy_evaluation';

#CORS
hook before => sub {
    response_header 'Access-Control-Allow-Origin' => '*';
    response_header 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS';
    response_header 'Access-Control-Allow-Headers' => 'Authorization, Content-Type';
};

#OPTIONS dla CORS
options qr{.*} => sub {
    status '200';
    content_type 'text/plain';
    return '';
};

#OAuth2.0
hook before => sub {
    my $auth_header = request->header('Authorization');

    if (!$auth_header) {
        status '401';
        content_type 'application/json';
        halt encode_json({ message => 'Brak nagłówka Authorization' });
    }

    my ($type, $access_token) = split / /, $auth_header;

    if ($type ne 'Bearer') {
        status '401';
        content_type 'application/json';
        halt encode_json({ message => 'Błędny typ autoryzacji' });
    }

    if (!$access_token) {
        status '401';
        content_type 'application/json';
        halt encode_json({ message => 'Brak tokenu dostępu' });
    }

    my $method = request->method;
    my $path   = request->path;
    my ($host, $port) = split ':', request->host;
    my $scheme = request->scheme;
    my $want_online_introspection = exists ${request->params}{'want_online_introspection'};

    my $input_data = {
        method => $method,
        scheme => $scheme,
        host   => $host,
        port   => $port,
        path   => $path,
        want_online_introspection => $want_online_introspection,
        access_token  => $access_token,
    };

    my $ua = LWP::UserAgent->new;

    my $req = HTTP::Request->new(
        'POST',
        $opa_url,
        ['Content-Type' => 'application/json'],
        encode_json({ input => $input_data })
    );

    my $res = $ua->request($req);

    if ($res->is_success) {
        my $result = decode_json($res->decoded_content);
        if (!$result->{result}{allow}) {
            status $result->{result}{code};
            content_type 'application/json';
            halt encode_json({
                status => 'DENY',
                online_introspected => $result->{result}{online_introspected},
                reasons => $result->{result}{reasons},
                config => $result->{result}{config}
            });
        } else {
            var 'opa_response' => $result->{result};
        }
    } else {
        status '500';
        content_type 'application/json';
        halt encode_json({ message => 'Błąd połączenia z OPA' });
    }
};

any qr{.*} => sub {
    my $opa_response = vars->{'opa_response'};

    content_type 'application/json';
    return encode_json({
        status  => 'ALLOW',
        token_data   => $opa_response->{token_data},
        online_introspected   => $opa_response->{online_introspected},
        config   => $opa_response->{config}
    });
};

dance;