defmodule BigDataConnection do
	def usuarios do
		[
			%{"nombre" => "Diego", # Diego Gonzalez Boneta 29-11-90
			"apaterno" => "Gonzalez", 
			"nss" => "10101010101", 
			"curp" => "GOBD901129HMCNNG00",
			"derecho" => true},

			%{"nombre" => "Laura", #Laura Torres Lima 12-02-85
			"apaterno" => "Torres", 
			"nss" => "10101010102", 
			"curp" => "TOLL850212MMCRMR00",
			"derecho" => true},

			%{"nombre" => "Moshe", # Moshe Kasher Leggero 06-07-79
			"apaterno" => "Kasher", 
			"nss" => "10101010103", 
			"curp" => "KALM790706HMCSGS00",
			"derecho" => false},

			%{"nombre" => "Aldo", # Aldo Camarena Ramirez 20-09-91
			"apaterno" => "Camarena", 
			"nss" => "12345678990", 
			"curp" => "B",
			"derecho" => true}
		]
	end

	def tiene_derecho(:nss, nss) do
		tiene_derecho_por_campo("nss", nss)
	end

	def tiene_derecho(:curp, curp) do
		tiene_derecho_por_campo("curp", curp)
	end

	def obtener_usuario(curp) do
		encontrar_usuario_por_campo("curp", curp)
	end

	defp encontrar_usuario_por_campo(campo, valor) do
		Enum.find(BigDataConnection.usuarios, fn usuario -> Map.get(usuario, campo) == valor end)
	end

	defp tiene_derecho_por_campo(campo, valor) do
		case encontrar_usuario_por_campo(campo, valor) do
			nil -> false
			%{"derecho" => derecho} -> derecho
			_ -> false
		end
	end
end