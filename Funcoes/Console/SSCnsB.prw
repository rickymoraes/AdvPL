#Include "Protheus.ch"

User Function SSCnsB()

	//Variaveis Locais
	Local nValor	:= 100
	Local dData		:= Date()
	Local cString1	:= "O Valor e: "
	Local cString2	:= " A Data de Hoje e:  " 

	ConOut(cString1 + AllTrim(Str(nValor)) + cString2 + DtoC(dData))	

Return Nil