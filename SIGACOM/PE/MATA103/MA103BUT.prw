#Include 'Protheus.ch'
#Include 'Parmtype.ch'

User Function MA103BUT()

	//Variavel do tipo Array para armazenar o bitmap, acao e label do botao
	Local aButton	:= {}

	//Adicionamos ao array aButton o bitmap (tal recurso era utilizado no P10), acao e nome do label do botao
	AADD(aButton, {"", {|| U_SSCOM001()}, "Atualizar TES"})

//Devolvemos o Array preenchido ao PE
Return (aButton)