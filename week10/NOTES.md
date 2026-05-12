# week10 Docker 실습 메모

## 주요 개념

- Docker CLI: 사용자가 입력하는 명령 인터페이스
- Docker Daemon: 이미지/컨테이너를 실제로 관리하는 백그라운드 서비스
- Image: 컨테이너 실행을 위한 패키지
- Container: 이미지로부터 생성된 실행 단위
- Tag: 이미지 버전 또는 변형을 가리키는 이름
- Registry: Docker Hub 같은 이미지 저장소

## 주요 명령

```bash
docker run
docker ps
docker ps -a
docker stop
docker start
docker rm
docker exec
docker logs
docker inspect
docker images
docker rmi
```

## 실습 확인 포인트

- CentOS VM 안에서 Ubuntu 컨테이너 실행 가능
- `ubuntu`와 `ubuntu:20.04` 태그 차이 확인
- `nginx` 컨테이너 실행 후 포트 매핑 확인
- `curl localhost:<port>`로 nginx 응답 확인
- 컨테이너 ID 또는 이름으로 stop/start/rm 가능
- `exec`로 컨테이너 내부 명령 실행 가능
- `logs`, `inspect`로 상태 확인 가능
