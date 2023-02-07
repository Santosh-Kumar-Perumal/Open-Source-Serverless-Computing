FROM nginx:1.22.1

ENV MESSAGE=""

COPY ./myweb.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "nginx", "-g", "daemon off;"]
