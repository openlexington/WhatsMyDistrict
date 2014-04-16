role :app, %w{ubuntu@localhost}
role :web, %w{ubuntu@localhost}
role :db,  %w{ubuntu@localhost}

server 'localhost', user: 'whatsmydistrict', roles: %w{web db app}
