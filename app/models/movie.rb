class Movie < ActiveRecord::Base
     
    def self.all_ratings
        #Giving each key a value of 1 is arbitrary; it could be anything
        {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1 }
    end
        
end
