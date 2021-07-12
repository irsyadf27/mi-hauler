fx_version 'cerulean'
game 'gta5'

description 'Mi-Hauler'
version '1.0.0'

shared_scripts { 
	'@qb-core/import.lua',
	'config.lua'
}

client_scripts {
    'client/main.lua',
}

server_script 'server/main.lua'