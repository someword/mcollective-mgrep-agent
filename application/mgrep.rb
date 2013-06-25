class MCollective::Application::Mgrep<MCollective::Application
  description "Massive Grep"

  usage <<-END_OF_USAGE
mco mgrep [OPTIONS] [FILTERS] <ACTION> [CONCURRENCY|MESSAGE]
Usage: mco mgrep search
Usage: mco mgrep search --file /etc/hosts --pattern mailhost  [--lines LINES]
Usage: mco mgrep search --file /etc/hosts --pattern mailhost  [--invert]

The OPTIONS 'file' and 'pattern' are required
 The argument to '--file' can include a shell glob like this
 --file /some/path/customers/*/config.yaml

 The argument to '--pattern' can include a shell glob but does not
 currently support advanced regular expressions.
--pattern SSL_*oala

The OPTIONS 'lines' and 'invert' are optional
The argument to '--lines' is how many lines to return.   These lines would be the first N matching lines.

The argument '--invert' turns on pattern inversion which matches *any* line which
does not contain the pattern.

The ACTION can be one of the following:

    search    - Perform a grep 
END_OF_USAGE

  option :file,
         :arguments   => ["-f FILE","--file FILE"],
         :description => "The name of the file to search",
         :type        => String,
         :required    => true
  option :pattern,
         :arguments   => ["-p PATTERN","--pattern PATTERN"],
         :description => "The pattern to match against file lines",
         :type        => String,
         :required    => true
  option :lines,
         :arguments   => ["-l LINES","--lines LINES"],
         :description => "The number of lines to return",
         :type        => Integer,
         :required    => false
  option :invert,
         :arguments   => ["-V","--invert"],
         :description => "Invert the match pattern",
         :type        => :bool,
         :required    => false
  option :ignore_case,
         :arguments   => ["-i","--ignore_case"],
         :description => "Invert the match pattern",
         :type        => :bool,
         :required    => false

  def main
    args = {}
    [ :lines, :invert, :ignore_case, :file, :pattern ].each do |arg|
      args[arg] = configuration[arg] if configuration.include?(arg)
    end

    mc = rpcclient("mgrep")
    mgrep_results =  mc.search(args, :options => options).each do |response|
      if response[:statuscode] == 0
        msg = response[:data][:results]
      else
        msg = response[:statusmsg]
      end
      printf("\n---- %10s ---->\n%s\n", "output for #{response[:sender]}", msg)
    end
    printrpcstats
    halt mc.stats
  end
end

