% ----------===== MINI PUTT =====---------
% Christian Gallai
% June 20th, 2005
% This is a single player, mouse based mini putt game with 18 holes and high scores.

%This imports the GUI's that will be used throughout the entire game
import GUI in "%oot/lib/GUI"

%This is the setscreen so that the game takes up the entire computer screen with no button-bar
var WindowID : int

% Setting the initial window parameters
WindowID := Window.Open ("graphics:787;540;nobuttonbar;nocursor")

% Declaration of univeral variables
var newWidth, newHeight, File_High_Scores, Y_Location, Pic_Score_Clear, Pic_Score_Card, x, y, b : int
var Putter_Width, Putter_Height, Putter_Clear, Ball_Clear, Filea : int
var Mon_Exit_Info, Button_Go, Mon_Exit_Game, Smallest, Location, Return_High, Create_GUI, Monitor_Menu, Panel_Open : int := 0
var Old_x, Old_y, Course_Score, Course_Par, Line_Clear, Current_Hole, Pic_Score_Hole : int := 0
var Hole_Number, Track_Number : int := 1
var Info_GUI : array 1 .. 7 of int
var FontID : array 1 .. 11 of int
var Hole_x, Hole_y, Drop_x, Drop_y, Hole_1x, Hole_1y, Drop_1x, Drop_1y, Pic_Course, Hole_Score, Hole_Par : array 1 .. 18 of int
var High_Scores_GUI : array 1 .. 100 of int
var Scores, Sort_Scores : array 1 .. 8 of int
var Player_Name, Hole_Num, String_Score, String_Score_Sheet, Score_Title : string
var Names, Sort_Names : array 1 .. 8 of string (30)
var Score_GUI : array 1 .. 58 of int
var GUI_End_Game : array 1 .. 3 of int
var GUI_Menu : array 1 .. 6 of int
var Pic_Putter : array 0 .. 36 of int
var Vertical, Bounce, Hole_Done, Playing, Ball_Rolling, Main_Menu, Start_New, Have_Name, No_Menu, Game_Done, Changed_Pic : boolean := false
var High_Scores_Box : int := Pic.FileNew ("High_Scores_Box.bmp")
var Return_Button : int := Pic.FileNew ("Return_Button.bmp")
var Return_Button_Hot : int := Pic.FileNew ("Return_Button_Hot.bmp")
var Return_Button_Press : int := Pic.FileNew ("Return_Button_Press.bmp")
var Buttons : int := Pic.FileNew ("Buttons_1.bmp")
var Button_1_Hot : int := Pic.FileNew ("Button_1_Hot.bmp")
var Button_2_Hot : int := Pic.FileNew ("Button_2_Hot.bmp")
var Button_3_Hot : int := Pic.FileNew ("Button_3_Hot.bmp")
var Button_4_Hot : int := Pic.FileNew ("Button_4_Hot.bmp")
var Button_5_Hot : int := Pic.FileNew ("Button_5_Hot.bmp")
var Button_1_Press : int := Pic.FileNew ("Button_1_Press.bmp")
var Button_2_Press : int := Pic.FileNew ("Button_2_Press.bmp")
var Button_3_Press : int := Pic.FileNew ("Button_3_Press.bmp")
var Button_4_Press : int := Pic.FileNew ("Button_4_Press.bmp")
var Button_5_Press : int := Pic.FileNew ("Button_5_Press.bmp")
var Button_Minimize : int := Pic.FileNew ("Minimize_Draw.bmp")
var Button_Minimize_Hot : int := Pic.FileNew ("Minimize_Hot.bmp")
var Button_Maximize : int := Pic.FileNew ("Maximize_Draw.bmp")
var Button_Maximize_Hot : int := Pic.FileNew ("Maximize_Hot.bmp")
var Button_Track_Bar : int := Pic.FileNew ("Track_Bar.bmp")
var Info_Bar : int := Pic.FileNew ("Info_Bar.bmp")
var Score_Card : int := Pic.FileNew ("Score_Sheet_Panel.bmp")

% Initializing variales
Pic_Putter (0) := Pic.FileNew ("Putter.bmp")
Pic_Score_Hole := Pic.FileNew ("Score-Hole.bmp")
Putter_Width := Pic.Width (Pic_Putter (0))
Putter_Height := Pic.Height (Pic_Putter (0))
FontID (1) := Font.New ("Arial:10:bold")
FontID (2) := Font.New ("Comic Sans MS:50:Italic")
FontID (3) := Font.New ("Comic Sans MS:50:Bold")
FontID (4) := Font.New ("Times New Roman Bold:15")
FontID (5) := Font.New ("Times New Roman Bold:10")
FontID (6) := Font.New ("Times New Roman Bold:13")
FontID (7) := Font.New ("Times New Roman Bold:20")
FontID (9) := Font.New ("Times New Roman Bold:40")
FontID (8) := Font.New ("Times New Roman Bold:30")
FontID (10) := Font.New ("Times New Roman Bold:25")
FontID (11) := Font.New ("Times New Roman Bold:50")

% Setting the transparent colours for pictures
Pic.SetTransparentColor (Buttons, brightred)
Pic.SetTransparentColor (Button_1_Hot, brightred)
Pic.SetTransparentColor (Button_2_Hot, brightred)
Pic.SetTransparentColor (Button_3_Hot, brightred)
Pic.SetTransparentColor (Button_4_Hot, brightred)
Pic.SetTransparentColor (Button_5_Hot, brightred)
Pic.SetTransparentColor (Button_1_Press, brightred)
Pic.SetTransparentColor (Button_2_Press, brightred)
Pic.SetTransparentColor (Button_3_Press, brightred)
Pic.SetTransparentColor (Button_4_Press, brightred)
Pic.SetTransparentColor (Button_5_Press, brightred)
Pic.SetTransparentColor (Button_Minimize, black)
Pic.SetTransparentColor (Button_Minimize_Hot, black)
Pic.SetTransparentColor (Button_Maximize, black)
Pic.SetTransparentColor (Button_Maximize_Hot, black)
Pic.SetTransparentColor (Button_Track_Bar, brightred)
Pic.SetTransparentColor (Info_Bar, brightred)
Pic.SetTransparentColor (High_Scores_Box, black)
Pic.SetTransparentColor (Return_Button, brightred)
Pic.SetTransparentColor (Return_Button_Hot, brightred)
Pic.SetTransparentColor (Return_Button_Press, brightred)
Pic.SetTransparentColor (Score_Card, black)
Pic.SetTransparentColor (Pic_Score_Hole, black)

% This program initializes the values used in the program by creating the rotated images of the putter
%and acquiring the hole pictures and data file information.
proc Initializing
    %This creates the rotated verisons of the putter
    for decreasing a : 36 .. 1
	Pic_Putter (a) := Pic.Rotate (Pic_Putter (0), 10 * a, Putter_Width div 2, Putter_Height div 2)
	Pic.SetTransparentColor (Pic_Putter (a), white)
    end for

    %This reads the hole information from the text files and the images for the courses
    for a : 1 .. 18
	if File.Exists ("Hole-Info" + intstr (a) + ".txt") then
	    open : Filea, "Hole-Info" + intstr (a) + ".txt", get
	    get : Filea, Hole_1x (a)
	    get : Filea, Hole_1y (a)
	    get : Filea, Drop_1x (a)
	    get : Filea, Drop_1y (a)
	    get : Filea, Hole_Par (a)
	    close : Filea
	    Pic_Course (a) := Pic.FileNew ("hole" + intstr (a) + ".bmp")
	    Pic.SetTransparentColor (Pic_Course (a), brightblue)
	else
	    exit
	end if
    end for
end Initializing

%This gets the name of the player
procedure Name_Get (text : string)
    if Start_New = false then
	GUI.Enable (Info_GUI (5))
    end if
    Have_Name := true
end Name_Get

