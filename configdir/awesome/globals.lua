local globals = {
    modkey = "Mod4",
    terminal = "alacritty",
    editor = os.getenv("EDITOR") or "vim",
    filemgr = "nemo",
}

globals.terminal_cmd = globals.terminal .. " -e "
globals.terminal_cmd_format = globals.terminal_cmd .. "%s"
-- terminal_cmd_format = terminal_cmd .. "\"%s\""

return globals
