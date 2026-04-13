# week06 실습 가이드 (GitLab Runner + Build Pipeline)

## 1. 목적
이 폴더는 6주차 Build Pipeline 실습용입니다.

실습 흐름:
1. Vagrant로 runner VM 생성
2. VM 안에서 Ansible playbook으로 Docker / GitLab Runner / Serverspec 설치
3. 기존 GitLab VM(192.168.33.44)에 Runner 등록
4. GitLab 프로젝트에 sample project 내용을 push
5. `.gitlab-ci.yml`로 pipeline 실행

> 전제: 2주차에 만든 GitLab VM이 먼저 떠 있어야 합니다.

## 2. PowerShell에서 시작
```powershell
cd C:\Users\sinbu\Documents\GitHub\devops_study_repo\week06
vagrant up
vagrant ssh
```

## 3. Runner VM 안에서 설치/등록
```bash
cd /vagrant/playbook
ansible-playbook -i development site.yml \
  --extra-vars "gitlab_url=http://192.168.33.44 gitlab_runner_token=<복사한_토큰>"
```

선택적으로 shell executor가 ansible을 sudo로 실행할 수 있게 하려면:
```bash
cd /vagrant/playbook
ansible-playbook -i development site.yml \
  --extra-vars "gitlab_url=http://192.168.33.44 gitlab_runner_token=<복사한_토큰> gitlab_runner_enable_passwordless_sudo=true"
```

## 4. GitLab에서 확인
- GitLab: `http://192.168.33.44`
- Admin → CI/CD → Runners 에서 shell / docker runner 등록 확인

## 5. sample project
`sample_gitlab_project/` 는 강의 후반 GitLab 프로젝트 실습용 샘플입니다.

포함 파일:
- `.gitlab-ci.yml.example`
- `site.yml`
- `development`
- `group_vars/`
- `roles/nginx/`

실제 GitLab 프로젝트에 push할 때는:
1. 빈 프로젝트 생성
2. 이 샘플 내용을 복사
3. `.gitlab-ci.yml.example` 를 `.gitlab-ci.yml` 로 이름 변경
4. commit / push

## 6. 자주 만나는 문제
- GitLab clone URL 이 `gitlab.example.com` 으로 보이면, GitLab VM 의 `external_url` 을 IP 로 바꾸고 `gitlab-ctl reconfigure` 필요
- shell executor 로 job 을 돌리면 runner VM 자체에 nginx 등 변경이 적용됩니다.
- 빌드가 환경에 영향을 덜 주게 하려면 docker executor 를 활용합니다.

## 7. 커밋 권장
포함:
- `Vagrantfile`
- `README.md`
- `playbook/`
- `sample_gitlab_project/`

제외:
- `.vagrant/`
