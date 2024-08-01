class AuditLogger
  def self.log(event, message)
    Dir.mkdir "#{Rails.root}/log/audit" unless Dir.exist? "#{Rails.root}/log/audit"

    log_message = "[#{DateTime.now.to_time.iso8601}] #{event.slug} #{message}\n"
    log_file = File.open(current_log_filepath, mode: 'a')
    log_file.write(log_message)
    log_file.close
  end

  def self.get_log(event)
    return nil unless File.exist? current_log_filepath

    full_content = File.read(current_log_filepath)
    filtered_content = full_content.split("\n").filter{|line| line.include? event.slug }
    filtered_content.join("\n")
  end

  private

  def self.current_log_filepath
    "#{Rails.root}/log/audit/#{DateTime.now.strftime '%d-%m-%Y'}.log"
  end
end
