MODULE errors;

IMPORT
    Strings, Out, VT100,
    format;

PROCEDURE Pipe*(error, label, description : ARRAY OF CHAR);
VAR
    newRow : ARRAY 1024 OF CHAR; 

BEGIN

    (* setup new clear row *)
    format.Clear(newRow);

    (* append escape sequence for dark gray text color *)
    format.AppendStr(newRow, VT100.CSI);
    format.AppendStr(newRow, VT100.DarkGray);

    (* append the row label with customsized prefix *)
    format.AppendStr(newRow, "> ");
    format.AppendStr(newRow, label);
    format.AppendStr(newRow, ": ");

    (* append escape sequence for style reset *)
    format.AppendStr(newRow, VT100.CSI);
    format.AppendStr(newRow, VT100.ResetAll);
    
    (* append the row description *)
    format.AppendStr(newRow, description);
    
    (* append the line feed *)
    format.AppendChr(newRow, CHR(10));

    (* append the new row to the parenting row set *)
    format.AppendStr(error, newRow);

END Pipe;

PROCEDURE Raise*(error, label : ARRAY OF CHAR);
VAR
    escape : ARRAY 8 OF CHAR;

BEGIN

    (* if raise is called with an empty error string *)
    (* then print raise misuse message and return *)
    IF (format.Length(error) = 0)
    THEN
        Out.String(label);
        Out.String(": invalid raising");
        Out.Ln;
        RETURN;
    END;
     
    (* else *)

    (* print header line feed *)
    Out.Ln;
    
    (* print escape sequence for red *)
    format.Clear(escape);
    format.AppendStr(escape, VT100.CSI);
    format.AppendStr(escape, VT100.Red);
    Out.String(escape);
    
    (* print escape sequence for underline *)
    format.Clear(escape);
    format.AppendStr(escape, VT100.CSI);
    format.AppendStr(escape, VT100.Underlined);
    Out.String(escape);

    (* print error row set label *)
    Out.String(label);
    Out.Ln;  

    (* print escape sequence for reset *)
    format.Clear(escape);
    format.AppendStr(escape, VT100.CSI);
    format.AppendStr(escape, VT100.ResetAll);
    Out.String(escape);
    
    (* print the piped set of error rows *)
    Out.String(error);

    (* print footer line feed *)
    Out.Ln;

END Raise;

END errors.
