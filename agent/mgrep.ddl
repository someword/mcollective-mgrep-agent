metadata :name => "mgrep",
         :description => "Grep via mcollective",
         :author => "derek.olsen@jivesoftware.com",
         :license => "ASL2.0",
         :version => "0.0.3",
         :url => "http://www.jivesoftware.com/",
         :timeout => 60

action "search", :description => "Search for stuff" do
     input :file,
           :prompt      => "Filename",
           :description => "Search Target",
      	   :type        => :string,
           :validation  => :shellsafe,
           :maxlength   => 256,
           :optional    => false

     input :pattern,
           :prompt      => "Pattern",
           :description => "Search Filter",
      	   :type        => :string,
           :validation  => :shellsafe,
           :maxlength   => 256,
           :optional    => false
     
     input :invert,
      	   :prompt      => "Invert",
           :description => "Invert Filter",
           :type        => :boolean,
           :valiation   => :bool,
           :optional    => true

     input :ignore_case,
      	   :prompt      => "Ignore case",
           :description => "Ignore case",
           :type        => :boolean,
           :valiation   => :bool,
           :optional    => true

     input :lines,
      	   :prompt      => "Lines",
           :description => "Lines to Return",
           :type        => :integer,
           :validation  => :integer,
           :optional    => true

     output :results,
            :description => "Search Results",
            :display_as  => "Results"
end
