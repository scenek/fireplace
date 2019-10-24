include cfg
include base
include locale
include krb

class cfg {
  $user = 'pi'
}

class base {
  require cfg

  package { ['vim', 'tmux', 'fail2ban', 'cron', 'wget', 'rsync', 'git']:
      ensure => latest
  }

  user { $::cfg::user:
    ensure   => present,
    password => '$6$J5ZY6ML0$K8EZp0N3.U72JnUGnmG4Setl0NX0EKFFCRCI.LZd3q5TnRhXxcxEMUqcr6oKQtRc1drhvHpJ4Fr7fGWi5l6Ip/',
    home     => "/home/${::cfg::user}",
    managehome => true,
    purge_ssh_keys => true,
  }

  ssh_authorized_key { 'petr.benas@gooddata.com':
    user   => $::cfg::user,
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC/dYtN0/kJPAsoKs1LJ9wRP5Sz8AmkF3p/1E1h9RTlrJ3XFlU6Aba/CoIoK/QSPweXQJW9f9ZTCDgt5YnwNHBVuKWoS5Yc48pUK0dnvtLnuVd59C4I7MP0VK3MD1tucM4DQh8m1PRfWGfygtarBwWVR2awwGP5sJsSPppvf1kJAtIaJ3DPxWdkBsEqZTg2hGf6f9oOCtsXr2ml0Zk1XhDO1+ryFiq9F5C7ATNindlMPEo31Ac4yDkVt8p/aK2UeRX2SjcFAGwndL6X04pdC2tQR7BPWCI6qTLuOZ2hsK7dCjjgH5wbHLWGecEmtCpRCQDiQmuGqXTUKwWZ29Nqj8GOCnuQ1omhTQjqy/Qod+H8IFwbFqZ9B6hcYSpIPKWb815D9wtUJglZpvriYMlJ8fohWpkkPsCyaOSL1JIp5GOn+99wbBopI9wyopusBZ2+AyipvnSPFxFYseWL58kv/xuyVKSSGfXE22r75d5QG29+BvnLjgwnMhXlk08jH43FvVGocjXTTgFdNF31cjuYWOZlZMSeNWM7ywFjgQV2EAhkFm1RfXbzSiudzIktWPoDV1P5cq4Ec3hBYYlgt3F4OpD98my9v259E8xWbgZptY4SOwCZZC5M3uy/Tz7NzNUFKLapkTwg+reYztyoXZtn+rKzDnbmDR1+LabRVydN0gAk5w==',
    type   => 'ssh-rsa'
  }

  ssh_authorized_key { 'kristian.lesko@gooddata.com':
    user   => $::cfg::user,
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDCepce4WJp1n+PeMKUCYern2RF/GIbOq39IhgjkdqditfBTNeHCMfYpdy/Nn20SxNgJ1qu3zvEMFmBN9MDZ0u/X/crDeM6LHgi5wpnXiKmQTqKvNvbfmLlH6pgXEg019ObHLR8mxus62lbvuvWocXaQW9OZM8gS6Kes6lG405zccQklZUNvquyXHitJW9za5A1pbZDa4LbBi2qjcUHKL+cREl/fUWjAHbAlMCCIZ0QrEKo9gHGG0qVl2TtKczpIuO4cm9P//fu0FDDvG9JvCJzpcMjBsWWRDjTEMqTV5b4IknmqKgt1cMr88nTx43QwZksi2iRk3cAkDYdo+5U8gwfVvHA/PW8ek+UqtbdYfahl63jXRqw1kD8SxNI7799D17Fe6/FzMffym2ScZgSybtIooZVuUu0DbF+jeewNe0ST63B1VuW9+c5/ZrOkNLmzdiElpVRg8ZptezUxqZSKh8lID+TPev5Qx1gmkn3JWAB16/gruo49tqzecizHN5SQEvNk8Wu5UvAMgeJ9FqHxsM2ZxgKZSZZafVKme4oGQjbMeIxXeYdXVuyK/uYTw9YnUN75ZP7h7Wj44UEoBB35vamjyv3E27/6v9XtwVbO3mEPJUCgci3fU7NI6Cb1CsTmvWD19SyfKQsNYvowZqGyioeBGo+hFXYCK5ch+VYCztXJQ==',
    type   => 'ssh-rsa'
  }

  ssh_authorized_key { 'martin.goldammer@gooddata.com':
    user   => $::cfg::user,
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO+2g18unnEIedw3QnwFKVPTqqvzLGbZz6k0qT1385rnN86zbiCqMon+KFYIPnVNPAX4rCeoPjwKu10bgLe39NXL4sgmmfBbxHlZ7AyLV/NT07jBVHeePyNMsj+2WvsKNxIOOtlKNg/z2GDrNeTqwVZbxYbejwoXpcIAm0WPrHjsEUtNuPcYsDGpDzdbL7b3SU0MITF9lX6dcqaijGvW88zxqKBqOZJCz81uxwhnGsJl08FkR91Rc3r+nb5KOAYI690ZrViDQCMbXzbUKrzwxqn1iqKlXNj3vOK6vskeI5Yk9HgjfUBSkzrlLXHBUN5FoHLC5VDmdSzoxSZYNoip16npaf48IYCOKD/GtT7dO1Im2QVMbn0tBX9f0odGECDx1nr+B0/N6aruM/x/l5chu/84diNdgPu0TGR/vZBncpNxYasMmEEx9CiB/VsarZF6K1/r5OxE0Gr2PIZHajcA7nlD8JEZaqJLfzMQ1XE2drGh/ga4wPHR/BzcX3Cd9HFb7pI9eYhet2juiqDgCwKUC17Mljk0r4fGXIyWPh9gRwWQ/tDCn9nyBU9VnSFBUQ1/jWRU5t25ahMGx6NyQ4FYcl0uOYceFaUnJMU6nmwdgYe7FAzR/DILhCUfWiLz2OQn1bh1MZdZktfGZA4w+xAfuGJuKVwdfL/YfFLa+A6FPuQ==',
    type   => 'ssh-rsa'
  }
}

class locale {
  file { '/etc/locale.gen':
    content => 'en_US.UTF-8 UTF-8'
  }

  exec { '/usr/sbin/locale-gen':
    refreshonly => true,
    subscribe => File['/etc/locale.gen']
  }

  exec { '/usr/bin/localedef -i en_US -f UTF-8 en_US.UTF-8':
    refreshonly => true,
    subscribe => File['/etc/locale.gen']
  }

  file { '/etc/default/locale':
    ensure  => file,
    content => 'LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_UTF.UTF-8'
  }
}

class krb {
  cron { 'non-gdc':
    command => "/home/${::cfg::user}/fireplace/scripts/play-rand.sh scream",
    hour    => '7-19',
    minute  => '0',
  } ->
  cron { 'gdc':
    command => "/home/${::cfg::user}/fireplace/scripts/play-rand.sh gdc",
    hour    => '7-19',
    minute  => '30',
  } ->
  file { '/etc/systemd/system/ohen.service':
    content => '[Unit]
Description=Ohen As AS ervice

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi
ExecStart=/home/pi/fireplace/scripts/play.sh /home/pi/fireplace/movies/ohen2.mp4
Restart=on-failure

[Install]
WantedBy=multi-user.target'
  } ~>
  exec { '/bin/systemctl enable ohen.service':
    refreshonly => true,
  } ~>
  exec { '/bin/systemctl daemon-reload':
    refreshonly => true,
  } ~>
  service { 'ohen':
    enable  => true,
    ensure  => 'running'
  }
}
