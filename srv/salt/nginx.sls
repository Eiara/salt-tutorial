nginx:
  pkg.installed

"start_nginx":
  service.running:
    - name: nginx
    - require:
      - pkg: nginx