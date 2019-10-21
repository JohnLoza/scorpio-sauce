class ProductBox
  include Serializable
  attr_accessor :name, :units
  
  def to_s
    name
  end
  
end
