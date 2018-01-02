#Include 'Protheus.ch'

User Function CotacaoMoedas()

	//Variaveis Locais
	Local oCotacaoMoedas 	:= Nil
	Local cRetCotMoeda 		:= ""
	Local cAvisos			:= ""
	Local cErros			:= ""
	Local cReplace			:= ""
	Local oXMLCotMoeda		:= Nil
	Local dDataCotacao		:= StoD("")	
	Local nCotacaoMoeda		:= 0
	Local lAtzDolar			:= .F.

	//Instanciacao do WsClient de Moeda do Fonte WCCotacaoMoedas.prw
	oCotacaoMoedas 	:= WSFachadaWSSGSService():New()

	//Setado o Codigo 10813 respectivo ao Dolar (Compra)
	oCotacaoMoedas:nin0 := 10813

	//Verificamos se o metodo getUltimoValorXML do WsClient WSFachadaWSSGSService foi consumido com sucesso
	If (oCotacaoMoedas:getUltimoValorXML())

		//Obtem o retorno de cotacao da Moeda no formato XML
		cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn 

		//Utiliza a funcao XmlParser para converter o retorno XML do WS para uma variavel do Tipo Objeto
		oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)	

		//Verifica se houve erro ao consumir o WS
		If AllTrim(cErros) == ""
			//Obtem a Data da Ultima Cotacao
			dDataCotacao := StoD(oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT + oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT + oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT)

			//Obtem o Valor da Ultima Cotacao
			nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))

			//Abre o Ordena a Tabela de Moedas - SM2
			DBSelectArea("SM2")
			SM2->(DBSetOrder(1))

			//Verifaca se ja existe ou nao, a Cotacao na Data obtida no consumo do WS
			IIF(DBSeek(FWFilial("SM2") + DtoS(dDataCotacao)),  RecLock("SM2", .F.), RecLock("SM2", .T.)) 

			//Atualiza a Data, Valor (no caso o Dolar e a Moeda 2, mas isso depende da configuracao), e a nao abertura da Tela de Cotacao na entrada do sistema
			SM2->M2_DATA	:= dDataCotacao
			SM2->M2_MOEDA2	:= nCotacaoMoeda
			SM2->M2_INFORM	:= "S"

			//Libera o registro alterado
			SM2->(MsUnLock())

			//Operacao realizada com sucesso
			lAtzDolar := .T.

		EndIf

	EndIf

Return (lAtzDolar)