defmodule Q1 do
  def sumEven(list), do: sumEven(list, 0)

  def sumEven([], sum), do: sum

  def sumEven(list, sum) do
    if is_integer(hd(list)) && rem(hd(list), 2) == 0 do
      sumEven(tl(list), sum + hd(list))
    else
      sumEven(tl(list), sum)
    end
  end
end
