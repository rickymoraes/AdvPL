#Include 'Protheus.ch'
#Include "Rwmake.ch"

User Function SSCOM002()

	Local aArea			:= GetArea()

	Private cNomeSup	:= "Smart Siga Aprovador"

	MsgRun("Gerando WorkFlow de Aprovacao, Aguarde...","",{|| CursorWait(), SSCOM002WK(), CursorArrow()})

	//Retorna o Posicionamento Original do Arquivo
	RestArea(aArea)

Return

//******************************
Static Function SSCOM002WK()

	Local oProcess 		:= Nil 
	Local oHtml			:= Nil
	Local cDestinatario	:= ""
	Local cShape		:= ""
	Local cArqHtml		:= ""
	Local cAssunto		:= ""
	Local cUsrCorrente	:= ""
	Local cCodigoStatus	:= ""
	Local cHtmlModelo	:= ""
	Local cNumSC		:= ca110Num
	Local cDescricao	:= ""
	Local cUser     	:= __cUserID
	Local cMailID		:= "" 

	//Assunto do E-mail
	cAssunto := "Aprovacao da S.C.  No: " + cNumSC

	//Caminho e Arquivo HTML do Link de Formulario de Aprovacao
	cArqHtml := "\Workflow\WFSCEnvio.html"

	//Obtem o Usuario Logado
	cUsrCorrente := SubStr(cUsuario, 7, 15)

	//Destinatario Separado por Ponto e Virgulha(;)
	cDestinatario := "aprovacaoemail.com.br"

	//Inicia o Processo de WorkFlow de Aprovacao de SC
	oProcess := TWFProcess():New( "SCCOM", cAssunto )

	//Cria uma Nova Tarefa Informando o HTML do Link de Envio
	oProcess:NewTask( "Aprovacao da S.C.", cArqHtml )

	//Informa o Codigo e Descricao do Status do Processo Correspondente ao Inicio do Start de WorkFlow 
	cCodigoStatus 	:= "100100"
	cDescricao 		:= "Inicio do Processo de Aprovacao da SC"

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado 
	oProcess:Track( cCodigoStatus, cDescricao, cUsrCorrente)

	//Função de Retorno da Aprovacao do WorkFlow de SC
	oProcess:bReturn := "U_SCRetorno"
	oProcess:cSubject := cAssunto

	//Usuario Responsavel pelo Processo do WorkFlow de Aprovacao de SC
	oProcess:UserSiga := WFCodUser( cUser )

	//Cria Objeto HTML do Processo de WorkFlow de Aprovacao de SC
	oHtml := oProcess:oHTML

	//Informa o Codigo e Descricao do Status do Processo Correspondente ao Inicio do Start de WorkFlow 
	cCodigoStatus 	:= "100200"
	cDescricao 		:= "Gerando Processo de Aprovacao da SC"	

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado
	oProcess:Track(cCodigoStatus, cDescricao, cUsrCorrente )

	// Preenche os Campos do HTML com as Informacoes da SC
	oHtml:ValByName( "Dt_Emissao" 	, DtoC(SC1->C1_EMISSAO))
	oHtml:ValByName( "Dt_Entrega" 	, DtoC(SC1->C1_DATPRF))
	oHtml:ValByName( "Solicitante"	, SC1->C1_SOLICIT)
	oHtml:ValByName( "CC"         	, SC1->C1_CC + " - " + SC1->C1_ITEMCTA)
	oHtml:ValByName( "Aprovacao"  	, "Bloqueada")
	oHtml:ValByName( "Aprovador"  	, cNomeSup)
	oHtml:ValByName( "Num_SC"		, cNumSC )

	DBSelectArea("SC1")
	SC1->(DBSetOrder(1))
	SC1->(DBSeek(FwFilial("SC1") + cNumSC))

	// Preencha o Arquivo HTML com as Informacoes da SC
	While !SC1->( EOF() ) .And. (SC1->C1_FILIAL == FwFilial("SC1") .And. SC1->C1_NUM == cNumSC)		

		AADD( ( oHtml:ValByName( "TB.Item"   ))		, SC1->C1_ITEM    )
		AADD( ( oHtml:ValByName( "TB.Codigo" ))		, SC1->C1_PRODUTO )
		AADD( ( oHtml:ValByName( "TB.Descricao" ))	, SC1->C1_DESCRI + " " + SC1->C1_OBS )
		AADD( ( oHtml:ValByName( "TB.Qtd" ))		, Transform( SC1->C1_QUANT,'@E 999,999.99' ) )
		AADD( ( oHtml:ValByName( "TB.Unid" )), SC1->C1_UM  )

		//Criar a Cor das Linhas em Zebrado atraves da verificacao se a Linha é Par ou Impar
		If (Val(SC1->C1_ITEM)%2) = 0
			AADD(oHTML:ValByName('TB.Fundo'),"#FFFFFF")
		Else
			AADD(oHTML:ValByName('TB.Fundo'),"#f3f3f3")

		EndIf

		RecLock("SC1", .F.)

		SC1->C1_WFID := oProcess:fProcessID

		SC1->(MsUnLock())

		SC1->(DbSkip())

	EndDo

	//Salva o Processo de WorkFlow na Pasta SSCOM002
	oProcess:cTo := "SSCOM002"

	//Cria o Processo de WorkFlow para Aprovacao de SC
	cMailID := oProcess:Start()

	//Associa o Arquivo HTML do Link
	cHtmlModelo := "\workflow\WFSCLink.html"

	//Informa o Codigo e Descricao do Status do Processo Correspondente ao Inicio do Start de WorkFlow
	cCodigoStatus 	:= "100300"
	cDescricao 		:= "Enviando Processo de Aprovação da SC"

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado
	oProcess:Track( cCodigoStatus, cDescricao )

	//Cria uma Nova Tarefa par ao Processo de Aprovacao de WorkFlow de SC
	oProcess:NewTask(cAssunto, cHtmlModelo)

	//E-mail do Aprovador do Processo de Aprovacao de WorkFlow de SC
	oProcess:cTo := "aprovacao@email.com.br" 

	//Substitui as Macros do Arquivo HTML do Link
	oProcess:oHTML:ValByName("usuario"	, AllTrim(cNomeSup))
	oProcess:oHTML:ValByName("referente", cNumSC)	
	oProcess:oHTML:ValByName("proc_link", "http://localhost:1236/WorkFlow/Messenger/Emp99/SSCOM002/" + cMailID + ".htm")

	//Inicia o Processo de Envio de E-mail do WorkFlow de Aprovacao de SC
	oProcess:Start()

	//oProcess:Finish()

	//WFKillProcess( oProcess:FProcessID + "." + oProcess:FTaskID )

