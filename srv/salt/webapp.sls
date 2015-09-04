include:
  - packages

"simplest-webapp":
  git.latest:
    - name: "https://github.com/Eiara/simplest-webapp.git"
    - target: /var/www/app
    - require:
      - pkg: git

"make-virtualenv":
  virtualenv.managed:
    - name: /var/www/app/venv
    - system_site_packages: False
    - requirements: /var/www/app/requirements.txt
    - require:
      - git: "simplest-webapp"

"initscript":
  file.managed:
    - name: /etc/init/simplest-webapp.conf
    - source: salt://files/simplest-webapp.conf
    - user: root
    - group: root
    - mode: "0644"

"run-me-a-webapp":
  service.running:
    - name: "simplest-webapp"
    - require:
      - virtualenv: "make-virtualenv"
      - file: "initscript"