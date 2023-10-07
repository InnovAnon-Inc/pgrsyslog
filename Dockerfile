FROM ubuntu as build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update                      \
&&  apt full-upgrade -y             \
    --no-install-recommends         \
&&  apt install      -y             \
    --no-install-recommends         \
    rsyslog-pgsql                   \
&&  apt autoremove   -y             \
    --purge                         \
&&  apt clean        -y             \
&&  rm -rf /var/lib/apt/lists/*     \
&&  sed -i                          \
    's@^module(load="imklog".*@#&@' \
    /etc/rsyslog.conf

ENTRYPOINT [                        \
  "/usr/sbin/rsyslogd",             \
  "-n"                              \
]

#CMD [                              \
#  "-d"                             \
#]

VOLUME ["/etc/rsyslog.d"]
VOLUME ["/var/log"]

EXPOSE  514/udp \
       6514/tcp

#HEALTHCHECK --interval=5m          \
#            --timeout=3s           \
#CMD         curl -f                \
#            http://0.0.0.0:3633/   \
#||          exit 1

