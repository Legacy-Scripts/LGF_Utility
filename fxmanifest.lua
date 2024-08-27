fx_version 'cerulean'
game 'gta5'
version '1.0.2'
lua54 'yes'
use_fxv2_oal 'yes'
author 'ENT510'
description 'UI library for fivem'

shared_script { "@ox_lib/init.lua",'init.lua'}

shared_scripts { 'shared/Config.lua','shared/Shared.lua',}
client_scripts {'client/**/*','game/client/*.lua',}
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/**/*', 'game/server/*.lua',}

files {'web/build/index.html', 'web/build/**/*',}
ui_page 'web/build/index.html'
