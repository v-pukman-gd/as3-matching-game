package states 
{
	import core.SpriteManager;
	import core.Vec;
	import flash.utils.Dictionary;
	import game.Game;
	import game.Leaderboard;
	import game.Level;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import utils.dictSize;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class MapState extends SpriteManager
	{
		public var mode:uint;		
		private var levels:Vector.<Level>;
		private var leaderboard:Leaderboard;
		//private var debugLabel:TextField;
		//private var levelsList:Array;
		//private var results:Dictionary;
		
		private var starBtn:Button;
		private var cleanBtn:Button;
		
		public function MapState(mode:uint) 
		{
			this.mode = mode;
			levels = new Vector.<Level>();
			leaderboard = new Leaderboard();
			
			/*if (mode == Game.ONE_PLAYER_MODE) {
				levelsList = Game.ONE_PLAYER_LEVELS;
				//results = Game.results.onePlayer;
			}
			else if ( mode == Game.TWO_PLAYERS_MODE) {
				levelsList = Game.TWO_PLAYERS_LEVELS;
				//results = Game.results.twoPlayers;
			}
			else throw new Error("unknown mode value in map state");*/
			
			
		}
		override public function init():void 
		{
			levelsGrid();
			updateAvailable();
			updateAchievements();
			updateRightBtn();			
		}		
		
		
		private function levelsGrid():void 
		{
			//get levels
			var levelsList:Array = (mode == Game.ONE_PLAYER_MODE) ? Game.ONE_PLAYER_LEVELS : Game.TWO_PLAYERS_LEVELS;
			
			//draw bg
			//var bg:Image = new Image(Game.getTexture("shared", "map_bg"));
			var bg:Image = new Image(Game.assets.getTexture("map_bg"));
			bg.width = 1024;
			bg.height = 768;
			bg.blendMode = BlendMode.NONE;
			container.addChild(bg);
			
			/*debugLabel = new TextField(1024, 120, "", Game.DEFAULT_FONT, 20, 0xFFFFFF);
			debugLabel.y = 650;
			debugLabel.x = 120;
			container.addChild(debugLabel);*/
			
			
			//draw buttons
			var backBtn:Button = new Button(Game.getTexture("shared", "back_btn"));
			backBtn.x = 30;
			backBtn.y = 680;			
			backBtn.addEventListener(Event.TRIGGERED, onBackTouch);
			container.addChild(backBtn);			
			
			starBtn = new Button(Game.getTexture("shared", "star_btn"));
			starBtn.x = 930;
			starBtn.y = 680;
			starBtn.visible = false;
			starBtn.addEventListener(Event.TRIGGERED, onStarTouch);
			container.addChild(starBtn);
			
			cleanBtn = new Button(Game.getTexture("shared", "clean_btn"));
			cleanBtn.x = 930;
			cleanBtn.y = 680;
			cleanBtn.visible = false;
			cleanBtn.addEventListener(Event.TRIGGERED, onCleanTouch);
			container.addChild(cleanBtn);			
			
			
			//grid
			// level 120 x 100
			var x:Number = 91; 
			var y:Number = 60; 
			
			var column:uint = 0;			
			var len:uint = levelsList.length;
			var level:Level;
			for (var i:uint = 0; i < len; i++) 
			{
				
				column++;
				
				level = new Level(levelsList[i]);
				level.add(container, new Vec(x, y));
				level.addEventListener(Game.LEVEL_TOUCH, onLevelTouch);
				levels.push(level);
				
				
				x += 240;
				if (column == 4) {
					x = 91;
					y += 160; 
					column = 0;
				}
				
			}		
			
		}
		
		public function updateAchievements():void 
		{
			var level:Level;
			var results:Dictionary = (mode == Game.ONE_PLAYER_MODE) ? Game.results.onePlayer : Game.results.twoPlayers;
			for (var i:int = (levels.length - 1); i >= 0; i-- ) 
			{
				level = levels[i];
				
				//if (level.checkAvailable(results)) {
					//yeah! level in not locked now
				//	level.removeLockIcon();
					//if level was completed - show trophy
					if (results[level.number]) {
						level.showTrophyIcon(results[level.number].trophyIcon);
					}
				//}
				//else level.showLockIcon(); //sorry, but level is locked now
			}
		}
		
		public function updateAvailable():void 
		{
			var level:Level;
			var results:Dictionary = Game.results.onePlayer; // use one player results for both modes
			for (var i:int = (levels.length - 1); i >= 0; i-- ) 
			{
				level = levels[i];
				
				if (level.checkAvailable(results)) {
					level.removeLockIcon();
				}
				else level.showLockIcon(); //sorry, but level is locked now
			}
		}
		
		public function updateRightBtn():void 
		{
			if(mode == Game.ONE_PLAYER_MODE && dictSize(Game.results.onePlayer) > 0) {
				starBtn.visible = true;
			}
			else if(mode == Game.TWO_PLAYERS_MODE && dictSize(Game.results.twoPlayers) > 0) {
				cleanBtn.visible = true;
			}
		}
		
		private function onLevelTouch(e:Event):void 
		{
			dispatchEvent(e);
		}
		
		private function onBackTouch(e:Event):void 
		{
			dispatchEvent(new Event(Game.BACK_TOUCH));
		}
		
		private function onStarTouch(e:Event):void 
		{
			trace("i am star and i am touched!");
			leaderboard.reportScore();
		}
			
		private function onCleanTouch():void 
		{
			if(dictSize(Game.results.twoPlayers) > 0){
				Game.results.twoPlayers = new Dictionary();
				Game.results.save();				
				for (var i:int = (levels.length - 1); i >= 0; i-- ) 
				{
					levels[i].removeTrophyIcon();
				}
				Starling.juggler.delayCall(function():void { cleanBtn.visible = false;  }, 0.5);
			}
		}
		
	}

}