nginx:
  pkg.installed
  
# creates a configuration file

/etc/nginx/conf.d/webapp.conf:
  file.managed:
    - source: salt://files/nginx.conf
    - requires:
      - pkg: nginx

# Restarts nginx when the config file is changed

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - pkg: nginx
      - file: /etc/nginx/conf.d/webapp.conf