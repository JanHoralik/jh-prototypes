require "csv"

class ScriptBuilder

	def initialize

		@logFiles = []
		@stepCounter = 1
		@state = nil
	end

	def startNewTest

		@stepCounter = 1
	end

	def addLog(inputFilename)
		
		@logFiles << inputFilename		
	end

	def process()
		
		@scriptLines = []

		@logFiles.each do |logFile|

			@state = "header"

			CSV.foreach(logFile){|row| processLine(row)}
			
			@scriptLines << nil
			@state = nil
		end

		#remove the last empty line
		@scriptLines.delete_at(-1)

		return @scriptLines
	end

	def processLine(row)

		case @state
		when "header"

			@state = "firstLine"

		when "firstLine"
			@scriptLines << readTestName(row)
			@scriptLines << readAction(row)
			@state = "commonLine"

		when "commonLine"
					
			if(row.empty?) then
				
				startNewTest
				@scriptLines << ""
				@state = "firstLine"
			else
				@scriptLines << readAction(row)
			end

		else
			raise RuntimeError "Unknown state:#{@state}"

		end

	end

	def readAction(row)

		step = ("%03d" % @stepCounter).to_s
		@stepCounter += 1 

		puts ">>#{row[3]}<<"

		action = row[3]
		action.slice!(/^\d\d\d\s/)

		return "#{step} #{action}"
	end

	def readTestName(row)

		return row[0]
	end

	def writeToFile(filename)

		file = File.open(filename, 'wb')
		write(file)
		file.close()
	end
	def write(file)

		CSV(file) do |writer|
			@rows.each {|row| writer << row}
		end
	end

end
