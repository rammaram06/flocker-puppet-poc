class flocker::docker_run {

  case $::hostname {
    'flocker-02':{   
      exec {'flocker-1':
        path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        command => 'docker run -d --volume-driver flocker -v puppet-demo:/home/jenkins -p 8080:8080 -p 50000:50000 --name jenkins scottyc/jenkins',
        }
      } 
   }
}   
