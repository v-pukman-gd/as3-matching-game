package states 
{
	import flash.media.SoundTransform;
	import game.Game;
	import game.Level;
	import game.ProgressBar;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class StateManager extends Sprite
	{
		private var startImg:Image;
		
		private var menuState:MenuState;
		private var gameState:GameState;
		private var mapState:MapState;
		public function StateManager() 
		{
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		public function start(startTxt:Texture, assets:AssetManager):void 
		{
			//show some start image
			startImg = new Image(startTxt);
			addChild(startImg);
			
			assets.addTexture("map_bg", startTxt);
			Game.assets = assets;
			
			var soundOff:Boolean = !Game.results.sound;			
			Game.music.muteAll(soundOff);
			Game.fx.muteAll(soundOff);
			
			var progressBar:ProgressBar = new ProgressBar(400, 50);
			progressBar.x = Game.screen.width * 0.5 - progressBar.width * 0.5;
			progressBar.y = Game.screen.height * 0.5 - progressBar.height * 0.5;
			addChild(progressBar);
			
			assets.loadQueue(function onProgress(ratio:Number):void
            {
                progressBar.ratio = ratio;
                
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
					   progressBar.removeFromParent(true);
                       init();
					   
                    }, 0.1);
            });
		}
		
		private function init():void 
		{
			trace("menu init");
			
			menuState = new MenuState();
			menuState.add(stage);			
			menuState.addEventListener(Game.MODE_TOUCH, onModeTouch);
			
			Game.fx.addSound("start",Game.assets.getSound("start"));
			Game.fx.playSound("start", Game.FX_VOLUME);
			
			Game.music.addSound("main_theme", Game.assets.getSound("main_theme"));
			Game.music.playSound("main_theme", Game.MUSIC_VOLUME,1,true);
			Game.lastPlayedMusic = "main_theme";
		}
		
		private function onModeTouch(e:Event,mode:uint):void 
		{
			menuState.container.visible = false;
			startImg.visible = false;
			
			initMapState(mode);
			trace("at stage " + stage.numChildren);
		}
	
		private function onBackTouch():void 
		{
			clearMapState();
			
			menuState.container.visible = true;
			//menuState.infoBtn.visible = true;
			startImg.visible = true;
			
			
		}
		
		private function onLevelTouch(e:Event, level:Level):void 
		{
			mapState.container.visible = false;			
			
			initGameState(mapState.mode, level);
		}
		
		private function onListTouch(e:Event):void 
		{
			clearGameState();
			mapState.updateAvailable();
			mapState.updateAchievements();
			mapState.updateRightBtn();
			mapState.container.visible = true;
			
			Game.music.stopSound(Game.lastPlayedMusic);
			Game.music.playSound("main_theme", Game.MUSIC_VOLUME,1,true);
			Game.lastPlayedMusic = "main_theme";
			
			//better but buggy
			//Game.music.crossFade(Game.lastPlayedMusic, "main_theme", 0.5, Game.MUSIC_VOLUME, 1, true);
			//Game.lastPlayedMusic = "main_theme";
			
		}
		
		private function onNextTouch(e:Event, level:Level):void 
		{
			clearGameState();
			initGameState(mapState.mode, level);
		}
		
		//adding and removing states
		private function clearMapState():void 
		{
			if (mapState) {				
				mapState.removeEventListener(Game.BACK_TOUCH, onBackTouch);
				mapState.removeEventListener(Game.LEVEL_TOUCH, onLevelTouch);
				mapState.remove();
				mapState = null;
				trace("clear map state");
			}
		}
		
		private function clearGameState():void 
		{
			if (gameState) {
				gameState.remove();
				gameState = null;
				trace("clear game state");
			}
		}
		
		private function initMapState(mode:uint):void 
		{
			mapState = new MapState(mode);
			mapState.add(stage);
			mapState.addEventListener(Game.BACK_TOUCH, onBackTouch);
			mapState.addEventListener(Game.LEVEL_TOUCH, onLevelTouch);
		}
		
		private function initGameState(mode:uint, level:Level):void 
		{
			gameState = new GameState(mode, level);
			gameState.add(stage);
			gameState.container.addEventListener(Game.LIST_TOUCH, onListTouch);
			gameState.container.addEventListener(Game.NEXT_TOUCH, onNextTouch);
		}		
		
		
		
		
	}

}