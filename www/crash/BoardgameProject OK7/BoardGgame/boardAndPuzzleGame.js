// PROBLEMS
// =Game1 doesn't work well after playing game2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!
//	it seems second click not recognized as such
//	on BoardgameProject2, it is mouseMove whhich is not detected!!!!!!!!!!!
// TODO
// =refuse dragging in same cell (in fact, will be resolved when dragging
//	into a cell will allign to the cell)
//
var Board = function(cellNr, cellSize, frame, background, position) {
	var scObj = wade.getSceneObjects();
	console.dir(scObj)
	wade.removeSceneObjects(wade.getSceneObjects("_name", "toScratchForNextGame" ));
	if (cellNr) {this.cellNr =  cellNr}
	else {this.cellNr = {row: 4, col: 4}};
	if (cellSize) {this.cellSize = cellSize}
	else {this.cellSize = 80};
	this.size = {x: this.cellNr.col*this.cellSize,y: this.cellNr.row*this.cellSize}
	this.frame = {width: 20, color: '#CC9900'}
	if (frame) {
		if (typeof frame == "number") {
			this.frame.width = frame;
		} else {
			this.frame = frame;
		}
	}
	this.background = null;
	switch (background) {
		case "plain": {this.background = {type: "plain", color: '#666666'}; break};
		case "checkboard": {this.background = {type: "checkboard", color: {a: '#666666', b: '#999999'}}; break};
		default: {this.background = background;}
	}
	if (position) {this.position = position}
	else {this.position = {x: 0, y: 0}};
	this.tokens =[[]];
	if (this.frame) {
		var frameSprite = new Sprite(null,3);
		frameSprite.setSize(this.size.x + 3*this.frame.width,
												this.size.y + 3*this.frame.width);
		frameSprite.setDrawFunction(wade.drawFunctions.drawRect_(this.frame.color, this.frame.width));
		this.frameSO = new SceneObject(frameSprite,null,0,0,"boardFrame");
		this.frameSO.setPosition(this.position.x,this.position.y)
		wade.addSceneObject(this.frameSO);
	}
	if (this.background) {
		var bkgScObjNr = 0;
		if (this.background.type =="plain") {
			var backSprite = new Sprite(null,3);
			backSprite.setSize(this.size.x,this.size.y);
			backSprite.setDrawFunction(wade.drawFunctions.solidFill_(this.background.color));
			this.backObject = new SceneObject(backSprite,null,0,0,"toScratchForNextGame" );
			this.backObject.setPosition(this.position.x,this.position.y)
			wade.addSceneObject(this.backObject);
		} else {
			var cellSOs = [];
			var color = this.background.color.a
			for (i=0;i<2;i++) {
				var cell = new Sprite(null,3);
				cell.setSize(this.cellSize,this.cellSize);
				cell.setDrawFunction(wade.drawFunctions.solidFill_(color));
				cellSO = new SceneObject(cell,null,0,0,"toScratchForNextGame" );
				cellSOs[i] = cellSO
				color = this.background.color.b
			}
			var kcol = 0;
			var krow = kcol
			for (i=0;i<this.cellNr.col;i++) {
				kcol = -kcol + 1
				var krow = kcol
				for (j=0;j<this.cellNr.row;j++) {
					zz = cellSOs[krow].clone();
					zz.setName("toScratchForNextGame" );
					zz.setPosition(this.cellSize*(i - (this.cellNr.col-1)/2) + this.position.x, this.cellSize*(j - (this.cellNr.row-1)/2) + this.position.y);  // WHY -1 ?????????????
					wade.addSceneObject(zz);
					krow = -krow + 1
				}
			}
		}
	}
	this.toString = function (x) {
		switch (typeof x) {
			case "number": {return x;break};
			case "string": {return x;break};
			case "undefined": {return "undefined";break};
			case "boolean": {return x; break}
			default: {
				if (x == null) {
					return x;
				} else {
					var res = "";
					res += "{";
					var myKeys = Object.keys(x);
					zz = myKeys[0];
					for (k = 0; k < myKeys.length; k++) {
						res += (myKeys[k] + ": " + x[myKeys[k]] + ",");
					};
					res += "}";
					return res;
				}
			}
		}
	}

	this.distance = function (a,b) {
		return Math.sqrt(Math.pow(a.i-b.i,2) + Math.pow(a.j-b.j,2));
	}
	this.tokenDistance = function (token1, token2) {
		return this.distance(token1.Ix,token2.Ix)
	}
	this.switchToken = function (token1,token2) {
		var temp = token1.Ix;
		token1.Ix = token2.Ix;
		token2.Ix = temp;
		token1.setPosition(this.rowColToPos(token1.Ix.i,token1.Ix.j));
		token2.setPosition(this.rowColToPos(token2.Ix.i,token2.Ix.j));
	}
	this.setHoleToken = function (aToken) {
		if (this.holeToken == null) {
			this.holeToken = aToken;
			this.holeToken.setVisible(false);
		}
	}
	this.rowColToPos = function(row,col) {
		var xx=  {x: ((col -	(this.cellNr.col - 1) / 2) *	this.cellSize +	this.position.x),
			y: ((row -	(this.cellNr.row - 1) / 2) *	this.cellSize +	this.position.y),
		};
		//console.log("pos={"+xx.x+","+xx.y+"}");
		return xx;
	};

	this.posToRowCol = function (position) {
		var row = Math.floor((position.x -this.position.x)/this.cellSize + (this.cellNr.row-1)/2+0.5);
		if ((row >= 0) && (row < this.cellNr.row)) {
			var col = Math.floor((position.y -this.position.y)/this.cellSize + (this.cellNr.col-1)/2+0.5);
			if ((col >= 0) && (col < this.cellNr.col)) {
				// this.showIx({row: row, col: col});
				return {row: row, col: col};
			}
			else {
				console.log("Board position = null");
				return null;
			}
		}
	}
	this.moveTo = function (aToken, position) {
		var pos = this.posToRowCol(position);
		// this.showPos(pos);
		if (pos) {
			aToken.move(this.rowColToPos(pos.col,pos.row));	// Inversion col row, Pourqoi???
		}
		else {
			aToken.move(position);
		}
	}

}

