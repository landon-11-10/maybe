module Account::ValuationsHelper
  def valuation_icon(valuation)
    if valuation.first_of_series?
      "keyboard"
    elsif valuation.trend.direction.up?
      "arrow-up"
    elsif valuation.trend.direction.down?
      "arrow-down"
    else
      "minus"
    end
  end

  def valuation_style(valuation)
    color = valuation.first_of_series? ? "#D444F1" : valuation.trend.color

    <<-STYLE.strip
      background-color: color-mix(in srgb, #{color} 5%, white);
      border-color: color-mix(in srgb, #{color} 10%, white);
      color: #{color};
    STYLE
  end
end