Return Nil

//Funcao de Retorno da Aprovacao/Rejeicao do WorkFlow
User Function SCRetorno(oProcess)

	//Variaveis Locais
	Local cAssunto		:= ""
	Local cNumSC		:= ""
	Local cCodigoStatus	:= ""
	Local cDescricao	:= ""
	Local cDescWork		:= ""
	Local cCor			:= ""
	Local cAprovador	:= ""
	Local cAprovacao	:= ""
	Local cStatusAP		:= ""
	Local cMotRejec		:= ""


	//Recupera o Numero da SC do Processo de WorkFlow
	cNumSC := oProcess:oHtml:RetByName("Num_SC")

	//Informa o Codigo e Descricao do Status do Processo Correspondente ao Inicio do Start de WorkFlow 
	cAssunto 		:= "Solicitacao de Compras no: " + cNumSC
	cCodigoStatus	:= "100400"
	cDescricao 		:= "Aguardando Aprovacao da SC"

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado 
	oProcess:Track( cCodigoStatus, cDescricao )

	//Verifica se o WorkFlow de Processo de Aprovacao de SC foi Aprovador ou Rejeitado
	If Upper(oProcess:oHtml:RetByName("RBAPROVA")) <> "SIM"

		//Varives de Controle de Aprovacao de WorkFlow de Aprovacao de SC
		cAprovacao	:= "Rejeitada"
		cStatusAP	:= "R"
		cMotRejec	:= oProcess:oHtml:RetByName('lbmotivo')

		ConOut("Teste Rejeicao: " + cMotRejec)

		//Cria uma Nova Tarefa par ao Processo de Aprovacao de WorkFlow de SC
		cCodigoStatus 	:= "100600"
		cDescricao 		:= "SC Reprovada"
		cCor 			:= "#FF6600"		

	Else

		//Varives de Controle de Aprovacao e Motivo de Rejeicao do WorkFlow de Aprovacao de SC
		cAprovacao 	:= "Aprovada"
		cStatusAP	:= "L"		

		//Cria uma Nova Tarefa par ao Processo de Aprovacao de WorkFlow de SC
		cCodigoStatus 	:= "100500"
		cDescricao 		:= "SC Aprovada"
		cCor 			:= "#009900"	

	EndIf

	DBSelectarea("SC1")
	DBSetOrder(1)
	SC1->(dbSeek(FwFilial("SC1") + cNumSC))

	While !SC1->(EOF()) .And. ( SC1->C1_FILIAL == FwFilial("SC1") .And. SC1->C1_NUM == cNumSC)

		RecLock("SC1",.F.)

		SC1->C1_APROV 	:= cStatusAP
		SC1->C1_NOMAPRO	:= oProcess:oHtml:RetByName("Aprovador")
		SC1->C1_OBS		:= AllTrim(SC1->C1_OBS) + IIF(AllTrim(SC1->C1_OBS) == "" .Or. AllTrim(cMotRejec) == "", "", " - ") + cMotRejec

		SC1->(MsUnLock())

		SC1->(DBSkip())

	EndDo

	//Associa a Descricao do Track ao Titulo da Notificacao
	cDescWork := cDescricao 

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado 
	oProcess:Track( cCodigoStatus, cDescricao )

	// Execute a função responsável pela notificação ao usuário solicitante.
	U_SCNotificar( oProcess, cDescWork, cCor, cAprovacao )

