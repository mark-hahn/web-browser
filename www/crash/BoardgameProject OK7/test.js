App = function () {
  this.load = function() {
    wade.loadScript("BoardGgame/boardAndPuzzleGame.js");
    wade.loadScript("dropDownMenu.js");
    wade.loadScript("gameExamples2.js");

    wade.loadImage("data/background.jpg");
    // wade.loadImage("data/cursor.png");

    // wade.loadImage("data/1to17.png");
    wade.loadImage("data/ChateauWRK.png");

  };

  this.init = function() {
    var backgroundImg = new Sprite("data/background.jpg",5);
    var background = new SceneObject(backgroundImg);
    wade.addSceneObject(background);

    this.menuItems = ['Choose game','Game 1','Game 2','Game 3','Game 4']
    this.crtMenuIx = 0
    // this.myMenu = new DropDownMenu(this.menuItems, this.crtMenuIx, dropDownMenuBehavior, '48px Verdana Bold', 'red', -600, -450, 'center', "Menu gauche")
    this.myMenu = new DropDownMenu(this.menuItems, this.crtMenuIx, dropDownMenuBehavior, '36px Verdana Bold', 'red', -500, -250, 'center', "Menu gauche")
  }
  this.previousGame = null;
  this.dropDownSelected  = function(sceneObj,ix) {
    wade.removeLayer(2);
    if (ix != 0) {
      switch (ix) {
    //     case 1: {if (this.previousGame) {
    //       for (row in previousGame.board.tokens) {
    //         for (col in previousGame.board.tokens[row]) {
    //           previousGame.board.tokens[row][col].
    //         }
    //       }
    /*

    clearScene()
    removeLayer(layerId)
    removeSceneObjects(sceneObjects)
    wade.removeLayer(layerId)
    */

        case 1: {wade.removeLayer(3); game1(); break}
        case 2: {wade.removeLayer(3);game2(); break}
        case 3: {wade.removeLayer(3);game3(); break}
        case 4: {wade.removeLayer(3);game4(); break}
        case 5: {wade.removeLayer(3);game5(); break}
        case 6: {wade.removeLayer(3);game6(); break}
      };
    }
  //
  //   console.log(sceneObj);
  //   console.log("ix="+ix);
  //   if (sceneObj === this.myMenu) {
  //   console.log(sceneObj.getName());
  // } else {
  // console.log(sceneObj.getName());
  //}
  }
}
//# sourceURL=test.js
