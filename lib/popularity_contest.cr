class PopularityContest
    @@store : Path = Path["~/.config/launcher/stats.ini"].expand(home: true)
    @data = { runs: {} of String => String }

    def initialize(@entries : Array(DesktopEntry))
        create
        read
    end

    def create
        if !File.directory?(@@store.dirname)
            Dir.mkdir_p(@@store.dirname)
        end
    end

    def read
        if File.exists?(@@store)
            @data = INI.parse(File.read(@@store))
        end
    end

    def write
        File.write(@@store, INI.build(@data, space: true))
    end

    def get_score(path)
        score = @data["runs"][path]?
        score ? score.to_i : 0
    end

    def vote(entry)
        path = entry.path
        @data["runs"][path] = (get_score(path) + 1).to_s
        write
    end

    def sorted
        @entries.sort do |a, b|
            sort_by_score = get_score(b.path) <=> get_score(a.path)
            next sort_by_score if sort_by_score != 0
            a.name <=> b.name
        end
    end
end
