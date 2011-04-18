if(ARGV.count<3) 
	puts "Usage: add_column <file> <header> <value>\n"
	exit 0
end

firstLine = true
file = File.open(ARGV[0], "r")
while (line = file.gets)
    line.chomp!	
    if(firstLine)
     	line << ",#{ARGV[1]}"
	firstLine = false
     else
	line << ",#{ARGV[2]}"	     
     end
     puts "#{line}"
end
file.close
