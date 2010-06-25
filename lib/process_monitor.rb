class ProcessMonitor
  
  ##
  # This method fetches the process ids of the process matching the process_type and
  # process_pattern
  # This method returns an array of hash as [{:process => {:pid => pid,:command => "Command to invoke the process",:status => "Status of the process"},...]

  def self.get_pid(process_type,process_pattern="",get_status=true)
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
        pid  = $1.gsub(/\s*/, "").to_i
        unless $$ == pid
          pid_command = `cat /proc/#{pid}/cmdline`
          if get_status
            pids << {:process => {:pid => pid, :command => pid_command, :status => get_process_status(pid)}}
          else
            pids << {:process => {:pid => pid, :command => pid_command}}
          end
        end
      end
    end
    
    pids
  rescue => e
    "Exception occurred. Exception => #{e.inspect}. Backtrace => #{e.backtrace} "
  end


  ##
  # Gets the process status given the process id

  def self.get_process_status(pid=nil)
    if process_is_up? pid
      status_regexp = %r{\s\((.*)\)\n}
      complete_status = `cat /proc/#{pid}/status|grep State`
      status_regexp.match(complete_status)
      status = $1.capitalize
    else
      "Process is not running!"
    end
  rescue => e
    "Exception occurred. Details => #{e}"
  end

  
  ##
  # Fetch the IO details of the process

  def self.get_io_details(pid=nil)
    if process_is_up? pid
      io = `cat /proc/#{pid}/io`
      io
    else
      "Process is not running!"
    end
  rescue => e
    "Exception occurred. Details => #{e}"
  end


  ##
  # Fetch the stack trace of the process

  def self.get_stack_details(pid=nil)
    if process_is_up? pid
      stack = `cat /proc/#{pid}/stack`
      stack
    else
      "Process is not running!"
    end
  rescue => e
    "Exception occurred. Details => #{e}"
  end


  ##
  # Fetch the system call made by the process

  def self.get_syscall_details(pid=nil)
    if process_is_up? pid
      syscall = `cat /proc/#{pid}/syscall`
      syscall
    else
      "Process is not running!"
    end
  rescue => e
    "Exception occurred. Details => #{e}"
  end

  
  ##
  # Fetch the limits of the process.

  def self.get_limits_details(pid=nil)
    if process_is_up? pid
      limits = `cat /proc/#{pid}/limits`
      limits
    else
      "Process is not running!"
    end
  rescue => e
    "Exception occurred. Details => #{e}"
  end


  ##
  # Returns true if the process is up else returns false.

  def self.process_is_up?(pid)
    if !pid.nil? && pid.is_a?(Integer)
      # The folder /proc/<pid>/ contains information about the process
      # The file /proc/<pid>/status gives information about the process as to if it is sleeping and so on.
      # If the folder exists it would mean the process exists.
      (pid.nil? || !File.exists?("/proc/#{pid}"))? false : true
    else
      false
    end
  rescue => e
    puts "Exception #{e} occurred. Details => #{e.backtrace}"
    return false
  end


  ##
  # Implements method missing. If get_first_pid is requested it returns a single hash of the first process to match.

  def self.method_missing(sym, * args, & block)
    if sym.to_s =~ /get_first_pid/
      return self.send(:get_pid, * args,& block).first
    end

    raise NoMethodError.new("Method \'#{sym.to_s}\' does not exist", sym.to_s, args)
  end

end