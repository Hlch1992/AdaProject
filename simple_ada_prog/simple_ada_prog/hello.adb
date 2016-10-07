With text_io;
use text_io;

procedure hello is

   task Foo;
   
   task body Foo is
   begin

      Put("In foo");
      New_Line;
   end Foo;

begin
  Put("Hello World"); New_Line;
end Hello;
