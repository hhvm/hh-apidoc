FROM hhvm/hhvm-proxygen:4.160-latest

ARG WORKSPACE

ADD .deploy/system-init.sh /var/tmp/system-init.sh
RUN touch /.docker_build && /var/tmp/system-init.sh && rm /var/tmp/system-init.sh
