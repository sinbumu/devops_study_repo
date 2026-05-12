# week10 실습 가이드 (Docker 기본 명령)

## 1. 목적

이 폴더는 DevOps & Deployment 10주차 Docker 실습용입니다.

10주차 강의 흐름:

1. Vagrant로 CentOS 7 VM 준비
2. CentOS에 Docker 설치
3. Docker daemon 시작 및 자동 시작 등록
4. `docker run`으로 Ubuntu / Nginx 컨테이너 실행
5. `ps`, `stop`, `start`, `rm`, `exec`, `logs`, `inspect`, `images`, `rmi` 명령 실습

## 2. PowerShell에서 VM 시작

```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week10
vagrant up
vagrant ssh
```

## 3. VM 안에서 Docker 설치

```bash
cd /vagrant
sudo bash scripts/install_docker_centos7.sh
```

설치 후 현재 `vagrant` 사용자를 `docker` 그룹에 추가하므로, 한 번 나갔다가 다시 접속합니다.

```bash
exit
```

PowerShell에서:

```powershell
vagrant ssh
```

다시 접속 후 확인:

```bash
docker version
docker info
```

## 4. Ubuntu 컨테이너 실행

최신 Ubuntu 이미지 실행:

```bash
docker run ubuntu cat /etc/lsb-release
```

특정 태그 실행:

```bash
docker run ubuntu:20.04 cat /etc/lsb-release
```

## 5. Nginx 이미지 검색 및 실행

```bash
docker search nginx
docker run -d -P nginx
docker ps
```

`docker ps`에서 `0.0.0.0:xxxxx->80/tcp` 형태의 포트를 확인한 뒤:

```bash
curl localhost:<확인한_포트>
```

임의 포트가 아니라 직접 포트를 지정하려면:

```bash
docker run -d -p 8080:80 --name nginx-fixed nginx
curl localhost:8080
```

## 6. 네트워크 상태 확인

```bash
sudo yum -y install net-tools
sudo netstat -natp
```

## 7. 컨테이너 정지 / 재시작 / 삭제

```bash
docker ps
docker stop <container_id_or_name>
docker ps -a
docker start <container_id_or_name>
docker rm <container_id_or_name>
docker rm -f <container_id_or_name>
```

## 8. 컨테이너 내부 명령 실행

```bash
docker exec <nginx_container_id_or_name> md5sum /etc/nginx/nginx.conf
docker exec -it <nginx_container_id_or_name> /bin/bash
exit
```

## 9. 로그 / 상세 정보 조회

```bash
docker logs <container_id_or_name>
docker logs -f <container_id_or_name>
docker inspect <container_id_or_name>
```

## 10. 이미지 목록 / 이미지 삭제

```bash
docker images
docker image ls
docker rmi ubuntu:20.04
```

이미지가 컨테이너에서 사용 중이면 먼저 컨테이너를 삭제해야 합니다.

```bash
docker ps -a
docker rm <ubuntu_container_id>
docker rmi ubuntu:20.04
```

## 11. 실습 명령 빠르게 실행하기

```bash
bash /vagrant/scripts/docker_lab_commands.sh
```

## 12. 종료

PowerShell에서:

```powershell
vagrant halt
```

## 13. 커밋 권장

포함:

- `Vagrantfile`
- `README.md`
- `NOTES.md`
- `scripts/`

제외:

- `.vagrant/`
