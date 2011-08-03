require "script_builder"
require "test/unit"

class ScriptBuilderTest < Test::Unit::TestCase

	def setup

		@inputFile1 = "Timing1.csv"
		@inputFile2 = "Timing2.csv"

		@b = ScriptBuilder.new
	end

	def tearDown
	end

	def test_SimpleFile

		@b.addLog @inputFile1
		scriptLines = @b.process
		assert_equal 16, scriptLines.length
	        assert_equal "D - Summary dashboard", scriptLines[0]
		assert_equal "001 Open login page", scriptLines[1]
		assert_equal "015 Logout ", scriptLines[-1]	
	end

	def test_FileWithTwoScripts

		@b.addLog @inputFile2
		scriptLines = @b.process
		assert_equal 35, scriptLines.length
	        assert_equal "H - Sales Agents dashboard", scriptLines[0]
		assert_equal "001 Open login page", scriptLines[1]
		assert_equal "F - Sales dashboard", scriptLines[15]
		assert_equal "019 Logout ", scriptLines[-1]	
	end

	def test_TwoFiles

		@b.addLog @inputFile1
		@b.addLog @inputFile2
		scriptLines = @b.process
		assert_equal 52, scriptLines.length
	        assert_equal "D - Summary dashboard", scriptLines[0]
		assert_equal "001 Open login page", scriptLines[1]
		assert_equal "019 Logout ", scriptLines[-1]
	end

	def test_ForCycle

		@b.addLog @inputFile3
		scriptLines = @b.process
		assert_equal 10, scripts.length
	        assert_equal "", scripts[2]
		assert_equal "", scripts[8]

	end

	def DIStest_writeOutputOfMultipleFiles

		@b.addLog @inputFile1
		@b.addLog @inputFile2
		scripts = @b.process
		@b.write scripts, @outputFile
		rows = CSV.read @outputFile
		assert_equal 10, rows.count
	end
end
