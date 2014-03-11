# builddep.pp

define apt::builddep() {
  include apt::update

  exec { "apt-builddep-${name}":
    command   => "/usr/bin/apt-get -y --force-yes build-dep ${name}",
    unless    => "/usr/bin/apt-get -s build-dep ${name} | /bin/grep -q '0 upgraded, 0 newly installed'",
    provider  => 'shell',
    logoutput => 'on_failure',
    notify    => Exec['apt_update'],
  }

  # Need anchor to provide containment for dependencies.
  anchor { "apt::builddep::${name}":
    require => Class['apt::update'],
  }
}
