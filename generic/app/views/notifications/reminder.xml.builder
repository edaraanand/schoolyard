 xml.instruct!  
 xml.Response do  
     xml.Gather(:action => @postto, :numDigits => 1) do  
       xml.Say "Hello AJ. Huw r u from Eshwar"  
       xml.Say "Please press 1 to repeat this menu. Press 2 for directions. Or press 3 if you are done."  
     end  
 end  
