program main;

{$APPTYPE CONSOLE}
{$mode objfpc}{$H+}

uses SysUtils, Classes,
    {$IFDEF UNIX}
    {$IFDEF UseCThreads}
    cthreads,
    {$ENDIF}
    unix,
    {$ENDIF} 
    {$IFDEF MSWINDOWS}
    Process,
    {$ENDIF}
    CustApp,
    StrUtils;



type
    MyApp = class(TCustomApplication)
    //private
    //       
    protected
        procedure DoRun; override;
    public
        constructor Create(TheOwner: TComponent); override;
        destructor Destroy; override;
        procedure WriteHelp; virtual;
end;

function getRAMUsageByPID(pid : String) : String;
var
    fn : Text;
    s  : String;
begin
    assignfile(fn, '/proc/'+ParamStr(1)+'/status');
    reset(fn);
    while not eof(fn) do
    begin
        readln(fn, s);
        //if (LeftStr(s, 7) = 'VmSize:') then 
        //begin
        //    s := TrimLeft(RightStr(s, Length(s)-7));
        //    break;
        //end;
        if (LeftStr(s, 6) = 'VmRSS:') then 
        begin
            s := TrimLeft(RightStr(s, Length(s)-6));
            break;
        end;
    end;
    closefile(fn);
    Result := s;
end;

procedure MyApp.DoRun;
begin
    if HasOption('h', 'help') then begin
        WriteHelp();
        Halt();
    end;
    
    // code here
    if ParamCount >= 1 then
    begin
        try
            writeln(getRAMUsageByPID(ParamStr(1)));
        except
            on E : EInOutError do
            begin
                writeln('There is no process with PID '+ParamStr(1));
            end;
            on E : Exception do
            begin
                writeln(E.toString());
            end;
        end;
    end else begin
        writeln('No PID provided!');
    end;

    Terminate; //
end;

constructor MyApp.Create(TheOwner: TComponent);
begin
    inherited Create(TheOwner);
    //StopOnException:=True;
end;

destructor MyApp.Destroy;
begin
    inherited Destroy;
end;

procedure MyApp.WriteHelp;
begin
    writeln('Usage: '+Title+' PID');
end;

var App : MyApp;

//{$R *.res}

begin
    App := MyApp.Create(nil);
    App.Title := 'fpmonitor';
    App.Run;
    App.Free;
    //{$IFDEF MSWINDOWS}
    //Sleep(500);
    //{$ENDIF}
    //readln();
end.
