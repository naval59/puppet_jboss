notify { 'Hello': }
node default {
 include puppet_vim
# include sample
# notify { lookup(sample::message): }
 include sample
 include jboss7
}


