fx_version "cerulean"

description "Trisslott System - Svenska Spel Tema"
author "0ph6"
version '1.0.0'

lua54 'yes'

games {
  "gta5",
}

ui_page 'html/ui.html'

client_script "client/client.lua"
client_script "client/utils.lua"
server_script "server/server.lua"
server_script "server/version.lua"
shared_script "config/server.lua"
shared_script "@ox_lib/init.lua"

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
    'html/assets/*.png'
}
