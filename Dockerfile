FROM quay.io/pires/docker-elasticsearch:2.2.1

MAINTAINER pjpires@gmail.com

# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD do_not_use.yml /elasticsearch/config/elasticsearch.yml

# Install Elasticsearch plug-ins
RUN /elasticsearch/bin/plugin install io.fabric8/elasticsearch-cloud-kubernetes/2.2.1_01 --verbose
RUN /elasticsearch/bin/plugin install https://github.com/jaohaohsuan/elasticsearch-analysis-ik/releases/download/v1.8.1_01/elasticsearch-analysis-ik-1.8.1.zip --verbose

# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Copy run script
COPY run.sh /