Return Nil

//Funcao de Notificacao do WorkFlow de Aprovacao de SC
User Function SCNotificar( oProcess, cDescWork, cCor, cAprovacao )

	Local oHtml			:= Nil
	Local aValues 		:= Array(17)
	Local cCodigoStatus	:= ""
	Local cDescricao	:= ""
	Local cArqHtml		:= ""

	//Caminho e Arquivo HTML do Link de Formulario de Aprovacao
	cArqHtml := "\Workflow\WFSCAprov.html"

	//Informa o Codigo do Status do Processo Correspondente ao Inicio do Start de WorkFlow
	cCodigoStatus	:= "100700"
	cDescricao 		:= "Notifica a Aprovacao/Reprovacao ao Solicitante e ao Departamento de Compras"

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado
	oProcess:Track( cCodigoStatus, cDescricao )

	//Cria Objeto HTML do Processo de WorkFlow de Aprovacao de SC
	oHtml := oProcess:oHtml

	//Atribui os Valores Recuperados do HTML ao Array aValues
	aValues[01] := oHtml:ValByName("Num_SC")
	aValues[02] := oHtml:ValByName("Dt_Emissao")
	aValues[03] := oHtml:ValByName("Dt_Entrega")
	aValues[04] := oHtml:ValByName("Solicitante")
	aValues[05] := oHtml:ValByName("CC")
	aValues[06] := oHtml:ValByName("TB.Item")
	aValues[07] := oHtml:ValByName("TB.Codigo")
	aValues[08] := oHtml:ValByName("TB.Unid")
	aValues[09] := oHtml:ValByName("TB.Descricao")
	aValues[10] := oHtml:ValByName("TB.Qtd")
	aValues[11] := oHtml:ValByName("TB.Fundo")
	aValues[12] := oHtml:ValByName("Aprovador")
	aValues[13] := oHtml:ValByName("Projeto")
	aValues[14] := oHtml:ValByName("Objetivo")

	//Associa o HTML de Envio da Aprovacao / Rejeicao
	oProcess:HtmlFile(cArqHtml)

	//Recupera as Informacoes do Array e Preenche o Arquivo HTML de Notificao
	oHtml:ValByName("Num_SC"		, aValues[01] )
	oHtml:ValByName("Dt_Emissao"	, aValues[02] )
	oHtml:ValByName("Dt_Entrega"	, aValues[03] )
	oHtml:ValByName("Solicitante"	, aValues[04] )
	oHtml:ValByName("CC"			, aValues[05] )
	oHtml:ValByName("Aprovador"		, aValues[12] )
	oHtml:ValByName("Projeto"		, aValues[13] )
	oHtml:ValByName("Objetivo"		, aValues[14] )

	//Recupera as Informacoes do Array e Preenche o Arquivo HTML de Notificao
	AEval( aValues[06],{ |x| AADD( oHtml:ValByName( "TB.Item" )		, x ) } )
	AEval( aValues[07],{ |x| AADD( oHtml:ValByName( "TB.Codigo" )	, x ) } )
	AEval( aValues[08],{ |x| AADD( oHtml:ValByName( "TB.Unid" )		, x ) } )
	AEval( aValues[09],{ |x| AADD( oHtml:ValByName( "TB.Descricao" ), x ) } )
	AEval( aValues[10],{ |x| AADD( oHtml:ValByName( "TB.Qtd" )		, x ) } )
	AEval( aValues[11],{ |x| AADD( oHtml:ValByName( "TB.Fundo" )	, x ) } )

	////Recupera as Informacoes das Variaveis e Preenche o Arquivo HTML de Notificao
	oHtml:ValByName( "Titulo"		, cDescWork )
	oHtml:ValByName( "Cor_Tit"  	, cCor )
	oHtml:ValByName( "Cor_Itens"	, cCor )
	oHtml:ValByName( "Aprovacao"	, cAprovacao)
	oHtml:ValByName( "Dt_Aprov"		, dDataBase )
	oHtml:ValByName( "Hora_Aprov"	, Time()  )

	//E-mail que Ira Receber a Notificacao de Aprovacao/Rejeicao do Processo de WorkFlow
	oProcess:cTo      := "aprovacao@email.com.br"

	//Assunto do E-mail que Ira Receber a Notificacao de Aprovacao/Rejeicao do Processo de WorkFlow
	oProcess:cSubject := "Retorno da Aprovacao da Solicitacao de Compras"

	//Cria e Inicia o Processo de Envio de E-mail do WorkFlow de Aprovacao de SC
	oProcess:Start()

	//Informa o Codigo e Descricao do Status do Processo Correspondente ao Inicio do Start de WorkFlow 
	cCodigoStatus := "100800"
	cDescricao := "Finalizacao do Processo de Workflow de Aprovacao de SC"

	//Ratreabilidade com o Codigo do Status, Descricao e Usuario Logado
	oProcess:Track( cCodigoStatus, cDescricao )

	// Se for a primeira vez, finalize a tarefa anterior.
	oProcess:Finish()

Return Nil