# DOCKER_NAME=data-hal-jessie
FROM docker.mgm.sipwise.com/sipwise-jessie:latest

# Important! Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT 2018-03-28

# TODO - the release-trunk-jessie is too dynamic yet, though required for some build/test dependencies
RUN echo "deb https://deb.sipwise.com/autobuild/ release-trunk-jessie main" >>/etc/apt/sources.list

RUN apt-get update && apt-get install --assume-yes perl \
 libboolean-perl \
 libclone-perl \
 libdata-visitor-perl \
 libfailures-perl \
 libfile-slurp-perl \
 libhttp-message-perl \
 libjson-perl \
 liblog-any-adapter-callback-perl \
 liblog-any-adapter-filehandle-perl \
 liblog-any-perl \
 libmime-types-perl \
 libmoo-perl \
 libsafe-isa-perl \
 libstrictures-perl \
 libtap-formatter-junit-perl \
 libtest-fatal-perl \
 libtest-roo-perl \
 libtype-tiny-perl \
 liburi-namespacemap-perl \
 liburi-perl \
 liburi-template-perl \
 libxml-regexp-perl

RUN echo 'prove -I /code/lib -v --color -l --formatter TAP::Formatter::JUnit' >>/root/.bash_history
RUN echo 'prove -I /code/lib --color -l' >>/root/.bash_history
RUN echo './t/testrunner' >>/root/.bash_history

WORKDIR /code/

################################################################################
# Instructions for usage
# ----------------------
# When you want to build the base image from scratch (jump to the next section if you don't want to build yourself!):
# % docker build --tag="data-hal-jessie" .
# % docker run --rm -i -t -v $(pwd)/..:/code:rw data-hal-jessie:latest bash
#
# Use the existing docker image:
# % docker pull docker.mgm.sipwise.com/data-hal-jessie
# % docker run --rm -i -t -v $(pwd)/..:/code:rw docker.mgm.sipwise.com/data-hal-jessie:latest bash
#
# Inside docker (the command is in history, just press UP button):
#   ./t/testrunner
#
################################################################################
