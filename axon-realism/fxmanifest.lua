fx_version 'cerulean'
game 'gta5'

repository 'https://github.com/TFNRP/axonbody3'
version '0.0.1'
author 'Reece Stokes <hagen@hyena.gay> Edit: Underwood Modifications'


ui_page 'html/index.html'
file {
    'html/sound/beep.wav',
    'html/index.html',
    'html/img/logo.png',
    'html/css/style.css',
    'html/fonts/BentonSansRegular.ttf',
}

client_script {
    'config.lua',
    'client/client.lua',
}
server_scripts { 
    'server/server.lua'
}
    
