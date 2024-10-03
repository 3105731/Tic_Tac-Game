import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(child: Column(children: [
         SwitchListTile.adaptive(
           title: const Text('Turn on/off two player',
             style: TextStyle(
                 color: Colors.white,
                 fontSize: 30,
             ) ,
             textAlign: TextAlign.center,
           ),
             value: isSwitched, 
             onChanged: (newVal){
             setState(() {
               isSwitched = newVal;
             });
             }),

        Text('It\'s $activePlayer turn '.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 52,
          ) ,
          textAlign: TextAlign.center,
        ),

     Expanded(child:
     GridView.count(
       padding: const EdgeInsets.all(16),
         crossAxisCount: 3,
       mainAxisSpacing:8.0 ,
       crossAxisSpacing:8.0 ,
       childAspectRatio: 1.0,
       children: List.generate(9, (index)=>
           InkWell(
             borderRadius: BorderRadius.circular(16),
           onTap: gameOver? null :   ()=> _onTap(index) ,
             child: Container(
               decoration: BoxDecoration(
                 color: Theme.of(context).shadowColor,
                 borderRadius: BorderRadius.circular(16)
               ),
               child:  Center(
                 child: Text(
                   Player.playerX.contains(index)?
                   'x':
                   Player.playerO.contains(index)?
                       'o':
                   ''
                   ,
                   style: TextStyle(
                     color:
                     Player.playerX.contains(index)?
                     Colors.blue: Colors.pink
                     ,
                     fontSize: 52,
                   ) ,
                   textAlign: TextAlign.center,
                 ),
               ) ,

             ),
           ),
       ),
     ),),




        Text(result,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 42,
          ) ,
          textAlign: TextAlign.center,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.replay),
          onPressed: (){
            setState(() {
              Player.playerX =[];
              Player.playerO =[];
               activePlayer = 'X';
               gameOver = false;
               turn = 0;
               result = '';
            });
          },
          label: const Text(
            "Repeat The Game",
            style: TextStyle(  color: Colors.white,
              fontSize: 24,
            ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).splashColor),
            ),
          ),

      ],),),
    );
  }

  _onTap(int index)async {

    if(Player.playerX.isEmpty || !Player.playerX.contains(index)  &&
        Player.playerO.isEmpty || !Player.playerO.contains(index)
    ){
      game.PlayGame(index, activePlayer);
      updateState();

      if(! isSwitched && !gameOver && turn!=9){
       await game.autoPlayer(activePlayer);
       updateState();
      }
}}

  void updateState() {
    setState(() {
      activePlayer = (activePlayer=='x')? 'o':'x';
       turn ++;

      String winnerPlayer = game.checkWinner();

      if(winnerPlayer != ''){
        gameOver = true;
        result = '$winnerPlayer is the Winner !';
      }
      else if(!gameOver && turn == 9) {
        result = 'It\'s Draw !';
      }
    });
  }
  }

