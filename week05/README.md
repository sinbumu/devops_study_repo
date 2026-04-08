# week05 실습 가이드 (Ansible + Serverspec)

## 1. 목적
이 폴더는 5주차 실습용입니다.

실습 흐름:
1. Vagrant로 Ubuntu VM 생성
2. Ansible playbook으로 nginx + Serverspec 환경 구성
3. `rake spec`으로 인프라 테스트 실행
4. 필요하면 HTML 리포트 생성
5. development / production 환경 차이 확인

## 2. PowerShell에서 시작
```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week05
vagrant up
vagrant ssh
```

## 3. VM 안에서 기본 확인
```bash
ansible --version
cd /vagrant/ansible-playbook-sample-local
```

## 4. development 환경 적용
```bash
ansible-playbook -i development site.yml --diff
cd /tmp/serverspec_sample
rake spec
curl localhost
```

예상 포인트:
- `Package "nginx" is expected to be installed`
- `Service "nginx" is expected to be running`
- `Port "80" is expected to be listening`
- `4 examples, 0 failures`
- `curl localhost` 결과: `Hello, development ansible!!`

## 5. production 환경으로 변경
```bash
cd /vagrant/ansible-playbook-sample-local
ansible-playbook -i production site.yml --diff
cd /tmp/serverspec_sample
rake spec
curl localhost
```

예상 결과:
- `4 examples, 0 failures`
- `curl localhost` 결과: `Hello, production ansible!!`

## 6. HTML 리포트 만들기 (선택)
```bash
sudo gem install coderay
cd /tmp/serverspec_sample
rake spec SPEC_OPTS="--format html" > ~/result.html
sudo cp ~/result.html /var/www/html/result.html
curl http://localhost/result.html
```

## 7. 자주 쓰는 명령
```powershell
vagrant status
vagrant halt
vagrant up
vagrant ssh
```

## 8. 커밋 권장
포함:
- `Vagrantfile`
- `README.md`
- `ansible-playbook-sample-local/`

제외:
- `.vagrant/`
