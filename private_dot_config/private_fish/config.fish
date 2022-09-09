fish_add_path ~/zig/master/files

if status is-interactive
    # Commands to run in interactive sessions can go here
end

direnv hook fish | source
fish-nix-shell --info-right | source
