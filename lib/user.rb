class User
  attr_reader :name, :email, :age, :country, :profession, :products, :validation_result

  def initialize(args = {})
    @name = args['name']
    @email = args['email']
    @age = args['age']
    @country = args['country']
    @profession = args['profession']
    @products = args['products']
    @validation_result = []
  end

  def validate
    generate_validation_result('name') unless valid_format?('name', @name)
    generate_validation_result('age') unless valid_format?('age', @age)
    generate_validation_result('country') unless valid_format?('country', @country)
    generate_validation_result('profession') unless valid_format?('profession', @profession)
    valid_products
    @validation_result << 'valid' if @validation_result == []
    @validation_result
  end

  private

  def generate_validation_result(key, value = nil)
    @validation_result << invalid_message(key, value)
  end

  def valid_products
    @products.each do |product|
      generate_validation_result('product', product['product_id']) unless valid_format?('product', product['rating'])
    end
  end

  def valid_format?(key, value)
    case key
    when 'name', 'country', 'profession'
      value.is_a?(String) && value.length.positive? && value.length <= 50
    when 'age'
      value.is_a?(Integer) && value > 18 && value < 100
    when 'product'
      value.is_a?(Integer) && value.positive? && value < 5
    end
  end

  def invalid_message(key, value)
    messages = {
      'name' => 'name should be a non-empty string with no more than 50 characters',
      'age' => 'age should be a positive integer between 18 and 100',
      'country' => 'country is not valid',
      'profession' => 'profession is not valid',
      'product' => "#{value} rating should be a positive integer between 1 and 5"
    }
    messages[key]
  end
end
