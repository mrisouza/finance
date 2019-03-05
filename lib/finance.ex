defmodule Finance do
# Cálculo de média
  def media(lista) do
    case is_list(lista) do
    :true -> Enum.sum(lista)/length(lista)
    :false -> IO.puts "Nao e uma lista."
  end
end
# Cálculo de mediana
  def mediana(lista) do
    case is_list(lista) do
      true -> lista_ordenada = Enum.sort(lista)
        case rem length(lista), 2 do
          0 -> a = length(lista)-1
               b = length(lista)+1
               lista2 = [Enum.at(lista_ordenada, Kernel.trunc(a/2)), Enum.at(lista_ordenada, Kernel.trunc(b/2))]
               media(lista2)
          1 -> Enum.at(lista_ordenada, Kernel.trunc(length(lista)/2))
        end
      false -> IO.puts "Entre com uma lista."
    end
end
# Cálculo do retorno
  def serie_retorno(lista) do
    case (is_list(lista)) do
      true -> Enum.map(Enum.to_list(1..(length(lista)-1)), fn x -> 1+(Enum.at(lista, x)-Enum.at(lista,x-1))/(Enum.at(lista, x-1))
    end)
      false -> IO.puts "Entre com uma lista."
    end
  end
# Cálculo de Retorno dado um capital
  def retorno(lista) do
    capital = IO.gets "Capital: "
    capital_sem_linha = String.trim(capital)
    capital_float = String.to_float(capital_sem_linha)
    lista_retornos = serie_retorno(lista)
    retorno_acumulado = Enum.reduce(lista_retornos, fn x, acc -> x*acc end)
    IO.puts "Retorno acumulado: #{(retorno_acumulado-1)*100}"
    total = retorno_acumulado * capital_float
    total
  end
end
