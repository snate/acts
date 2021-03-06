with AUnit;
with AUnit.Test_Cases;

with Active.Agent;

with Reactive.Infrastructure.Lane.Mock;

package Reactive.Infrastructure.Lane.Decoration.Lane_Decorator.Tests is

   package AU renames AUnit;
   package TC renames AUnit.Test_Cases;
   package Agent renames Active.Agent;
   package Lane_Mock renames Reactive.Infrastructure.Lane.Mock;

   type Concrete_Decorator is new Lane_Decorator.Object with null record;

   type Lane_Decorator_Test is new TC.Test_Case with record
      Decorator : Lane_Decorator.Reference;
      Lane_Ref  : Lane_Mock.Reference;
   end record;

   overriding
   procedure Set_Up (T : in out Lane_Decorator_Test);

   -- Test Routines:
   procedure Test_Get_Lane_Ref (T : in out Lane_Decorator_Test);

   procedure Register_Tests (T : in out Lane_Decorator_Test);
   overriding
   function Name (T : in Lane_Decorator_Test) return AU.Message_String;

end Reactive.Infrastructure.Lane.Decoration.Lane_Decorator.Tests;
