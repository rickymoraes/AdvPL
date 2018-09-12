#Include 'Protheus.ch'

User Function SSTamSx3()

	//Variavel Local
	Local aInfoCPO 	:= TamSx3('AA3_OBS')

	//Mensagens com as Informacoes do Campo
	MsgInfo( "Tamanho do Campo: "  				+ cValToChar(aInfoCPO[1]))
	MsgInfo( "Tamanho do Decimal do Campo: "  	+ cValToChar(aInfoCPO[2]))
	MsgInfo( "Tipo do Campo: "  				+ cValToChar(aInfoCPO[3]))

Return Nil