package game 
{
	import core.SpriteManager;
	import core.Vec;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	import starling.utils.HAlign;
	import utils.imageToCenter;
	
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class OnePlayer extends SpriteManager 
	{
		
		private const DESC_POSITION:Vec = new Vec(557, 133); // 500 + card half, 76 + card half
		private var desc:Desc;
		private var descContainer:Sprite;
		
		private var level:Level;
		private var levelValLabel:TextField;
		
		private var score:int = 0;
		private var scoreValLabel:TextField;
		
		private var time:int;
		private var timeValLabel:TextField;
		private var timer:Timer;
		
		
		private var messager:Messager;
		
		private var music:SoundManager;
		private var fx:SoundManager;
		
		private var assets:AssetManager;
		private var loadingScreen:Image;
		
		public function OnePlayer(level:Level) 
		{
			super();
			this.level = level;
			
			music = Game.music;
			fx = Game.fx;
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
			var staticContainer:Sprite = new Sprite();
			container.addChild(staticContainer);
			
			//bg
			var bg:Image = new Image(Game.getTexture(level.name, "bg"));
			bg.width = 1024;
			bg.height = 768;
			bg.touchable = false;
			bg.blendMode = BlendMode.NONE;
			staticContainer.addChild(bg);
			
			//hero
			var hero:Image = new Image(Game.getTexture(level.name, "hero"));
			imageToCenter(hero);
			hero.x = level.heroPos.x;
			hero.y = level.heroPos.y;
			staticContainer.addChild(hero);
			
			//desc
			descContainer = new Sprite();
			container.addChild(descContainer);			
			buildDesc();
	
			//score label			
			var scoreLabel:TextField = new TextField(200, 60, "Score", Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//scoreLabel.border = true;
			scoreLabel.filter = Game.FONT_SHADOW_FILTER;
			scoreLabel.x = 90;
			scoreLabel.y = 15;
			scoreLabel.hAlign = HAlign.LEFT;
			staticContainer.addChild(scoreLabel);
			
			scoreValLabel = new TextField(200, 60, score.toString(), Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//scoreValLabel.border = true;
			scoreValLabel.filter = Game.FONT_SHADOW_FILTER;
			scoreValLabel.x = 90;
			scoreValLabel.y = 72;
			scoreValLabel.hAlign = HAlign.LEFT;
			container.addChild(scoreValLabel);
			
			//set time
			time = level.time;
			
			//draw time labels
			var timeLabel:TextField = new TextField(150, 60, "Time", Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//timeLabel.border = true;
			timeLabel.filter = Game.FONT_SHADOW_FILTER;
			timeLabel.x = 300;
			timeLabel.y = 15;
			timeLabel.hAlign = HAlign.LEFT;
			staticContainer.addChild(timeLabel);
			
			timeValLabel = new TextField(150, 60, time.toString(),Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//timeValLabel.border = true;
			timeValLabel.filter = Game.FONT_SHADOW_FILTER;
			timeValLabel.x = 300;
			timeValLabel.y = 72;
			timeValLabel.hAlign = HAlign.LEFT;
			container.addChild(timeValLabel);
			
			
			//buttons
			var pauseBtn:Button = new Button(Game.getTexture("shared", "pause_btn"));
			pauseBtn.x = 30;
			pauseBtn.y = 680;
			container.addChild(pauseBtn);
			//to prevent very fast exit
			//Starling.juggler.delayCall(function():void { 
			pauseBtn.addEventListener(Event.TRIGGERED, onPauseTouch);
			//}, 1);
			
			messager = new Messager(level);
			messager.add(container);						
			messager.addEventListener(Game.PLAY_TOUCH, onPlayTouch);
			messager.addEventListener(Game.REPLAY_TOUCH, onReplayTouch);
			messager.addEventListener(Game.LIST_TOUCH, function():void { container.dispatchEvent(new Event(Game.LIST_TOUCH, true, Game.ONE_PLAYER_MODE)); } );
			messager.addEventListener(Game.NEXT_TOUCH, onNextTouch);
			//messager.addEventListener(Game.SOUND_TOUCH, onSoundTouch);
			
			//start timer
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, updateTime);
			timer.start();
			
			//set music	
			if(!music.soundIsAdded(level.name)) music.addSound(level.name, assets.getSound(level.name));
			if(!fx.soundIsAdded("bang")) fx.addSound("bang", assets.getSound("bang"));
			if(!fx.soundIsAdded("timer")) fx.addSound("timer", assets.getSound("timer"));
			if (!fx.soundIsAdded("flop")) fx.addSound("flop", assets.getSound("flop"));
			
			//start timer sound for very short levels from here 
			if(level.time <= 10) fx.playSound("timer", Game.FX_VOLUME, 1, true);
			
			//music.crossFade(Game.lastPlayedMusic, level.name, 2, Game.MUSIC_VOLUME, 1, true);	
			music.stopSound(Game.lastPlayedMusic);
			music.playSound(level.name, Game.MUSIC_VOLUME, 1, true);
			Game.lastPlayedMusic = level.name;
			
			//flat static content
			staticContainer.flatten();
			
			//listeners
			container.addEventListener(Event.ENTER_FRAME, update);				
			//Game.showStats(true);
		}
		
		private function onPlayTouch():void 
		{
			timer.start();
			//if (!music.isMuted) music.setVolume(level.name, Game.MUSIC_VOLUME);
			if (!fx.isMuted && time <= 10) fx.playSound("timer", Game.FX_VOLUME, 1, true);
			messager.hide();
		}
		
		private function onReplayTouch():void 
		{
			timer.reset();
			
			time = level.time;
			timeValLabel.text = time.toString();
			
			score = 0;
			scoreValLabel.text = score.toString();
			
			buildDesc();
			messager.hide();					
			timer.start();
			
			//if (!music.isMuted) music.setVolume(level.name, Game.MUSIC_VOLUME);
			if (!fx.isMuted && time <= 10) fx.playSound("timer", Game.FX_VOLUME, 1, true);
		}
		
		private function onNextTouch():void 
		{
			var params:Object = Game.ONE_PLAYER_LEVELS[level.number];
			
			if (params != null) {
				var nextLevel:Level = new Level(params);
				
				if(nextLevel.checkAvailable(Game.results.onePlayer)) {
					container.dispatchEvent(new Event(Game.NEXT_TOUCH, true, nextLevel));
				}
			}
		}
		
		private function buildDesc():void 
		{
			if (desc != null) {
				desc.removeEventListeners();
				desc.remove();
			}
			
			
			desc = new Desc(Game.getTextures(level.name,"card_"),Game.getTexture("shared", "card_cover"), Game.getTexture("shared", "star"), 4, 5, Desc.ENTER_FROM_RIGHT, level.opened);
			desc.add(descContainer,DESC_POSITION);
			desc.addEventListener("cardsMatched", onCardsMatched);
			desc.addEventListener("cardsMissed", onCardsMissed);
			
		}
		
		/*private function onSoundTouch():void 
		{
			trace("deal with sound");			
		}*/
		
		private function onPauseTouch():void 
		{
			timer.stop();
			fx.stopSound("timer");
			//music.setVolume(level.name, 0);
			messager.pause();
		}
		
		private function updateTime(e:TimerEvent):void 
		{			
			time--;
			timeValLabel.text = time.toString();
			
			//trace(time);
			if(level.time > 10 && time == 10){
				fx.playSound("timer", Game.FX_VOLUME, 1, true);
			}			
			
			if (time == 0) {
				timer.stop();
				fx.stopSound("timer");
				fx.playSound("flop", Game.FX_VOLUME);
				messager.failed();
			}
			
			
		}
		
		private function update(e:Event, passedTime:Number):void 
		{
			Game.frameStep = Game.FRAMES_PER_SECOND * passedTime;
			desc.update();
			messager.update();
		}
		
		private function onCardsMatched(e:Event):void 
		{
			updateScore(100);
			fx.playSound("bang", Game.FX_VOLUME);
			
			if (desc.cardsCount == 0 && time > 0) {
				timer.stop();
				fx.stopSound("timer");
				
				messager.completed();
				messager.showResults(score);
				messager.fixNextBtn(Game.ONE_PLAYER_MODE);				
			}
		}
		
		private function onCardsMissed(e:Event):void 
		{
			updateScore( -20);
			fx.playSound("flop",Game.FX_VOLUME * 0.2);
		}
		private function updateScore(d:int):void 
		{
			score += d;
			if (score < 0) score = 0;
			scoreValLabel.text = score.toString();
		}
		
		/*private function stopTimerSound():void 
		{
			if(fx.soundIsPlaying("timer")) fx.stopSound("timer");
		}*/
		
		override public function clean():void 
		{
			//Game.showStats(false);
			fx.stopSound("timer");
			assets.removeTextureAtlas(level.name, true);
			trace("level clean!");
		}
		
	}

}