%This is the continue procedure for the continue button on the information get screen
procedure Continue_GUI_Info
    Player_Name := GUI.GetText (Info_GUI (1))
    Hole_Number := strint (GUI.GetText (Info_GUI (7)))
    for Dis : 2 .. 6
	GUI.Disable (Info_GUI (Dis))
    end for

    GUI.Dispose (Info_GUI (1))
    GUI.Dispose (Info_GUI (7))
    Course_Par := 0
    for a : 1 .. Hole_Number
	Course_Par += Hole_Par (a)
    end for
    Mon_Exit_Info := 1
    Start_New := false
end Continue_GUI_Info

%This si the scroll bar procedure
procedure ScrollBarMoved (value : int)
    if Mon_Exit_Info not= 1 then
	Hole_Number := value
    end if
    Hole_Num := intstr (Hole_Number)
    GUI.SetText (Info_GUI (7), "     " + Hole_Num)
end ScrollBarMoved
%This is if the player chooses to play 1 hole
procedure Hole_Chose_1
    Hole_Number := 1
    Mon_Exit_Info := 1
    Hole_Num := intstr (Hole_Number)
    GUI.SetText (Info_GUI (7), "     " + Hole_Num)
    Button_Go := 1
end Hole_Chose_1

%This is if the player chooses to play 18 holes
procedure Hole_Chose_18
    Hole_Number := 18
    Mon_Exit_Info := 1
    Hole_Num := intstr (Hole_Number)
    GUI.SetText (Info_GUI (7), "     " + Hole_Num)
    Button_Go := 1
end Hole_Chose_18

%This draws the opening information get procedure which gets the player's name and the amount
%of holes that he or she would like to play
procedure Opening_Information_Get
    Window.Set (WindowID, "nooffscreenonly")
    Playing := false
    Mon_Exit_Info := 0
    %Background Picture
    Pic.ScreenLoad ("Golf_Course.jpg", 0, 0, picCopy)

    %Back Panel
    Info_GUI (6) := GUI.CreateButton (maxx div 2 - 150, maxy div 2 - 125, 0, " ", GUI.Quit)
    newWidth := 300
    newHeight := 250
    GUI.SetSize (Info_GUI (6), newWidth, newHeight)
    GUI.Disable (Info_GUI (6))

    Draw.Text ("Please Input Your Full Name", 268, 345, FontID (4), black)
    Draw.Text ("Hole Number", 338, 255, FontID (4), black)
    Draw.Text ("(Hit Enter When Done)", 330, 295, FontID (5), black)

    %Get Name GUI
    Info_GUI (1) := GUI.CreateTextFieldFull (315, 310, 150, "", Name_Get, GUI.INDENT, 0, 0)
    Info_GUI (7) := GUI.CreateTextFieldFull (370, 173, 40, "", Name_Get, GUI.INDENT, 0, 0)
    Hole_Num := intstr (Hole_Number)
    GUI.SetText (Info_GUI (7), "     " + Hole_Num)

    %Slider GUI
    drawfillbox (263, 211, 521, 235, white)
    Info_GUI (2) := GUI.CreateHorizontalScrollBar (267, 215, 250, 1, 18, 1, ScrollBarMoved)

    %Hole GUI's
    Info_GUI (3) := GUI.CreateButton (263, 170, 70, "1 Hole", Hole_Chose_1)
    Info_GUI (4) := GUI.CreateButton (445, 170, 50, "18 Holes", Hole_Chose_18)

    %Continue GUI
    Info_GUI (5) := GUI.CreateButton (340, 100, 100, "Continue", Continue_GUI_Info)
    GUI.Disable (Info_GUI (5))

    if Start_New = true then
	for a : 1 .. 3
	    GUI.Disable (GUI_Menu (a))
	end for
	GUI.SetText (Info_GUI (1), Player_Name)
	GUI.Enable (Info_GUI (5))
    end if

    loop
	exit when GUI.ProcessEvent
	if Mon_Exit_Info = 1 and Have_Name = true then
	    exit
	end if
    end loop

    if Button_Go = 1 then
	Continue_GUI_Info
    end if
end Opening_Information_Get

%This process changes the pictures on top of the main menu GUI's (high scores, play game,
%and quit game)" to make the main menu more interactive
process Pictures_Menu
    loop
	exit when Monitor_Menu = 1
	mousewhere (x, y, b)
	if y <= 400 and y >= 100 then
	    %High Scores
	    if x >= 45 and x <= 246 then
		if Changed_Pic = false then
		    Pic.ScreenLoad ("Trophy_2.jpg", 51, 106, picCopy)
		    Changed_Pic := true
		end if
		%Play Game
	    elsif x >= 295 and x <= 496 then
		if Changed_Pic = false then
		    Pic.ScreenLoad ("Golf_2.jpg", 301, 106, picCopy)
		    Changed_Pic := true
		end if
		%Quit Game
	    elsif x >= 545 and x <= 746 then
		if Changed_Pic = false then
		    Pic.ScreenLoad ("Door_2.jpg", 551, 106, picCopy)
		    Changed_Pic := true
		end if
		%None
	    else
		if b not= 1 and Changed_Pic = true then
		    Pic.ScreenLoad ("Door.jpg", 551, 106, picCopy)
		    Pic.ScreenLoad ("Trophy.jpg", 51, 106, picCopy)
		    Pic.ScreenLoad ("Golf.jpg", 301, 106, picCopy)
		    Changed_Pic := false
		end if
	    end if
	    %None
	else
	    if b not= 1 and Changed_Pic = true then
		Pic.ScreenLoad ("Door.jpg", 551, 106, picCopy)
		Pic.ScreenLoad ("Trophy.jpg", 51, 106, picCopy)
		Pic.ScreenLoad ("Golf.jpg", 301, 106, picCopy)
		Changed_Pic := false
	    end if
	end if
    end loop
end Pictures_Menu

%This procedure draws the openign menu
procedure Draw_Opening_Menu
    Monitor_Menu := 0

    %Background Picture
    Pic.ScreenLoad ("Golf_Course_4.jpg", 0, 0, picCopy)

    %This enables and draws the GUI's
    for Draw_Menu : 1 .. 3
	GUI.Enable (GUI_Menu (Draw_Menu))
	newWidth := 201
	newHeight := 300
	GUI.SetSize (GUI_Menu (Draw_Menu), newWidth, newHeight)
    end for

    %Title
    Draw.Text ("Miniputt", 285, 475, FontID (9), black)
    Draw.Text ("By: Christian Gallai", 270, 445, FontID (4), black)
    Draw.Text ("High Scores", 62, 410, FontID (10), black)
    Draw.Text ("Play Game", 320, 410, FontID (10), black)
    Draw.Text ("Quit Game", 568, 410, FontID (10), black)

    %Flame Decals
    var pic1 : int := Pic.FileNew ("Flame_Decal_Left.bmp")
    Pic.SetTransparentColor (pic1, black)
    Pic.Draw (pic1, 32, 465, picMerge)
    var pic2 : int := Pic.FileNew ("Flame_Decal_Right.bmp")
    Pic.SetTransparentColor (pic2, black)
    Pic.Draw (pic2, 620, 463, picMerge)

    %Button Pictures
    Pic.ScreenLoad ("Door.jpg", 551, 106, picCopy)
    Pic.ScreenLoad ("Trophy.jpg", 51, 106, picCopy)
    Pic.ScreenLoad ("Golf.jpg", 301, 106, picCopy)
    fork Pictures_Menu
end Draw_Opening_Menu

%This is the quit game procedure which ends all the processes and loops in tha game and closes
%the window, but not before saying goodbye
procedure Quit_Game
    Monitor_Menu := 1
    if Hole_Done = false then
	for Dis : 1 .. 3
	    GUI.Disable (GUI_Menu (Dis))
	end for
    else
	for Dis : 4 .. 6
	    GUI.Disable (GUI_Menu (Dis))
	end for
    end if
    %Background Picture
    Pic.ScreenLoad ("Golf_Course_4.jpg", 0, 0, picCopy)

    %Title
    Draw.Text ("Goodbye", 285, 275, FontID (11), white)
    delay (1000)

    Window.Close (WindowID)
    Mon_Exit_Game := 1
end Quit_Game

%This is the button click sound effect
process Button_Click
    Music.PlayFile ("Click.wav")
end Button_Click

