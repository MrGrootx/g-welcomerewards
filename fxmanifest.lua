fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "G3DEV - justgroot"
description "A boilerplate for my feature project"
version '1.0.0'

shared_scripts {
	"src/shared/Config.lua",
	"locales/locale.lua",
	"src/shared/nui_localizations.lua",
	"locales/translations/*.lua",
	-- "src/utils/global.lua",
}

server_scripts {
	"src/shared/sv_config.lua",
	-- "@oxmysql/lib/MySQL.lua",
	-- "bridge/**/server.lua",
	-- "src/server/utils.lua",
	"src/server/*.lua",
}


client_script {
	-- "bridge/**/client.lua",
	"src/client/*.lua",
	"src/theme/theme.lua",
}


ui_page 'http://localhost:3000/' -- (for local dev)
-- ui_page 'web/build/index.html'

files {
  'web/build/index.html',
	'web/build/**/*',
  'src/shared/*.lua'
}

use_experimental_fxv2_oal "yes"
