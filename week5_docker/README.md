# week5_docker

윈도우11 + PowerShell + VirtualBox 기준 Docker 과제 실습 폴더입니다.

## 실행 순서

```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week5_docker
vagrant up
vagrant ssh
```

VM 안에서:

```bash
cd /vagrant/docker-playbook
ansible-playbook -i development site.yml --diff
ansible --version
docker --version
sudo systemctl status docker --no-pager
sudo docker run hello-world
```

## 문제 해결

- `vagrant up` 이 오래 걸리면 `boot_timeout = 3600` 이 이미 적용되어 있습니다.
- 그래도 첫 `up` 이 끊기면 다시 `vagrant up` 또는 `vagrant reload --provision` 을 실행하세요.
- `/vagrant` 가 없으면 `vagrant up` 이 중간에 끊긴 것입니다. 다시 `vagrant up` 을 끝까지 완료하세요.
