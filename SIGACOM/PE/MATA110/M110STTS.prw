#Include "PROTHEUS.CH"
#Include "rwmake.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "topconn.ch"

//PE M110STTS - MATA110 - Executado apos Gravar SC
User Function M110STTS()

	//Variaveis Locais
	Local cNumSC	:= Paramixb[1] // Numero da Solicitacao de Compras
	Local nOptSC	:= Paramixb[2] // Operacao Utilizada: 1 = Inclusao, 2 = Alteraçao, 3 = Exclusao

	//Verifica a Opcao acionada na SC: 1 - Inclusao | 2 - Alteracao
	If (nOptSC == 1 .Or. nOptSC == 2)

		//Exibe a mensagem de Confirmarcao para Start da Aprovacao de SC
		If (MsgYesNo("Deseja Iniciar o WorkFlow de Aprovacao da SC: " + AllTrim(cNumSC)))

			U_SSCOM002(cNumSC)

		EndIf

	EndIf

Return Nil