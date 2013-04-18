while true
  t = Time.now
  count1 = TwitterAPICall.count
  sleep(10)
  count2 = TwitterAPICall.count
  tt = Time.now
  amount = count2-count1
  time = tt-t
  per_hour = amount/time*60*60
  puts "#{per_hour} API calls per hour (#{Time.now})"
end