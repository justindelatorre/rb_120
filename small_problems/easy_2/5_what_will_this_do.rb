=begin
What will the following code print?
=end

class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata

=begin
Output:
'ByeBye'
'HelloHello'
=end
