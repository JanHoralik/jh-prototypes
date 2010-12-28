require 'win32ole'
require 'dl'
require 'time'
require 'ftools'

class TimeFilter

  SHEET_INDEX = 1 	
  TIME_COLUMN_INDEX=3
  LAST_COLUMN_LETTER = 'f'

  attr_reader :iwb, :owb 

  def initialize(dir, inputFile, outputFile, startTs, endTs)  

    @dir = dir
    @inputPath = dir+"\\"+inputFile
    @outputPath = dir+"\\"+outputFile
  
    @startTime = Time.parse(startTs)
    @endTime = Time.parse(endTs)
  
  end

  def open

    # Create an instance of the Excel application object
    @xl = WIN32OLE.new('Excel.Application')
    # Make Excel visible
    @xl.Visible = 1
    
    @iwb = @xl.Workbooks.Open(@inputPath)
    @ws = @iwb.Worksheets(1)

    @owb = @xl.Workbooks.Add
  end

  def copyLine(inputLine,outputLine)
    
    @owb.Worksheets(SHEET_INDEX).Cells(outputLine,TIME_COLUMN_INDEX).Value =  @iwb.Worksheets(SHEET_INDEX).Cells(inputLine,TIME_COLUMN_INDEX).Value
  end	  

  def close

	@iwb.Close(false)
	  
	File.delete(@outputPath) if File.exists?(@outputPath)
        # xlCSV = 6	
	@owb.SaveAs(@outputPath,6)
        @owb.Close(false)

	@xl.Quit

	@xl = @iwb = @owb =  nil
	
  end

  def _d(value)
    user32 = DL.dlopen('user32')
    msgbox = user32['MessageBoxA', 'ILSSI']
    r, rs = msgbox.call(0, value.to_s, "Debug", 0)
    return r
  end 
 

  def getCellValue(wb, si,ri,ci)
	wb.Worksheets(si).Cells(ri,ci).Value
  end

  def getTimestamp(wb, ri)
	return getCellValue(wb, SHEET_INDEX,ri,TIME_COLUMN_INDEX);
  end  

  def filterByTimeRange(ts)
    
    t = Time.parse(ts)
    return t>=@startTime && t<@endTime
    
  end

  def firstEmptyLine(ws)

    line = '1'
    while ws.Range("a#{line}")['Value']
      line.succ!
    end
  
    return line
  end

  def process()
    
    iws = @iwb.Worksheets(SHEET_INDEX)
    lastInputLine = Integer(firstEmptyLine(iws))-1 
    endColumn = LAST_COLUMN_LETTER

    ows = @owb.Worksheets(1)
    outputLine = 2

    # copy header
     ows.Range("a1:#{endColumn}1")['Value'] = iws.Range("a1:#{endColumn}1")['Value']

    # copy data if they pass time filter
    for inputLine in 2..lastInputLine do

      if filterByTimeRange(getTimestamp(@iwb,inputLine))

        val = iws.Range("a#{inputLine}:#{endColumn}#{inputLine}")['Value']	      
        ows.Range("a#{outputLine}:#{endColumn}#{outputLine}")['Value'] = val 
        
	outputLine = outputLine.succ
      end	
    end
    
  end

  # main 
  if ARGV.length != 5
    puts "Usage: filterByTime <dir> <inputFile> <outputFile> <startTs, e.g.2010/12/15 17:20:00 > <endTs>"
             exit(1)
  end

  @f = TimeFilter.new(ARGV[0],ARGV[1],ARGV[2],ARGV[3],ARGV[4])
  @f.open
  @f.process
  @f.close
	
end

