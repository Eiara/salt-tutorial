pull-repo:
  git.latest:
    - name: "https://github.com/Eiara/simplest-webapp.git"
    - target: /var/www/webapp
    
/etc/init/webapp.conf:
  file.managed:
    - source: salt://files/webapp.conf
    
webapp:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/init/webapp.conf
    - watch:
      - file: /etc/init/webapp.conf
    