%This process forks the track to be played depending on which one was selected form the bottom
%panel music selection
process Play_Track
    if Track_Number = 1 then
	Music.PlayFile ("Toxicity.mp3")
    elsif Track_Number = 2 then
	Music.PlayFile ("Queen - Bohemian Rhapsody.MP3")
    elsif Track_Number = 3 then
	Music.PlayFile ("Our_Lady_Peace.mp3")
    elsif Track_Number = 4 then
	Music.PlayFile ("Mother_Earth.mp3")
    elsif Track_Number = 5 then
	Music.PlayFile ("No_Transitory_Alexisonfire.mp3")
    elsif Track_Number = 6 then
	Music.PlayFile ("Accidents - Alexisonfire.mp3")
    elsif Track_Number = 7 then
	Music.PlayFile ("Silver And Cold - AFI.mp3")
    elsif Track_Number = 8 then
	Music.PlayFile ("Vermillion_Slipknot.mp3")
    elsif Track_Number = 9 then
	Music.PlayFile ("Bang Bang - Rammstein.mp3")
    elsif Track_Number = 10 then
	Music.PlayFile ("Rock_The_Casbah_The_Clash.mp3")
    end if
end Play_Track

%This prcoedure draws the title of the music selected on the track bar of the bottom panel
procedure Music_Play
    if Track_Number = 1 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 1 : Toxicity - System Of A Down", 550, 21, FontID (5), black)
    elsif Track_Number = 2 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 2 : Bohemian Rhapsody - Queen", 550, 21, FontID (5), black)
    elsif Track_Number = 3 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 3 : Superman's Dead - Our Lady Peace", 537, 21, FontID (5), black)
    elsif Track_Number = 4 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 4 : I Mother Earth - Another Sunday", 541, 21, FontID (5), black)
    elsif Track_Number = 5 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 5 : No Transitory - Alexisonfire", 555, 21, FontID (5), black)
    elsif Track_Number = 6 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 6 : Accidents - Alexisonfire", 563, 21, FontID (5), black)
    elsif Track_Number = 7 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 7 : Silver And Cold - AFI", 570, 21, FontID (5), black)
    elsif Track_Number = 8 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 8 : Vermillion - Slipknot", 573, 21, FontID (5), black)
    elsif Track_Number = 9 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 9 : Bang Bang - Rammstein", 565, 21, FontID (5), black)
    elsif Track_Number = 10 then
	Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
	Draw.Text ("Track 10 : Rock The Casbah", 577, 21, FontID (5), black)
    end if
end Music_Play

%This process draws the interactive bottom panel on the scren, which can be accesed throughout the
%entire game
process Draw_Panel_Field
    %Background Picture
    if Playing = true then
	Pic.ScreenLoad ("Grass_Overlap.jpg", 0, 0, picCopy)
    elsif Main_Menu = true then
	Pic.ScreenLoad ("Golf_Course_Overlap.jpg", 0, 0, picCopy)
    end if
    drawfillbox (0, 0, maxx, 75, 30)
    Pic.Draw (Buttons, 300, 5, picMerge)
    Pic.Draw (Button_Minimize, 340, 72, picMerge)
    Pic.Draw (Button_Track_Bar, 520, 10, picMerge)
    Pic.Draw (Info_Bar, 30, 5, picMerge)
    Pic.Draw (Info_Bar, 160, 5, picMerge)
    Draw.Text ("Par", 65, 55, FontID (4), black)
    if Playing = true then
	Draw.Text (intstr (Hole_Par (Current_Hole)), 75, 20, FontID (4), black)
    end if
    Draw.Text ("Strokes", 180, 55, FontID (4), black)
    if Playing = true then
	if length (intstr (Hole_Score (Current_Hole))) = 1 then
	    Draw.Text (intstr (Hole_Score (Current_Hole)), 210, 20, FontID (4), black)
	else
	    Draw.Text (intstr (Hole_Score (Current_Hole)), 200, 20, FontID (4), black)
	end if
    end if
    Draw.Text ("Track", 620, 50, FontID (4), black)
    if Playing = true then
	Music_Play
    end if
end Draw_Panel_Field

%This process draws the interactive bottom panel on the scren, which can be accesed throughout the
%entire game
process Panel_Field
    loop
	mousewhere (x, y, b)
	if Ball_Rolling = false then
	    if Panel_Open = 1 then
		if y <= 55 and y >= 18 then
		    %Button 1 - Back
		    if x >= 305 and x <= 340 then
			Pic.Draw (Button_1_Hot, 300, 5, picMerge)

			%Button 2 - Play
		    elsif x >= 345 and x <= 390 then
			Pic.Draw (Button_2_Hot, 300, 5, picMerge)

			%Button 3 - Forward
		    elsif x >= 397 and x <= 432 then
			Pic.Draw (Button_3_Hot, 300, 5, picMerge)

			%Button 4 - Pause
		    elsif x >= 437 and x <= 472 then
			Pic.Draw (Button_4_Hot, 300, 5, picMerge)

			%Button 5 - Stop
		    elsif x >= 477 and x <= 512 then
			Pic.Draw (Button_5_Hot, 300, 5, picMerge)
		    else
			Pic.Draw (Buttons, 300, 5, picMerge)
		    end if

		    %Minimize Button
		elsif y <= 90 and y >= 72 then
		    if x >= 340 and x <= 470 then
			Pic.Draw (Button_Minimize_Hot, 340, 72, picMerge)
		    end if

		    %The Buttons Are Not Being Pressed
		else
		    Pic.Draw (Buttons, 300, 5, picMerge)
		    Pic.Draw (Button_Minimize, 340, 72, picMerge)
		end if

		%A Button is being pressed
		if b = 1 then
		    mousewhere (x, y, b)
		    if y <= 55 and y >= 18 then
			%Button 1 - Back
			if x >= 305 and x <= 340 then
			    Pic.Draw (Button_1_Press, 300, 5, picMerge)
			    delay (150)
			    if Track_Number >= 2 then
				Track_Number := Track_Number - 1
			    else
				Track_Number := 1
			    end if
			    Music_Play
			    fork Button_Click
			    delay (50)
			    fork Play_Track

			    %Button 2 - Play
			elsif x >= 345 and x <= 390 then
			    Pic.Draw (Button_2_Press, 300, 5, picMerge)
			    delay (150)
			    Music_Play
			    fork Button_Click
			    delay (50)
			    fork Play_Track

			    %Button 3 - Forward
			elsif x >= 397 and x <= 432 then
			    Pic.Draw (Button_3_Press, 300, 5, picMerge)
			    delay (150)
			    if Track_Number <= 9 then
				Track_Number := Track_Number + 1
			    else
				Track_Number := 10
			    end if
			    Music_Play
			    fork Button_Click
			    delay (50)
			    fork Play_Track

			    %Button 4 - Pause
			elsif x >= 437 and x <= 472 then
			    Pic.Draw (Button_4_Press, 300, 5, picMerge)
			    delay (150)
			    fork Button_Click
			    delay (50)
			    Music.PlayFileStop

			    %Button 5 - Stop
			elsif x >= 477 and x <= 512 then
			    Pic.Draw (Button_5_Press, 300, 5, picMerge)
			    delay (150)
			    fork Button_Click
			    delay (50)
			    Music.PlayFileStop
			end if

		    elsif y <= 90 and y >= 72 then
			if x >= 340 and x <= 470 then
			    fork Button_Click
			    delay (50)
			    if Playing = true then
				Pic.ScreenLoad ("Grass_Overlap.jpg", 0, 0, picCopy)
			    else
				Pic.ScreenLoad ("Golf_Course_Overlap.jpg", 0, 0, picCopy)
			    end if
			    Panel_Open := 0
			end if
		    end if
		end if
		View.UpdateArea (0, 0, maxx, 90)

		%Panel is minimized
	    elsif Panel_Open = 0 then
		Pic.Draw (Button_Maximize, 340, -3, picMerge)
		if y <= 17 and y >= -5 then
		    if x <= 470 and x >= 340 then
			Pic.Draw (Button_Maximize_Hot, 340, -3, picMerge)
			delay (100)
		    else
			Pic.Draw (Button_Maximize, 340, -3, picMerge)
		    end if
		end if
		if b = 1 then
		    if y <= 17 and y >= -5 then
			if x <= 470 and x >= 340 then
			    Panel_Open := 1
			    fork Draw_Panel_Field
			    fork Button_Click
			    delay (50)
			    Music_Play
			end if
		    end if
		end if
		View.UpdateArea (0, 0, maxx, 90)
	    end if
	end if
	exit when Game_Done = true
    end loop
    Game_Done := false
