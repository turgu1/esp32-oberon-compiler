MODULE Logger;
  IMPORT Texts, Out;

VAR
  Log* : Texts.Text;

PROCEDURE Notify(T: Texts.Text; op: INTEGER; beg, end: INTEGER);
VAR
  R : Texts.Reader;
  Ch : CHAR;
BEGIN
  Texts.OpenReader(R, T, beg);
  WHILE ~ R.eot DO
    Texts.Read(R, Ch);
    Out.Char(Ch);
  END 
END Notify;

BEGIN
  NEW(Log);
  Log.notify := Notify;
  Texts.Open(Log, "");
END Logger.