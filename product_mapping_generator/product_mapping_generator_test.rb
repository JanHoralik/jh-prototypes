require "test/unit"
require "product_mapping_generator"

 class ProductMappingGeneratorTest < Test::Unit::TestCase

  def setup
     @g = ProductMappingGenerator.new
  end

  def teardown
  end

  def test_load_product_info   
        
	@g.load
  	assert_equal 10, @g.productToPck.keys.count 
        assert_equal 10, @g.countryToSalesOrg["GB"].count
	assert_equal 10, @g.countryToSalesOrg["DK"].count
	assert_equal 10, @g.countryToRpg["DK"].count	
 	    
  end

  def test_generate_l1_prices
	
	@g.load
	l1Prices = @g.generateL1Prices
	assert_equal 10, l1Prices.count
	assert_equal "5001 EUR", l1Prices[5][1]
	assert_equal "Approved", l1Prices[5][2]
	assert_equal "01/10/2010", l1Prices[5][3]
	assert_equal "31/12/9999", l1Prices[5][4]
	
  end

    def test_generate_l2_prices
	
	@g.load
	l2Prices = @g.generateL2Prices
	assert_equal 10, l2Prices.count
	#assert_match /(0-9,A-Z,\-)+/, l2Prices[5][0]
	assert_equal "4999 EUR", l2Prices[5][1]
	assert_equal "Approved", l2Prices[5][2]
	assert_equal "01/10/2010", l2Prices[5][3]
	assert_equal "31/12/9999", l2Prices[5][4]
	assert_equal "GB", l2Prices[5][5]
	
  end


  def test_generate_mlfb_hqpg_mapping
	  
	@g.load
	mapping = @g.generateMlfbMappingWithHqpg "GB"
	assert_equal 10, mapping.count
	assert_equal 5, mapping[0].count
  end

  def test_generate_mlfb_rpg_mapping

	@g.load
	mapping = @g.generateMlfbMappingWithHqpg "DK"
	assert_equal 10, mapping["VProductSalesData"].count
	assert_equal 5, mapping["VProductSalesData"][0].count
	assert_equal 10, mapping["SCountryRpgPckData"].count
	assert_equal 3, mapping["SCountryRpgPckData"][0].count
  end

 end

