# This creates the Module Elixir.Us
#
defmodule Us do
  def rtest(remote_pid,number) do
    server_pid = spawn(&universal_server/0) # &function/0 is a function pointer to a zero argument function
    send(server_pid, {:become,&fac_server/0})
    send(server_pid, {remote_pid, number})
  end

  def test(number) do
    rtest(self(),number)
    receive do
       x -> x
    end
  end
  def test() do
    test(50)
  end
  defp universal_server do
    receive do
      {:become, f} -> f.()
    end
  end

  defp fac_server do
    receive do
      {from,num} ->
        send(from,factorial(num))
        fac_server()
    end
  end

  defp factorial(0) do
    1
  end

  defp factorial(number) do
    number * factorial(number-1)
  end
end
