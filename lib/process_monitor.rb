class ProcessMonitor
  
  def self.get_pid(process_type,process_pattern="")
    # Parse the output to fetch the process id.
    process_id_reg_exp = %r{^(.*)\s*}

    process_information_lines = `pgrep #{process_type}|xargs ps`.split("\n")
    pids = []

    process_information_lines.each_with_index do |process_line,index|
      next if index == 0
      # The name of the process will be verity-spider
      # This is to make sure we don't kill any other ruby process other than spider.
      if process_line =~ /#{process_pattern}/
        process_id_reg_exp.match(process_line)
        pid =  $1.gsub(/\s*/, "").to_i
        pids << pid unless $$ == pid
      end
    end
    if pids.length > 1
      pids
    else
      pids.first
    end
  end


  def self.get_process_status(pid=nil)
    unless pid.nil?
      `cat /proc/#{pid}/status|grep State`
    else
      p "No pid given!"
    end
  end


  def self.process_is_up?(pid)
    unless pid.nil?
      # The folder /proc/<pid>/ contains information about the process
      # The file /proc/<pid>/status gives information about the process as to if it is sleeping and so on.
      # If the folder exists it would mean the process exists.
      (pid.nil? || !File.exists?("/proc/#{pid}"))? false : true
    else
       p "No pid given!"
    end
  end

end




