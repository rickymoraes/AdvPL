#Include 'Protheus.ch'

User Function SSMATA020Log()

	//Variaveis Locais
	Local aDadosFor := {}
	Local nOperacao := 3
	Local cCod      := ""
	Local cNome     := ""
	Local cLoja     := ""
	Local cNReduz   := ""
	Local cEnd      := ""
	Local cEst      := ""
	lOCAL cMun      := ""
	Local cTipo     := ""
	Local cPath		:= ""
	Local cNomeArq	:= ""
	

	//Variavel de Controle do MsExecAuto
	Private lMsErroAuto := .F.
	
	//Variavies com os Dados do Fornecedor
	cCod      := "000002"
	cNome     := "TESTE FORNECEDOR 000002"
	cLoja     := "01"
	cNReduz   := "FORNECEDOR 000002
	cEnd      := "ENDERECO"
	cEst      := "SP"
	cMun      := "SAO PAULO"
	cTipo     := "J"

	//Array de Informacoes
	AADD(aDadosFor,{"A2_COD"		, cCod		})	
	AADD(aDadosFor,{"A2_LOJA"		, cLoja		})	
	AADD(aDadosFor,{"A2_NOME"		, cNome		})	
	AADD(aDadosFor,{"A2_NREDUZ"		, cNReduz	})	
	AADD(aDadosFor,{"A2_END"		, cEnd 		})	
	AADD(aDadosFor,{"A2_EST"		, cEst		})	
	AADD(aDadosFor,{"A2_MUN"		, cMun		})	
	AADD(aDadosFor,{"A2_TIPO"		, cTipo		})	        

	//MsExecAuto de Cadastro de Fornecedor - MATA020 - Tipo 3 - Inclusao
	MsExecAuto({|x,y| MATA020(x,y)},aDadosFor, nOperacao)		

	//Verifique se houve erro no MsExecAuto
	If (lMsErroAuto)
	
		cPath := "C:\ToTvs\MsExecAuto" 
		cNomeArq := "Erro_MsExecAuto_MATA020" 		

		//Mostra em Tela o Erro Ocorrido
		MostraErro(cPath, cNomeArq)		

	Else		

		//Exibe Mensssagem caso o Forneceodr seja incluido com sucesso
		MsgInfo("Fornecedor Incluído com Sucesso!!!",  "Smart Siga")	

	EndIf	

Return Nil