def convert_to_bgn(price, currency)
  case
  when currency == :usd
    result = price * 1.7408

  when currency == :eur
    result = price * 1.9557

  when currency == :gbp
    result = price * 2.6415

  else
    result = price

  end
  result.round(2)
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  convert_to_bgn(first_price, first_currency) -
  convert_to_bgn(second_price, second_currency)
end
