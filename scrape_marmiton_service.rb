require_relative 'controller'

class ScrapeMarmitonService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{@keyword}"
    page = Nokogiri::HTML(open(url))
    cards = page.css('div.recipe-card')
    puts "******* Looking for '#{@keyword}' recipes on the Internet... *******"
    five_recipes = scrape_marmiton(cards)
    return five_recipes
  end

  private

  def scrape_marmiton(cards)
    scraped_recipes = []
    cards.each do |card|
      name = card.css('h4.recipe-card__title').text
      direct_link =  "https://www.marmiton.org#{card.css('a.recipe-card-link').attribute('href').value}"
      description =  card.css('div.recipe-card__description').text.strip[0...25]
      rating = card.css('div.recipe-card__rating').text.strip.scan(/^\d\.?\d?/)[0]
      # prep_time = card.css('span.recipe-card__duration__value').text.strip
      prep_time_details = scrape_marmiton_details(direct_link)
      # scraped_recipes << Recipe.new(name, description, rating, prep_time, false, direct_link)
      scraped_recipes << Recipe.new(name, description, rating, prep_time_details, false, direct_link)
    end
    scraped_recipes = scraped_recipes.first(5)
  end

  def scrape_marmiton_details(direct_link)
    page_details = Nokogiri::HTML(open(direct_link))
    page_details = page_details.css('div.recipe-infos__timmings__detail').text.strip.gsub(/[\t\n]/, '')
    page_details.gsub(/^.+min|.+min$/, '\0 ')
  end


end
