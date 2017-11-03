#Include 'protheus.ch'

User Function UseFWTemporaryTable()

	Local aFields 		:= {}
	Local oTempTable	:= Nil
	Local cQuery		:= ""
	
	//Cria o objeto da Tabela Temporaria
	oTempTable := FWTemporaryTable():New( "NewSA1" )
	
	//Montagem da estrutura dos campos da Tabela Temporaria
	AADD(aFields,{"A1_COD"	, "C", 	6,	0})
	AADD(aFields,{"A1_LOJA"	, "C", 	2,	0})
	AADD(aFields,{"A1_NOME"	, "C",	40,	0})
		
	//Input dos campos na Tabela Temporaria
	oTemptable:SetFields( aFields )
	
	//Adiciona indice na Tabela Temporaria
	oTempTable:AddIndex("01", {"A1_COD"} )
	
	//Criacao da Tabela no Banco de Dados
	oTempTable:Create()

	//Criacao da Query que ira alimentar a Tabela Temporaria
	cQuery := "select * from " + RetSQLName("SA1") 
	
	//Cria uma Tabela Termporaria para Query
	MPSysOpenQuery( cQuery, 'QrySA1' )
	
	DbSelectArea('QrySA1')
	
	//Le todos os registro da Query e armazena na Tabela Temporaria
	While !(QrySA1->(EOF()))
		
		RecLock("NewSA1", .T.)
		
		NewSA1->A1_COD := QrySA1->A1_COD
		NewSA1->A1_LOJA := QrySA1->A1_LOJA
		NewSA1->A1_NOME := QrySA1->A1_NOME
		
		QrySA1->(MsUnLock())
		
		QrySA1->(DBSkip())
		
	Enddo

	//Exclui a Tabela Termporaria do Bando de Dados
	oTempTable:Delete()

Return Nil