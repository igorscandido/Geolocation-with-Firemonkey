program GPS_Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMainU in 'fMainU.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