end Panel_Field

%This procedure starts a new game, and is caled upon from the end-game screen
proc New_Game
    Start_New := true
    for Dis : 4 .. 6
	GUI.Disable (GUI_Menu (Dis))
    end for
end New_Game

%This procedure returns the user to the main menu from the end game screen
procedure Return_Button_Draw
    loop
	mousewhere (x, y, b)
	%Retrn button has been clicked
	if b = 1 then
	    if y <= 43 and y >= 10 then
		if x >= 655 and x <= 685 then
		    delay (50)
		    Pic.Draw (Return_Button_Press, 650, 10, picMerge)
		    Return_High := 1
		    delay (100)
		    if Hole_Done = false then
			Draw_Opening_Menu
		    else
			New_Game
		    end if
		else
		    Pic.Draw (Return_Button, 650, 10, picMerge)
		end if
	    end if

	    %Mouse is not being clicked on the return button
	elsif b not= 1 then
	    if y <= 43 and y >= 10 then
		if x >= 655 and x <= 685 then
		    Pic.Draw (Return_Button_Hot, 650, 10, picMerge)
		    delay (150)
		else
		    Pic.Draw (Return_Button, 650, 10, picMerge)
		end if
	    else
		Pic.Draw (Return_Button, 650, 10, picMerge)
	    end if
	else
	    Pic.Draw (Return_Button, 650, 10, picMerge)
	end if
	exit when Return_High = 1
    end loop
    View.Update
end Return_Button_Draw

%This procedure draws the high scores
procedure Draw_High_Scores
    Return_High := 0

    %Background Picture
    Pic.ScreenLoad ("Golf_Course_4.jpg", 0, 0, picCopy)
    View.Update
    %Picture GUI's
    Pic.Draw (High_Scores_Box, 90, 48, picMerge)
    Pic.Draw (Return_Button, 650, 10, picMerge)

    %Title
    Draw.Text ("High Scores", 285, 475, FontID (8), black)

    %Flame Decals
    var pic1 : int := Pic.FileNew ("Flame_Decal_Left.bmp")
    Pic.SetTransparentColor (pic1, black)
    Pic.Draw (pic1, 132, 475, picMerge)
    var pic2 : int := Pic.FileNew ("Flame_Decal_Right.bmp")
    Pic.SetTransparentColor (pic2, black)
    Pic.Draw (pic2, 520, 473, picMerge)

    %This creates the GUI's for the screen
    High_Scores_GUI (1) := GUI.CreateFrame (105, 390, 220, 430, GUI.EXDENT)
    High_Scores_GUI (2) := GUI.CreateFrame (222, 390, 575, 430, GUI.EXDENT)
    High_Scores_GUI (3) := GUI.CreateFrame (577, 390, 675, 430, GUI.EXDENT)
    Create_GUI := 1
    for Create : 1 .. 8
	High_Scores_GUI (Create_GUI) := GUI.CreateFrame (105, 390 - (Create * 41), 222, 430 - (Create * 41), GUI.EXDENT)
	High_Scores_GUI (Create_GUI + 1) := GUI.CreateFrame (222, 390 - (Create * 41), 575, 430 - (Create * 41), GUI.INDENT)
	High_Scores_GUI (Create_GUI + 3) := GUI.CreateFrame (577, 390 - (Create * 41), 675, 430 - (Create * 41), GUI.INDENT)
	Create_GUI := Create + 5
    end for

    %This draws the titles on the high scores table
    Draw.Text ("Rank", 130, 402, FontID (7), black)
    Draw.Text ("Player", 355, 402, FontID (7), black)
    Draw.Text ("Score", 595, 402, FontID (7), black)
    Draw.Text ("1st", 140, 361, FontID (7), black)
    Draw.Text ("2nd", 140, 320, FontID (7), black)
    Draw.Text ("3rd", 140, 279, FontID (7), black)
    Draw.Text ("4th", 140, 238, FontID (7), black)
    Draw.Text ("5th", 140, 197, FontID (7), black)
    Draw.Text ("6th", 140, 156, FontID (7), black)
    Draw.Text ("7th", 140, 115, FontID (7), black)
    Draw.Text ("8th", 140, 74, FontID (7), black)

    %This gets the information
    open : File_High_Scores, "High_Scores.dat", get
    for Get : 1 .. 8
	get : File_High_Scores, Names (Get) : 20
	get : File_High_Scores, Scores (Get)
    end for
    close : File_High_Scores

    %This inputs the players score into the high scores if 18 holes were played
    if Hole_Number = 18 then
	if Course_Score < Scores (8) then
	    Scores (8) := Course_Score
	    Names (8) := Player_Name

	    %This sorts and re-saves the information
	    for Sort_1 : 1 .. 8
		Smallest := 999
		Location := 0
		for Sort_2 : 1 .. 8
		    if Scores (Sort_2) < Smallest then
			Location := Sort_2
			Smallest := Scores (Sort_2)
		    end if
		end for
		Sort_Names (Sort_1) := Names (Location)
		Sort_Scores (Sort_1) := Scores (Location)
		Scores (Location) := 999
	    end for
	    for Re : 1 .. 8
		Names (Re) := Sort_Names (Re)
		Scores (Re) := Sort_Scores (Re)
	    end for

	    %This re-saves the information into the adat file
	    open : File_High_Scores, "High_Scores.dat", put
	    for Save : 1 .. 8
		put : File_High_Scores, Names (Save) + repeat (" ", 20 - length (Names (Save))) ..
		put : File_High_Scores, Scores (Save)
	    end for
	    close : File_High_Scores
	end if
    end if

    %This displays the information
    Y_Location := 361
    for Display : 1 .. 8
	String_Score := intstr (Scores (Display))
	Draw.Text (Names (Display), 280, Y_Location, FontID (7), black)
	Draw.Text (String_Score, 610, Y_Location, FontID (7), black)
	Y_Location := Y_Location - 41
    end for
    View.Update
    Return_Button_Draw
end Draw_High_Scores

