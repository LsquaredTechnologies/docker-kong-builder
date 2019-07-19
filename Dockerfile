FROM kong:1.2-centos

# Installing "Development tools" is long... Keep it first!
RUN yum groupinstall "Development tools" -y && \
    # Remove this line when image is OK!
    # yum install which -y && \
    rm -rf /var/cache/

RUN luarocks install busted && \
    luarocks install luacheck

RUN git clone https://github.com/Kong/kong.git && \
    cd kong && \
    mkdir -p /usr/local/openresty/lualib/spec/ && \
    cp -R ./spec/fixtures /usr/local/openresty/lualib/spec/ && \
    cd .. && \
    rm -rf kong

# Add modified "busted" + "helpers.lua" + "docker-entrypoint.sh"
ADD ./root /
RUN chmod a+x /docker-entrypoint.sh /usr/local/bin/busted

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "sh" ]
