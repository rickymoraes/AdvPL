#Include 'protheus.ch'
#Include 'parmtype.ch'

User Function SSFWVetByDic()

	//Variaveis Locais
	Local aCampos 		:= {}
	Local aCamposOrd	:= {}

	//Array de Campos da Tabela SE2 - Contas a Pagar
	aCampos := {{ "E2_PREFIXO" 	, ""	, NIL },;
	{ "E2_NATUREZ"  , "0000000001"      , NIL },;
	{ "E2_NUM"      , "1234567890" 		, NIL },;
	{ "E2_TIPO"     , "NF"              , NIL },;
	{ "E2_VENCREA"  , StoD("20180101")	, NIL },;            
	{ "E2_FORNECE"  , "000001"          , NIL },;
	{ "E2_EMISSAO"  , StoD("20180101")	, NIL },;
	{ "E2_VENCTO"   , StoD("20180101")	, NIL },;
	{ "E2_VALOR"    , 100              	, NIL } }


	//Ordenacao dos Campos, conforme Dicionario de Campos (SX3), da Tabela SE2
	aCamposOrd := FWVetByDic( aCampos, "SE2" )

	//Fucao para exibicao dos dados do Array de campos em tela antes do uso da Funcao FWVetByDic, e depois do uso da mesma
	ExibeArray(aCampos, aCamposOrd)

Return

Static Function ExibeArray(aCampos, aCamposOrd)

	//Variaveis Locais
	Local aLinhas	:= {}
	Local nLinha	:= 1
	Local oDlg		:= Nil
	Local oBrowseE	:= Nil
	Local oBrowseD	:= Nil
	Local oSayD		:= Nil
	Local oSayE		:= Nil

	//Executa todo os itens do Array aCampos, criando sequencia de linhas no Array aLinhas
	AEval( aCampos, {|| AADD(aLinhas, StrZero(nLinha++, 2)) })


	//Cria Janela (Dialog) para montagem dos browses para exibicao dos Arrays
	DEFINE DIALOG oDlg TITLE "Função FWVetByDic" FROM 300,180 TO 652,1000 PIXEL

	//Cria Label de informacao a esquerda
	oSayE:= TSay():New(oDlg,{||"Antes de Utilizar a FWVetByDic"}, 005, 062,,,,,,.T.,CLR_BLUE, CLR_WHITE, 200,200,,,,,,, 2, 2)

	//Cria Browse com o Array antes da ordenacao de campos atraves da funcao FWVetByDic
	oBrowseE := TCBrowse():New( 020 , 003, 200, 156,,{"Linha", "Campo - Sx3", "Valores - SE2", "Nil"},{050, 500, 050}, oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,, )

	//Seta o Array de informacoes para o Browse                            
	oBrowseE:SetArray(aCampos) 

	//Adciona  as colunas do Browse
	oBrowseE:AddColumn( TCColumn():New("Linha"			,{ || aLinhas[oBrowseE:nAt]  },,,,"CENTER",,.F.,.T.,,,,.F.,) )
	oBrowseE:AddColumn( TCColumn():New("Campo - Sx3"	,{ || aCampos[oBrowseE:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,)  ) 
	oBrowseE:AddColumn( TCColumn():New("Valores - SE2"  ,{ || aCampos[oBrowseE:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,)  ) 
	oBrowseE:AddColumn( TCColumn():New("Nil" 			,{ || aCampos[oBrowseE:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,)  ) 

	//Evento de duplo click na celula para troca de linha do Browse a Direita
	oBrowseE:bLDblClick := {|| oBrowseD:GoPosition( oBrowseE:nAt ) }

	//Cria Label de informacao a diretira
	oSayD:= TSay():Create(oDlg,{||"Depois de Utilizar a FWVetByDic"}, 005, 268,,,,,, .T., CLR_RED, CLR_WHITE, 200,200,,,,,,, 2, 2)

	//Cria Browse com o Array apos a ordenacao de campos atraves da funcao FWVetByDic
	oBrowseD := TCBrowse():New( 020 , 210, 200, 156,,{"Linha", "Campo - Sx3", "Valores - SE2" , "Nil"},{050, 500, 050},	oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,, )

	//Seta o Array de informacoes para o Browse	                            
	oBrowseD:SetArray(aCamposOrd) 

	//Adciona  as colunas do Browse
	oBrowseD:AddColumn( TCColumn():New("Linha"			,{ || aLinhas[oBrowseD:nAt]   },,,,"CENTER",,.F.,.T.,,,,.F.,) )
	oBrowseD:AddColumn( TCColumn():New("Campo - Sx3"	,{ || aCamposOrd[oBrowseD:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
	oBrowseD:AddColumn( TCColumn():New("Valores - SE2"  ,{ || aCamposOrd[oBrowseD:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
	oBrowseD:AddColumn( TCColumn():New("Nil" 			,{ || aCamposOrd[oBrowseD:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 	

	//Evento de duplo click na celula para troca de linha do Browse a Direita
	oBrowseD:bLDblClick := {|| oBrowseE:GoPosition( oBrowseD:nAt ) }

	//Exibe o Dialog dos Browses
	ACTIVATE DIALOG oDlg CENTERED 

Return