%this procedure is called u[on to draw the high scores from either the main menu or the end game
%screen of the game
procedure High_Scores
    Panel_Open := 0
    Monitor_Menu := 1
    Playing := false
    if Hole_Done = true then
	Window.Set (WindowID, "offscreenonly")
	for Dis : 4 .. 6
	    GUI.Disable (GUI_Menu (Dis))
	end for
    else
	for Dis : 1 .. 3
	    GUI.Disable (GUI_Menu (Dis))
	end for
    end if
    Draw_High_Scores
end High_Scores

%This is the clapping sound effect which is played at the end of each game
process Clapping
    Music.PlayFile ("CROWD_4.wav")
end Clapping

%This is the end game screen of the game which animates the score card of the game to the middle
%of the screen and draws the three option GUI's of return to menu, new game, or quit game
procedure End_Game_Screen
    Game_Done := true
    Pic_Score_Card := Pic.New (32, 435, 754, 522)
    Pic.Draw (Pic_Score_Clear, 0, 91, picCopy)
    Pic_Score_Clear := Pic.New (0, 91, maxx, maxy)

    %This gets the information
    open : File_High_Scores, "High_Scores.dat", get
    for Get : 1 .. 8
	get : File_High_Scores, Names (Get) : 20
	get : File_High_Scores, Scores (Get)
    end for
    close : File_High_Scores

    %This adds the player's score into the hgih scores if 18 holes were played
    if Hole_Number = 18 then
	if Course_Score < Scores (8) then
	    Scores (8) := Course_Score
	    Names (8) := Player_Name

	    %This sorts and re-saves the information
	    for Sort_1 : 1 .. 8
		Smallest := 999
		Location := 0

		for Sort_2 : 1 .. 8
		    if Scores (Sort_2) < Smallest then
			Location := Sort_2
			Smallest := Scores (Sort_2)
		    end if
		end for

		Sort_Names (Sort_1) := Names (Location)
		Sort_Scores (Sort_1) := Scores (Location)
		Scores (Location) := 999
	    end for

	    %This re-saves the information
	    for Re : 1 .. 8
		Names (Re) := Sort_Names (Re)
		Scores (Re) := Sort_Scores (Re)
	    end for

	    %This saves the new information into the data file
	    open : File_High_Scores, "High_Scores.dat", put
	    for Save : 1 .. 8
		put : File_High_Scores, Names (Save) + repeat (" ", 20 - length (Names (Save))) ..
		put : File_High_Scores, Scores (Save)
	    end for
	    close : File_High_Scores
	end if
    end if

    %This animates the score card down the screen
    for Down : 1 .. 200 by 5
	Pic.Draw (Pic_Score_Card, 32, 435 - Down, picCopy)
	View.Update
	delay (20)
	if Down < 196 then
	    Pic.Draw (Pic_Score_Clear, 0, 91, picCopy)
	end if
    end for

    %This draws the end game option GUI's
    Window.Set (WindowID, "nooffscreenonly")
    GUI_Menu (4) := GUI.CreateButton (maxx div 2 - 275, 150, 150, "High Scores", High_Scores)
    GUI_Menu (5) := GUI.CreateButton (maxx div 2 - 75, 150, 150, "New Game", New_Game)
    GUI_Menu (6) := GUI.CreateButton (maxx div 2 + 125, 150, 150, "QUIT", Quit_Game)
    Pic.Draw (Pic_Score_Hole, 194, 375, picMerge)
    Draw.Text ("Final Score Card", 250, 388, FontID (8), black)

    %This plays the clapping sound effect
    fork Clapping
end End_Game_Screen

% These are the sound effect processes which are played at the end of each hole. The sound effect
% The sound for a hole in one
process HIO_Sound
    Music.PlayFile ("HANDEL.wav")
end HIO_Sound

% The sound for an albatross
process Alb_Sound
    Music.PlayFile ("CROWD_3.wav")
end Alb_Sound

% The sound for a score of par
process Par_Sound
    Music.PlayFile ("CROWD_2.wav")
end Par_Sound

% The sound for an eagle
process Eag_Sound
    Music.PlayFile ("ORCH_3.wav")
end Eag_Sound

% The sound for a score above par
process Bog_Sound
    Music.PlayFile ("INSTR_2.wav")
end Bog_Sound

%This procedure draws the score shett on the screen
procedure Draw_Score_Sheet
    %This creates the GUI's in the panel
    Pic.ScreenLoad ("grass.jpg", 0, 100, picCopy)
    Pic.Draw (Score_Card, 32, 435, picMerge)
    Score_GUI (1) := GUI.CreateFrame (40, 490, 100, 515, GUI.EXDENT)
    Score_GUI (2) := GUI.CreateFrame (40, 489, 100, 465, GUI.EXDENT)
    Score_GUI (3) := GUI.CreateFrame (40, 464, 100, 442, GUI.EXDENT)
    Create_GUI := 0

    %This draws the frames across the scre sheet
    for GUI_Spread : 4 .. 21
	Score_GUI (GUI_Spread) := GUI.CreateFrame (101 + (Create_GUI * 33), 490, 133 + (Create_GUI * 33), 515, GUI.EXDENT)
	Score_GUI (18 + GUI_Spread) := GUI.CreateFrame (101 + (Create_GUI * 33), 489, 133 + (Create_GUI * 33), 465, GUI.INDENT)
	Score_GUI (37 + GUI_Spread) := GUI.CreateFrame (101 + (Create_GUI * 33), 464, 133 + (Create_GUI * 33), 442, GUI.INDENT)
	Create_GUI := Create_GUI + 1
    end for
    Score_GUI (56) := GUI.CreateFrame (101 + (Create_GUI * 33), 490, 151 + (Create_GUI * 33), 515, GUI.EXDENT)
    Score_GUI (57) := GUI.CreateFrame (101 + (Create_GUI * 33), 489, 151 + (Create_GUI * 33), 465, GUI.INDENT)
    Score_GUI (58) := GUI.CreateFrame (101 + (Create_GUI * 33), 464, 151 + (Create_GUI * 33), 442, GUI.INDENT)

    %These are the titles
    Draw.Text ("Hole", 50, 497, FontID (6), black)
    Draw.Text ("Par", 55, 472, FontID (6), black)
    Draw.Text ("Strokes", 43, 448, FontID (6), black)
    Draw.Text ("Total", 700, 497, FontID (6), black)

    %Par
    Draw.Text (intstr (Course_Par), 710, 472, FontID (6), black)
    %Strokes
    Draw.Text (intstr (Course_Score), 710, 448, FontID (6), black)

    %This puts the hole numbers on the screen
    for Dis : 0 .. 8
	String_Score_Sheet := intstr (Dis + 1)
	Draw.Text (String_Score_Sheet, 115 + (33 * Dis), 497, FontID (6), black)
    end for
    Create_GUI := 0
    for Dis : 9 .. 17
	String_Score_Sheet := intstr (Dis + 1)
	Draw.Text (String_Score_Sheet, 405 + (33 * Create_GUI), 497, FontID (6), black)
	Create_GUI := Create_GUI + 1
    end for

    %These are the dashes
    for Put_Dash : 0 .. 17
	if Put_Dash + 1 > Hole_Number then
	    Draw.Text ("-", 115 + (33 * Put_Dash), 472, FontID (6), black)
	    Draw.Text ("-", 115 + (33 * Put_Dash), 448, FontID (6), black)
	end if
    end for

    %This displays the pars for the holes
    for Dis_Par : 1 .. Hole_Number
	Draw.Text (intstr (Hole_Par (Dis_Par)), 115 + (33 * (Dis_Par - 1)), 472, FontID (6), black)
    end for

    %Equation for putting info in boxes
    for Hole_Played : 1 .. Current_Hole
	if Hole_Score (Hole_Played) = Hole_Par (Hole_Played) then
	    Draw.Text (intstr (Hole_Score (Hole_Played)), 115 + (33 * (Hole_Played - 1)), 448, FontID (6), black)
	elsif Hole_Score (Hole_Played) < Hole_Par (Hole_Played) then
	    Draw.Text (intstr (Hole_Score (Hole_Played)), 115 + (33 * (Hole_Played - 1)), 448, FontID (6), green)
	elsif Hole_Score (Hole_Played) > Hole_Par (Hole_Played) then
	    Draw.Text (intstr (Hole_Score (Hole_Played)), 115 + (33 * (Hole_Played - 1)), 448, FontID (6), red)
	end if
    end for

    % Drawing bubble for the Score for the hole
    Pic.Draw (Pic_Score_Hole, 194, 175, picMerge)
    % Selecting the proper term for the score

    %This draws the veridct bar, calls on the appropriate music, and displays the verdict of the
    %game in golf terms
    if Hole_Score (Current_Hole) = 1 then
	Score_Title := "Hole In One!"
	fork HIO_Sound
	Draw.Text (Score_Title, 270, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) = Hole_Par (Current_Hole) then
	Score_Title := "You Made Par"
	fork Par_Sound
	Draw.Text (Score_Title, 250, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) + 1 = Hole_Par (Current_Hole) then
	Score_Title := "You Made Birdie"
	Draw.Text (Score_Title, 250, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) + 2 = Hole_Par (Current_Hole) then
	Score_Title := "You Made Eagle"
	fork Eag_Sound
	Draw.Text (Score_Title, 250, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) + 3 = Hole_Par (Current_Hole) then
	Score_Title := "You Made Albatross"
	fork Alb_Sound
	Draw.Text (Score_Title, 210, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) - 1 = Hole_Par (Current_Hole) then
	Score_Title := "You Made Bogey"
	fork Bog_Sound
	Draw.Text (Score_Title, 250, 188, FontID (8), black)
    elsif Hole_Score (Current_Hole) - 1 > Hole_Par (Current_Hole) then
	Score_Title := "You Were " + intstr (Hole_Score (Current_Hole) - Hole_Par (Current_Hole)) + " Over Par"
	fork Bog_Sound
	Draw.Text (Score_Title, 199, 188, FontID (8), black)
    end if
    View.Update
    % SET TO 2500
    delay (2500)
    if Current_Hole = Hole_Number then
	End_Game_Screen
    end if
end Draw_Score_Sheet

% This procedure creates the entire putting game, including the dropping, hitting, and movement of the all.
proc Hit_Ball
    % Procedure specific variables
    var Ball_Speed, Pic_Ball, Ball_Radius, Mouse_x, Mouse_y, Mouse_b, Added_Angle, Count : int
    var Ball_Angle, Mouse_tan, Ball_Dx, Ball_Dy, Ball_x, Ball_y, Mouse_Dist, Min_Speed, Hole_Dist, Stopped, Ball_Rate, Temp : real := 0
    var Hole_Radius, Pic_Done, Drop_Colour, Speed_Cap, Max_Score, Wall_Colour : int

    % Initializing procedure specific variables
    Pic_Ball := Pic.FileNew ("Pic_Ball.bmp")
    Pic_Done := Pic.FileNew ("ball-in.bmp")
    Wall_Colour := black
    Speed_Cap := 3
    Min_Speed := 0.2
    Stopped := 70
    Ball_Angle := 0
    Ball_Radius := Pic.Width (Pic_Ball) div 2
    Drop_Colour := brightgreen
    Hole_Radius := 6
    Max_Score := 99
    Course_Score := 0
    Pic.SetTransparentColor (Pic_Ball, Wall_Colour)
    Pic.SetTransparentColor (Pic_Done, brightblue)
    Playing := true

    % For Flicker-Free Animation
    Window.Set (WindowID, "offscreenonly")

    % To repeat the game screen for each hole for the number of holes to be played
    for a : 1 .. Hole_Number
	% Initializing values and the screen's appearance for each hole
	Current_Hole := a
	Hole_Done := false
	Hole_Score (a) := 1
	Pic.ScreenLoad ("grass.jpg", 0, 0, picCopy)
	Pic_Score_Clear := Pic.New (0, 91, maxx, maxy)
	Pic.Draw (Pic_Course (a), maxx div 2 - (Pic.Width (Pic_Course (a)) div 2), maxy div 2 - (Pic.Height (Pic_Course (a)) div 2) + 50, picMerge)
	Hole_x (a) := maxx div 2 - (Pic.Width (Pic_Course (a)) div 2) + Hole_1x (a)
	Hole_y (a) := maxy div 2 + (Pic.Height (Pic_Course (a)) div 2) - Hole_1y (a) + 50
	Drop_y (a) := maxy div 2 + (Pic.Height (Pic_Course (a)) div 2) - Drop_1y (a) + 50
	Drop_x (a) := maxx div 2 - (Pic.Width (Pic_Course (a)) div 2) + Drop_1x (a)
	Ball_x := Drop_x (a)
	Ball_y := Drop_y (a)
	Ball_Clear := Pic.New (round (Ball_x) - 15, round (Ball_y) - Ball_Radius, round (Ball_x) + 20, round (Ball_y) + 30)
	Pic.Draw (Pic_Ball, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picMerge)
	Draw.Text ("Drop", round (Ball_x) - 15, round (Ball_y) + 10, FontID (1), white)
	if Panel_Open = 1 then
	    fork Draw_Panel_Field
	    Music_Play
	end if
	View.Update
	Pic.Draw (Ball_Clear, round (Ball_x) - 15, round (Ball_y) - Ball_Radius, picMerge)

	% Dropping the ball on the bright green section at the beginning of the hole
	loop
	    % Determing the mouse's position
	    mousewhere (Mouse_x, Mouse_y, Mouse_b)

	    % Checking the colour of the screen at the mouse's location and displaying the ball at the location
	    %if the colour is bright green
	    if whatdotcolour (Mouse_x, Mouse_y) = Drop_Colour and (Mouse_x not= Ball_x or Mouse_y not= Ball_y) then
		View.Update
		Ball_x := Mouse_x
		Ball_y := Mouse_y
		Ball_Clear := Pic.New (round (Ball_x) - 15, round (Ball_y) - Ball_Radius, round (Ball_x) + 20, round (Ball_y) + 30)
		Pic.Draw (Pic_Ball, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picMerge)
		Draw.Text ("Drop", Mouse_x - 15, Mouse_y + 10, FontID (1), white)
		View.Update
		Pic.Draw (Ball_Clear, round (Ball_x) - 15, round (Ball_y) - Ball_Radius, picCopy)
		Pic.Free (Ball_Clear)
	    end if

	    % Exiting when the mouse button is clicked and it is not on the music panel buttton
	    if Mouse_b = 1 then
		if (Panel_Open = 1 and Mouse_y > 90) or (Panel_Open = 0 and Mouse_y > 15) then
		    exit
		end if
	    end if
	end loop

	% Dropping the ball at the location indicated by the user with the mouse
	Ball_Clear := Pic.New (round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, round (Ball_x) + Ball_Radius, round (Ball_y) + Ball_Radius)
	Pic.Draw (Pic_Ball, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picMerge)
	View.Update
	delay (200)

	%           -= HITTING THE BALL AND ITS MOVEMENT =-
	% Repeated until the ball is in the cup
	loop
	    locate (1, 1)
	    Pic.Draw (Pic_Ball, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picMerge)
	    Count := 0
	    Ball_Dx := 0
	    Ball_Dy := 0
	    Ball_Speed := 0

	    % Determing the mouse's position
	    mousewhere (Mouse_x, Mouse_y, Mouse_b)

	    % Deteriming the angle to be added to the mouse's angle to the ball, due to discrepencies caused by the CAST rule,
	    %and determining the ball's angle
	    if Mouse_x = Ball_x then
		if Mouse_y > Ball_y then
		    Ball_Angle := 180
		elsif Mouse_y < Ball_y then
		    Ball_Angle := 0
		end if
		Vertical := true
	    else
		Mouse_tan := (Mouse_y - Ball_y) / (Mouse_x - Ball_x)
		Vertical := false
	    end if
	    if Mouse_x > Ball_x then
		if Mouse_y >= Ball_y then
		    Added_Angle := 90
		elsif Mouse_y < Ball_y then
		    Added_Angle := 90
		end if
	    elsif Mouse_x < Ball_x then
		if Mouse_y >= Ball_y then
		    Added_Angle := 270
		elsif Mouse_y < Ball_y then
		    Added_Angle := 270
		end if
	    end if
	    if Vertical = false then
		Ball_Angle := arctand (Mouse_tan) + Added_Angle
	    end if

	    % Verifying if the mouse is on the screen
	    if Mouse_x > 0 and Mouse_x < maxx - Putter_Width div 2 - 15 and ((Panel_Open = 1 and Mouse_y > 90) or (Panel_Open = 0 and Mouse_y > 15)) and Mouse_y < maxy then
		% Verifying if the mouse has moved
		if Old_x not= Mouse_x or Old_y not= Mouse_y then

		    % Drawing the putter
		    if Mouse_x - Putter_Width div 2 > 0 and Mouse_x + Putter_Width div 2 < maxx and Mouse_y - Putter_Height div 2 > 0 and Mouse_y + Putter_Height div 2 + 1 < maxy then
			Putter_Clear := Pic.New (Mouse_x - Putter_Width div 2, Mouse_y - Putter_Height div 2, Mouse_x + Putter_Width div 2 + 1, Mouse_y + Putter_Height div 2 + 1)
			Pic.Draw (Pic_Putter (Ball_Angle div 10), Mouse_x - Putter_Width div 2, Mouse_y - Putter_Height div 2, picMerge)
		    end if

		    % Drawing the yellow line illustrating the ball's prospective course
		    if (round (Ball_x) - (Mouse_x - round (Ball_x)) div 2 > 1 and round (Ball_x) - (Mouse_x - round (Ball_x)) div 2 < maxx - 1 and round (Ball_x) + (Mouse_x - round (Ball_x)) div
			    2 > 1 and round (Ball_x) + (Mouse_x - round (Ball_x)) div 2 < maxx - 1) or (round (Ball_y) - (Mouse_y - round (Ball_y)) div 2 > 15 and round (Ball_y) - (Mouse_y -
			    round (Ball_y)) div 2 < maxy - 1 and round (Ball_y) + (Mouse_y - round (Ball_y)) div 2 > 15 and round (Ball_y) + (Mouse_y - round (Ball_y)) div 2 < maxy - 1) then
			Line_Clear := 0
			Line_Clear := Pic.New (round (Ball_x) - (Mouse_x - round (Ball_x)) div 2, round (Ball_y) - (Mouse_y - round (Ball_y)) div 2, round (Ball_x) + (Mouse_x - round (Ball_x))
			    div 2, round (Ball_y) + (Mouse_y - round (Ball_y)) div 2)
			if Line_Clear not= 0 then
			    drawline (round (Ball_x), round (Ball_y), round (Ball_x) - (-1 * ((round (Ball_x) - Mouse_x) div 2)), round (Ball_y) - (-1 * ((round (Ball_y) - Mouse_y) div 2)),
				yellow)
			    View.Update
			    if round (Ball_x) < Mouse_x then
				if round (Ball_y) < Mouse_y then
				    Pic.Draw (Line_Clear, round (Ball_x) - (Mouse_x - round (Ball_x)) div 2, round (Ball_y) - (Mouse_y - round (Ball_y)) div 2, picCopy)
				elsif round (Ball_y) > Mouse_y then
				    Pic.Draw (Line_Clear, round (Ball_x) - (Mouse_x - round (Ball_x)) div 2, round (Ball_y) + (Mouse_y - round (Ball_y)) div 2, picCopy)
				else
				    Pic.Draw (Line_Clear, round (Ball_x) - (Mouse_x - round (Ball_x)) div 2, round (Ball_y), picCopy)
				end if
			    elsif round (Ball_x) > Mouse_x then
				if round (Ball_y) < Mouse_y then
				    Pic.Draw (Line_Clear, round (Ball_x) + (Mouse_x - round (Ball_x)) div 2, round (Ball_y) - (Mouse_y - round (Ball_y)) div 2, picCopy)
				elsif round (Ball_y) > Mouse_y then
				    Pic.Draw (Line_Clear, round (Ball_x) + (Mouse_x - round (Ball_x)) div 2, round (Ball_y) + (Mouse_y - round (Ball_y)) div 2, picCopy)
				else
				    Pic.Draw (Line_Clear, round (Ball_x) + (Mouse_x - round (Ball_x)) div 2, round (Ball_y), picCopy)
				end if
			    else
				if round (Ball_y) > Mouse_y then
				    Pic.Draw (Line_Clear, round (Ball_x), round (Ball_y) + (Mouse_y - round (Ball_y)) div 2, picCopy)
				else
				    Pic.Draw (Line_Clear, round (Ball_x), round (Ball_y) - (Mouse_y - round (Ball_y)) div 2, picCopy)
				end if
			    end if
			    Pic.Free (Line_Clear)
			end if
			Old_x := Mouse_x
			Old_y := Mouse_y
		    end if

		    % Clearing the putter in order to animate it
		    if Mouse_x - Putter_Width div 2 > 0 and Mouse_x + Putter_Width div 2 < maxx and Mouse_y - Putter_Height div 2 > 0 and Mouse_y + Putter_Height div 2 + 1 < maxy then
			Pic.Draw (Putter_Clear, Mouse_x - Putter_Width div 2, Mouse_y - Putter_Height div 2, picMerge)
			Pic.Free (Putter_Clear)
		    end if
		end if

		%       -= Movement of the Ball =-
		% Checking if the user has clicked the mouse to hit the ball
		if Mouse_b = 1 then
		    Ball_Rolling := true
		    Pic.Draw (Ball_Clear, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picCopy)

		    % Determining speed of the ball and the horizontal and vertical speeds to travel in the correct angle
		    if Mouse_x = Ball_x and Mouse_y = Ball_y then
			Mouse_x += 1
		    end if
		    Mouse_Dist := sqrt ((Mouse_x - Ball_x) ** 2 + (Mouse_y - Ball_y) ** 2)
		    Ball_Dx -= sind (Ball_Angle)
		    Ball_Dy += cosd (Ball_Angle)
		    if Mouse_Dist >= 100 then
			Ball_Dx -= sind (Ball_Angle) * ((Mouse_Dist / 100) ** 2)
			Ball_Dy += cosd (Ball_Angle) * ((Mouse_Dist / 100) ** 2)
		    else
			Ball_Dx -= sind (Ball_Angle) * (Mouse_Dist / 100)
			Ball_Dy += cosd (Ball_Angle) * (Mouse_Dist / 100)
		    end if

		    % Preventing the ball from exceeding the speed cap and adjusting the speeds accordingly
		    if Ball_Dx > Speed_Cap then
			Ball_Dy := (Speed_Cap / Ball_Dx) * Ball_Dy
			Ball_Dx := Speed_Cap
		    elsif Ball_Dx < -Speed_Cap then
			Ball_Dy := (-Speed_Cap / Ball_Dx) * Ball_Dy
			Ball_Dx := -Speed_Cap
		    end if
		    if Ball_Dy > 3 then
			Ball_Dx := (Speed_Cap / Ball_Dy) * Ball_Dx
			Ball_Dy := Speed_Cap
		    elsif Ball_Dy < -Speed_Cap then
			Ball_Dx := (-Speed_Cap / Ball_Dy) * Ball_Dx
			Ball_Dy := -Speed_Cap
		    end if
		    Ball_Speed := 0

		    % Animating the ball
		    loop
			Count += 1
			% Checking for a vertical or horizontal wall in the ball's path, causing a bounce
			if Ball_Dx > 0 then
			    if Ball_Dy > 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx + Ball_Radius + 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				elsif whatdotcolour (round (Ball_x + Ball_Dx), round (Ball_y + Ball_Dy + Ball_Radius + 1)) = Wall_Colour then
				    Ball_Dy := -Ball_Dy
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    elsif Ball_Dy < 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx + Ball_Radius + 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				elsif whatdotcolour (round (Ball_x + Ball_Dx), round (Ball_y + Ball_Dy - Ball_Radius - 1)) = Wall_Colour then
				    Ball_Dy := -Ball_Dy
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    else
				if whatdotcolour (round (Ball_x + Ball_Dx + Ball_Radius + 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    end if
			end if
			if Ball_Dx < 0 then
			    if Ball_Dy > 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx - Ball_Radius - 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				elsif whatdotcolour (round (Ball_x + Ball_Dx), round (Ball_y + Ball_Dy + Ball_Radius + 1)) = Wall_Colour then
				    Ball_Dy := -Ball_Dy
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    elsif Ball_Dy < 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx - Ball_Radius - 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				elsif whatdotcolour (round (Ball_x + Ball_Dx), round (Ball_y + Ball_Dy - Ball_Radius - 1)) = Wall_Colour then
				    Ball_Dy := -Ball_Dy
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    end if
			    if Ball_Dx = 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx - Ball_Radius - 1), round (Ball_y + Ball_Dy)) = Wall_Colour then
				    Ball_Dx := -Ball_Dx
				else
				    Ball_x += Ball_Dx
				    Ball_y += Ball_Dy
				end if
			    end if
			end if

			% Checking for a diagonal wall in the ball's path
			if Ball_Dx > 0 then
			    if Ball_Dy > 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
			    elsif Ball_Dy < 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
			    else
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) - 5) = gray then
				    Ball_Dy := Ball_Dx
				    Ball_Dx := 0
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) + 4) = gray then
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := 0
				end if
			    end if
			elsif Ball_Dx < 0 then
			    if Ball_Dy > 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
			    elsif Ball_Dy < 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) + 4) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) - 5) = gray then
				    Temp := Ball_Dy
				    Ball_Dy := Ball_Dx
				    Ball_Dx := Temp
				end if
			    else
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) + 4) = gray then
				    Ball_Dy := Ball_Dx
				    Ball_Dx := 0
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) - 5) = gray then
				    Ball_Dy := -Ball_Dx
				    Ball_Dx := 0
				end if
			    end if
			else
			    if Ball_Dy > 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) + 4) = gray then
				    Ball_Dy := 0
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) + 4) = gray then
				    Ball_Dy := 0
				    Ball_Dx := Temp
				end if
			    elsif Ball_Dy < 0 then
				if whatdotcolour (round (Ball_x + Ball_Dx) - 4, round (Ball_y + Ball_Dy) - 5) = gray then
				    Ball_Dy := 0
				    Ball_Dx := -Temp
				end if
				if whatdotcolour (round (Ball_x + Ball_Dx) + 5, round (Ball_y + Ball_Dy) - 5) = gray then
				    Ball_Dy := 0
				    Ball_Dx := Temp
				end if
			    end if
			end if

			% Adjusting the ball's location
			Ball_x += Ball_Dx
			Ball_y += Ball_Dy

			% Ball Animation
			Ball_Clear := Pic.New (round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, round (Ball_x) + Ball_Radius, round (Ball_y) + Ball_Radius)
			Pic.Draw (Pic_Ball, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picMerge)
			View.Update
			Ball_Speed := (10 - Mouse_Dist div 100) + (((Count) ** 2) div 50) div ((Mouse_Dist / 100) ** 2)
			delay (Ball_Speed)
			Pic.Draw (Ball_Clear, round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, picCopy)
			Pic.Free (Ball_Clear)

			% Checking if the ball is in the cup
			Hole_Dist := sqrt ((Hole_x (a) - Ball_x) ** 2 + (Hole_y (a) - Ball_y) ** 2)
			Ball_Rate := sqrt (Ball_Dx ** 2 + Ball_Dy ** 2) / Ball_Speed
			if Hole_Dist <= Hole_Radius + 0.25 then
			    if Ball_Rate < Min_Speed then
				Pic.Draw (Pic_Done, Hole_x (a) - 6, Hole_y (a) - 7, picMerge)
				View.Update
				delay (1000)
				Hole_Done := true
				exit
			    end if
			end if

			% Ending movement when the ball's speed is below the minimum for movement and it has not entered the cup
			exit when Ball_Speed > Stopped
		    end loop
		    Ball_Clear := Pic.New (round (Ball_x) - Ball_Radius, round (Ball_y) - Ball_Radius, round (Ball_x) + Ball_Radius, round (Ball_y) + Ball_Radius)
		end if
	    end if
	    if Hole_Score (a) > Max_Score then
		Hole_Done := true
	    end if
	    exit when Hole_Done = true

	    % Adjusting the number of strokes for the hole if it has not ended yet
	    if Ball_Rolling = true then
		Hole_Score (a) += 1
		if Panel_Open = 1 then
		    fork Draw_Panel_Field
		    Music_Play
		end if
	    end if
	    Ball_Rolling := false
	end loop
	Ball_Rolling := false

	% Adjusting the total score for the course and calling the procedure to draw the score card
	Course_Score := Course_Score + Hole_Score (a)
	Draw_Score_Sheet
    end for
