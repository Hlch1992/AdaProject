
package body AdaptiveQuad is

    function SimpsonsRule (a,b: Float) return Float is
        c:Float:=(a+b)/2.0;
        h3:Float:=abs(b-a)/6.0;
    begin
        return h3*(f(a)+4.0*f(c)+f(b));
    end SimpsonsRule;

    function RecAQuad (a,b,eps,whole:Float) return Float is
        c,left,right,Res:Float;
        procedure Rec(a,b,c,eps:Float; Res: out Float) is
            task Tleft is
                entry push(x:Float);
                entry pop(t1:out Float);
            end Tleft;
            task body Tleft is
                t1:Float;
            begin
                select
                    accept push (x:Float) do
                       t1:=x+1.0;
                    end push;
                or
                    accept pop(t1:out Float) do
                        t1:=RecAQuad(a,c,eps/2.0,SimpsonsRule(a,c));
                    end pop;
                end select;
            end Tleft;

            task Tright is
                entry push(x:Float);
                entry pop(t2:out Float);
            end Tright;
            task body Tright is
                t2:Float;
            begin
                select
                    accept push (x:Float) do
                        t2:=x+1.0;
                    end push;
                or
                    accept pop(t2:out Float) do
                        t2:=RecAQuad(c,b,eps/2.0,SimpsonsRule(c,b));
                    end pop;
                end select;
            end Tright;
            function pop return Float is
                t1,t2:Float;
            begin
                Tleft.pop(t1);
                Tright.pop(t2);
                return t1+t2;
            end pop;
        begin
            Res:=pop;
        end Rec;
    begin
        c:=(a+b)/2.0;
        left:=SimpsonsRule(a,c);
        right:=SimpsonsRule(c,b);
        if abs(left+right-whole) > 15.0*eps then
            Rec(a,b,c,eps,Res);
            return Res;
        else
            return left+right+(left+right-whole)/15.0;
        end if;
    end RecAQuad;

    function AQuad (a,b,eps:Float) return Float is
    begin
        return RecAQuad(a,b,eps,SimpsonsRule(a,b));
    end AQuad;
begin
    Null;
end AdaptiveQuad;