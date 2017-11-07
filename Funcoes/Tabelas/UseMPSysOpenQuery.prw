#Include 'Protheus.ch'

User Function UseMPSysOpenQuery()

	//Variavel Local
	Local cQuery := ""

	//Geracao da Instrucao SQL para selecao de Produtos -> SB1
	cQuery := "SELECT B1_COD, B1_DESC, B1_TIPO "
	cQuery += "FROM " + RetSQLName("SB1") + " "
	cQuery += "ORDER BY B1_COD"

	//Compatibiliza a Query para a necessidade o DBAccess
	cQuery := ChangeQuery(cQuery)

	//Cria uma Tabela Termporaria para Query utilizando a funcao MPSysOpenQuery
	MPSysOpenQuery( cQuery, 'TempSB1' )

	//Le todos os registro da tabela temporia TempSB1
	While !(TempSB1->(EOF()))

		MsgInfo("Codigo do Produto: " + TempSB1->B1_COD + " - Descricao do Produto: " + TempSB1->B1_COD +  " - Tipo do Produto: " + TempSB1->B1_COD)		

		TempSB1->(DBSkip())

	EndDo

Return Nil