apt_update 'all platforms'

user "user" do
  comment "default user"
  home "/home/user"
  shell "/bin/bash"
  gid "admin"
  password "$1$QnV1y6Fs$VUzciCDd0cphAGX2bazh60"
end


package 'python-pip'
package 'python-setuptools'
package 'python-dev'
package 'supervisor'

easy_install_package 'pyTelegramBotAPI'


