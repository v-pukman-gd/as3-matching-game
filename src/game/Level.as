package game 
{

	import core.SpriteManager;
	import core.Vec;
	import flash.utils.Dictionary;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import utils.imageToCenter;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Level extends SpriteManager
	{
		public var name:String;
		public var number:uint;
		public var time:uint;
		public var opened:Boolean;
		public var cover:Button;
		public var label:TextField;
		public var heroPos:Vec;
		
		private var trophyIcon:Image;
		private var lockIcon:Image;
		private var keys:Array;
		private var unlocked:Boolean;
		public function Level(params:Object) 
		{
			super();
			this.number = params.number;
			this.name = params.name;
			this.keys = params.keys;
			this.unlocked = false;
			this.heroPos = (params.heroPos == null) ? new Vec(0,0) : params.heroPos;
			this.time = (params.time == null) ? 0 : params.time;
			this.opened = (params.opened == null) ? false : params.opened;
			
		}
		override public function init():void 
		{
			cover = new Button(Game.getTexture("shared", "level_cover"));
			cover.scaleWhenDown = 1;
			cover.pivotX = 60;
			cover.pivotY = 50;
			cover.x = 60;
			cover.y = 50;
			
			label = new TextField(120, 100, number.toString(), Game.DEFAULT_FONT, 43,0xFFFFFF);
			label.filter = Game.FONT_SHADOW_FILTER;
			label.hAlign = HAlign.CENTER;
			label.vAlign = VAlign.CENTER;		
			cover.addChild(label);
			
			cover.addEventListener(TouchEvent.TOUCH, onLevelTouch);
			container.addChild(cover);
		}
		
		private function onLevelTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(container);
			if (touch != null && touch.phase == TouchPhase.BEGAN) {
				cover.scaleX = cover.scaleY = 0.9;
			}
			else if (touch != null && touch.phase == TouchPhase.ENDED) {
				cover.scaleX = cover.scaleY = 1;
				// if level is unlocked - we are go
				if(unlocked) dispatchEvent(new Event(Game.LEVEL_TOUCH, false, this));
			}
		}
		
		public function showTrophyIcon(txtName:String):void 
		{
			if (trophyIcon) {
				trophyIcon.removeFromParent();
			}
			
			if (lockIcon) {
				lockIcon.removeFromParent(); 
				lockIcon = null;
			}
			
			if (txtName) {				
				trophyIcon = new Image(Game.getTexture("shared", txtName));
				imageToCenter(trophyIcon);
				trophyIcon.x = 110; //110
				trophyIcon.y = 10; //0
				cover.addChild(trophyIcon);
			}
		}
		
		public function showLockIcon():void 
		{
			if(lockIcon == null) {
				lockIcon = new Image(Game.getTexture("shared", "lock"));
				imageToCenter(lockIcon);
				lockIcon.x = 110;
				lockIcon.y = 0;
				cover.addChild(lockIcon);
			}
		}
		
		public function removeLockIcon():void 
		{
			if (lockIcon) { lockIcon.removeFromParent(); lockIcon = null; }
		}
		
		public function removeTrophyIcon():void {
			if (trophyIcon) { trophyIcon.removeFromParent(); trophyIcon = null; }
		}
		
		public function checkAvailable(completedLevels:Dictionary):Boolean 
		{
			var levelNumber:int;
			var count:int = 0;
			for (var i:int = 0; i < keys.length; i++) {
				levelNumber = keys[i];
				if (completedLevels[levelNumber] != null) count++;
			}
			
			if (count == keys.length) unlocked = true;
			return unlocked;
		}
		
		
	}

}