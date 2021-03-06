unit fMainU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls, FMX.Controls.Presentation, FMX.WebBrowser,
  System.Sensors, System.Sensors.Components;

type
  TForm1 = class(TForm)
    lbMenu: TListBox;
    wbMapa: TWebBrowser;
    ListBoxHeader1: TListBoxHeader;
    Label1: TLabel;
    swGPS: TSwitch;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItemLatitude: TListBoxItem;
    ListBoxItemLongitude: TListBoxItem;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    ListBoxItemAdminArea: TListBoxItem;
    ListBoxItemPaisCod: TListBoxItem;
    ListBoxItemPais: TListBoxItem;
    ListBoxItemCaracteristica: TListBoxItem;
    ListBoxItemLocalidade: TListBoxItem;
    ListBoxItemSubAdminArea: TListBoxItem;
    ListBoxItemSubLocalidade: TListBoxItem;
    ListBoxItemSubLogradouro: TListBoxItem;
    ListBoxItemLogradouro: TListBoxItem;
    lsGPS: TLocationSensor;
    procedure swGPSSwitch(Sender: TObject);
    procedure lsGPSLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
    { Private declarations }
    FGeocoder : TGeocoder;
    procedure OnGeocodeReverseEvent(const Adress : TCivicAddress);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.lsGPSLocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);

var URLString : string;
begin

  FormatSettings.DecimalSeparator := '.';

  ListBoxItemLatitude.ItemData.Detail := Format('%2.6f', [NewLocation.Latitude]);
  ListBoxItemLongitude.ItemData.Detail := Format('%2.6f', [NewLocation.Longitude]);


  URLString := Format('https://maps.google.com/maps?q=%s,%s',
                      [Format('%2.6f', [NewLocation.Latitude]), Format('%2.6f', [NewLocation.Longitude])]);


  wbMapa.Navigate(URLString);

  try

  if not Assigned(FGeocoder) then
  begin
    if Assigned(FGeocoder.Current) then
      FGeocoder := TGeocoder.Current.Create;
    if Assigned(FGeocoder) then
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
  end;


    if Assigned(FGeocoder) and not FGeocoder.Geocoding then
      FGeocoder.GeocodeReverse(NewLocation);

  except

    ListBoxGroupHeader1.Text := 'Falha no servi?o de geolocaliza??o';

  end;

end;

procedure TForm1.OnGeocodeReverseEvent(const Adress: TCivicAddress);
begin

    ListBoxItemAdminArea.ItemData.Detail      := Adress.AdminArea;
    ListBoxItemPaisCod.ItemData.Detail        := Adress.CountryCode;
    ListBoxItemPais.ItemData.Detail           := Adress.CountryName;
    ListBoxItemCaracteristica.ItemData.Detail := Adress.FeatureName;
    ListBoxItemLocalidade.ItemData.Detail     := Adress.Locality;
    ListBoxItemSubAdminArea.ItemData.Detail   := Adress.SubAdminArea;
    ListBoxItemSubLocalidade.ItemData.Detail  := Adress.SubLocality;
    ListBoxItemSubLogradouro.ItemData.Detail  := Adress.SubThoroughfare;
    ListBoxItemLogradouro.ItemData.Detail     := Adress.Thoroughfare;

end;

procedure TForm1.swGPSSwitch(Sender: TObject);
begin
  lsGPS.Active := swGPS.IsChecked;
end;

end.