this.createToken = function (master, images, frames) {
	Token = function(name) {
		this.images = images;
		this.frames = frames;
		var sprite = new Sprite(null,2);
		var animation = new Animation(this.images, this.frames.x, this.frames.y, 1, true);
		sprite.addAnimation(animation);
		SceneObject.call(this, sprite, defaultBehavior,0,0,name);
		animation.stop();
		this.ix = null;
		this.boardIx = null;
		this.master = master;
		this.kind = "Token"	// To delete ????????????????????????????

		this.getFrameNumber = function() {
			return (this.getSprite(0).getCurrentAnimation().getFrameNumber())
		}

		this.setFrameNumber = function(n) {
			(this.getSprite(0).getCurrentAnimation().setFrameNumber(n))
		}

		this.rotate = function (angleDegree) {
			this.setRotation(this.getRotation()+Math.PI*2*angleDegree/360)
		}

		this.move = function (position) {
			this.setPosition(position.x,position.y);
			//console.log("("+position.x+","+position.y+")");
		}


	};

	Token.prototype = Object.create(SceneObject.prototype);
	return Token;
};

this.Layout = function (board, Token, layout, arg) {
	this.board = board;
	this.Token = Token;
	this.rowNr = this.board.cellNr.row
	this.colNr = this.board.cellNr.col
	this.itemNr = this.rowNr*this.colNr;
	if (arg) {this.arg = arg} else {this.arg =1.4};
	var aToken = new Token();
	this.imageNr = aToken.frames.x*aToken.frames.y;

	this.modulo = function(a, b) {
		return (+a % (b = +b) + b) % b;
	};

	this.setFrameNr = function(aToken,aFrameNr) {
		aToken.getSprite(0).getCurrentAnimation().setFrameNumber(aFrameNr)
		aToken.getSprite(0).setDirtyArea();		//?????????????????????????????????
		// if (aFrameNr == 0) {board.emptyToken = aToken}
	}

	this.sequenceZeroToN = function(n) {
		var res = [];
		for (i = 0; i < n; i++) {
			res.push(i);
		}
		return res;
	};

	this.shuffleSequenceZeroToN = function (n) {
		var oneToN = this.sequenceZeroToN(n);
		var result =[];
		for (var i = 0; i < n; i++) {
			result.push((oneToN.splice(Math.floor(Math.random()*oneToN.length),1))[0]);
		}
		return result;
	};

	this.randomSequenceFromZeroToN = function(n) {
		var oneToN = this.sequenceZeroToN(n);
		var res = [];
		for (i = 0; i < n;i++) {
			res.push(oneToN[Math.floor(Math.random()*n)]);
		}
		return res;
	};

	this.setSize = function(aToken) {
		aToken.getSprite(0).setSize(this.board.cellSize,this.board.cellSize);
	}
	this.createToken = function () {
		aToken = new Token("toScratchForNextGame" );//+tokenNr++);
		aToken.board = this.board;
		this.setSize(aToken);
		aToken.Ix = {i: i, j: j};
		aToken.boardIx = {i: i, j: j};
		aToken.setPosition(this.board.rowColToPos(i,j));
	}

	// this.setHole = function (aToken) {
	// 	if (this.holeToken == null) {
	// 		this.holeToken = aToken;
	// 		this.holeToken.setVisible(false);
	// 	}
	// }
	var tokenNr = 0;
	switch (layout) {
		case "sequence" : {
			// var crtFrameNr = 0;
			for (i = 0; i < this.rowNr; i++) {
				this.board.tokens[i] = [];
				for (j = 0; j < this.colNr; j++) {
					this.createToken()
					// aToken = new Token();
					// this.setSize(aToken);
					// aToken.board = this.board;
					// aToken.Ix = {i: i, j: j};
					// aToken.boardIx = {i: i, j: j};
					// aToken.setPosition(this.board.rowColToPos(i,j));

					this.setFrameNr(aToken,this.modulo(i*this.rowNr + j, this.imageNr))
					// this.setFrameNr(this.tokens[i][j], (i*this.colNr+j));
					wade.addSceneObject(aToken);
					this.board.tokens[i][j] = aToken;
				}
			}
			break;
		}
		case "shuffle" : {
			var shuffledSequence = this.shuffleSequenceZeroToN(this.imageNr);
			for (i = 0; i < this.rowNr; i++) {
				this.board.tokens[i] = [];
				for (j = 0; j < this.colNr; j++) {
					if ((k=i*this.colNr+j) < this.imageNr){
						this.createToken();						// aToken = new Token();
						// aToken.board = this.board;
						// this.setSize(aToken);
						// aToken.Ix = {i: i, j: j};
						// aToken.boardIx = {i: i, j: j};
						// aToken.setPosition(this.board.rowColToPos(i,j));
						this.setFrameNr(aToken, shuffledSequence[k]);
						wade.addSceneObject(aToken);
						this.board.tokens[i][j] = aToken;
					} else { break}
				}
			}
			break;
		}
		case "random" : {
			var randomSequence = this.randomSequenceFromZeroToN(this.itemNr);
			for (i = 0; i < this.rowNr; i++) {
				this.board.tokens[i] = [];
				for (j = 0; j < this.colNr; j++) {
					this.createToken();
					// aToken = new Token();
					// this.setSize(aToken);
					// aToken.board = this.board;
					// aToken.Ix = {i: i, j: j};
					// aToken.boardIx = {i: i, j: j};
					// aToken.setPosition(this.rowColToPos(i,j));
					this.setFrameNr(aToken, this.modulo(randomSequence[i*this.colNr+j],this.imageNr));
					wade.addSceneObject(aToken);
					this.board.tokens[i][j] = aToken;
				}
			}
			break;
		}
		case "scattered": {
			for (i = 0; i< this.imageNr; i++) {
				aToken = new Token("toScratchForNextGame" );//+tokenNr++);
				this.setSize(aToken);
				aToken.board = this.board;
				aToken.setPosition((Math.random()-1/2)*this.colNr*this.arg*this.board.cellSize,
													 (Math.random()-1/2)*this.rowNr*this.arg*this.board.cellSize);
				this.setFrameNr(aToken, i);
				wade.addSceneObject(aToken);
			}
		}
		case "schemed": {
			for (i = 0; i < this.rowNr; i++) {
				this.board.tokens[i] = [];
				for (j = 0; j < this.colNr; j++) {
					this.createToken();
					// aToken = new Token();
					// this.setSize(aToken);
					// aToken.board = this.board;
					// aToken.Ix = {i: i, j: j};
					// aToken.boardIx = {i: i, j: j};
					// aToken.setPosition(this.board.rowColToPos(i,j));
						if (arg[i][j] != -1) {
						this.setFrameNr(aToken,this.arg[i][j]);
						wade.addSceneObject(aToken);
						this.board.tokens[i][j] = aToken;
					}
				}
			}
			break;

		}
		default : {
			if (typeof layout == "number") {
				for (i = 0; i < this.rowNr; i++) {
					for (j = 0; j < this.colNr; j++) {	// token Instance creation ????????
						aToken.board = this.board;
						this.setFrameNr(this.tokens[i][j], layout);
					}
				}
				// var zz = 0;
			} else {
				for (i = 0; i < this.rowNr; i++) {
					for (j = 0; j < this.colNr; j++) {	// token Instance creation ????????
						aToken.board = this.board;
						this.setFrameNr(this.tokens[i][j], layout[i][j]);
					}
				}
			}
		}
	}
	var scObj = wade.getSceneObjects();
	// console.dir(scObj)
	// console.dir(wade.getSceneObject( "toScratchForNextGame"));
	// console.dir(wade.getSceneObjects("_name", "toScratchForNextGame" ));
};

