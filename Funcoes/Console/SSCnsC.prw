#Include "Protheus.ch" 

User Function SSCnsC() 

	//Variaveis Locais 
	Local nValor	:= 100 
	Local dData 	:= Date()
	Local cString	:= "Mensagem TesTe"
	Local lLogica	:= .T.
	Local bBloco	:= {| x1,x2 | IIF( 5 < 4 , "Menor" , "Maior" ) }
	Local oTFont 	:= TFont():New('Courier new',,-16,.T.)
	Local aArray	:= {nValor, dData, cString, lLogica, bBloco, oTFont, cString + 200} 

	VarInfo("Dados das Variaveis: ", aArray)	 

Return Nil