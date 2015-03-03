//				EXAMPLES of Game definition
gameExamples = function(gameNr) {
//  1) Chateau 4*4, clickOnce
	var Game1 = function() {
		var backgroundImg = new Sprite("data/background.jpg",5);
		var background = new SceneObject(backgroundImg);
		wade.addSceneObject(background);

		var token = createToken("data/ChateauWRK.png", {x: 4,y: 4});
		this.board = new Board(this, token,100,{col:4,row:4},"clickOnce");
		Layout(this.board,"shuffle");//					OK
//		this.board.setEmpty(this.board.tokens[1][2])
	};
//-----------------------------------------
	this.turnPlayed1 = function(aToken) {				// Show empty token on winning
		this.board.nextFrame(aToken)
/*
*/
	};
//-----------------------------------------*/
//  2) 1to17, clickOnce
//*-------------------------------------------------------------------------
	this.Game2 = function() {
		var backgroundImg = new Sprite("data/background.jpg",5);
		var background = new SceneObject(backgroundImg);
		wade.addSceneObject(background);

//		var token = createToken("data/from1to17.png", {x: 17,y: 1});  // KO Why ???????
    var token = createToken("data/1to17.png", {x: 17,y: 1});
		this.board = new Board(this,token,120,{col:4,row:4},"clickOnce");
		Layout(this.board,"shuffle");//					OK
		this.board.setEmpty(this.board.tokens[1][2])
  };
//-----------------------------------------
	this.turnPlayed2 = function(aToken) {				// Show empty token on winning
		var w = this.board.tokenDistance(this.board.emptyToken,aToken)
		console.log(w)
		if (this.board.tokenDistance(this.board.emptyToken,aToken) == 1) {
			this.board.switchToken(this.board.emptyToken,aToken)
		}
/*
*/
	};
//-----------------------------------------*/
//  3) Chateau 3*3, clickOnce
//*--------------------------------------------------------------------------
	this.Game3 = function() {
		var backgroundImg = new Sprite("data/background.jpg",5);
		var background = new SceneObject(backgroundImg);
		wade.addSceneObject(background);

		var token = createToken("data/ChateauWRK.png", {x: 3,y: 3});
		this.board = new Board(this,token,150,{col:3,row:3},"clickOnce",1);
		Layout(this.board,"shuffle");//					OK

		boardFrame(this.board,10)

		this.board.setEmpty(this.board.tokens[1][2])
	};
//-----------------------------------------
	this.turnPlayed3 = function(aToken) {
		var w = this.board.tokenDistance(this.board.emptyToken,aToken)
		console.log(w)
		if (this.board.tokenDistance(this.board.emptyToken,aToken) == 1) {
			this.board.switchToken(this.board.emptyToken,aToken)
		}
	};
//-----------------------------------------*/
//  4) Chateau 4*4, clickFromTo
	this.Game4 = function() {
		var backgroundImg = new Sprite("data/background.jpg",5);
		var background = new SceneObject(backgroundImg);
		wade.addSceneObject(background);

		var token = createToken("data/ChateauWRK.png", {x: 4,y: 4});
		this.board = new Board(this,token,150,{col:4,row:4},"clickFromTo",1);
		Layout(this.board,"shuffle");//					OK

		boardFrame(this.board,10)

	};
//-----------------------------------------
	this.turnPlayed4 = function(aToken) {
		this.board.switchFromTo()
/*
*/
	};
//  5) checkbord 4*4, clickFromTo
	this.Game5 = function() {
		var backgroundImg = new Sprite("data/background.jpg",5);
		var background = new SceneObject(backgroundImg);
		wade.addSceneObject(background);

		var token = createToken("data/blackAndWhite.png", {x: 2,y:1});
		this.board = new Board(this,token,150,{col:4,row:4},"clickFromTo",1);
		Layout(this.board,"random");//					OK

		boardFrame(this.board,10)

	};
//-----------------------------------------
	this.turnPlayed5 = function(aToken) {
		this.board.switchFromTo()
/*
*/
	};
//-----------------------------------------*/
//Layout models
/*--------------------------------------------------------------------------
/*
		// Layout(this.board,"random");//					 OK
		// Layout(this.board,"sequence");
		// Layout(this.board,4);//									OK
		// Layout(this.board,[[1,0,2,0,3,0],
		//									 [0,4,0,5,0,6],
		//									 [7,0,8,0,9,0]]);//		 OK
*/

  this.clearGame =function() {
    if (this.board && this.board.frame) {wade.removeSceneObject(this.board.frame)}
    if (this.board) {
      for (aRow in this.board.tokens) {
        for (aTokenIx in this.board.tokens[aRow]) {
          wade.removeSceneObject(this.board.tokens[aRow][aTokenIx]);
        }
      }
    }
  }

//  wade.clearCanvas(5);    //???????????????????????????????????????
//  wade.removeLayer(4);
	switch (gameNr) {
		case 1: {this.clearGame();Game1(); break}
		case 2: {this.clearGame();this.Game2(); break}
		case 3: {this.clearGame();this.Game3(); break}
		case 4: {this.clearGame();this.Game4(); break}
		case 5: {this.clearGame();this.Game5(); break}
	}

this.turnPlayed = function(aToken) {
	switch (gameNr) {
		case 1: {this.turnPlayed1(aToken); break}
		case 2: {this.turnPlayed2(aToken); break}
		case 3: {this.turnPlayed3(aToken); break}
		case 4: {this.turnPlayed4(aToken); break}
		case 5: {this.turnPlayed5(aToken); break}
	}
}

}
//# sourceURL=gameExamples.js
