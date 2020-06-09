{$SetPEFlags $0020}           // Gerenciador de Aloca��o de Mem�ria Alternativo (FastMM4, "App can handle >2gb addresses")


{$MINSTACKSIZE $00004000}     // O Valor "Padr�o Default" � "$00004000" (O Valor Padr�o Pode Ser Utilizado Sem Problemas)
{$MAXSTACKSIZE $00100000}     // O Valor "Padr�o Default" � "$00100000" (O Valor Padr�o Pode Ser Utilizado Sem Problemas)

program Infosistemas;

uses
  FastMM4,
  Forms,
  Windows,
  Midaslib,
  uDialogo in 'uDialogo.pas' {frmDialogo},
  uLogin in 'uLogin.pas' {frmLogin},
  uImprimirDefinirOrientacaoImpressao in 'uImprimirDefinirOrientacaoImpressao.pas' {frmImprimirDefinirOrientacaoImpressao},
  uImprimirPrevisaoImpressao in 'uImprimirPrevisaoImpressao.pas' {frmImprimirPrevisaoImpressao},
  uDialogoCrudClientes in 'uDialogoCrudClientes.pas' {frmDialogoCrudClientes},
  uImprimirRelatorioCrudClientesComFotos in 'uImprimirRelatorioCrudClientesComFotos.pas' {frmImprimirRelatorioCrudClientesComFotos},
  uAguarde in 'uAguarde.pas' {frmAguarde},
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uImprimirRelatorioCrudClientes in 'uImprimirRelatorioCrudClientes.pas' {frmImprimirRelatorioCrudClientes};

{$R *.res}

var
  PrioridadeClasse, Prioridade: Integer;

begin
  {Definir Prioridade De Execu��o Com o M�ximo:}
  PrioridadeClasse := GetPriorityClass( GetCurrentProcess );
  Prioridade := GetThreadPriority( GetCurrentThread );
  SetPriorityClass( GetCurrentProcess, HIGH_PRIORITY_CLASS );      // Poderia Ser REALTIME_PRIORITY_CLASS
  SetThreadPriority( GetCurrentThread, THREAD_PRIORITY_HIGHEST );  // Poderia Ser THREAD_PRIORITY_TIME_CRITICAL

  FastMM4.SuppressMessageBoxes := True;                            // Gerenciador de Aloca��o de Mem�ria Alternativo

  Application.Initialize;
  Application.Title := 'Infosistemas CRUD';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmAguarde, frmAguarde);
  Application.CreateForm(TfrmImprimirRelatorioCrudClientes, frmImprimirRelatorioCrudClientes);
  Application.Run;

  {Restaurar Prioridade De Execu��o Com o Original Normal:}
  SetThreadPriority( GetCurrentThread, Prioridade );
  SetPriorityClass( GetCurrentProcess, PrioridadeClasse );
end.
