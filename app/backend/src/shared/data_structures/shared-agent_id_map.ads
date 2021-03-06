with Ada.Containers.Ordered_Maps;

with Active.Agent;

package Shared.Agent_Id_Map is
    new Ada.Containers.Ordered_Maps
      (Key_Type        => Active.Agent.Agent_Id,
       Element_Type    => Natural,
       "="             => "=",
       "<"             => Active.Agent."<");
