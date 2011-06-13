require "CSV"

class ProductMappingGenerator

  USE_RANDOM = true
  OUTPUT_FOLDER = "out"	

  CURRENCY = {"GB" => "GBP", "DK" => "DKK", "NL" => "EUR", "PL" => "PLZ"}

  USED_MLFBs_NAME = "MLFB"
  SALES_DATA_NAME = "VProductSalesData"

  L1_PRICE_MIN = 750
  L1_PRICE_MAX = 800
  L1_PRICE_DEFAULT = 777
  L2_PRICE_MIN = 700
  L2_PRICE_MAX = 749
  L2_PRICE_DEFAULT = 733
  PRICE_BOT = "01/10/2010"
  PRICE_EOT = "31/12/9999"	
  
  attr_reader :productToPck, :countryToSalesOrg, :rpgs
  
  def initialize

	@productToPck = {}
	@countryToSalesOrg = {}
  end

  def load

	  CSV.foreach("SProduct.csv") do |row|
    	
		# skip lines with comments and MLFBs in different format than *-*-*  
		next if (row[0] =~ /^#/ || row[0] !~ /.*\-.*\-.*/) 

		mlfb = row[0]
		pck = row[4]

		@productToPck[mlfb] = pck
	  end

	  CSV.foreach("VSalesOrg.csv") do |row|
    		
	  	next if row[0] =~ /^#/	  
		
		salesOrg = row[0]
		country = row[2]

		if(!@countryToSalesOrg[country]) then @countryToSalesOrg[country] = [] end
		@countryToSalesOrg[country] << salesOrg
		
	  end


  end 

  def writeToCsv(array, filename)

	  Dir.mkdir(OUTPUT_FOLDER) if(!Dir.exist?(OUTPUT_FOLDER))
	  outfile = File.open("#{OUTPUT_FOLDER}\\#{filename}", 'wb')

	  array.each do |row|
		 
		 if(row.is_a?(Array)) then
			outfile.puts(row.join(','))
		 else
			 outfile.puts(row)
		 end
	  end
    
	  outfile.close
  end

  def generateMlfbMappingWithHqpg(country, limit)

	allMlfbs = @productToPck.keys
	
	salesData = []
        mlfbsUsed = [] 	
	
	(0..limit-1).each do |i|  
	
		if(USE_RANDOM) then 
			salesOrgIndex = Random.new.rand(0..@countryToSalesOrg[country].count-1)
		else
			salesOrgIndex = 0
		end	


		salesData << [allMlfbs[i],@countryToSalesOrg[country][salesOrgIndex], nil, nil, 15]
		mlfbsUsed << allMlfbs[i] 		
	end

	mapping = {}
	mapping[USED_MLFBs_NAME] = mlfbsUsed
	mapping[SALES_DATA_NAME] = salesData

	return mapping	
  end



  def generateL1Prices(mlfbs)

	prices = []

	mlfbs.each do |mlfb|

		if(USE_RANDOM) then 
		
			priceValue = Random.new.rand(L1_PRICE_MIN..L1_PRICE_MAX)
		else
			priceValue = L1_PRICE_DEFAULT
		end	
			
		prices << [mlfb, "#{priceValue} EUR", "Approved", PRICE_BOT, PRICE_EOT]
	end

	return prices
  end

    def generateL2Prices(country, mlfbs)

	prices = []

	mlfbs.each do |mlfb|

		if(USE_RANDOM) then 
		
			priceValue = Random.new.rand(L2_PRICE_MIN..L2_PRICE_MAX)
		else
			priceValue = L2_PRICE_DEFAULT
		end	
			
		prices << [mlfb, "#{priceValue} #{CURRENCY[country]}", "Approved", PRICE_BOT, PRICE_EOT, country]
	end

	return prices
  end
end

