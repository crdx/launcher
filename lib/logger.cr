class Logger
    @@log : Path = Path["~/.config/launcher/log.txt"].expand(home: true)

    def self.log(entry)
        if !File.directory?(@@log.dirname)
            Dir.mkdir_p(@@log.dirname)
        end

        file = File.open(@@log, "a+")
        file.print "[%s] Launch %s (%s)\n" % [Time.local, entry.name, entry.path]
        file.close
    end
end
