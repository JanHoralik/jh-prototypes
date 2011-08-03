require "script_builder"


  # main 
  if ARGV.count < 1
    puts "Usage: ruby convert_log_to_script.rb inputFile1 [inputFile2] .. [inputFileN]"
             exit(1)
  end

 
  inputFiles = ARGV
  inputFiles.each do |file|
	  if(!File.exist?(file)) then
		  raise ArgumentError, "Input file not found:#{file}"
	  end
  end

  b = ScriptBuilder.new
  inputFiles.each {|file| b.addLog file}
  scriptLines = b.process
  b.write(STDOUT, scriptLines)
  
	

