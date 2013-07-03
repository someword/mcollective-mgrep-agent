module MCollective
  module Agent
    class Mgrep<RPC::Agent
      attr_accessor :file_list, :blacklist
      action "search" do

        check_files(request[:file])

        check_blacklist if blacklist_enabled?

      	cmd = "/bin/grep"
        cmd << " -c " if request[:count]
        cmd << " -v " if request[:invert]
        cmd << " -i " if request[:ignore_case]
        cmd << " -m #{request[:lines]} " if request[:lines]

        run("#{cmd} #{request[:pattern]} #{request[:file]}", :stdout => :results, :stderr => :err, :chomp => true)
        reply[:results]
      end

    private

    def check_files(f)
      @file_list = Dir.glob(f)
      if @file_list.empty?
       reply.fail! "No files found matching #{f}"
      end
    end

    def blacklist_enabled?
      config = Config.instance.pluginconf["mgrep.blacklist"] || '/etc/mcollective/plugin.d/mgrep.cfg'
      @blacklist = []
      if File.exists?(config)
        begin
          @blacklist = File.read(config).split(/\n/).delete_if do |l|
            l =~ /(^#|^$)/
          end
        rescue Exception => e
          Log.warn("An error occurred while trying to read #{config}")
        end 
      end
      @blacklist.count > 0
    end

    def check_blacklist
      matches = @file_list.inject([]) do |matches, file|
        matches << file if @blacklist.any? {|b| file.match(b.strip) }
      end

      reply.fail! "Blacklisted file(s): #{matches.join(' ')}" if matches
    end
    end
  end
end
