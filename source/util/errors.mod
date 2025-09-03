MODULE errors;

IMPORT
    Strings, Out, VT100,
    format;

TYPE
    ErrorDesc* = RECORD
        rows : ARRAY 1024 OF CHAR
    END;
    Error* = POINTER TO ErrorDesc;

PROCEDURE Pipe*(error : Error; label, description : ARRAY OF CHAR) : Error;
VAR
    pipedError  : Error;
    pipedRow    : ARRAY 1024 OF CHAR;

BEGIN

    (* setup new error record and new row to be piped *)
    NEW(pipedError);
    format.Clear(pipedError.rows);
    format.Clear(pipedRow);

    (* append escape sequence for dark gray text color to the row *)
    format.AppendStr(pipedRow, VT100.CSI);
    format.AppendStr(pipedRow, VT100.DarkGray);

    (* append the row label with decorations to the row *)
    format.AppendStr(pipedRow, "> ");
    format.AppendStr(pipedRow, label);
    format.AppendStr(pipedRow, ": ");

    (* append escape sequence for style reset to the row *)
    format.AppendStr(pipedRow, VT100.CSI);
    format.AppendStr(pipedRow, VT100.ResetAll);
    
    (* append the row description to the row *)
    format.AppendStr(pipedRow, description);
    
    (* append line feed after the description *)
    format.AppendChr(pipedRow, CHR(10));

    (* now firstly append the new row to the new record *)
    (* and secondly if there is an initial error record being piped *)
    (* then append the rows of the initial record afterwards *)
    (* to append the whole set of rows in descending order *)
    format.AppendStr(pipedError.rows, pipedRow); 
    IF (error # NIL)
    THEN
        format.AppendStr(pipedError.rows, error.rows);
    END;

    (* return the new error record *)
    RETURN pipedError;

END Pipe;

PROCEDURE Raise*(error : Error; label : ARRAY OF CHAR);
VAR
    escape : ARRAY 8 OF CHAR;

BEGIN

    (* if raised error is not specified *)
    (* then print raise misuse message and return *)
    IF (error = NIL)
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
    
    (* print the piped error rows *)
    Out.String(error.rows);

    (* print footer line feed *)
    Out.Ln;

END Raise;

END errors.
