(* 
This module serves, with the QioDefs module, as a bridge between the 
Oberon execution context and the ESP-IDF framework. The Qio module is 
compiled only to retrieve the smb file, such that it can be imported in 
other Oberon modules. The code is supplied by a C language source file
that is responsible of calling ESP-IDF functions. Normally, the Qio 
Oberon module definition must stay unchanged. The QioDefs module 
contains the constants and type structure required by other modules to
prepare calls to ESP-IDF through the Qio procedures. It is expected that
new bridge connexions would require both changes in the QioDefs and the 
C language source file, leaving the Qio module unchanged. This is to 
limit the needs of modifying entry points as the module signature is 
part of the procedure names.
*)

MODULE Qio;

  PROCEDURE [CDECL] Qio0*(component, function: INTEGER): INTEGER;
    VAR Result: INTEGER;
  BEGIN RETURN Result END Qio0; 

  PROCEDURE [CDECL] Qio1*(component, function, param: INTEGER): INTEGER;
    VAR Result: INTEGER;
  BEGIN RETURN Result END Qio1; 

  PROCEDURE [CDECL] Qio2*(component, function, param1, param2: INTEGER): INTEGER;
    VAR Result: INTEGER;
  BEGIN RETURN Result END Qio2; 

  PROCEDURE [CDECL] Qio4*(component, function, param1, param2, param3, param4: INTEGER): INTEGER;
    VAR Result: INTEGER;
  BEGIN RETURN Result END Qio4; 

END Qio.