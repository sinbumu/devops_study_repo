# Dockerfile Lab

PDF 예시는 `centos:7` 기반이지만, CentOS 7 저장소 이슈를 피하기 위해 `rockylinux:8` 기반으로 구성했습니다.

## Build

```bash
docker build -t week11-httpd .
```

## Run

```bash
docker run -d -P --name week11-httpd week11-httpd
docker ps
```

## Test

`docker ps`에서 host port를 확인한 뒤:

```bash
curl localhost:<포트>
```

## Cleanup

```bash
docker rm -f week11-httpd
docker rmi week11-httpd
```