end Hit_Ball

%This procedure is called upon for the main menu GUI for "Play Game" it disables the main menu
%GUI's and plays the game
procedure Play_Game
    Monitor_Menu := 1
    for Dis : 1 .. 3
	GUI.Disable (GUI_Menu (Dis))
    end for
    Hit_Ball
end Play_Game

%This draws the opening menu of the program
procedure Opening_Menu_GUI
    Monitor_Menu := 0
    Hole_Done := false
    %Background Picture
    Pic.ScreenLoad ("Golf_Course_4.jpg", 0, 0, picCopy)

    %Title
    Draw.Text ("Miniputt", 285, 475, FontID (9), black)
    Draw.Text ("By: Christian Gallai", 300, 445, FontID (4), black)
    Draw.Text ("High Scores", 62, 410, FontID (10), black)
    Draw.Text ("Play Game", 320, 410, FontID (10), black)
    Draw.Text ("Quit Game", 568, 410, FontID (10), black)

    %Flame decals
    var pic1 : int := Pic.FileNew ("Flame_Decal_Left.bmp")
    Pic.SetTransparentColor (pic1, black)
    Pic.Draw (pic1, 32, 465, picMerge)
    var pic2 : int := Pic.FileNew ("Flame_Decal_Right.bmp")
    Pic.SetTransparentColor (pic2, black)
    Pic.Draw (pic2, 620, 463, picMerge)

    %High Scores GUI
    GUI_Menu (1) := GUI.CreateButton (45, 100, 0, " ", High_Scores)
    newWidth := 201
    newHeight := 300
    GUI.SetSize (GUI_Menu (1), newWidth, newHeight)

    %Plau Game GUI
    GUI_Menu (2) := GUI.CreateButton (295, 100, 0, " ", Play_Game)
    newWidth := 201
    newHeight := 300
    GUI.SetSize (GUI_Menu (2), newWidth, newHeight)

    %Quit Game GUI
    GUI_Menu (3) := GUI.CreateButton (545, 100, 0, " ", Quit_Game)
    newWidth := 201
    newHeight := 300
    GUI.SetSize (GUI_Menu (3), newWidth, newHeight)

    %Button Pictures
    Pic.ScreenLoad ("Door.jpg", 551, 106, picCopy)
    Pic.ScreenLoad ("Trophy.jpg", 51, 106, picCopy)
    Pic.ScreenLoad ("Golf.jpg", 301, 106, picCopy)
    fork Pictures_Menu
