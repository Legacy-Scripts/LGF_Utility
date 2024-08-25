fx_version 'cerulean'
game 'gta5'
version '1.0.1'
lua54 'yes'
use_fxv2_oal 'yes'
author 'ENT510'
description 'UI library for fivem'
shared_scripts {
  'shared/*.lua',
  -- '@ox_lib/init.lua', -- Used only for test the Textui Whit a points for testing purposes
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


