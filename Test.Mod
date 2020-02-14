MODULE Test;
  IMPORT Logger, Texts;

VAR
  W: Texts.Writer;

BEGIN
  Texts.OpenWriter(W);
  Texts.WriteString(W, "ALLO!!");
  Texts.WriteString(W, "BONSOIR");
  Texts.WriteLn(W);
  Texts.WriteString(W, "BOO!!");
  Texts.WriteString(W, "REBOO!!");
  Texts.WriteLn(W);
  Texts.Append(Logger.Log, W.buf);
END Test.