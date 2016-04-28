FROM java:8u77-alpine 

# Export HTTP & Transport
EXPOSE 9200 9300

ENV VERSION 2.3.1

# Install Elasticsearch.
RUN apk add --update curl ca-certificates sudo && \

  ( curl -Lskj https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$VERSION/elasticsearch-$VERSION.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv /elasticsearch-$VERSION /elasticsearch && \
  rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))") && \
  apk del curl

# Volume for Elasticsearch data
VOLUME ["/data"]

# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD do_not_use.yml /elasticsearch/config/elasticsearch.yml

# Install Elasticsearch plug-ins
RUN /elasticsearch/bin/plugin install io.fabric8/elasticsearch-cloud-kubernetes/2.3.1 --verbose --batch
RUN /elasticsearch/bin/plugin install https://github.com/jaohaohsuan/elasticsearch-analysis-ik/releases/download/v1.8.1-beta.1/elasticsearch-analysis-ik-1.8.1.zip --verbose

# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Copy run script
COPY run.sh /
