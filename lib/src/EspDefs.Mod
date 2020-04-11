(* 
This module serves, with the Esp module, as a bridge between the 
Oberon execution context and the ESP-IDF framework. The Esp module is 
compiled only to retrieve the smb file, such that it can be imported in 
other Oberon modules. The code is supplied by a C language source file
that is responsible of calling ESP-IDF functions. Normally, the Esp 
Oberon module definition must stay unchanged. The EspDefs module 
contains the constants and type structure required by other modules to
prepare calls to ESP-IDF through the Esp procedures. It is expected that
new bridge connexions would require both changes in the EspDefs and the 
C language source file, leaving the Esp module unchanged. This is to 
limit the needs of modifying entry points as the module signature is 
part of the procedure names.
*)

MODULE EspDefs;
CONST 
  (* Results. Negative numbers are for error results. *)

  (* Components *)

  (* Functions *)

TYPE

END EspDefs.
