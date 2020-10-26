class Recipe
  attr_reader :name, :description, :rating, :prep_time, :is_done, :direct_link

  def initialize(name, description, rating, prep_time, is_done, direct_link)
    @name = name
    @description = description
    @rating = rating
    @prep_time = prep_time
    @is_done = is_done
    @direct_link = direct_link
  end

  def mark_as_done!
     @is_done = true
  end
end
