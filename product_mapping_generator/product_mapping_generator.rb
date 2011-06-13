require "CSV"

class ProductMappingGenerator

  USE_RANDOM = true

  OUTPUT_FOLDER = "out"	
  USED_MLFBs_NAME = "MLFB"
  SALES_DATA_NAME = "VProductSalesData"

  attr_reader :productToPck, :countryToSalesOrg, :rpgs
  
  def initialize

	@productToPck = {}
	@countryToSalesOrg = {}
  end

  def set_fake_values

	  @productToPck = {"10000088"  => "584",
	 		   "100000939" => "4770"}

          @countryToSalesOrg = { "GB" => ["7011","7021","7031"],
		  		 "DK" => ["5411","5421"]}
	  @rpgs = ["VTE","S32"]

  end

  def load

	  CSV.foreach("SProduct.csv") do |row|
    	
		next if row[0] =~ /^#/

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

	  #CSV::new(outfile) do |csv|
   	  #	csv << array #"ttz, ttz" #row.join(',')
	  #end
    
	  outfile.close
  end
end

