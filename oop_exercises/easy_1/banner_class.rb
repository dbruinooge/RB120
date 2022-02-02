class Banner
  def initialize(message, width=(message.length + 4))
    @message = message
    @width = width < (message.length + 2) ? message.length + 2 : width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  
  attr_reader :message, :width

  def horizontal_rule
    "+" + "-" * (width - 2) + "+"
  end

  def empty_line
    "|" + " " * (width - 2) + "|"
  end

  def message_line
    "|#{@message.center(width - 2)}|"
  end
end

banner1 = Banner.new("To boldly go where no one has gone before.")
banner2 = Banner.new("To boldly go where no one has gone before.", 5)
banner3 = Banner.new("To boldly go where no one has gone before.", 65)

puts banner1
puts banner2
puts banner3
