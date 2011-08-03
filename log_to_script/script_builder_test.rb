require "script_builder"
require "test/unit"

class ScriptBuilderTest < Test::Unit::TestCase

	def setup

		@inputFile1 = "Timing1.csv"
		@inputFile2 = "Timing2.csv"
		@inputFile3 = "Timing3.csv"
		@outputFile = "out.txt"

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
		assert_equal 49, scriptLines.length
	        assert_equal "For all line items..", scriptLines[13]
		assert_equal "013 Add new MLBF line item", scriptLines[14]
		assert_equal "014 Filter LI", scriptLines[15]
		assert_equal "015 Set field on LI 1' 'Proposed Standard Discount' '1'", scriptLines[16]
		assert_equal "..", scriptLines[17]
		assert_equal "016 Price PA ", scriptLines[18]
		assert_match "Logout", scriptLines[-1]
	end

	def test_writeOutputOfMultipleFiles

		@b.addLog @inputFile1
		@b.addLog @inputFile2
		scriptLines = @b.process
		@b.writeToFile @outputFile, scriptLines
		rows = CSV.read @outputFile
		assert_equal 52, rows.count
		assert_equal "019 Logout ", scriptLines[-1]
	end
end
