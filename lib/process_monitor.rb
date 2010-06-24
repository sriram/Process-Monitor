def get_pid(process_type,process_pattern)
  # Parse the output to fetch the process id.
  process_id_reg_exp = %r{^(.*)\s*}

  process_information_lines = `pgrep #{process_type}|xargs ps`.split("\n")
  pid = nil

  process_information_lines.each do |process_line|
    # The name of the process will be verity-spider
    # This is to make sure we don't kill any other ruby process other than spider.
    if process_line =~ /#{process_pattern}/
      process_id_reg_exp.match(process_line)
      pid = $1.gsub(/\s*/, "").to_i
    end
  end
  pid
end


def get_process_status
  `cat /proc/#{pid}/status|grep State`
end


def process_running?(process_type,process_pattern)
  pid = get_pid(process_type,process_pattern)
  # The folder /proc/<pid>/ contains information about the process
  # The file /proc/<pid>/status gives information about the process as to if it is sleeping and so on.
  # If the folder exists it would mean the process exists.
  (pid.nil? || !File.exists?("/proc/#{pid}"))? false : true
end

