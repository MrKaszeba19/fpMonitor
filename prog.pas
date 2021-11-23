program NAME;

{$mode objfpc}{$H+}

uses StrUtils, SysUtils;

var
    fn   : Text;
    s    : String;
begin
	if ParamCount >= 1 then
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
        writeln(s);
    end else begin
        writeln('No PID!');
    end;
end.
