defmodule Q3 do

  def basicFib(0), do: 0
  def basicFib(1), do: 1
  def basicFib(n) do
    n < 0 && :error || basicFib(n - 1) + basicFib(n - 2)
  end

  def tailFib(n), do: tailFib(n, 1, 0)
  def tailFib(0, _, res), do: res
  def tailFib(n, curr, sum) do
    n <= 0 && :error || tailFib(n - 1, curr + sum, curr)
  end
end
