require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def new_product image_url
    Product.new(:title=>'MyBookTitle',
      :description=>'yyy',
      :price=>1,
      :image_url=>image_url)
  end
 
  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG }
    bad = %w{ fred.doc fred.gif.doc fred.more }
    
    ok.each do |name| 
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name| 
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
    
  end
  
  
  test "product attributes must bot be empyt" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be postive" do
    product =  Product.new(:title=>'MybookTitle',:description=>'yyy',
      :image_url=>"zzz.jpg")
    
    product.price = -1
    assert product.invalid?
    
    
    product.price = 0
    assert product.invalid?
    
    product.price = 1
    assert product.valid?
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title ,
      :description => "yyy",
      :price => 1,
      :image_url => "fred.gif")
    
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join("; ")
    
  end
  
  test "product is not vaild without a unique title -i18n" do
    product = Product.new(:title => products(:ruby).title,
      :description => "yyy",
      :price => 1,
      :image_url => "freg.gif"
    )
    
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join("; ")
  end
  
  
end
