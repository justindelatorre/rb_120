=begin
Complete this class so that the test cases shown below work as intended. You
are free to add any methods or instance variables you need. However, do not make
the implementation details public.

You may assume that the input will always fit in your terminal window.
=end

class Banner
  def initialize(message)
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    '+' + ('-' * (@message.size + 2)) + '+'
  end

  def empty_line
    '|' + (' ' * (@message.size + 2)) + '|'
  end

  def message_line
    "| #{@message} |"
  end
end

# Test Cases
banner1 = Banner.new('To boldly go where no one has gone before.')
puts banner1

banner2 = Banner.new('')
puts banner2
