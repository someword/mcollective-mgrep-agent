module MCollective
  module Agent
    class Mgrep<RPC::Agent
      attr_accessor :file_list
      action "search" do

        build_file_list(request[:file])

        check_black_list

      	cmd = "/bin/grep"
        cmd << " -v " if request[:invert]
        cmd << " -i " if request[:ignore_case]
        cmd << " -m #{request[:lines]} " if request[:lines]

        run("#{cmd} #{request[:pattern]} #{request[:file]}", :stdout => :results, :stderr => :err, :chomp => true)
        reply[:results]
      end

    private

    def build_file_list(f)
      @file_list = Dir.glob(f)
      if @file_list.empty?
       reply[:results] = "No files match #{f}"
       reply.fail!
      end
    end

    def check_black_list
      blist_file =  Config.instance.pluginconf["mgrep.blacklist"] || '/etc/mcollective/plugin.d/mgrep.cfg'
      if File.exists?(blist_file)
        begin
          blist = IO.read(blist_file).split(/\n/).delete_if { |l| l =~ /(^#|^$)/ }
        rescue Exception => e
          Log.warn("An exception occurred while opening #{blist_file}")
        end
      else
        blist = []
      end

      matches = @file_list.inject([]) do |matches, file|
        matches << file if blist.any? {|b| file.match(b.strip) }        
      end

      if matches
        reply.fail! "Blacklisted file(s): #{matches.join(' ')}"
      end
    end
    end
  end
end
