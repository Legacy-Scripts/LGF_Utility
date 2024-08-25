fx_version 'cerulean'
game 'gta5'
version '1.0.0'
lua54 'yes'
use_fxv2_oal 'yes'

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
  'web/build/index.html',
  'web/build/**/*',
}

ui_page 'web/build/index.html'

