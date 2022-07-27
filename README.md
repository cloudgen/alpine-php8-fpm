# Alpine php-fpm

This PHP FPM and PHP CLI docker image based on [Alpine](https://hub.docker.com/_/alpine/). Alpine is based on [Alpine Linux](http://www.alpinelinux.org), lightweight Linux distribution based on [BusyBox](https://hub.docker.com/_/busybox/). The size of this image is very small, less than 30 MB!

### PHP 8

This docker version of alpine is using php 8 version

## Getting The Image

This image is published in the [Docker Hub](https://hub.docker.com/r/cloudgen/alpine-php8-fpm/). Simply run this command below to get it to your machine.

```Shell
docker pull cloudgen/alpine-php8-fpm
```

Alternatively you can clone this repository and build the image using the `docker build` command.

## Build

This image use `Asia/Hong_Kong` timezone by default. You can change the timezone by change the `TIMEZONE` environment on `Dockerfile` and then build.

```Shell
docker build -t cloudgen/alpine-php8-fpm .
```

## Configuration

The site data, config, and log data is configured to be located in a Docker volume so that it is persistent and can be shared by other containers or a backup container).

There is volume defined in this image `/var/www` that is shared with Nginx container. Please make sure both containers can access the directory. You can store the sites data to this directory.

### PHP Configuration

The config is set using environments listed below on build.

```Ini
ENV TIMEZONE Asia/Hong_Kong
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M
```

Change it in `Dockerfile` and you can rebuild your image.

## Run The Container

### Create and Run The Container

```Shell
docker run -p 9000:9000 --name phpfpm -v /var/www:/var/www:rw -d cloudgen/alpine-php8-fpm
```

If you run and want to link Nginx container, make sure you created and run this PHP-FPM the container before running this Nginx container. Make sure the `/www` volume in PHP-FPM container is mapped.

 * The first `-p` argument maps the container's port 9000 to port 9000 on the host and used for communication between Nginx and PHP-FPM.
 * `--name` argument sets the name of the container, useful when starting and stopping the container.
 * The `-v` argument maps the `/var/www` directory in the host to `/var/www` in the container with read/write access (rw).
 * `-d` argument runs the container as a daemon.

### Stopping The Container

```Shell
docker stop phpfpm
```
### Start The Container Again

```Shell
docker start phpfpm
```

## Nginx Docker Image
If you don't want to setup nginx yourself, you can use [Docker Hub](https://hub.docker.com/r/cloudgen/alpine-nginx-1.23/)


## Nginx Configuration
The following is an example of nginx configuration.
```Shell
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  root /var/www;
  # The root path refers to the container's exposed volume
  set $fastcgi_root_in_container "/var/www";

  location / {
    try_files $uri $uri/ = 404;
  }
  location ~ \.php$ {
    fastcgi_index index.php;
    fastcgi_split_path_info ^(.+\.php)(.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_NAME $fastcgi_root_in_container$fastcgi_script_name;
    fastcgi_param SCRIPT_FILENAME $fastcgi_root_in_container$fastcgi_script_name;
    fastcgi_pass 127.0.0.1:9000;
  }
}
```
