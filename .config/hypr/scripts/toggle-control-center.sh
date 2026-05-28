#!/usr/bin/env bash

# Toggle the eww control_center window and manage the Escape key binding
if eww active-windows | grep -q "control_center"; then
    eww close control_center
    # Dynamically unbind Escape when the menu is closed
    hyprctl eval "if hl.unbind then hl.unbind('', 'Escape') end"
else
    eww open control_center
    # Dynamically bind Escape to close the menu and unbind itself
    # This ensures Escape only closes the menu when it's actually open
    hyprctl eval "if hl.bind then hl.bind('', 'Escape', function() hl.dispatch(hl.dsp.exec_cmd('eww close control_center')); hl.unbind('', 'Escape') end) end"
fi
