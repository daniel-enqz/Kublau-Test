require 'user'
require 'pry-byebug'

describe User do
  before do
    @valid_user = User.new(
      {'id' => 82,
      'name' => 'Daniel Cobb',
        "email"=>"kyoko@osinski-larson.test",
        "age"=>19,
        "country"=>"Tanzania",
        "profession"=>"Principal Farming Coordinator",
        "products"=>[{"product_id"=>"p9", "rating"=>4}]}
    )
    @invalid_user = User.new(
      {'id' => 82,
      'name' => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        "email"=>"kyoko@osinski-larson.test",
        "age"=>0,
        "country"=>"Tanzania",
        "profession"=>"Principal Farming Coordinator",
        "products"=>[{"product_id"=>"p9", "rating"=>4}]}
    )
  end

  it 'should initialize' do
    @valid_user.should be_a(User)
  end

  it 'should have a validation_result key with is valid when all fields are valid' do
    @valid_user.validate
    @valid_user.validation_result.should == ['valid']
  end

  it 'should have a validation_result key with is invalid when all fields are invalid' do
    @invalid_user.validate
    @invalid_user.validation_result.should == ['name should be a non-empty string with no more than 50 characters', 'age should be a positive integer between 18 and 100']
  end
end
