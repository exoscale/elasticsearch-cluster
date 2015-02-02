class elasticsearch {

  include apt

  apt::repo { 'elasticsearch':
    key_url => 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch',
    location => 'http://packages.elasticsearch.org/elasticsearch/1.4/debian/'
  }

  package { 'openjdk-7-jre':
    ensure => latest
  }

  package { 'elasticsearch':
    require => [Exec['/usr/bin/apt-get update'],
                Apt::Repo['elasticsearch'],
                Package['openjdk-7-jre']],
    ensure => latest
  }

  file { '/etc/elasticsearch/elasticsearch.yml':
    content => template('elasticsearch/elasticsearch.yml.erb'),
    require => Package['elasticsearch'],
    notify => Service['elasticsearch']
  }

  service { 'elasticsearch':
    ensure => running
  }
}
