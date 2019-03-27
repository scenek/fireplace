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

  ssh_authorized_key { 'stepan@stepan-ntb':
    user   => $::cfg::user,
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAgEAy2evqVvSAyirplCBRAp5mEv2EB0K71HNEDt0xuJwB1PJoODy+tjJjgIvQkppBIhDnWjgiepxp4ITmrHJ18nqTLbUIZ8mczBhb8BZdIJptbDtP6mZiGxnraYwTlz0a/BAC948rcqf2xrZbTUdd247mPWdGzhXGmhyB/Avn6hCLFDAvhyBm7bDOxmBAa5pD4f4AlMoSdmMVu3BuJHPrFFBSZy6lcKuqC0wywUWhMm3VDD0+g4EM/pNo6aKg9pSYe9W++f6W53Vnfs/WUcCKo8QKT2oSeo5Sdk+pqJJEla4rLPYfjy/+YBGo0BJ95Zj/VAmpEbyhht7kJw7Bw9lbgXW/2euwFuwsALj809HNaXsLWYnnrwar1MxcJRQWyGmt+Wt1fee5NMzSDBsp05S6x6wWxpeh5Ubc0d6fIEsJ3eIhubQOzd6VZk02F8ctc86jwNWapQYgY/RBP8D7u3B6hBUJXWR9ryC+5CrKYVd5FCOnUiDSpk4AyYc26uzLuZL6Zjp+iaBbthVjTzazUmIuvg1tV6I4Pygbx+x6W/nQXpTMwJD+w8oUiFSlllXcHC3e/y6IS084B3KTjIco0n7gyGJvZNzvsQF5WcDqYr4ccocCcXEdGIQy16YDkYITNl03FxQZIiQc+gCTyph+Atqk6ZqbKYmmvR+kGna//Bh5WL9sik=',
    type   => 'ssh-rsa'
  }

  ssh_authorized_key { 'petr.benas@gooddata.com':
    user   => $::cfg::user,
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC/dYtN0/kJPAsoKs1LJ9wRP5Sz8AmkF3p/1E1h9RTlrJ3XFlU6Aba/CoIoK/QSPweXQJW9f9ZTCDgt5YnwNHBVuKWoS5Yc48pUK0dnvtLnuVd59C4I7MP0VK3MD1tucM4DQh8m1PRfWGfygtarBwWVR2awwGP5sJsSPppvf1kJAtIaJ3DPxWdkBsEqZTg2hGf6f9oOCtsXr2ml0Zk1XhDO1+ryFiq9F5C7ATNindlMPEo31Ac4yDkVt8p/aK2UeRX2SjcFAGwndL6X04pdC2tQR7BPWCI6qTLuOZ2hsK7dCjjgH5wbHLWGecEmtCpRCQDiQmuGqXTUKwWZ29Nqj8GOCnuQ1omhTQjqy/Qod+H8IFwbFqZ9B6hcYSpIPKWb815D9wtUJglZpvriYMlJ8fohWpkkPsCyaOSL1JIp5GOn+99wbBopI9wyopusBZ2+AyipvnSPFxFYseWL58kv/xuyVKSSGfXE22r75d5QG29+BvnLjgwnMhXlk08jH43FvVGocjXTTgFdNF31cjuYWOZlZMSeNWM7ywFjgQV2EAhkFm1RfXbzSiudzIktWPoDV1P5cq4Ec3hBYYlgt3F4OpD98my9v259E8xWbgZptY4SOwCZZC5M3uy/Tz7NzNUFKLapkTwg+reYztyoXZtn+rKzDnbmDR1+LabRVydN0gAk5w==',
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
  cron { 'skola':
    command => "/home/${::cfg::user}/fireplace/scripts/play-rand.sh skola",
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
ExecStart=/home/pi/fireplace/scripts/play.sh /home/pi/fireplace/movies/ohen.mp4
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
