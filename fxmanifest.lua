fx_version 'cerulean'
game 'gta5'
version '1.0.0'
lua54 'yes'

shared_scripts {
  'shared/*.lua',
  '@ox_lib/init.lua', -- Used only for test the Textui Whit a points
}

client_scripts {
  'client/**/*',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/**/*'
}

files {
  -- 'locales/*.json',
  'web/build/index.html',
  'web/build/**/*',
}

ui_page 'web/build/index.html'
