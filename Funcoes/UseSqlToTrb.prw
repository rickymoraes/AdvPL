#Include 'Protheus.ch'

User Function UseSqlToTrb()

	//Variaveis Locais
	Local cTemp		:= GetNextAlias()
	Local cArqInd	:= Nil
	Local cArqTrb	:= Nil
	Local aStrucSQL	:= {}

	//Montagem da query de seleção de dados do Cadastro de Clientes
	cQuery	:= "SELECT A1_COD, A1_LOJA, A1_NOME "
	cQuery 	+= "FROM " + RetSQLName("SA1") + " "
	
	//Faz a compatibilização da query junto ao DBAccess
	cQuery := ChangeQuery(cQuery)

	//Adiciona os dados ao array para montegem do temporário
	AADD(aStrucSQL, {"A1_COD"	, "C", 6, 0})
	AADD(aStrucSQL, {"A1_LOJA"	, "C", 2, 0})
	AADD(aStrucSQL, {"A1_NOME"	, "C", 40, 0})

	//Cria um arquivo de trabalho com uma estrutura especificada
	cArqTrb := CriaTrab(aStrucSQL, .T.)

	//Define um tabela para área de trabalho ativa
	DBUseArea(.T., __LOCALDRIVER, cArqTrb, cTemp, .T., .F.)

	//Preenche um arquivo temporário com o conteúdo do retorno da query
	SqlToTrb(cQuery, aStrucSQL, cTemp)

	//Fornece uma arquivo válido para área de trabalho ativa
	cArqInd := CriaTrab(Nil, .F.)

	//Cria um índice para área de trabalho ativa
	IndRegua(cTemp, cArqInd, "A1_COD")

Return Nil