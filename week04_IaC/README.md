# week04_IaC 실습 가이드

## 1. 목적
이 폴더는 4주차 IaC 실습용입니다.

실습 흐름:
1. Vagrant로 Ansible VM 생성
2. VM 안에서 `ansible --version` 확인
3. localhost 대상 ad-hoc 명령으로 nginx 서비스 시작
4. playbook 실행
5. development / production 환경 차이 확인

## 2. PowerShell에서 시작
```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week04_IaC
vagrant up
vagrant ssh
```

## 3. VM 안에서 기본 확인
```bash
ansible --version
sudo bash -c 'grep -qxF "localhost" /etc/ansible/hosts || echo "localhost" >> /etc/ansible/hosts'
```

## 4. ad-hoc 명령 실습
```bash
ansible localhost -b -c local -m service -a "name=nginx state=started"
ansible localhost -b -c local -m service -a "name=nginx state=started"
```

첫 실행은 보통 `CHANGED`, 두 번째는 `changed=false` 또는 `SUCCESS` 성격으로 보일 수 있습니다.

## 5. playbook 실습
```bash
cd /vagrant/ansible-playbook-sample-local
ansible-playbook -i development site.yml
curl localhost
ansible-playbook -i production site.yml
curl localhost
```

예상 결과:
- development 적용 후: `hello, development ansible`
- production 적용 후: `hello, production ansible`

## 6. 자주 쓰는 명령
```powershell
vagrant status
vagrant halt
vagrant up
vagrant ssh
```

## 7. Git 커밋 권장
커밋 대상:
- `Vagrantfile`
- `README.md`
- `ansible-playbook-sample-local/`

제외:
- `.vagrant/`
