FROM perl:latest

RUN apt-get update

RUN cpanm --notest \
    Dancer2 \
    JSON \
    LWP::UserAgent \
    HTTP::Request \
    HTTP::Response \
    Plack::Runner \
    IO::Socket::SSL

WORKDIR /app

ENV PERL5LIB=/app/lib