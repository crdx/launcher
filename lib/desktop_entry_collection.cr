class DesktopEntryCollection
    def initialize(@user_path : String)
    end

    def entries
        # Assume that XDG_DATA_DIRS is complete and that anything new will (correctly) add to that.
        paths = ENV["XDG_DATA_DIRS"].split(":").map(&.rstrip('/')).uniq
        user_entries = get_entries(@user_path)
        system_entries = paths.map { |path| get_entries(path) }.flatten
        (filter_system_entries(system_entries, user_entries) + user_entries).flatten
    end

    private def filter_system_entries(system, user)
        # Even though we are using `gtk-launch` to launch the desktop file by basename (so that will
        # do the work of figuring out which one (system or user) to run), we use the Name for
        # display and that *could* be changed by a user override.
        user_basenames = user.map { |entry| File.basename(entry) }
        system.reject { |entry| user_basenames.includes?(File.basename(entry)) }
    end

    private def get_entries(path)
        # This may be better as "applications/**/*.desktop".
        Dir[File.join(path, "applications/*.desktop")]
    end
end
