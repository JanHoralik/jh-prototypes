class ProductMappingGenerator

  SOURCE_COLUMNS = [3,4,6]

  attr_reader :productToPck, :countryToSalesOrg, :rpgs
  
  def initialize

	
  end

  def set_fake_values

	  @productToPck = {"10000088"  => "584",
	 		   "100000939" => "4770"}

          @countryToSalesOrg = { "GB" => ["7011","7021","7031"],
		  		 "DK" => ["5411","5421"]}
	  @rpgs = ["VTE","S32"]

  end

  def load

	  set_fake_values
  end 

end

