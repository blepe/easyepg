FROM ubuntu
RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get -y --no-install-recommends install tzdata \
 && apt-get install -y --no-install-recommends cron phantomjs dialog curl wget libxml2-utils perl nano perl-doc jq php php-curl git xml-twig-tools unzip liblocal-lib-perl cpanminus build-essential inetutils-ping \
 && rm -rf /var/lib/apt/lists/* 

RUN cpan App:cpanminus
RUN cpanm install JSON
RUN cpanm install XML::Rules
RUN cpanm install XML::DOM
RUN cpanm install Data::Dumper
RUN cpanm install Time::Piece
RUN cpanm install Time::Seconds
RUN cpanm install DateTime
RUN cpanm install DateTime::Format::DateParse
RUN cpanm install utf8
RUN cpanm install DateTime::Format::Strptime

WORKDIR /

RUN git clone https://github.com/sunsettrack4/easyepg.git

COPY easyepg-cron /etc/cron.d/easyepg-cron
RUN chmod 0644 /etc/cron.d/easyepg-cron
RUN crontab /etc/cron.d/easyepg-cron
RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
