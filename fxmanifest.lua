fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "G3DEV - justgroot"
description "A welcome rewards system"
version '1.0.0'

shared_scripts {
	"src/shared/Config.lua",
	"locales/locale.lua",
	"src/shared/nui_localizations.lua",
	"locales/translations/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"src/server/init/*.lua",
	"src/shared/sv_config.lua",
	"src/server/utils.lua",
	"bridge/**/server.lua",
	"src/server/services/*.lua",
	"src/server/*.lua",
}


client_script {
	"bridge/**/client.lua",
	"src/client/utils.lua",
	"src/client/cl_vehicle_spawn.lua",
	"src/client/client.lua",
	"src/client/cl_edit.lua",
	"src/theme/theme.lua",
}


-- ui_page 'http://localhost:3000/' -- (for local dev)
ui_page 'web/build/index.html'

files {
  'web/build/index.html',
   'web/build/**/*',
  'src/shared/*.lua'
}

use_experimental_fxv2_oal "yes"
