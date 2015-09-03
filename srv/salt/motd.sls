"hello pycon":
  file.managed:
    - name: "/etc/update-motd.d/99-hello-pycon"
    - contents: "#!/bin/bash\necho\necho 'hello pycon'"
    - mode: "0755"
    - user: root
    - group: root