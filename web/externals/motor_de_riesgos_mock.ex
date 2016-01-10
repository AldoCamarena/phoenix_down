defmodule MotorDeRiesgosConnection do
	def obtener_riesgos(%{"peso" => peso} = _status) do
		{peso, _} = Float.parse(peso)

		cond do
			peso < 80 ->
				%{
					"riesgo_colesterol" => 3,
					"riesgo_diabetes" => 4,
					"riesgo_rinones" => 5,
					"riesgo_cancer_mama" => 2,
					"riesgo_hipertension" => 4,
					"riesgo_cancer_colon" => 1		
				}
			true ->
				%{
					"riesgo_colesterol" => 6,
					"riesgo_diabetes" => 7,
					"riesgo_rinones" => 5,
					"riesgo_cancer_mama" => 4,
					"riesgo_hipertension" => 8,
					"riesgo_cancer_colon" => 6		
				}
		end
	end
end