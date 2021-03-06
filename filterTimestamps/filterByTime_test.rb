require "test/unit"
require "filterByTime"

 class TimeFilterTest < Test::Unit::TestCase

  def setup
     @g = TimeFilter.new('C:\msysgit\work\prototypes\filterTimestamps',
			  'timing.csv','timing1.csv', 
			  "2010/12/15 17:20:00", "2010/12/15 17:50:00")
     @g.open
  end

  def teardown
     @g.close
  end

  def assert_cell_equals(si,ri,ci,value)
	  assert_equal(value,@g.getCellValue(@g.iwb,si,ri,ci))
  end
  
  def test_open_close   
          
     assert_not_nil(@g)
  end


  def testReadTimeValues
	assert_equal("2010/12/15 17:30:00",@g.getTimestamp(@g.iwb,2))
  end

  def testRangeFilter()
	assert_equal(true, @g.filterByTimeRange(@g.getTimestamp(@g.iwb,2)));  
  	assert_equal(false, @g.filterByTimeRange(@g.getTimestamp(@g.iwb,155)));  
  end

  def testSavingNewFile()

	@g.copyLine(2,2)
	assert_equal("2010/12/15 17:30:00",@g.getTimestamp(@g.owb,2))
  end

  def testFilterRecords()

    	@g.process
  end	  
 end 

