
--[[
=head1 NAME

applets.Quit.QuitMeta - Quit meta-info

=head1 DESCRIPTION

See L<applets.Quit.QuitApplet>.

=head1 FUNCTIONS

See L<jive.AppletMeta> for a description of standard applet meta functions.

=cut
--]]


local oo            = require("loop.simple")
local os            = require("os")

local AppletMeta    = require("jive.AppletMeta")

local Framework     = require("jive.ui.Framework")

local appletManager = appletManager
local jiveMain      = jiveMain

local EVENT_CONSUME = jive.ui.EVENT_CONSUME
local EVENT_QUIT    = jive.ui.EVENT_QUIT


module(...)
oo.class(_M, AppletMeta)


function jiveVersion(self)
	return 1, 1
end


function registerApplet(self)
end

function configureApplet(self)
	-- add ourselves to the end of the main menu
	jiveMain:addItem({
		id = 'appletQuit',
		iconStyle = 'hm_quit',
		node = 'home',
		text = self:string("QUIT"),
		callback = function() 
			-- disconnect from Player/SqueezeCenter
			appletManager:callService("disconnectPlayer")
			os.execute('openframe_power.sh quit')
			Framework:quit()

			-- return (EVENT_CONSUME | EVENT_QUIT)
			return
		end,
		weight = 1010,
	})
end


--[[

=head1 LICENSE

Copyright 2010 Logitech. All Rights Reserved.

This file is licensed under BSD. Please see the LICENSE file for details.

=cut
--]]
