Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
   c[:reload_classes] = true
   c[:reload_templates] = true
   c[:reload_time] = 0.5
   c[:log_auto_flush ] = true
   c[:ignore_tampered_cookies] = true
   c[:log_auto_flush ] = true
   c[:log_stream] = STDOUT
   c[:log_level] = :debug
   #c[:log_file]   = nil
}