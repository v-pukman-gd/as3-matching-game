package game 
{
	import core.SpriteManager;
	import core.Vec;
	import flash.filesystem.File;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class TwoPlayers extends SpriteManager
	{
		private var desc:Desc;
		private var descContainer:Sprite;
	
		
		private var lPlayer:Player;
		private var rPlayer:Player;
		private var currPlayer:String;
		
		private var level:Level;
		private var messager:Messager;
		
		private var fx:SoundManager;
		private var music:SoundManager;
		
		private var assets:AssetManager;
		private var loadingScreen:Image;
		
		public function TwoPlayers(level:Level) 
		{
			this.level = level;
			
			fx = Game.fx;
			music = Game.music;
			assets = Game.assets;
		}
		override public function init():void {
			//add loading bg
			//loadingScreen = new Image(Game.getTexture("shared", "map_bg"));
			loadingScreen = new Image(Game.assets.getTexture("map_bg"));
			container.addChild(loadingScreen);
			
			//load texture atlas
			var appDir:File = File.applicationDirectory;
			if (assets.getTextureAtlas(level.name) == null) {
				assets.enqueue(
					appDir.resolvePath(formatString("textures/{0}x/{1}.png", assets.scaleFactor, level.name)),
					appDir.resolvePath(formatString("textures/{0}x/{1}.xml", assets.scaleFactor, level.name))
				);
			}
			//load music
			if (assets.getSound(level.name) == null) {
				assets.enqueue(
					appDir.resolvePath(formatString("audio/music/{0}.mp3",level.name))
				);
			}
			assets.loadQueue(onProgress);
		}
		
		private function onProgress(ratio:Number):void 
		{
			if (ratio == 1) { 
				initLevel();
				loadingScreen.removeFromParent();
			}
		}
		private function initLevel():void 
		{
			
			var bg:Image = new Image(Game.getTexture(level.name, "bg"));
			//bg.width = 1024;
			//bg.height = 768;
			bg.touchable = false;
			bg.blendMode = BlendMode.NONE;
			container.addChild(bg);
			
			descContainer = new Sprite();
			container.addChild(descContainer);
			buildDesc();
			
			lPlayer = new Player(Game.LEFT_PLAYER_CHARACTER);
			lPlayer.add(container, new Vec(0, 240));
			
			rPlayer = new Player(Game.RIGHT_PLAYER_CHARACTER);
			rPlayer.add(container, new Vec(768, 240));			
			
			currPlayer = Math.random() > 0.5 ? Player.LEFT : Player.RIGHT;
			updateScore(-1); //show current player
			
			var pauseBtn:Button = new Button(Game.getTexture("shared", "pause_btn"));
			pauseBtn.x = 30;
			pauseBtn.y = 680;
			container.addChild(pauseBtn);
			//Starling.juggler.delayCall(function():void { 
			pauseBtn.addEventListener(Event.TRIGGERED, onPauseTouch);
			//}, 2.5);
			
			
			messager = new Messager(level);
			messager.add(container);						
			messager.addEventListener(Game.PLAY_TOUCH, onPlayTouch);
			messager.addEventListener(Game.REPLAY_TOUCH, onReplayTouch);
			messager.addEventListener(Game.LIST_TOUCH, function():void { container.dispatchEvent(new Event(Game.LIST_TOUCH, true, Game.TWO_PLAYERS_MODE)); } );
			messager.addEventListener(Game.NEXT_TOUCH, onNextTouch);
			//messager.addEventListener(Game.SOUND_TOUCH, onSoundTouch);
			
			//set music
			if(!music.soundIsAdded(level.name)) music.addSound(level.name, assets.getSound(level.name));
			if(!fx.soundIsAdded("bang")) fx.addSound("bang", assets.getSound("bang"));
			if(!fx.soundIsAdded("flop")) fx.addSound("flop", assets.getSound("flop"));
			
			//music.crossFade(Game.lastPlayedMusic, level.name, 2, Game.MUSIC_VOLUME, 1, true);	
			music.stopSound(Game.lastPlayedMusic);
			music.playSound(level.name, Game.MUSIC_VOLUME, 1, true);
			Game.lastPlayedMusic = level.name;
			
			//listeners
			container.addEventListener(Event.ENTER_FRAME, update);
			
			//Game.showStats(true);
		}
		
		private function onNextTouch():void 
		{
			var params:Object = Game.TWO_PLAYERS_LEVELS[level.number];
			
			if (params != null) {
				var nextLevel:Level = new Level(params);
				//check available by one player progress
				if(nextLevel.checkAvailable(Game.results.onePlayer)) {
					container.dispatchEvent(new Event(Game.NEXT_TOUCH, true, nextLevel));
				}
			}
		
		}
		
		/*private function onSoundTouch():void 
		{
			trace("i am sound!");
		}*/
		
		private function onReplayTouch():void 
		{
			messager.hide();
			
			lPlayer.updateScore(-lPlayer.score);
			rPlayer.updateScore(-rPlayer.score);
			
			updateScore( -1); //set other player
			
			buildDesc();	
		}
		
		private function buildDesc():void 
		{
			if (desc != null) {
				desc.removeEventListeners();
				desc.remove();
			}
			
			desc = new Desc(Game.getTextures(level.name, "card_"),Game.getTexture("shared", "card_cover"), Game.getTexture("shared", "star"), 4, 5, Desc.ENTER_FROM_TOP, level.opened);
			desc.add(descContainer,new Vec(325,134));
			desc.addEventListener("cardsMatched", onCardsMatched);
			desc.addEventListener("cardsMissed", onCardsMissed);
		
		}
		
		private function onPlayTouch():void 
		{
			messager.hide();
		}
		
		private function onPauseTouch():void 
		{
			messager.pause();
		}
		
		private function update(e:Event, passedTime:Number):void 
		{
			Game.frameStep = Game.FRAMES_PER_SECOND * passedTime;
			desc.update();
			messager.update();
		}
		
		private function onCardsMissed():void 
		{
			updateScore( -20);
			fx.playSound("flop",Game.FX_VOLUME * 0.2);
		}
		
		private function onCardsMatched():void 
		{
			updateScore(100);
			fx.playSound("bang", Game.FX_VOLUME);
			
			if (desc.cardsCount == 0) {
				
				messager.winner();
				messager.fixNextBtn(Game.TWO_PLAYERS_MODE);
				
				if (lPlayer.score == rPlayer.score) {
					messager.showCharacters(lPlayer.character, rPlayer.character);
				}
				else if (lPlayer.score > rPlayer.score) {
					messager.showCharacter(lPlayer.character);
				}
				else messager.showCharacter(rPlayer.character);				
			}
		}
		
		private function updateScore(value:int):void 
		{	
			if (currPlayer == Player.LEFT) {
				lPlayer.updateScore(value);
				if (value < 0) {
					lPlayer.wait();
					rPlayer.run();
					currPlayer = Player.RIGHT;
				}
				
			}
			else if (currPlayer == Player.RIGHT) {
				rPlayer.updateScore(value);
				if (value < 0) {
					rPlayer.wait();
					lPlayer.run();
					currPlayer = Player.LEFT;
				}
			}			
			
		}
		
		override public function clean():void 
		{
			//Game.showStats(false);
			assets.removeTextureAtlas(level.name, true);
			trace("level clean!");
		}
		
		
	}

}