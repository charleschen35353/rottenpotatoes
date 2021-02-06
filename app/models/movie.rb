class Movie < ActiveRecord::Base
  @@all_ratings = ['G','PG','PG-13','R']

  def self.all_ratings
    @@all_ratings 
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    ratings_list = @@all_ratings if ratings_list.size == 0
    return self.where(rating: ratings_list)
  end
  
end 
