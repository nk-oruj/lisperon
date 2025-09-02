MODULE format;

PROCEDURE Clear*(VAR destination : ARRAY OF CHAR);
VAR
    capacity    : LONGINT;

BEGIN

    capacity    := LEN(destination);

    (* just in case, only if destination has a non zero capacity *)
    (* set the first character of the array to null to reset the string *)
    IF (capacity > 0)
    THEN
        destination[0] := 0X;
    END;

END Clear;

PROCEDURE Length*(valueStr : ARRAY OF CHAR) : INTEGER;
VAR
    capacity    : LONGINT;
    maximum     : INTEGER;
    index       : INTEGER;

BEGIN

    capacity    := LEN(valueStr);
    maximum     := MAX(INTEGER);

    (* iterate through the indices of the array starting from zero *)
    (* until iteration either reaches null termination in the array *)
    (* or reaches array capacity *)
    (* or reaches integer maximum *)
    index := 0; WHILE (valueStr[index] # 0X) & (index < capacity) & (index < maximum)
    DO
        index := index + 1;
    END;

    (* return the iterated value as the string length *) 
    RETURN index;

END Length;

PROCEDURE AppendStr*(VAR destination : ARRAY OF CHAR; valueStr : ARRAY OF CHAR);
VAR
    capacity    : LONGINT;
    lengthA     : INTEGER;
    lengthB     : INTEGER;
    index       : INTEGER;

BEGIN

    capacity    := LEN(destination);
    lengthA     := Length(destination);
    lengthB     := Length(valueStr);
   
    (* iterate through the value string *)
    (* by halting if it ever reaches destination capacity *)
    (* and append characters from value to destination *)
    index := 0; WHILE (index < lengthB) & ((index + lengthA) < capacity)
    DO
        destination[index + lengthA] := valueStr[index];
        index := index + 1;
    END;

    (* if prior iteration ended without reaching capacity *)
    (* then set null after the last appended character *)
    (* else set last character of destination to null *)
    IF ((index + lengthA) < capacity)
    THEN
        destination[index + lengthA] := 0X;
    ELSE
        destination[capacity - 1] := 0X;
    END;

END AppendStr;

PROCEDURE AppendChr*(VAR destination : ARRAY OF CHAR; valueChr : CHAR);
VAR
    capacity    : LONGINT;
    length      : INTEGER;

BEGIN

    capacity    := LEN(destination);
    length      := Length(destination);

    (* if the array is still capable to receive character *)
    (* then set value character after lastly appended character *)
    (* and set null after it *)
    IF ((length + 1) < capacity)
    THEN
        destination[length] := valueChr;
        destination[length + 1] := 0X;
    END;

END AppendChr;

PROCEDURE AppendInt*(VAR destination : ARRAY OF CHAR; valueInt : INTEGER);
VAR
    index, length   : INTEGER;
    digitChar       : CHAR;
    negative        : BOOLEAN;
    temp            : ARRAY 16 OF CHAR;

BEGIN

    (* if value integer is zero *)
    (* then append character zero and return *)
    IF (valueInt = 0)
    THEN
        AppendChr(destination, "0");
        RETURN;
    END;

    (* if value integer is negative *)
    (* then memorize the negativity and invert the value *)
    negative := FALSE; IF (valueInt < 0)
    THEN
        negative    := TRUE;
        valueInt    := -valueInt;
    END;

    (* while value integer has not been popped of all its digits *)
    (* take off its last digit and convert to character firstly *)
    (* then append the character to a temporary array *)
    index := 0; WHILE (valueInt # 0)
    DO
        digitChar   := CHR(ORD("0") + (valueInt MOD 10));
        valueInt    := valueInt DIV 10;
        
        temp[index] := digitChar;        
        index       := index + 1;
    END;

    (* if the value integer was initially negative *)
    (* then append a minus character to destination *)
    IF (negative)
    THEN
        AppendChr(destination, "-");
    END;

    (* iterate through the temporary array in reverse *)
    (* and sequentially append the stored digit characters to destination *)
    WHILE (index > 0)
    DO
        index := index - 1;
        AppendChr(destination, temp[index]);
    END;

END AppendInt;

PROCEDURE AppendFlt*(VAR destination : ARRAY OF CHAR; valueFlt : REAL);
BEGIN
END AppendFlt;

END format.
