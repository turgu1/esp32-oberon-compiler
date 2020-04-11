# .smb File Format

- `INTEGER` 0
- `INTEGER` chksum
- `ARRAY OF CHAR` moduleId
- `BYTE` .smb version key
- `BYTE` = 1 if a CDECL module, 0 otherwise
- For Each Exported Object
  - `BYTE` Object Class
  - `ARRAY OF CHAR` Object Name
  - Type Descriptor (see below)
  - If Object Class is Typ
    - 
- `BYTE` 0
To be completed


