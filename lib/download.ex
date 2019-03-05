defmodule Download do
  # módulo que faz download e tratamento da lista
  def main do
    {status, _} = File.open("./cotacao.txt")
    case status do
      :ok -> tratar_arquivo()
      :error -> baixar_arquivo(status)
    end
  end

# rotina que baixa arquivo
# descompacta
# cria cotacao.txt
  def baixar_arquivo(status) do
    path = "http://bvmf.bmfbovespa.com.br/InstDados/SerHist/COTAHIST_A2019.ZIP"
    case status do
      :ok -> IO.puts "Arquivo ja existente."
      :error -> %HTTPoison.Response{body: body} = HTTPoison.get!(path)
              File.write!("./COTAHIST_A2019.ZIP", body)
              :zip.unzip(body)
              File.rename("./COTAHIST_A2019.txt", "./cotacao.txt")
    end
  end

  # Trata o arquivo cotacao.txt
  # transforma em arquivo de série de preço do ticker desejado

  def tratar_arquivo do
    ticker = IO.gets "Entre com o ticker do ativo: "
    ticker_tratado = String.trim(ticker)
    {:ok, file} = File.read("./cotacao.txt")
    lista_file = tl(String.split(file, "\r\n")) # remove primeira entrada
    lista_file1 = Enum.reject(lista_file, fn x ->
      ((x == "") || (String.contains?(x, "COTAHIST") == true))
    end)
    lista_cotacao = Enum.map(lista_file1, fn x ->
      if (String.trim(String.slice(x, 12, 12)) == ticker_tratado) do
        String.slice(x, 8, 2) <> "/" <> String.slice(x, 6, 2) <> "/" <> String.slice(x, 2, 4) <> " " <> String.trim(String.slice(x, 12, 12)) <> " " <> String.slice(x, 108, 13) <> "\n"
      end
  end)
    lista_final = Enum.reject(lista_cotacao, &is_nil/1)
    {:ok, file_final}  = File.open("./cotacao_ticker.txt", [:write])
    IO.write(file_final, lista_final)
  end

  # definir a serie
  def definir_serie do
    {:ok, file} = File.read("./cotacao_ticker.txt")
    file2 = String.split(file, "\n")
    Enum.map(file2, fn x -> String.split(x, " ")
  end)
    |> Enum.reject(fn x -> (x == "") end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn x -> Enum.at(x, 2) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn x -> String.to_integer(x)/100 end)
  end
end
