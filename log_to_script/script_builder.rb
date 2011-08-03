require "csv"

class ScriptBuilder

	def initialize

		@logFiles = []
		@stepCounter = 1
		@state = nil
	end

	def startNewTest

		@stepCounter = 1
		@state = "header"

	end

	def startNewForCycle(stepCount)
		
		@forStepCounter = stepCount
	end

	def addLog(inputFilename)
	
		@logFiles << inputFilename		
	end

	def process()
		
		@scriptLines = []

		@logFiles.each do |logFile|

			startNewTest
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
			elsif (row[0] == "FOR")
				
				startNewForCycle(row[2])
				@scriptLines << row[1]	
				@state = "forCycle"
			else
				@scriptLines << readAction(row)
			end

		when "forCycle"
		
			if(row[0] == "END")

				@scriptLines << ".."
				@state = "commonLine"
			else
				if(@forStepCounter.to_i > 0) then

					@scriptLines << readAction(row)
					@forStepCounter = @forStepCounter.to_i-1
				else
					# skip other lines
				end
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

	def writeToFile(filename, rows)

		File.open filename, "wb" do |file|
			rows.each {|row| file.puts row}
		end	
	end

end
