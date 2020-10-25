package game 
{
	import core.SpriteManager;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import tweens.FireworkTween;
	import utils.imageToCenter;
	
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Messager extends SpriteManager 
	{
		private const BOX_SHADOW_SIZE:uint = 15;
		private const TROPHY_ALPHA:Number = 0.3;
		private const TROPHY_FIREWORK_PARAMS:Object = { fade: 0.05, xVel: [ -13, 13], yVel: [ -13, 13] };
		private const TROPHY_FADE_IN_TIME:Number = 0.1;
		
		private var level:Level;
		
		private var pauseMsg:Sprite;
		private var completedMsg:Sprite;
		private var failedMsg:Sprite;
		private var winnerMsg:Sprite;
		
		private var resultScoreLabel:TextField;
		private var resultTrophyImg1:Image;
		private var resultTrophyImg2:Image;
		private var resultTrophyImg3:Image;
		
		private var charCont:Sprite;
		
		private var bg:Sprite;
		private var soundOnBtn:Button;
		private var soundOffBtn:Button;
		
		//one player winner fix
		private var starBtn:Button;
		private var nextBtn:Button;
		
		//two player winner fix
		private var nextBtn2:Button;
		private var listBtn4:Button;
		private var replayBtn4:Button;
		
		private var leaderboard:Leaderboard;
		
		private var tweensArr:Vector.<FireworkTween> = new Vector.<FireworkTween>();
		public function Messager(level:Level) 
		{
			super();
			//level name
			this.level = level;
			
			//leaderboard
			leaderboard = new Leaderboard();
			
			//bg
			bg = new Sprite();
			bg.visible = false;
			
			var bgShape:Shape = new Shape();
			bgShape.graphics.beginFill(0xE5E5E5, 0.8);
			bgShape.graphics.drawRect(0, 0, Game.screen.width, Game.screen.height);
			bgShape.graphics.endFill();
			bg.addChild(bgShape);
			
			//pause
			pauseMsg = new Sprite();
			pauseMsg.x = Game.screen.width * 0.5;
			pauseMsg.y = Game.screen.height * 0.5;
			pauseMsg.visible = false;
			
			var pauseBox:Image = new Image(Game.getTexture("shared", "window_small"));
			pauseBox.x = -220;
			pauseBox.y = -195;
			pauseBox.filter = Game.BOX_SHADOW_FILTER; ///BlurFilter.createDropShadow(BOX_SHADOW_SIZE);
			pauseMsg.addChild(pauseBox);
			
			var pauseLabel:TextField = new TextField(440, 50, "Level " + level.number.toString(), Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//pauseLabel.border = true;
			pauseLabel.filter = Game.FONT_SHADOW_FILTER;
			pauseLabel.x = -220;
			pauseLabel.y = -150;
			pauseLabel.hAlign = HAlign.CENTER;
			pauseMsg.addChild(pauseLabel);
			
			var playBtn:Button = new Button(Game.getTexture("shared", "play_btn"));
			playBtn.pivotX = playBtn.width * 0.5;
			playBtn.pivotY = playBtn.height * 0.5;
			playBtn.x = 0;
			playBtn.y = -13;
			playBtn.addEventListener(Event.TRIGGERED, onPlay);
			pauseMsg.addChild(playBtn);
			
			var replayBtn:Button = new Button(Game.getTexture("shared", "replay_btn"));
			replayBtn.pivotX = replayBtn.width * 0.5;
			replayBtn.pivotY = replayBtn.height * 0.5;
			replayBtn.x = -92;
			replayBtn.y = 118;
			replayBtn.addEventListener(Event.TRIGGERED, onReplay);
			pauseMsg.addChild(replayBtn);
			
			var listBtn:Button = new Button(Game.getTexture("shared", "list_btn"));
			listBtn.pivotX = listBtn.width * 0.5;
			listBtn.pivotY = listBtn.height * 0.5;
			listBtn.x = 0;
			listBtn.y = 118;
			listBtn.addEventListener(Event.TRIGGERED, onList);
			pauseMsg.addChild(listBtn);
			
			
			soundOnBtn = new Button(Game.getTexture("shared", "sound_on_btn"));
			soundOnBtn.pivotX = soundOnBtn.width * 0.5;
			soundOnBtn.pivotY = soundOnBtn.height * 0.5;
			soundOnBtn.x = 92;
			soundOnBtn.y = 118;
			soundOnBtn.addEventListener(Event.TRIGGERED, onSound);
			pauseMsg.addChild(soundOnBtn);
			
			soundOffBtn = new Button(Game.getTexture("shared", "sound_off_btn"));
			soundOffBtn.pivotX = soundOffBtn.width * 0.5;
			soundOffBtn.pivotY = soundOffBtn.height * 0.5;
			soundOffBtn.x = 92;
			soundOffBtn.y = 118;
			soundOffBtn.addEventListener(Event.TRIGGERED, onSound);
			pauseMsg.addChild(soundOffBtn);
			
			updateSound();
			
			//completed begin
			completedMsg = new Sprite();
			completedMsg.x = Game.screen.width * 0.5;
			completedMsg.y = Game.screen.height * 0.5;
			completedMsg.visible = false;
			
			var compBox:Image = new Image(Game.getTexture("shared", "window_big"));
			compBox.x = -220;
			compBox.y = -225;
			compBox.filter = Game.BOX_SHADOW_FILTER;
			completedMsg.addChild(compBox);
			
			var compLabel:TextField = new TextField(440, 50, "Level completed!", Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//compLabel.border = true;
			compLabel.filter = Game.FONT_SHADOW_FILTER;
			compLabel.x = -220;
			compLabel.y = -180;
			compLabel.hAlign = HAlign.CENTER;
			completedMsg.addChild(compLabel);
			
			resultScoreLabel = new TextField(440, 50, "", Game.DEFAULT_FONT, 43, 0xFFFFFF);
			resultScoreLabel.filter = Game.FONT_SHADOW_FILTER;
			//resultScoreLabel.border = true;
			resultScoreLabel.x = -220;
			resultScoreLabel.y = -125;
			resultScoreLabel.hAlign = HAlign.CENTER;
			completedMsg.addChild(resultScoreLabel);
			
			resultTrophyImg1 = new Image(Game.getTexture("shared", "candy_trophy"));
			resultTrophyImg1.x = -175; //-180;
			resultTrophyImg1.y = -50; //-60;
			completedMsg.addChild(resultTrophyImg1);
			
			resultTrophyImg2 = new Image(Game.getTexture("shared", "lollipop_trophy"));
			resultTrophyImg2.x = -48; //-50;
			resultTrophyImg2.y = -55;
			completedMsg.addChild(resultTrophyImg2);
			
			resultTrophyImg3 = new Image(Game.getTexture("shared", "cakeboy_trophy"));
			resultTrophyImg3.x = 62; //59;
			resultTrophyImg3.y = -50; //-60;
			completedMsg.addChild(resultTrophyImg3);
			
			var listBtn2:Button = new Button(Game.getTexture("shared", "list_btn"));
			listBtn2.pivotX = listBtn2.width * 0.5;
			listBtn2.pivotY = listBtn2.height * 0.5;
			listBtn2.x = 0; //-92
			listBtn2.y = 145;
			listBtn2.addEventListener(Event.TRIGGERED, onList);
			completedMsg.addChild(listBtn2);
			
			var replayBtn2:Button = new Button(Game.getTexture("shared", "replay_btn"));
			replayBtn2.pivotX = replayBtn2.width * 0.5;
			replayBtn2.pivotY = replayBtn2.height * 0.5;
			replayBtn2.x = -92; //0
			replayBtn2.y = 145;
			replayBtn2.addEventListener(Event.TRIGGERED, onReplay);
			completedMsg.addChild(replayBtn2);		
			
			starBtn = new Button(Game.getTexture("shared", "star_btn"));
			starBtn.pivotX = starBtn.width * 0.5;
			starBtn.pivotY = starBtn.height * 0.5;
			starBtn.x = 92;
			starBtn.y = 145;
			starBtn.visible = false;
			starBtn.addEventListener(Event.TRIGGERED, onStar);
			completedMsg.addChild(starBtn);
			
			nextBtn = new Button(Game.getTexture("shared", "next_btn"));
			nextBtn.pivotX = nextBtn.width * 0.5;
			nextBtn.pivotY = nextBtn.height * 0.5;
			nextBtn.x = 92;
			nextBtn.y = 145;
			nextBtn.addEventListener(Event.TRIGGERED, onNext);
			completedMsg.addChild(nextBtn);
			//complited end
			
			//failed
			failedMsg = new Sprite();
			failedMsg.x = Game.screen.width * 0.5;
			failedMsg.y = Game.screen.height * 0.5;
			failedMsg.visible = false;
			
			var failedBox:Image = new Image(Game.getTexture("shared", "window_small"));
			failedBox.x = -220;
			failedBox.y = -195;
			failedBox.filter = Game.BOX_SHADOW_FILTER;
			failedMsg.addChild(failedBox);
		
			var timerImg:Image = new Image(Game.getTexture("shared", "timer"));
			imageToCenter(timerImg);
			timerImg.x = 10;
			timerImg.y = -10;
			failedMsg.addChild(timerImg);
			
			var failedLabel:TextField = new TextField(440, 50, "Level failed!", Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//failedLabel.border = true;
			failedLabel.filter = Game.FONT_SHADOW_FILTER;
			failedLabel.x = -220;
			failedLabel.y = -150;
			failedLabel.hAlign = HAlign.CENTER;
			failedMsg.addChild(failedLabel);
			
			var listBtn3:Button = new Button(Game.getTexture("shared", "list_btn"));
			listBtn3.pivotX = listBtn3.width * 0.5;
			listBtn3.pivotY = listBtn3.height * 0.5;
			listBtn3.x = 47; // -47
			listBtn3.y = 118;
			listBtn3.addEventListener(Event.TRIGGERED, onList);
			failedMsg.addChild(listBtn3);
			
			var replayBtn3:Button = new Button(Game.getTexture("shared", "replay_btn"));
			replayBtn3.pivotX = replayBtn3.width * 0.5;
			replayBtn3.pivotY = replayBtn3.height * 0.5;
			replayBtn3.x = -47; // 47
			replayBtn3.y = 118;
			replayBtn3.addEventListener(Event.TRIGGERED, onReplay);
			failedMsg.addChild(replayBtn3);
			
			//winner
			winnerMsg = new Sprite();
			winnerMsg.x = Game.screen.width * 0.5;
			winnerMsg.y = Game.screen.height * 0.5;
			winnerMsg.visible = false;
			
			var winnerBox:Image = new Image(Game.getTexture("shared", "window_big"));
			winnerBox.x = -220;
			winnerBox.y = -225;
			winnerBox.filter = Game.BOX_SHADOW_FILTER;
			winnerMsg.addChild(winnerBox);
			
			var winnerLabel:TextField = new TextField(440, 50, "is winner!", Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//winnerLabel.border = true;
			winnerLabel.filter = Game.FONT_SHADOW_FILTER;
			winnerLabel.x = -220;
			winnerLabel.y = -125;
			winnerLabel.hAlign = HAlign.CENTER;
			winnerMsg.addChild(winnerLabel);
			
			listBtn4 = new Button(Game.getTexture("shared", "list_btn"));
			listBtn4.pivotX = listBtn4.width * 0.5;
			listBtn4.pivotY = listBtn4.height * 0.5;
			listBtn4.x = 0;
			listBtn4.y = 145;
			listBtn4.addEventListener(Event.TRIGGERED, onList);
			winnerMsg.addChild(listBtn4);
			
			replayBtn4 = new Button(Game.getTexture("shared", "replay_btn"));
			replayBtn4.pivotX = replayBtn4.width * 0.5;
			replayBtn4.pivotY = replayBtn4.height * 0.5;
			replayBtn4.x = -92;
			replayBtn4.y = 145;
			replayBtn4.addEventListener(Event.TRIGGERED, onReplay);
			winnerMsg.addChild(replayBtn4);
			
			nextBtn2 = new Button(Game.getTexture("shared", "next_btn"));
			nextBtn2.pivotX = nextBtn2.width * 0.5;
			nextBtn2.pivotY = nextBtn2.height * 0.5;
			nextBtn2.x = 92;
			nextBtn2.y = 145;
			nextBtn2.addEventListener(Event.TRIGGERED, onNext);
			winnerMsg.addChild(nextBtn2);
			
			//sounds
			if (!Game.fx.soundIsAdded("trophy")) Game.fx.addSound("trophy", Game.assets.getSound("trophy"));
			
			
			container.addChild(bg);
			container.addChild(pauseMsg);
			container.addChild(completedMsg);
			container.addChild(failedMsg);
			container.addChild(winnerMsg);
			
		}		
		
		
		public function pause():void {
			bg.visible = true;
			pauseMsg.visible = true;
		}
		public function failed():void 
		{
			bg.visible = true;
			failedMsg.visible = true;
		}
		
		public function hide():void 
		{
			bg.visible = false;
			pauseMsg.visible = false;
			completedMsg.visible = false;
			failedMsg.visible = false;
			winnerMsg.visible = false;
		}
		
		public function completed():void 
		{
			bg.visible = true;
			completedMsg.visible = true;
		}
		public function winner():void 
		{
			bg.visible = true;
			winnerMsg.visible = true;
		}
		public function update():void {
			
			var t:FireworkTween;
			for (var i:int = tweensArr.length - 1; i >= 0; i--) 
			{	
				t = tweensArr[i];
				if (t.finished) {
					t.remove();
					tweensArr.splice(i, 1);
					trace("messager tween removed ", tweensArr.length); 
				}
				else 
					t.update();
			}
		}
		public function showResults(score:uint):void 
		{
			resultScoreLabel.text = score.toString();
			
			var trophyIcon:String = null;
			resultTrophyImg1.alpha = TROPHY_ALPHA;
			resultTrophyImg2.alpha = TROPHY_ALPHA;
			resultTrophyImg3.alpha = TROPHY_ALPHA;
			
			if (score >= 0) {
				Starling.juggler.delayCall(setTrophy, 0.5, resultTrophyImg1);
				trophyIcon = "candy_trophy_icon";
			}
			
			if (score >= 700) {
				Starling.juggler.delayCall(setTrophy, 1.5, resultTrophyImg2);
				trophyIcon = "lollipop_trophy_icon";
			}
			
			if (score >= 900) {
				Starling.juggler.delayCall(setTrophy, 2.5, resultTrophyImg3);
				trophyIcon = "cakeboy_trophy_icon";
			}
			
			Game.results.onePlayer[level.number] = { score: score,  trophyIcon: trophyIcon };
			Game.results.save();
			
		}
		private function setTrophy(trophyImg:Image):void 
		{
			//trophyImg.alpha = 1;
			
			var firework:FireworkTween = new FireworkTween(Game.getTexture("shared", "firework"), 20, trophyImg.x + trophyImg.width * 0.5, trophyImg.y + trophyImg.width * 0.5, 2000, true, TROPHY_FIREWORK_PARAMS);
			firework.add(completedMsg);
			tweensArr.push(firework);			
			
			Starling.juggler.tween(trophyImg, TROPHY_FADE_IN_TIME, { alpha: 1 } );		
			
			Game.fx.playSound("trophy", Game.FX_VOLUME);
		}
		public function showCharacter(char:PlayerCharacter):void 
		{
			if (charCont != null) {
				charCont.removeFromParent();
			}
			charCont = new Sprite();
			
			var nameLabel:TextField = new TextField(440, 50, char.name, Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//nameLabel.border = true;
			nameLabel.filter = Game.FONT_SHADOW_FILTER;
			nameLabel.x = -220;
			nameLabel.y = -180;
			nameLabel.hAlign = HAlign.CENTER;
			charCont.addChild(nameLabel);
			
			var charImg:Image = new Image(Game.getTexture("shared", char.txtName + "big"));
			imageToCenter(charImg);
			charImg.x = 0;
			charImg.y = 15;
			charImg.alpha = 0;
			charCont.addChild(charImg);
			
			var firework:FireworkTween = new FireworkTween(Game.getTexture("shared", "firework"), 20, charImg.x, charImg.y, 2000, true, TROPHY_FIREWORK_PARAMS);
			Starling.juggler.delayCall(function():void {
				firework.add(charCont);
				tweensArr.push(firework);
				Starling.juggler.tween(charImg, TROPHY_FADE_IN_TIME, { alpha: 1 } );			
				Game.fx.playSound("trophy", Game.FX_VOLUME);
			}, 0.5);
			
			winnerMsg.addChild(charCont);			
			
			Game.results.twoPlayers[level.number] = { trophyIcon: (char.txtName + "icon") };
			Game.results.save();
		}
		
		public function showCharacters(char1:PlayerCharacter, char2:PlayerCharacter):void 
		{
			if (charCont != null) {
				charCont.removeFromParent();
			}
			charCont = new Sprite();
			
			var nameLabel:TextField = new TextField(440, 50, "Frendship", Game.DEFAULT_FONT, 43, 0xFFFFFF);
			//nameLabel.border = true;
			nameLabel.filter = Game.FONT_SHADOW_FILTER;
			nameLabel.x = -220;
			nameLabel.y = -180;
			nameLabel.hAlign = HAlign.CENTER;
			charCont.addChild(nameLabel);
			
			var charImg1:Image = new Image(Game.getTexture("shared", char1.txtName + "big"));
			imageToCenter(charImg1);
			charImg1.x = -90;
			charImg1.y = 15;
			charImg1.alpha = 0;
			charCont.addChild(charImg1);	

			var charImg2:Image = new Image(Game.getTexture("shared", char2.txtName + "big"));
			imageToCenter(charImg2);
			charImg2.x = 90;
			charImg2.y = 15;
			charImg2.alpha = 0;
			charCont.addChild(charImg2);
			
			var firework1:FireworkTween = new FireworkTween(Game.getTexture("shared", "firework"), 20, charImg1.x, charImg1.y, 2000, true, TROPHY_FIREWORK_PARAMS);
			Starling.juggler.delayCall(function():void{
				firework1.add(charCont);
				tweensArr.push(firework1);
				Game.fx.playSound("trophy", Game.FX_VOLUME);
				Starling.juggler.tween(charImg1, TROPHY_FADE_IN_TIME, { alpha: 1});
			}, 0.5);
			
			var firework2:FireworkTween = new FireworkTween(Game.getTexture("shared", "firework"), 20, charImg2.x, charImg2.y, 2000, true, TROPHY_FIREWORK_PARAMS);
			Starling.juggler.delayCall(function():void {
				firework2.add(charCont);
				tweensArr.push(firework2);
				Game.fx.playSound("trophy", Game.FX_VOLUME);
				Starling.juggler.tween(charImg2, TROPHY_FADE_IN_TIME, { alpha: 1} );
			}, 1.5);
			
			winnerMsg.addChild(charCont);		
			
			
			Game.results.twoPlayers[level.number] = { trophyIcon: null };
			Game.results.save();
		}
		
		public function fixNextBtn(mode:uint):void 
		{
			if (mode == Game.ONE_PLAYER_MODE) {
				// level.number always means next level
				//so if current level is last - show star btn
				if (Game.ONE_PLAYER_LEVELS[level.number] == null) {
					starBtn.visible = true;
					nextBtn.visible = false;
				}
			}
			else if (mode == Game.TWO_PLAYERS_MODE) {
				if (Game.TWO_PLAYERS_LEVELS[level.number] == null) {
					nextBtn2.visible = false;
					
					listBtn4.x = 47;
					listBtn4.y = 145;
					
					replayBtn4.x = -47;
					replayBtn4.y = 145;
				}
			}
		}
		
		private function updateSound():void 
		{
			if (Game.results.sound) {
				soundOnBtn.visible = true;
				soundOffBtn.visible = false;
				
				
				Game.fx.muteAll(false);
				Game.music.muteAll(false);
			}
			else {
				soundOnBtn.visible = false;
				soundOffBtn.visible = true;
				
				
				Game.fx.muteAll(true);
				Game.music.muteAll(true);
			}
		}
		
		private function onPlay(e:Event):void 
		{
			dispatchEvent(new Event(Game.PLAY_TOUCH));
		}
		
		private function onSound():void 
		{
			Game.results.sound = !Game.results.sound;
			Game.results.save();	
			
			updateSound();
			//dispatchEvent(new Event(Game.SOUND_TOUCH));
		}
		
		private function onList():void 
		{
			dispatchEvent(new Event(Game.LIST_TOUCH));
		}
		
		private function onReplay():void 
		{
			dispatchEvent(new Event(Game.REPLAY_TOUCH)); 
		}
		
		private function onNext():void 
		{
			dispatchEvent(new Event(Game.NEXT_TOUCH));
		}
		
		private function onStar():void 
		{
			trace("liderboard here!");
			leaderboard.reportScore();
		}
		
	}

}