end Opening_Menu_GUI

% This creates the opening screen animation for the game.
proc Opening_Animation
    % This draws the background picture and sets the screen so that output is not sent to the screen directly,
    %resulting in flickerless animation.
    Pic.ScreenLoad ("grass-hole.jpg", 0, 0, picCopy)
    Window.Set (WindowID, "offscreenonly")
    Line_Clear := Pic.New (0, 0, maxx, maxy)

    % This animates the word "Mini" across the screen to the hole
    for horiz : 1 .. maxx div 2
	Draw.Text ("Mini", -60 + horiz, 400, FontID (2), white)
	exit when horiz = maxx div 2
	View.Update
	Pic.Draw (Line_Clear, 0, 0, picCopy)
    end for
    Pic.Free (Line_Clear)
    Line_Clear := Pic.New (0, 0, maxx, maxy)

    % This animates the woed "Putt" up the screen to the hole
    for vert : 1 .. maxy div 2 + 90
	Draw.Text ("Putt", maxx div 2 - 50, -30 + vert, FontID (3), white)
	View.Update
	exit when vert = maxy div 2 + 90
	Pic.Draw (Line_Clear, 0, 0, picCopy)
    end for
    Pic.Free (Line_Clear)
    Line_Clear := Pic.New (0, 0, maxx, maxy)

    %This animates the names of the programmers across the screen to where the meet at the center
    for horiz : 1 .. 320
	Draw.Text ("By: Christian Gallai", -60 + horiz, 50, FontID (8), white)
	View.Update
	exit when horiz = 300
	Pic.Draw (Line_Clear, 0, 0, picCopy)
    end for
    delay (3000)
    Window.Set (WindowID, "nooffscreenonly")
end Opening_Animation

%               -= Main Program =-
%This draws the opning animation
Opening_Animation
%This initializes the putter and the courses
Initializing
%This gets the opening information
Opening_Information_Get
%This draws the main menu
Opening_Menu_GUI
%This draws the bottom panel
fork Panel_Field

%This is the main menu GUI process loop for the GUI's in the main menu
loop
    exit when GUI.ProcessEvent

    %The game is exited from the quit option
    if Mon_Exit_Game = 1 then
	exit
    end if

    %The Game is started over
    if Start_New = true then
	Opening_Information_Get
	Opening_Menu_GUI
	fork Panel_Field
    end if
end loop
