# jeu-de-carte-en-Ocaml
jeu de carte en ocaml


# purpose 
The goal is to code utility functions to play a variant of Solitaire. This
game (also called Klondike in English) is a game using 52 cards arranged in a particular way. Four
areas, initially empty are reserved for hearts, spades, clubs and diamonds. Next to them, the discard pile
(initially empty) and the draw pile consist of two piles of cards. The cards in the draw pile are face down.
Finally, 7 stacks of cards are arranged under the storage areas. Initially the heaps have respectively
0, 1, 2, . . . , 6 hidden cards and 1 visible card. Figure 1 shows an initial configuration of our game.
In this figure, e dotted squares represent empty locations (without a map). Moreover, in order to
simplify the display functions, the stacks of cards are displayed horizontally and preceded by their
number (rather than vertically). The object of the game is to arrange all the cards, in order on each
of the four spaces reserved for each color (a color here is heart, spade, club or diamond,
not black or red). The rules are very simple.
A card is said to be directly accessible if it is either on the discard pile or the leftmost of one.
batteries. In Figure 1, the directly accessible cards are: the 9 of Clubs (on the discard pile), the King of
Spades, Jack of Clubs, 3 of Diamonds, 3 of Spades, King of Clubs, 8 of Diamonds and 9 of Diamonds.
Card Movements:
- you can move an Ace to the empty storage area of its color

<center> ![image](https://user-images.githubusercontent.com/72779962/169643971-abf9b0d3-4806-4863-b530-2383521af362.png) </center>


- if a card is directly accessible and it is immediately higher than the card at the top
of the storage area of its color, then it can be stored there (i.e. if the last card placed on the
hearts zone is 10 and the Jack of hearts is accessible, it can be placed above the 10.
against if the last card placed on the hearts area is 8 and the Jack of hearts is accessible,
it cannot be put away because it does not immediately follow the 8).
- you can move the card to the top of the discard area to put it under a visible card
numbered stacks, if it is of directly lower value and of alternating color (i.e. one can
place a 7 of spades under an 8 of hearts or an 8 of diamonds)
- you can move a whole series of cards from one stack to another, the lowest card in front
be directly inferior and of alternating color to the destination card. In other words, we can
move a card that is not directly accessible from a pile if you also move all the cards below it.
- finally, if one of the 7 stacks is empty, you can only place a King on it


From figure 1, we can for example store the Ace of hearts which is directly accessible on
pile number 5, which gives the configuration of figure 1, in which the card is arranged and the 9 of
tile that was underneath is revealed.
Then, you can choose to move the 3 of diamonds (stack 2) under the 4 of spades (stack 4). We get the
figure 1. The Jack of clubs thus becomes visible. We can then move the 3 of diamonds and the 4 of spades
under the 5 of hearts (tail 3). The result of this operation is given in figure 1.
You can then move the 9 of diamonds (stack 5) under the 10 of spades (stack 7), as in figure 1.
At this point, we find ourselves blocked, so we will choose to draw (it is always possible to draw even
when we can play something else), which reveals 9 of clubs in the discard area.
We proceed in this way, drawing when we are blocked until we have managed to put away all the cards (or
to give up because we find ourselves completely blocked). If at any time the draw pile is empty, we turn over the
discard to make a new draw pile.
The program provided as an example can be launched simply with the command:
``` ./solitaire_ref.exe ``` 



Once the program is launched, the game begins. The possible commands are:
- P to draw a card;
- Ri to put away the card at i. The latter can be either the letter D to indicate that we
wants to put the card in the discard pile back on its final location, i.e. an integer between 1 and
7 to indicate that you want to put away the leftmost card of the pile indicated
- Dij to move as many cards as possible between i and j. Here i is either D or an integer from 1 to 7 and j is
an integer from 1 to 7.
- Q to quit.
Thus, to obtain figures a 1.f, one successively enters the commands:
- R5 (place the Ace in stack 5)
- D24 (move the 3 from pile 2 under the 4 from pile 4)
- D43 (move the 3 and 4 from pile 4 under the 5 from pile 3)
- D57 (move the 9 from pile 5 under the 10 from pile 7)
- P (we draw)



