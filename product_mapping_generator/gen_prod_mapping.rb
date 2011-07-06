require "product_mapping_generator"
require "csv"

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

	processList(@g.selectProducts(limit))
end

def processList(products)

	@g = ProductMappingGenerator.new(@useRandom, @outputFolder)
	@g.load(products)

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

def loadProductsFromFile(productListFile)

	 products = []
	 CSV.foreach(productListFile) do |row|
	
	  	# skip lines with comments   
		next if (row[0] =~ /^#/) 

		products << row[0]
	  end

	 return products
end


end

  # main 
  if ARGV.count < 2 || ARGV.count > 4
    puts "Usage: ruby gen_prod_mapping.rb [--list|--limit]  <productCount|productListFile> [<useRandom>] [<outputFolder>]"
             exit(1)
  end

  USE_RANDOM_DEFAULT = true
  OUTPUT_FOLDER_DEFAULT = "out"	

  action = ARGV[0]
  case action
	when "--list"
		productListFile = ARGV[1]
	when "--limit"
		limit = Integer(ARGV[1])
 	else
  		raise ArgumentError, "Unknown action:#{action}"
  end
  
  useRandom = ARGV[2] ? ARGV[2] : USE_RANDOM_DEFAULT
  outputFolder = ARGV[3] ? ARGV[3] : OUTPUT_FOLDER_DEFAULT

  p = Program.new(useRandom, outputFolder)
  case action
	when "--list"
		products = p.loadProductsFromFile(productListFile)
	  	p.processList(products)
	when "--limit"
		p.process(limit)
 	else
  		raise ArgumentError, "Unknown action:#{action}"
  end
  
	
