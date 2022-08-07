program GameSnake;
uses Crt;
type
    indicator = ^part;

    part = record
        segment: char;
        coordinate_x,coordinate_y: byte;
        next: indicator
    end;

var
  snake,tail: indicator;
  cl,x,y,x1,y1: byte;
  input,key: char;
  FoodInsideSnake,TheEnd: boolean;
  score: word;
  board: array[1..23,1..80] of byte;
procedure SnakeDisplay(var count_loop: byte);
begin
     while tail^.next <> nil do
          with tail^ do
              begin
                if FoodInsideSnake = false then
                 if count_loop = 1 then
                   begin
                     gotoxy(coordinate_x,coordinate_y);
                     write(' ');
                     board[coordinate_y,coordinate_x] := 0
                   end;
                coordinate_y := next^.coordinate_y;
                coordinate_x := next^.coordinate_x;
                if (coordinate_y = y) and (coordinate_x = x) then
                TheEnd := true;
                gotoxy(coordinate_x,coordinate_y);
                TextColor(LightRed);
                writeln(segment);
                board[coordinate_y,coordinate_x] := 1;
                count_loop := count_loop + 1;
                tail := next
              end
end;
procedure AddSegment(length: byte);
var
  i: byte;
begin
     for i := 1 to length do
        begin
          New(tail);
          tail^.next := snake;
          with tail^ do
            begin
              segment := chr(64);
              coordinate_y := y;
              coordinate_x := x + (i - 1)
            end;
          snake := tail
        end
end;
begin
     New(snake);
     tail := nil;
     snake := nil;
     ClrScr;

     TextColor(Yellow);
     gotoxy(1,2); write(chr(201));
     gotoxy(80,2); write(chr(187));

     for x := 2 to 79 do
       if not (x in [31..49]) then
         begin
           gotoxy(x,2);
           write(chr(205));
           gotoxy(x,23);
           write(chr(205))
         end;

     for y := 3 to 22 do
       if not (y in [9..13]) then
         begin
           gotoxy(1,y);
           write(chr(186));
           gotoxy(80,y);
           write(chr(186))
         end;

     gotoxy(1,23); write(chr(200));
     gotoxy(80,23); write(chr(188));

     TextColor(White);

     y := 12; x := 40;
     y1 := 11; x1 := 30;
     AddSegment(2);
     input := #75;
     randomize;

     FoodInsideSnake := true; TheEnd := false; score := 0;

     repeat
           if (x = x1) and (y = y1) then
             begin
               AddSegment(1);
               while board[y1,x1] = 1 do
                 begin
                   x1 := random(78)+2;
                   y1 := random(20)+3
                 end;
               FoodInsideSnake := true;
               score := score + 1;
               Sound(1000)
             end
           else
             begin
               FoodInsideSnake := false;
               NoSound
             end;

           tail := snake;

           if keypressed then
             begin
               key := readkey;
               if ord(key) = 0 then key := readkey;
               if ((key = #72) and (input <> #80)) or
                  ((key = #80) and (input <> #72)) or
                  ((key = #75) and (input <> #77)) or
                  ((key = #77) and (input <> #75)) then input := key
             end;

           if input = #72 then y := y - 1;
           if input = #80 then y := y + 1;
           if input = #75 then x := x - 1;
           if input = #77 then x := x + 1;

           if (y > 22) and not (x in [31..49]) then TheEnd := true
           else if y > 23 then y := 2;

           if (x > 79) and not (y in [9..13]) then TheEnd := true
           else if x > 80 then x := 1;

           if (y < 3) and not (x in [31..49]) then TheEnd := true
           else if y < 2 then y := 23;

           if (x < 2) and not (y in [9..13]) then TheEnd := true
           else if x < 1 then x := 80;

           cl := 1;
           SnakeDisplay(cl);

           if cl = 1 then
             begin
              gotoxy(tail^.coordinate_x,tail^.coordinate_y);
              write(' ')
             end;

           tail^.coordinate_y := y;
           tail^.coordinate_x := x;

           with tail^ do
             begin
               gotoxy(coordinate_x,coordinate_y);
               board[coordinate_y,coordinate_x] := 1;
               TextColor(LightCyan);
               write(chr(2))
             end;

           gotoxy(x1,y1);
           TextColor(Green);
           writeln(chr(15));
           TextColor(White);

           gotoxy(36,1);
           writeln('Score: ',score);

           delay(125)
     until TheEnd = true;

     gotoxy(36,12);
     TextColor(Red);
     write('GAME OVER');
     gotoxy(35,13);
     TextColor(Green);
     write('Press Enter');

     Sound(300);
     delay(500);
     NoSound;
     readln
end.