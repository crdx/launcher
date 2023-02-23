class DesktopEntry
    @data : Hash(String, String)
    @path : String

    def initialize(path)
        @path = path
        @data = INI.parse(File.read(path))["Desktop Entry"]
    end

    def path
        @path
    end

    def name
        @data["Name"]
    end

    def hidden?
        @data["NoDisplay"]? == "true" || @data["Hidden"]? == "true"
    end

    def application?
        @data["Type"]? == "Application"
    end

    def basename
        File.basename(@path)
    end

    def launch
        Process.run("gtk-launch", { basename })
    end
end
