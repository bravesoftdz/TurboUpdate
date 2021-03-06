{******************************************************************************}
{                           ErrorSoft TurboUpdate                              }
{                          ErrorSoft(c)  2016-2017                             }
{                                                                              }
{                     More beautiful things: errorsoft.org                     }
{                                                                              }
{           errorsoft@mail.ru | vk.com/errorsoft | github.com/errorcalc        }
{              errorsoft@protonmail.ch | habrahabr.ru/user/error1024           }
{                                                                              }
{             Open this on github: github.com/errorcalc/TurboUpdate            }
{                                                                              }
{ You can order developing vcl/fmx components, please submit requests to mail. }
{ �� ������ �������� ���������� VCL/FMX ���������� �� �����.                   }
{******************************************************************************}
unit TurboUpdate.Update;

interface

uses
  TurboUpdate.Types, System.Classes, System.SysUtils, Vcl.Forms, TurboUpdate.Model;

procedure Update(const UpdateInfo: TUpdateInfo);
procedure UpdateFromFile(const UpdateInfo: TUpdateInfo; FileName: string);

type
  TVclUpdateThread = class(TUpdateThread)
  protected
    View: TCustomForm;
    function CreateView: TCustomForm; virtual;
    procedure Work; override;
    procedure Prepare; override;
  end;

implementation

uses
  TurboUpdate.FormUpdate, Vcl.Dialogs;

//var
//  UpdateThread: TThread = nil;

procedure Update(const UpdateInfo: TUpdateInfo);
//var
//  Model: TUpdater;
//  View: TFormUpdate;
begin
//  if UpdateThread <> nil then
//    Exit;
//
//  Model := nil;
//  Application.CreateForm(TFormUpdate, View);
//  try
//    Model := TUpdater.Create(View, UpdateInfo);
//
//    UpdateThread := TThread.CreateAnonymousThread(
//    procedure
//    begin
//      try
//        Model.Update;
//      finally
//        Model.Free;
//
//        if View <> Application.MainForm then
//          TThread.Synchronize(nil, procedure
//          begin
//            View.Release;
//          end);
//
//        UpdateThread := nil;
//      end;
//    end);
//    UpdateThread.Start;
//
//  except
//    Model.Free;
//    View.Release;
//    raise;
//  end;
  TVclUpdateThread.Create(UpdateInfo).Update;
end;

procedure UpdateFromFile(const UpdateInfo: TUpdateInfo; FileName: string);
begin
  TVclUpdateThread.Create(UpdateInfo).UpdateFromFile(FileName);
end;

//function IsDone: Boolean;
//begin
//  Result := (UpdateThread = nil);
//end;

{ TVclUpdateThread }

function TVclUpdateThread.CreateView: TCustomForm;
begin
  Application.CreateForm(TFormUpdate, Result);
end;

procedure TVclUpdateThread.Prepare;
begin
  View := CreateView;
end;

procedure TVclUpdateThread.Work;
var
  Model: TUpdater;

begin

  Model := nil;
  try
    Model := CreateModel(View as IUpdateView);

    if IsUpdateFromFile then
      Model.UpdateFromFile(FileName)
    else
      Model.Update;

  finally
    Model.Free;

    if View <> Application.MainForm then
      Sync(procedure
      begin
        View.Release;
      end)
    else
    begin
      IsUpdating := False;
      Sync(procedure
      begin
        View.Close;
      end)
    end;
  end;
end;

//initialization
//  AddTerminateProc(IsDone);
//
//finalization

end.
