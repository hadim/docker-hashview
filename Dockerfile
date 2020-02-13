FROM ruby:2.4

# Install dependencies
RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    wget \
    nano \
    openssl \
    p7zip-full \
    mysql-client-* \
    redis-server

ENV HASHVIEW_VERSION=v0.7.5-beta
ENV HASHCAT_VERSION=4.2.1

# Install hashview
RUN git clone https://github.com/hashview/hashview /hashview
RUN cd /hashview && git checkout $HASHVIEW_VERSION
RUN cd /hashview && gem install bundler && bundle install
COPY config/database.yml /hashview/config/database.yml

# Install hashcat
RUN wget https://hashcat.net/beta/hashcat-5.1.0%2B800.7z
RUN 7z x hashcat-5.1.0+800.7z -o/
RUN ln -s /hashcat-5.1.0 /hashcat
#RUN wget https://github.com/hashcat/hashcat/releases/download/v$HASHCAT_VERSION/hashcat-$HASHCAT_VERSION.7z
#RUN 7z x hashcat-$HASHCAT_VERSION.7z -o/
#RUN ln -s /hashcat-$HASHCAT_VERSION /hashcat
COPY config/agent_config.json /hashview/config/agent_config.json

EXPOSE 4567

COPY start.sh /start.sh
CMD bash /start.sh
