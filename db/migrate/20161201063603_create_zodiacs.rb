class CreateZodiacs < ActiveRecord::Migration
  def change
    create_table :zodiacs do |t|
      t.string :sign
      t.date :start_date
      t.date :end_date
    end
    zodiacs = {"aries" => {"from_month" => 3, "from_date" => 21, "to_month" => 4, "to_date"=> 19},
            "taurus" => {"from_month" => 4, "from_date" => 20, "to_month" => 5, "to_date"=> 20},
            "gemini" => {"from_month" => 5, "from_date" => 21, "to_month" => 6, "to_date"=> 20},
            "cancer" => {"from_month" => 6, "from_date" => 21, "to_month" => 7, "to_date"=> 22},
            "leo" => {"from_month" => 7, "from_date" => 23, "to_month" => 8, "to_date"=> 22},
            "virgo" => {"from_month" => 8, "from_date" => 23, "to_month" => 9, "to_date"=> 22},
            "libro" => {"from_month" => 9, "from_date" => 23, "to_month" => 10, "to_date"=> 22},
        	"scorpio" => {"from_month" => 10, "from_date" => 23, "to_month" => 11, "to_date"=> 21},
        	"sagittarius" => {"from_month" => 11, "from_date" => 22, "to_month" => 12, "to_date"=> 21},
        	"capricorn" => {"from_month" => 12, "from_date" => 22, "to_month" => 12, "to_date"=> 31},
          "capricorn" => {"from_month" => 1, "from_date" => 1, "to_month" => 1, "to_date"=> 19},
        	"aquarius" => {"from_month" => 1, "from_date" => 20, "to_month" => 2, "to_date"=> 18},
            "pisces" => {"from_month" => 2, "from_date" => 19, "to_month" => 3, "to_date"=> 19}}
    
    inserts = []
    zodiacs.each do |key, values|
      inserts.push "('#{key}', '#{Time.new(2016, values["from_month"], values["from_date"]).to_date}', '#{Time.new(2016, values["to_month"], values["to_date"]).to_date}')" 	
    end    	
    sql = "INSERT INTO zodiacs (sign, start_date, end_date) VALUES #{inserts.join(", ")}"
    ActiveRecord::Base.connection.execute(sql)
  end
end
