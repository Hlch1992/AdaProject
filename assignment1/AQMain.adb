with Text_Io;
use Text_Io;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with AdaptiveQuad;

procedure AQMain is
    eps:Float:=0.000001;

    package FloatFunctions is new Ada.Numerics.Generic_Elementary_Functions(Float);
    use FloatFunctions;

    function MyF (x:Float) return Float is
    begin
        return Sin(x*x);
    end MyF;

    package MyAQ is new AdaptiveQuad (MyF);

    task ReadPairs;
    task ComputeArea is
        entry Start(a,b:Float);
        entry Done;
    end ComputeArea;
    task PrintResult is
        entry Start (a,b,Res:Float);
        entry Done;
    end PrintResult;

    task body ReadPairs is
        a,b : Float;
    begin
        for I in 1..5 loop
            Put("enter a: ");
            Get(a);
            Put("enter b: ");
            Get(b);
            ComputeArea.Start(a,b);
        end loop;
        ComputeArea.Done;
    end ReadPairs;

    task body ComputeArea is
        Res:Float;
        Finished: Boolean := False;
    begin
            while not Finished loop
            select
                accept Start (a,b:Float) do
                    Res:= MyAQ.AQuad(a,b,eps);
                    PrintResult.Start(a,b,Res);
                end Start;
            or
                accept Done;
                Finished:=True;
            end select;
        end loop;
        PrintResult.Done;
    end ComputeArea;

    task body PrintResult is
        Finished: Boolean := False;
    begin
            while not Finished loop
            select
                accept Start (a,b,Res:Float) do
                    Put("The area under sin(x^2) for x= ");
                    Put(a);
                    Put(" to ");
                    Put(b);
                    Put(" is ");
                    Put(Res); New_Line;
                end Start;
            or
                accept Done;
                Finished:=True;
            end select;
        end loop;
    end PrintResult;
begin
    Null;
end AQMain;
