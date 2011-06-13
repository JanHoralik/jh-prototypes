require "product_mapping_generator"

class Program

HQ_COUNTRIES = ["GB","PL"]
RPG_COUNTRIES = ["DK","NL"]

def initialize(_useRandom, _outputFolder)

	@useRandom = _useRandom
	@outputFolder = _outputFolder
end

def process(limit)

	@g = ProductMappingGenerator.new(@useRandom, @outputFolder)
	@g.load


	products = @g.selectProducts(limit)

	salesData = []
	rpgPckData = []
	l1Prices = []
	l2Prices = []

	l1Prices += @g.generateL1Prices(products)

	HQ_COUNTRIES.each do |country|
	
		mapping = @g.generateMlfbMappingWithHqpg(products, country)
	
		salesData += mapping["VProductSalesData"]
		l2Prices += @g.generateL2Prices(products, country)
	end	

	RPG_COUNTRIES.each do |country|
	
		mapping = @g.generateMlfbMappingWithRpg(products, country)
	
		salesData += mapping["VProductSalesData"]
		rpgPckData += mapping["SCountryRpgPckData"]
		l2Prices += @g.generateL2Prices(products, country)
	end

	@g.writeToCsv(products, "products.txt")
	@g.writeToCsv(salesData, "productSales.csv")
	@g.writeToCsv(rpgPckData, "rpgPckData.csv") if (!rpgPckData.empty?)
	@g.writeToCsv(l1Prices, "l1prices.csv")
	@g.writeToCsv(l2Prices, "l2prices.csv")

end
end

  # main 
  if ARGV.count < 1 || ARGV.count > 3
    puts "Usage: ruby gen_prod_mapping.rb <productCount> [<useRandom>] [<outputFolder>]"
             exit(1)
  end

  USE_RANDOM_DEFAULT = true
  OUTPUT_FOLDER_DEFAULT = "out"	

  limit = Integer(ARGV[0])
  useRandom = ARGV[1] ? ARGV[1] : USE_RANDOM_DEFAULT
  outputFolder = ARGV[2] ? ARGV[2] : OUTPUT_FOLDER_DEFAULT

  p = Program.new(useRandom, outputFolder)
  p.process(limit)
	
