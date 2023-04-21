class BuildJsonService < ApplicationService
  attr_accessor :json

  def initialize(json)
    @json = json
  end

  def call
    @json.each do |data|
      user = User.new(data)
      data['validation_result'] = user.validate
    end
    @json << { "insights" => { "average_age" => average_age, "most_popular_country" => most_popular_country, "best_rated_products" => best_rated_products } }
    @json << { "aggregate_data" => average_age_by_profession }
    @json
  end

  private

  def valid_user?(key, data)
    data['validation_result'] == 'valid' || !data['validation_result'].any? { |error| error.include?(key) }
  end

  def average_age
    number_of_users = @json.count
    sum = 0
    @json.each do |data|
      if valid_user?('age', data)
        sum += data['age']
      end
    end
    sum / number_of_users
  end

  def average_age_by_profession
    average_age_by_profession = {}
    json_without_insights = @json.reject { |data| data['insights'] }
    professions = json_without_insights.map { |data| data['profession'] if valid_user?('profession', data) }.uniq.compact
    professions.each do |profession|
      ages = json_without_insights.select { |user| user["profession"] == profession }.map { |user| user["age"] if valid_user?('age', user) }.compact
      average_age_by_profession[profession] = ages.sum / ages.size if ages.length > 0
    end
    average_age_by_profession
  end


  def most_popular_country
    countries = @json.map { |data| data['country'] if valid_user?('country', data) }.uniq.compact
    countries.max_by { |country| countries.count(country) }
  end

  def best_rated_products
    products = @json.map { |data| data['products'] if valid_user?('products', data) }
    products.flatten!
    products.delete_if { |product| product['rating'].nil? }
    products.sort_by! { |product| product['rating']}.reverse!
    products.first(3)
  end
end
