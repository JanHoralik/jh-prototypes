require "test/unit"
require "product_mapping_generator"

 class ProductMappingGeneratorTest < Test::Unit::TestCase

  USE_RANDOM = false
  OUTPUT_FOLDER = "out"

  def setup
     @g = ProductMappingGenerator.new(USE_RANDOM, OUTPUT_FOLDER)
  end

  def teardown
  end

  def test_load_product_info   
        
	@g.load
  	assert_equal 37, @g.productToPck.keys.count 
        assert_equal 4, @g.countryToSalesOrg["GB"].count
	assert_equal 4, @g.countryToSalesOrg["DK"].count
	assert_equal 1936, @g.rpgs.count	
 	    
  end

  def test_selectProducts

	@g.load
	products = @g.selectProducts(23)
	assert_equal 23, products.count
	assert_equal "1FK7082-7AF71-1FH2", products[0] 
  		
  end  
  def test_generate_l1_prices
	
	mlfbs = ["100001162", "100001208", "100001219"]

	@g.load
	l1Prices = @g.generateL1Prices(mlfbs)
	assert_equal 3, l1Prices.count
	assert_equal "100001208", l1Prices[1][0]
	assert_match "777 EUR", l1Prices[1][1]
	assert_equal "Approved", l1Prices[1][2]
	assert_equal "01/10/2010", l1Prices[1][3]
	assert_equal "31/12/9999", l1Prices[1][4]
	
  end

    def test_generate_l2_prices
	
	mlfbs = ["100001162", "100001208", "100001219"]

	@g.load
	l2Prices = @g.generateL2Prices("GB", mlfbs)
	assert_equal 3, l2Prices.count
	assert_equal "733 GBP", l2Prices[1][1]
	assert_equal "Approved", l2Prices[1][2]
	assert_equal "01/10/2010", l2Prices[1][3]
	assert_equal "31/12/9999", l2Prices[1][4]
	assert_equal "GB", l2Prices[1][5]
	
  end


  def test_generate_mlfb_hqpg_mapping
	  
	@g.load
	products = @g.selectProducts(10)
	assert_equal 10, products.count
	assert_equal "1FK7082-7AF71-1FH2", products[0]
	
	mapping = @g.generateMlfbMappingWithHqpg(products, "GB")
	assert_equal 10, mapping["VProductSalesData"].count
	assert_equal "7011", mapping["VProductSalesData"][0][1]
 end

  def test_generate_mlfb_rpg_mapping

	@g.load
	products = @g.selectProducts(10)
	assert_equal 10, products.count
	assert_equal "1FK7082-7AF71-1FH2", products[0]
	
	mapping = @g.generateMlfbMappingWithRpg(products, "DK")
	assert_equal 10, mapping["VProductSalesData"].count
	assert_equal "5411", mapping["VProductSalesData"][0][1]
	assert_equal 10, mapping["SCountryRpgPckData"].count
	assert_equal "DK", mapping["SCountryRpgPckData"][0][0]
	assert_equal "*HA", mapping["SCountryRpgPckData"][0][1]
	assert_equal "9620", mapping["SCountryRpgPckData"][0][2]
  end

def test_write_files_hq

	@g.load
	products = @g.selectProducts(20)
	mapping = @g.generateMlfbMappingWithHqpg(products, "GB")
	
	@g.writeToCsv(products, "products.txt")
	assert File.exists?("out\\products.txt")
	@g.writeToCsv(mapping["VProductSalesData"], "sales.csv")
	assert File.exists?("out\\sales.csv")

	@g.writeToCsv(@g.generateL1Prices(products), "l1prices.txt")
	@g.writeToCsv(@g.generateL2Prices("GB",products), "l2prices.txt")
end

def test_write_files_rpg

	country = "DK"

	@g.load
	products = @g.selectProducts(20)
	mapping = @g.generateMlfbMappingWithRpg(products, "DK")

	@g.writeToCsv(products, "products.txt")
	assert File.exists?("out\\products.txt")
	@g.writeToCsv(mapping["VProductSalesData"], "sales.csv")
	assert File.exists?("out\\sales.csv")
	@g.writeToCsv(mapping["SCountryRpgPckData"], "rpgpck.csv")
	assert File.exists?("out\\rpgpck.csv")

	@g.writeToCsv(@g.generateL1Prices(products), "l1prices.txt")
	@g.writeToCsv(@g.generateL2Prices(country,products), "l2prices.txt")
end


end

