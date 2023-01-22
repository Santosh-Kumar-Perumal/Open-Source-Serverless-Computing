#!/bin/bash

sed -i 's/&H1/'"$MESSAGE"'/g' /usr/share/nginx/html/index.html
exec "$@"
