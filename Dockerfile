FROM ruby:2.4

ENV HASVIEW_VERSION=v0.7.5-beta

# Install dependencies
RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    wget \
    nano \
    openssl \
    p7zip-full \
    mysql-client \
    redis-server

# Install hashview
RUN git clone https://github.com/hashview/hashview /hashview
RUN cd /hashview && git checkout $HASVIEW_VERSION
RUN cd /hashview && gem install bundler && bundle install
COPY config/database.yml /hashview/config/database.yml

# Install hashcat
RUN wget https://hashcat.net/beta/hashcat-5.1.0%2B789.7z
RUN 7z x hashcat-5.1.0+789.7z -o/
RUN ln -s /hashcat-5.1.0 /hashcat
#RUN wget https://github.com/hashcat/hashcat/releases/download/v4.2.1/hashcat-4.2.1.7z
#RUN 7z x hashcat-4.2.1.7z -o/
#RUN ln -s /hashcat-4.2.1 /hashcat
COPY config/agent_config.json /hashview/config/agent_config.json

EXPOSE 4567

COPY start.sh /start.sh
CMD bash /start.sh
