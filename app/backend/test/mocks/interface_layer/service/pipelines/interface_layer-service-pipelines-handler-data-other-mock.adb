package body Interface_Layer.Service.Pipelines.Handler.Data.Other.Mock is

   function Create (Next : Handler.Reference;
                    Req : Req_Wrapper.Object := Empty_Request)
   return Data.Other.Mock.Reference
   is
      Instance : Data.Other.Mock.Reference := new Data.Other.Mock.Object;
   begin
      Instance.Mocked_Values.Next := Next;
      Instance.Mocked_Values.Next_Existence := True;
      Instance.Mocked_Values.Req := Req;
      Instance.Mocked_Values.Next_Existence := False;
      return Instance;
   end;

end Interface_Layer.Service.Pipelines.Handler.Data.Other.Mock;
