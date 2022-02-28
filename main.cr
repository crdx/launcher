require "ini"
require "system"

require "./lib/logger"
require "./lib/desktop_entry"
require "./lib/desktop_entry_collection"
require "./lib/popularity_contest"

desktop = DesktopEntryCollection.new(File.join(Path.home, ".local/share"))

entries = desktop.entries
    .select { |path| File.file?(path) }
    .map { |path| DesktopEntry.new(path) }
    .reject(&.hidden?)
    .select(&.application?)

contest = PopularityContest.new(entries)
entries = contest.sorted
choices = entries.map(&.name)

choices_tally = choices.tally

choices.map_with_index! do |choice, i|
    # If any choices are duplicates by name, append the basename to its name so we can correctly
    # pick it out from the list on selection.
    if choices_tally[choice] > 1
        "%s (%s)" % [choice, entries[i].basename]
    else
        choice
    end
end

choice = Process.run("dmenu", args: { "-i", "-m", "0", "-b", "-h", "25" }) do |proc|
    proc.input.puts choices.join("\n")
    proc.input.close
    proc.output.gets
end

index = choices.index(choice)

if index.nil?
    exit
end

entry = entries[index]

contest.vote entry
Logger.log entry

entry.launch
