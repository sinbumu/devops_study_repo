# week11 실습 가이드 (Docker 옵션 + Kubernetes 클러스터 준비)

## 목적

11주차 실습용 폴더입니다.

강의 흐름:

1. Docker 실행 옵션
   - `--name`
   - `-e`
   - `-v`
   - `-p`
   - `--net`
2. Dockerfile
   - `FROM`
   - `RUN`
   - `EXPOSE`
   - `CMD`
   - `docker build`
3. Kubernetes 클러스터
   - Vagrant로 master + node VM 구성
   - containerd / kubeadm / kubelet / kubectl 설치
   - master에서 `kubeadm init`
   - node에서 join
   - `kubectl get nodes` 확인

## 구성

```text
week11/
  Vagrantfile
  README.md
  .gitignore
  setup/
    bootstrap-common.sh
    master.sh
    node.sh
  dockerfile-lab/
    Dockerfile
    README.md
```

수업 PDF는 Vagrant의 Ansible provisioner를 사용하지만, Windows + PowerShell 환경에서는 host Ansible 문제가 자주 생길 수 있습니다.  
그래서 이 실습본은 같은 목표를 shell provisioner로 구성했습니다.

## 시작

기본 구성은 master 1대 + node 2대입니다.

```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week11
vagrant up
```

PC 자원이 부족하면 node를 1대로 줄일 수 있습니다.

```powershell
$env:NODE_COUNT="1"
vagrant up
```

## Kubernetes 확인

```powershell
vagrant ssh master
```

master 안에서:

```bash
kubectl get nodes
kubectl get pods -A
```

처음에는 `NotReady`가 보일 수 있습니다. Calico Pod Network가 뜰 때까지 몇 분 기다린 뒤 다시 확인합니다.

```bash
watch kubectl get nodes
```

## node 수동 join

node join이 실패한 경우:

```powershell
vagrant ssh node1
```

node 안에서:

```bash
sudo bash /vagrant/setup/join-command.sh
```

## Dockerfile 실습

master 또는 node에 접속한 뒤:

```bash
cd /vagrant/dockerfile-lab
docker build -t week11-httpd .
docker run -d -P --name week11-httpd week11-httpd
docker ps
```

`docker ps`에서 host port를 확인한 뒤:

```bash
curl localhost:<포트>
```

정리:

```bash
docker rm -f week11-httpd
docker rmi week11-httpd
```

## 종료

```powershell
vagrant halt
```

## 삭제

```powershell
vagrant destroy -f
```

## 커밋 권장

포함:
- `Vagrantfile`
- `README.md`
- `setup/`
- `dockerfile-lab/`

제외:
- `.vagrant/`
- `setup/join-command.sh`
