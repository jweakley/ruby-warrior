class String
  COLORS = {
    black: 30,
    red: 31,
    green: 32,
    brown: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    gray: 37
  }

  OTHERS = {
    bold: 1,
    reverse_color: 7
  }

  COLORS.each do |color, value|
    define_method(color.to_s) do
      color_it(color)
      self
    end
    define_method("bg_#{color.to_s}") do
      color_it(color, true)
      self
    end
  end

  OTHERS.each do |other, value|
    define_method(other.to_s) do
      "\e[#{OTHERS[other]}m#{self}\e[0m"
      self
    end
  end

  def camelize
    gsub(/(?:^|_)(.)/) { $1.upcase }
  end

  def constantize
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ self
      raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
    end

    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end

  def underscore
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
  end

  def humanize
    gsub(/_/, " ").capitalize
  end

  def titleize
    underscore.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }
  end

  def hard_wrap(width = 80)
    gsub(/(.{1,#{width}})(\s+|$)/, "\\1\n").strip
  end

  private

  def color_it(color, bg = false)
    "\e[#{COLORS[color] + (bg ? 10 : 0)}m#{self}\e[0m"
  end
end
