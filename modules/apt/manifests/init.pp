class apt {

  exec { '/usr/bin/apt-get update':
    refreshonly => true
  }

  define repo($key=undef, $key_url=undef, $key_server='pgp.mit.edu', $repos='main', $release='stable', $location) {

    $source_file =  "/etc/apt/sources.list.d/${name}.list"

    if ($key) {

      exec { "${name} repo key":
        path => "/bin:/usr/bin",
        command => "gpg --keyserver ${key_server} --recv-keys ${key} && gpg --export --armor ${key} | apt-key add -",
        cwd => "/",
        before => [ File[$source_file] ]
      }
    }
    if ($key_url) {
      exec {"${name} repo key by url":
        path => "/bin:/usr/bin",
        command => "wget -qO - ${key_url} | apt-key add -",
        cwd => "/",
        before => [ File[$source_file] ]
      }

    }

    file { "${source_file}":
      content => inline_template("deb <%= @location %> <%= @release %> <%= @repos %>\n"),
      notify => Exec['/usr/bin/apt-get update']
    }
  }
}
