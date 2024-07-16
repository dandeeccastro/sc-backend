class AuditLogger
  def self.log(event, message)
    Dir.mkdir "#{Rails.root}/log/audit" unless Dir.exist? "#{Rails.root}/log/audit"

    log_message = "[#{DateTime.now.to_time.iso8601}] #{event.slug} #{message}\n"
    log_file = File.open("#{Rails.root}/log/audit/#{DateTime.now.strftime '%d-%m-%Y'}.log", mode: 'a')
    log_file.write(log_message)
    log_file.close
  end
end
