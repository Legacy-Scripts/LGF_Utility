fx_version 'cerulean'
game 'gta5'
version '1.0.7'
lua54 'yes'
use_fxv2_oal 'yes'
author 'ENT510'
description 'UI library for fivem'

shared_scripts {
    "@ox_lib/init.lua",
    "init.lua",
    'shared/*.lua',
}

client_scripts {
    'client/**/*',
    'game/client/*.lua',
    'game/client/class/*.lua',
    'game/framework/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*',
    'game/server/*.lua',
    'game/framework/server.lua',
}

files { 'web/build/index.html', 'web/build/**/*', }
ui_page 'web/build/index.html'
