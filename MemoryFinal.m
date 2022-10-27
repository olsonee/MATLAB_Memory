% This code plays the card game Memory with Graphics 
% Written by Eagan Olson 10-13-2022

warning off
rng 'shuffle'
load CardDeck.mat
[y, Fs] = audioread('Applause.wav');
Applause = audioplayer(y,Fs);
[z, Ff] = audioread("BuzzerIncorrect.wav");
Incorrect = audioplayer(z,Ff);
figure('WindowStyle','docked');
pairs = randperm(13,8);
MemoryCards = [pairs pairs];%Ensures there are 8 pairs
cboard = zeros(4); %Creates 4x4 matrix
index = randperm(16);
counter = 1;
for i = index
    cboard(counter) = MemoryCards(index(counter)); %Randomizes the pairs in the matrix
    counter = counter + 1;
end
dboard = zeros(4);   % Set up Digital Board
for r = 1:4     %Deals Cards
    for c = 1:4
        MemoryBoard{r,c} = RedDeck {55};
    end
end
UpdateMemory
score = 0;

while score < 8     %Card Actions
    fprintf('\n Please click on a card.')   %Card 1
    [x,y] = ginput(1);
    Arow = floor(y/96)+1;
    Acol = floor(x/72)+1;
    check = 0;      %Input Check
    while check == 0
        if Arow > 4 || Arow < 1 || Acol > 4 || Acol < 1
            fprintf('Invalid Choice: Click on another card \n');
            [x,y] = ginput(1);
            Arow = floor(y/96)+1;
            Acol = floor(x/72)+1;
        elseif dboard(Arow,Acol) ~= 0
            fprintf('Card already selected: Click on another card \n');
            [x,y] = ginput(1);
            Arow = floor(y/96)+1;
            Acol = floor(x/72)+1;
        else
            check = 1;
        end
    end
    dboard(Arow,Acol) = 1; %Put a 1 in digital board 
    n = cboard(Arow,Acol); %Assign selected card a value
    MemoryBoard{Arow,Acol} = RedDeck{n};
    UpdateMemory
    fprintf('\n Please click on a card.')  %Card 2
    [x,y] = ginput(1);
    Brow = floor(y/96)+1;
    Bcol = floor(x/72)+1;
    check = 0;     %Check Input
    while check == 0
        if Brow > 4 || Brow < 1 || Bcol > 4 || Bcol <1
            fprintf('Invalid Choice: Click on another card \n');
            [x,y] = ginput(1);
            Brow = floor(y/96)+1;
            Bcol = floor(x/72)+1;
        elseif dboard(Brow,Bcol) ~= 0
            fprintf('Card already selected: Click on another card \n');
            [x,y] = ginput(1);
            Brow = floor(y/96)+1;
            Bcol = floor(x/72)+1;
        else
            check = 1;
        end
    end
    dboard(Brow,Bcol) = 1; %Put a 1 in digital board signifying taken space
    m = cboard(Brow,Bcol); %Assign selected card a value
    MemoryBoard{Brow,Bcol} = RedDeck{m};
    UpdateMemory
    if n == m    %If cards match remove them from the board
        play(Applause)
        MemoryBoard{Arow,Acol} = Blank; 
        MemoryBoard{Brow,Bcol} = Blank;
        score = score + 1;
        msg1 = msgbox('Great Guess!');
        pause(0.70)
        close(msg1)
    else  %If cards don't match flip them back over
        play(Incorrect)
        MemoryBoard{Arow,Acol} = RedDeck{55};
        MemoryBoard{Brow,Bcol} = RedDeck{55};
        dboard(Arow,Acol) = 0;   %If the cards don't match remove the 1s from the dboard
        dboard(Brow,Bcol) = 0;
        error = errordlg('Wrong Card, try again!');
        pause(0.70)
        close(error)
    end
    UpdateMemory
end
wmsg = msgbox('Congratulations you have won!');
pause(1.0)
close(wmsg)
 dlgTitle    = 'User Question';
 dlgQuestion = 'Do you wish to play again?';
 choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');
 if choice == 'Yes'
     MemoryTest
 end