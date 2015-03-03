var game1 = function () {
  //-------- Move, rotate and switch token(s)----------------
  game1.onMouseClickedOnce = null;
  game1.onMouseDraged = null;
  game1.clickNr = 0;
  game1.onMouseUp = function (aToken,position) {
    game1.board.moveTo(game1.board.movingToken, game1.board.movingToken.getPosition());
    // game1.movingToken = null;
  }
  game1.onMouseDoubleClicked = function (aToken,position) {
    aToken.rotate(90)
  }
  game1.onMouseClickedTwice = function (token1,token2,clickpos) {
    game1.board.switchToken(token1,token2);
  }
  game1.onMouseDraged = function (aToken,position) {
    // game1.board.moveTo(aToken,position);
    aToken.move(position);

  }
  game1.board = new Board({row: 5, col: 5},60,null,"checkboard");//"plain");
  game1.token = createToken(game1,"data/ChateauWRK.png", {x: 5,y: 5});
  game1.layout = new Layout(game1.board, game1.token, "shuffle");
}
var game2 = function () {
  //--------------- Picture with hole to rearange by switching hole with neighbour-------
  game2.onMouseUp = null;
  game2.onMouseDoubleClicked = null;
  game2.onMouseClickedTwice = null;
  game2.onMouseDraged = null;
  game2.clickNr = 0;
  game2.onMouseClickedOnce = function (aToken,position) {
    if (game2.board.tokenDistance(game2.board.holeToken, aToken) == 1) {
       game2.board.switchToken(game2.board.holeToken,aToken);
    }
  }
  game2.board = new Board({row: 5, col: 5},80,null,"checkboard");//"plain");
  game2.token = createToken(game2,"data/ChateauWRK.png", {x: 5,y: 5});
  game2.layout = new Layout(game2.board, game2.token, "shuffle");
  game2.board.setHoleToken(game2.board.tokens[2][2]);
}
var game3 = function () {
  //--------------- Picture to rearange by switching tokens ---------------------
  game3.onMouseClickedTwice = function (token1, token2, position) {
    console.log(4);
    // console.dir(var owner.board.firstToken.Ix);
    game3.board.switchToken(token1,token2);// console.log(aToken.getPosition());
  }
  game3.board = new Board({row: 5, col: 5},80,null,"checkboard");//"plain");
  game3.token = createToken(game3,"data/ChateauWRK.png", {x: 5,y: 5});
  game3.layout = new Layout(game3.board, game3.token, "shuffle");
}
var game4 = function () {
  //-------- Move, rotate and switch token(s)----------------
  game4.onMouseClickedOnce = null;
  game4.onMouseDraged = null;
  game4.clickNr = 0;
  game4.onMouseDraged = function (aToken,position) {
    aToken.move(position);
  }
  game4.board = new Board({row: 5, col: 5},60,null,"checkboard");//"plain");
  game4.token = createToken(game4,"data/ChateauWRK.png", {x: 5,y: 5});
  game4.layout = new Layout(game4.board, game4.token, "shuffle");
}

/*

  var game2 = function () {
    //var board = new Board();//{row: 6, col: 6});//"plain");
    var schema = [[1,1,1,1,1,1,1,1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,0,-1,-1,-1,-1]]
    // var board = new Board({row: 8, col: 8},80,null,"checkboard");//"plain");
    var board = new Board({row: 5, col: 5},80,null,"checkboard");//"plain");
    // var token = createToken("data/BlackAndWhite2.png", {x: 2,y: 1});
    var token = createToken(this,"data/ChateauWRK.png", {x: 5,y: 5});
    // var layout = new Layout(board, token, "schemed",schema);
    var layout = new Layout(board, token, "shuffle");
    //"scattered");//"shuffle");//"sequence");random
    //    (cellNr, cellSize, frame, background, position
    //var backgroundImg = new Sprite("data/background.jpg",5);
    //var background = new SceneObject(backgroundImg);
    //wade.addSceneObject(background);

    var onMouseUp = function (aToken,position) {
    console.log("Master mouseUp");
    var movingToken = null;
    console.log(var movingToken);
    }
    var onMouseClicked = function (aToken,position) {
    if (var movingToken == null) {var movingToken = aToken};
    console.log("Master clicked");
    console.log(var movingToken);
    // console.log(aToken.getPosition());
    // console.log(position);
    }
    var onMouseDoubleClicked = function (aToken,position) {
    console.log("Master double Clicked");
    console.log(var movingToken);
    aToken.rotate(90)
    // console.log(aToken.getPosition());
    // console.log(position);
    }
    var onMouseDraged = function (aToken,position) {
    console.log("Master dragged");
    console.log(var movingToken);
    // console.log(aToken.getPosition());
    // console.log(position);
    var movingToken.move(position);
    // aToken.move(position)
  }

  }
*/
//# sourceURL=gameExamples2.js
