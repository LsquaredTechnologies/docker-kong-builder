FROM kong:1.3.0-centos

# Installing "Development tools" is long... Keep it first!
RUN yum groupinstall "Development tools" -y && \
    # Remove this line when image is OK!
    yum install which -y && \
    rm -rf /var/cache/

RUN luarocks install busted && \
    luarocks install luacheck && \
    luarocks install lua-resty-jwt && \
    luarocks install lua-resty-openidc && \
    luarocks install kong-oidc

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
