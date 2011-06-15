require "CSV"

class ProductMappingGenerator


  CURRENCY = {"GB" => "GBP", "DK" => "DKK", "NL" => "EUR", "PL" => "PLN"}

  SALES_DATA_NAME = "VProductSalesData"
  RPG_PCK_DATA_NAME = "SCountryRpgPckData"

  L1_PRICE_MIN = 750
  L1_PRICE_MAX = 800
  L1_PRICE_DEFAULT = 777
  L2_PRICE_MIN = 700
  L2_PRICE_MAX = 749
  L2_PRICE_DEFAULT = 733
  PRICE_BOT = "01/10/2010"
  PRICE_EOT = "31/12/9999"	
  
  attr_reader :productToPck, :countryToSalesOrg, :rpgs
  
  def initialize(_useRandom, _outputFolder)

	@useRandom = _useRandom
	@outputFolder = _outputFolder

	@productToPck = {}
	@countryToSalesOrg = {}
	@rpgs = []
  end

  def load
	  load(nil)
  end

  def load(products)

	  CSV.foreach("SProduct.csv") do |row|
    	
		# skip lines with comments and MLFBs in different format than *-*-*  
		next if (row[0] =~ /^#/ || row[0] !~ /.*\-.*\-.*/) 

		mlfb = row[0]
		pck = row[4]

		# if product list specified, skip others
		next if (products != nil && !products.include?(mlfb))

		@productToPck[mlfb] = pck
	  end

	  CSV.foreach("VSalesOrg.csv") do |row|
    		
	  	next if row[0] =~ /^#/	  
		
		salesOrg = row[0]
		country = row[2]

		if(!@countryToSalesOrg[country]) then @countryToSalesOrg[country] = [] end
		@countryToSalesOrg[country] << salesOrg
		
	  end

	  CSV.foreach("SRegionalPriceGroup.csv") do |row|
    		
	  	next if row[0] =~ /^#/	  
		
		@rpgs << row[0]
	  end

  end 

  def selectProducts(limit)

        selected = []

	(0..limit-1).each do |i|
		
		if(@useRandom) then 
			index = Random.new.rand(0..@productToPck.count-1)
		else
			index = i
		end

		selected << @productToPck.keys[index]	
	end

	return selected
  end


  def writeToCsv(array, filename)

	  Dir.mkdir() if(!Dir.exist?(@outputFolder))
	  outfile = File.open("#{@outputFolder}\\#{filename}", 'wb')

	  array.each do |row|
		 
		 if(row.is_a?(Array)) then
			outfile.puts(row.join(','))
		 else
			outfile.puts(row)
		 end
	  end
    
	  outfile.close
  end

  def generateMlfbMappingWithHqpg(products, country)
	
	salesData = []
	
	products.each do |mlfb|  
	
		if(@useRandom) then 
			salesOrgIndex = Random.new.rand(0..@countryToSalesOrg[country].count-1)
		else
			salesOrgIndex = 0
		end	


		salesData << [mlfb,@countryToSalesOrg[country][salesOrgIndex], nil, nil, 15]
	end

	mapping = {}
	mapping[SALES_DATA_NAME] = salesData

	return mapping	
  end

  def generateMlfbMappingWithRpg(products, country)
	
	salesData = []
        rpgPckData = []
	
	products.each do |mlfb|  
	
		if(@useRandom) then 
			rpgIndex = Random.new.rand(0..@rpgs.count-1)
			salesOrgIndex = Random.new.rand(0..@countryToSalesOrg[country].count-1)
			
		else
			rpgIndex = 0
			salesOrgIndex = 0	
		end	

		pck = @productToPck[mlfb]
		rpg = @rpgs[rpgIndex]
		salesOrg = @countryToSalesOrg[country][salesOrgIndex]

		salesData << [mlfb, salesOrg, rpg, nil, 15]
		rpgPckData << [country, rpg, pck] 
	end

	mapping = {}
	mapping[SALES_DATA_NAME] = salesData
	mapping[RPG_PCK_DATA_NAME] = rpgPckData

	return mapping	
  end


  def generateL1Prices(mlfbs)

	prices = []

	mlfbs.each do |mlfb|

		if(@useRandom) then 
		
			priceValue = Random.new.rand(L1_PRICE_MIN..L1_PRICE_MAX)
		else
			priceValue = L1_PRICE_DEFAULT
		end	
			
		prices << [mlfb, "#{priceValue} EUR", "Approved", PRICE_BOT, PRICE_EOT]
	end

	return prices
  end

  def generateL2Prices(mlfbs,country)

	prices = []

	mlfbs.each do |mlfb|

		if(@useRandom) then 
		
			priceValue = Random.new.rand(L2_PRICE_MIN..L2_PRICE_MAX)
		else
			priceValue = L2_PRICE_DEFAULT
		end	
			
		prices << [mlfb, "#{priceValue} #{CURRENCY[country]}", "Approved", PRICE_BOT, PRICE_EOT, country]
	end

	return prices
  end
end
