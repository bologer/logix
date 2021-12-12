FROM nginx:alpine
WORKDIR /app
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./conf.d/ /etc/nginx/conf.d
COPY . /app
CMD ["nginx"]
EXPOSE 80