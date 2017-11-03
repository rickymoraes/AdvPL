#Include 'Protheus.ch'

//Funcao TcGetDB - http://tdn.totvs.com/display/tec/TCGetDB
User Function UseTcGetDB()

	Local cNomeBD := ""

	//Obtem a Conexao atual do DBAccess
	cNomeBD := TcGetDB()

	MsgInfo("Banco de Dados Utilizado: " + cNomeBD)

Return Nil