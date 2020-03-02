defmodule Q2 do
  def sumNum(list), do: sumNum(list, 0)

  def sumNum([], sum), do: sum

  def sumNum(list, sum) do
    if is_number(hd(list)) do
      sumNum(tl(list), sum + hd(list))
    else
      sumNum(tl(list), sum)
    end
  end
end
