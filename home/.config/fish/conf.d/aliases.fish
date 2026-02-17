# Command aliases
alias l="eza -l"

function wr
    wrangler $argv
end

# Search for files by extension with optional max depth
# Usage: fi -d 2 sh yml yaml
#        fi sh yml  (no depth limit)
function fi
    set -l depth ""
    set -l extensions

    # Parse arguments
    while set -q argv[1]
        switch $argv[1]
            case -d --depth
                if set -q argv[2]
                    set depth "--max-depth" $argv[2]
                    set -e argv[1..2]
                else
                    echo "Error: -d/--depth requires a value"
                    return 1
                end
            case '*'
                set -a extensions $argv[1]
                set -e argv[1]
        end
    end

    # Check if we have extensions
    if test (count $extensions) -eq 0
        echo "Usage: fi [-d DEPTH] EXTENSION..."
        echo "Example: fi -d 2 sh yml yaml"
        return 1
    end

    # Build fd command with -e flags for each extension
    set -l fd_cmd fd
    for ext in $extensions
        set -a fd_cmd -e $ext
    end
    set -a fd_cmd .
    if test -n "$depth"
        set -a fd_cmd $depth
    end

    # Execute the command
    eval $fd_cmd
end