var defaultBehavior = function() {
	this.onAddToScene = function() {
		wade.addEventListener(this.owner, 'onMouseDown');
		wade.addEventListener(this.owner, 'onMouseUp');
		wade.addEventListener(this.owner, 'onMouseMove');
	};
	this.mouseUpTime = 0;
	// this.owner.master.clickNr = 0;
	//console.log("aaa");
	this.onMouseUp = function(evnt) {
		this.mouseUpTime = wade.getAppTime();
		//console.log("Mouse onMouseUp");
		if (this.owner.master.onMouseUp) {
			this.owner.master.onMouseUp(this.owner,evnt.screenPosition)
		}
		this.owner.board.movingToken = null;
	};

	this.onMouseDown = function(evnt) {
		//console.log("this.owner.master.clickNr="+this.owner.master.clickNr);
		if (this.owner.master.clickNr == null) {this.owner.master.clickNr = 0};
		this.owner.master.clickNr++;
		//console.log("this.owner.master.clickNr="+this.owner.master.clickNr);
		if (wade.getAppTime() - this.mouseUpTime < 0.5) {
			// //console.log("dDouble click");
			if (this.owner.master.onMouseDoubleClicked) {
				this.owner.master.clickNr = 0;
				//console.log(1);
				this.owner.master.onMouseDoubleClicked(this.owner,evnt.screenPosition);
			}
		} else {
			// //console.log("Single click");
			if (this.owner.master.clickNr == 1) {
				console.log(2);
				this.owner.board.firstToken = this.owner;
				// this.owner.master.board.toString (this.owner.board.firstToken.Ix);
				// console.dir(this.owner.board.firstToken.Ix);
				this.owner.board.movingToken = this.owner;
				if (this.owner.master.onMouseClickedOnce) {
					this.owner.master.clickNr = 0;
					this.owner.master.onMouseClickedOnce(this.owner,evnt.screenPosition);
				}
			}
			if ((this.owner.master.clickNr == 2) && (this.owner.master.onMouseClickedTwice)) {
				this.owner.master.clickNr = 0;
				console.log(3);
				// console.dir(this.owner.board.firstToken.Ix);
				// this.owner.master.board.toString (this.owner.board.firstToken.Ix);
				this.owner.master.onMouseClickedTwice(this.owner.board.firstToken,
																							this.owner,evnt.screenPosition);
			}
		}
	};
	this.onMouseMove = function(evnt) {
		if (wade.isMouseDown() && this.owner.master.onMouseDraged) {
			// //console.log("Mouse dragged");
			this.owner.master.clickNr = 0;
			//console.log(4);
			if (this.owner.board.movingToken == null) {
				this.owner.board.movingToken = this.owner
			};
			this.owner.master.onMouseDraged(this.owner.board.movingToken,evnt.screenPosition)
		}
	};
}
//# sourceURL=boardAndPuzzleGame.js
