# analyze_nginx_log.rb

require 'time'

logs = Hash.new { |hash, key| hash[key] = { total: 0, count: 0, method: '', path: '' } }

File.foreach(ARGV[0]) do |line|
  begin
    # Split the log line by tab
    data = line.strip.split("\t")

    # Parse the necessary fields
    time_field = data.find { |field| field.start_with?('reqtime:') }
    req_field = data.find { |field| field.start_with?('req:') }

    # Ensure required fields are present
    if time_field.nil? || req_field.nil?
    #   puts "Skipping line due to format mismatch: #{line.strip}"
      next
    end

    reqtime = time_field.split(':').last.to_f
    req_parts = req_field.split(' ')
    method = req_parts[1]
    path = req_parts[2]

    key = "#{method} #{path}"
    logs[key][:total] += reqtime
    logs[key][:count] += 1
    logs[key][:method] = method
    logs[key][:path] = path
  rescue => e
    # puts "Skipping line due to error: #{e.message}"
  end
end

puts "sort by total_time"
puts "    avg     total   count   method  path"

logs.sort_by { |_, v| -v[:total] }.each do |key, data|
  avg = data[:total] / data[:count]
  puts "    %0.2f    %0.2f   %d      %s     %s" % [avg, data[:total], data[:count], data[:method], data[:path]]
end
