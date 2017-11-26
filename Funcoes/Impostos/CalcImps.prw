#Include "Protheus.ch"
#Include "RwMake.ch"

User Function CalcImps()

	//Busca referencias fiscais ("NF_" e ""IT_") no Dicionario de Dados (Sx3)
	Local aRelImp   := MaFisRelImp("MATA410",{"SF2","SD2"})

	//Variaveis para obtencao das posicoes dos campos na GetDados
	Local nPosPrd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
	Local nPosTes   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})
	Local nPosQtVen := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
	Local nPosPrUnt := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRUNIT"})
	Local nPosVDes	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_VALDESC"})
	Local nPosVlr   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR"})
	Local nPosAlICM	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XALICMS"})
	Local nPosBsICM := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XBSICMS"})
	Local nPosVlICM	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLICM"})
	Local nPosAlIPI	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XALIPI"})
	Local nPosBsIPI := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XBSIPI"})
	Local nPosVlIPI := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLIPI"})
	Local nPosBsIss	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XBSISS"})
	Local nPosVlISS := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLISS"})
	Local nPosBsST  := aScan(aHeader,{|x| Alltrim(x[2]) ==  "C6_XBSICST"})
	Local nPosVlST  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLICST"})
	Local nPosBsPIS := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XBSPIS"})
	Local nPosVlPIS := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLPIS"})
	Local nPosBsCOF := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XBSCOF"})
	Local nPosVlCOF	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_XVLCOF"})

	//Inicia o processo de calculo da MatxFis, gerando um array do Cabecalho do Documento Fisca/
	MaFisIni(	M->C5_CLIENTE,;			     		// 1-Codigo Cliente/Fornecedor
	M->C5_LOJACLI,;			     		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO $ 'DB', "F", "C"),;	// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				     	// 4-Tipo da NF
	M->C5_TIPOCLI,;			     		// 5-Tipo do Cliente/Fornecedor
	aRelImp,;					     	// 6-Relacao de Impostos que suportados no arquivo
	,;						   	     	// 7-Tipo de complemento
	,;							     	// 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					     		// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA461")					     	// 10-Nome da rotina que esta utilizando a funcao

	//Inclui um novo item ao array aNFItem da MatxFis, disparando o calculo das bases e impostos
	MaFisAdd(	aCols[n][nPosPrd],; 	  		// 1-Codigo do Produto ( Obrigatorio )
	aCols[n][nPosTes],;							// 2-Codigo do TES ( Opcional )
	aCols[n][nPosQtVen],;	  					// 3-Quantidade ( Obrigatorio )
	aCols[n][nPosPrUnt],;	  					// 4-Preco Unitario ( Obrigatorio )
	aCols[n][nPosVDes],;    					// 5-Valor do Desconto ( Opcional )
	,;		            						// 6-Numero da NF Original ( Devolucao/Benef )
	,;		            						// 7-Serie da NF Original ( Devolucao/Benef )
	0,;			        						// 8-RecNo da NF Original no arq SD1/SD2
	0,;											// 9-Valor do Frete do Item ( Opcional )
	0,;											// 10-Valor da Despesa do item ( Opcional )
	0,;            								// 11-Valor do Seguro do item ( Opcional )
	0,;											// 12-Valor do Frete Autonomo ( Opcional )
	(aCols[n][nPosVlr]+aCols[n][nPosVDes]),;	// 13-Valor da Mercadoria ( Obrigatorio )
	0)											// 14-Valor da Embalagem ( Opiconal )

	//Atribui aos campos de aliquotas de ICMS e IPI, os valores de porcentagem do ICMS e IPI
	aCols[n][nPosAlICM] := MaFisRet(1, "IT_ALIQICM")
	aCols[n][nPosAlIPI] := MaFisRet(1, "IT_ALIQIPI")

	//Atribui aos campos de Bases e Valores dos Impostos, os valores de ICMS, ICMS ST e IPI	
	aCols[n][nPosBsICM]	:= MaFisRet(1, "IT_BASEICM")
	aCols[n][nPosVlICM] := MaFisRet(1, "IT_VALICM")
	aCols[n][nPosBsST] 	:= MaFisRet(1, "IT_BASESOL")
	aCols[n][nPosVlST] 	:= MaFisRet(1, "IT_VALSOL")
	aCols[n][nPosBsIPI] := MaFisRet(1, "IT_BASEIPI")
	aCols[n][nPosVlIPI]	:= MaFisRet(1, "IT_VALIPI")

	//Atribui aos campos de Bases e Valores dos Impostos, os valores de ISS
	aCols[n][nPosBsIss]  := MaFisRet(1, "IT_BASEISS")
	aCols[n][nPosVlISS]  := MaFisRet(1, "IT_VALISS")

	//Atribui aos campos de Bases e Valores dos Impostos, os valores de PIS e COFINS	
	aCols[n][nPosBsPIS] := MaFisRet(1, "IT_BASEPS2")
	aCols[n][nPosVlPIS] := MaFisRet(1, "IT_VALPS2")	
	aCols[n][nPosBsCOF] := MaFisRet(1, "IT_BASECF2")
	aCols[n][nPosVlCOF] := MaFisRet(1, "IT_VALCF2")

	//Finaliza o uso da funcao MatxFis, "zerando" os arrays de calculos interno
	MaFisEnd()

Return .T.