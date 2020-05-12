MODULE [CDECL] ESP_Support;

  TYPE 
    OPAQUE*     = INTEGER;
    OPAQUE_PTR* = POINTER TO OPAQUE;
    FILE*       = OPAQUE;
    FILE_PTR*   = POINTER TO FILE;

    size_t*     = INTEGER;
    enum_t*     = INTEGER;

    mac_t*      = ARRAY 6 OF BYTE; (* MAC Address *)
    
    str_t*      = ARRAY OF CHAR;
    bytes_t*    = ARRAY OF BYTE;
    str_ptr_t*  = POINTER TO str_t;

END ESP_Support.