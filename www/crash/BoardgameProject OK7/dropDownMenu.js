DropDownMenu = function (menuItems, defaultMenuIx, mybehavior, font, color, posX, posY, alignment, name) {
	this.DDmenuItems = menuItems
	this.DDcrtMenuIx = defaultMenuIx
	// create text menu
	this.DDallMenuText =""
	for (var t in this.DDmenuItems) {
		this.DDallMenuText += (this.DDmenuItems[t] + '\n') 
	};
	this.DDallMenuText = this.DDallMenuText.slice(0,this.DDallMenuText.length-1)
	this.DDnumLines = this.DDmenuItems.length
	this.DDmybehavior = mybehavior
	this.DDmyPosx = posX
	this.DDmyPosy = posY
	this.DDtestTextSprite = new TextSprite(this.DDmenuItems[this.DDcrtMenuIx], font, 'red', alignment)
	SceneObject.call(this, this.DDtestTextSprite, this.DDmybehavior, this.DDmyPosx, this.DDmyPosy, name)
	wade.addSceneObject(this)
//	this.sceneObject = new SceneObject(this.testTextSprite, this.mybehavior);//, this.myPosx, this.myPosy,"titi")
//	this.sceneObject.dropDownMenu = this
//	wade.addSceneObject(this.DDsceneObject)
	this.DDfullMenu = false				// Remember a single entry is displayed
	this.DDsituation
}
DropDownMenu.prototype = Object.create(SceneObject.prototype)

//dropDownMenuBehavior
dropDownMenuBehavior = function () {
	this.onAddToScene = function() {
console.log("added")
		wade.addEventListener(this.owner, 'onMouseDown');
	}

	this.onMouseDown = function (ez) {
console.log("onMouseDown");
		if (!this.owner.DDfullMenu) {				// a single entry is displayed
			this.owner.DDtestTextSprite.setText(this.owner.DDallMenuText)
			if (!this.owner.DDsituation) {				// Compute full menu charactéristics
				this.owner.DDsituation = this.owner.DDtestTextSprite.getScreenPositionAndExtents()
				this.owner.DDmenuHigh = 2*this.owner.DDsituation.extents.y
				this.owner.DDmenuTopPosition = this.owner.DDsituation.position.y - this.owner.DDsituation.extents.y
				this.owner.DDlineHigh = this.owner.DDmenuHigh/this.owner.DDnumLines
			}
			this.owner.DDfullMenu = true				// Remember all entries are displayed
		} else {
			this.owner.DDcrtMenuIx = Math.floor((ez.screenPosition.y - this.owner.DDmenuTopPosition)/this.owner.DDlineHigh)
			this.owner.DDtestTextSprite.setText(this.owner.DDmenuItems[this.owner.DDcrtMenuIx])
			this.owner.DDfullMenu = false				// Remember a single entry is displayed
		}
		wade.app.dropDownSelected(this.owner,this.owner.DDcrtMenuIx)
	}
}
//# sourceURL=dropDownMenuBehavior.js
//# sourceURL=dropDownMenu.js