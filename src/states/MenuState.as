package states 
{
	import core.SpriteManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import tweens.FireworkTween;
	/*import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;*/
	import game.Character;
	import game.Game;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import utils.imageToCenter;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class MenuState extends SpriteManager
	{
		public var infoBtn:Button;
		public var backBtn:Button;
		
		private var gameTitle:Image;
		private var startBtn:Button;
		private var firework:FireworkTween;
		private var fireworkContainer:Sprite;
		
		//private var onePlayerLabel:TextField;
		//private var twoPlayersLabel:TextField;
		private var onePlayerLabel:Button;
		private var twoPlayersLabel:Button;
		
		//private var charLabel1:TextField;		
		//private var charLabel2:TextField;
		private var charLabel1:Image;		
		private var charLabel2:Image;
		
		private var charsContainer:Sprite;
		private var chars:Vector.<Character>;
		private var choosedChar:Character;
		private var startChoose:Boolean;
		
		private var creditsLabel:TextField;
		
		//private var shadowFilter:DropShadowFilter;
		//private var blurFilter:BlurFilter;
	
		public function MenuState() 
		{
			
		}
		
		override public function init():void 
		{
			//fireworkContainer = new Sprite();
			//container.addChild(fireworkContainer);
			
			gameTitle = new Image(Game.getTexture("shared", "game_title"));
			imageToCenter(gameTitle);
			gameTitle.x = 512;
			gameTitle.y = 265;
			gameTitle.alpha = 1;
			gameTitle.scaleX = gameTitle.scaleY = 2;
			//gameTitle.visible = true;
			container.addChild(gameTitle);
			//Starling.juggler.delayCall(function():void { gameTitle.visible = true; }, 0.2);
			Starling.juggler.tween(gameTitle, 1.5, { transition: Transitions.EASE_OUT_ELASTIC, scaleX: 1, scaleY: 1 } );
			//Starling.juggler.tween(gameTitle, 0.5, { alpha: 1 } );
			//firework = new FireworkTween(Game.getTexture("shared", "star"), 50, 512, 265, 5000, false, { xVel:[-35,35], fade: 0, drag:0.99 });
			//firework.add(fireworkContainer);
			//fireworkContainer.visible = false;
			//Starling.juggler.delayCall((function():void { fireworkContainer.visible = true; } ), 0.2);
			
			startBtn = new Button(Game.getTexture("shared", "start_btn"));
			startBtn.pivotX = startBtn.width * 0.5;
			startBtn.pivotY = startBtn.height * 0.5;
			startBtn.x = 512;
			startBtn.y = 545;
			startBtn.visible = false;
			startBtn.alpha = 0;
			startBtn.addEventListener(Event.TRIGGERED, onStartTouch);
			container.addChild(startBtn);
			Starling.juggler.delayCall(function():void { 
				startBtn.visible = true;
				Starling.juggler.tween(startBtn, 0.1, { alpha: 1 } );
			}, 2.5);
			
			
			
			creditsLabel = new TextField(1024, 768, Game.CREDITS, Game.DEFAULT_FONT, 22, 0xFFFFFF);
			creditsLabel.hAlign = HAlign.CENTER;
			creditsLabel.vAlign = VAlign.TOP;
			creditsLabel.x = 0;
			creditsLabel.y = 40;
			creditsLabel.visible = false;
			container.addChild(creditsLabel);
			
			/*onePlayerLabel = new TextField(500, 71, "one player", Game.fontName, 62, 0xFFFFFF);
			onePlayerLabel.border = false;
			onePlayerLabel.x = 262;
			onePlayerLabel.y = 485;	
			onePlayerLabel.nativeFilters = [shadowFilter, blurFilter];
			container.addChild(onePlayerLabel);*/
			
			//Yeah, label is button because you can touch it
			onePlayerLabel = new Button(Game.getTexture("shared", "one_player_label"));
			onePlayerLabel.x = 337;
			onePlayerLabel.y = 455;
			onePlayerLabel.visible = false;
			container.addChild(onePlayerLabel);
			
			/*twoPlayersLabel = new TextField(500, 71, "two players", Game.fontName, 62, 0xFFFFFF);
			twoPlayersLabel.border = false;
			twoPlayersLabel.x = 262;
			twoPlayersLabel.y = 600;
			twoPlayersLabel.nativeFilters = [shadowFilter, blurFilter];
			container.addChild(twoPlayersLabel);*/
			
			twoPlayersLabel = new Button(Game.getTexture("shared", "two_players_label"));
			twoPlayersLabel.x = 312;
			twoPlayersLabel.y = 570;
			twoPlayersLabel.visible = false;
			container.addChild(twoPlayersLabel);
			
			
			//set players names
			/*charLabel1 = new TextField(500, 71, "left player", Game.fontName, 62, 0xFFFFFF)
			charLabel1.border = false;
			charLabel1.x = 262;
			charLabel1.y = 485;
			charLabel1.visible = false;
			charLabel1.nativeFilters = [shadowFilter];
			container.addChild(charLabel1);	*/
			
			charLabel1 = new Image(Game.getTexture("shared", "left_player_label"));
			charLabel1.x = 337;
			charLabel1.y = 455;
			charLabel1.visible = false;
			container.addChild(charLabel1);			
			
			/*charLabel2 = new TextField(500, 71, "right player", Game.fontName, 62, 0xFFFFFF);
			charLabel2.border = false;
			charLabel2.x = 262;
			charLabel2.y = 485;
			charLabel2.visible = false;
			charLabel2.nativeFilters = [shadowFilter];
			container.addChild(charLabel2);*/
			
			charLabel2 = new Image(Game.getTexture("shared", "right_player_label"));
			charLabel2.x = 312;
			charLabel2.y = 455;
			charLabel2.visible = false;
			container.addChild(charLabel2);
		
			var char:Character;
			var txtName:String;
			var x:Number = 37;
			var y:Number = 525; //540
			
			chars = new Vector.<Character>;
			charsContainer = new Sprite();
			container.addChild(charsContainer);
			charsContainer.visible = false;
			
			for (var i:int = 0; i < Game.PLAYER_CHARACTERS.length; i++) 
			{
				txtName = Game.PLAYER_CHARACTERS[i].txtName;
				char = new Character(i, Game.getTexture("shared", txtName + "small"));
				char.add(charsContainer);
				
				char.x = x;
				char.y = y;
				char.addEventListener(Game.CHARACTER_TOUCH, onCharacterTouch);
				
				x += 160;
			}
			
			//deal with buttons
			infoBtn = new Button(Game.getTexture("shared", "info_btn"));
			infoBtn.x = 930;
			infoBtn.y = 680;
			infoBtn.visible = false;
			infoBtn.addEventListener(Event.TRIGGERED, onInfoTouch);
			container.addChild(infoBtn);
			
			backBtn = new Button(Game.getTexture("shared", "back_btn"));
			backBtn.x = 30;
			backBtn.y = 680;
			backBtn.visible = false;
			backBtn.addEventListener(Event.TRIGGERED, onBackTouch);
			container.addChild(backBtn);
			
			//start sound
			
			
			
			onePlayerLabel.addEventListener(Event.TRIGGERED, onOnePlayerTouch);
			twoPlayersLabel.addEventListener(Event.TRIGGERED, onTwoPlayersTouch);
			
			//container.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/*private function update(e:Event, passedTime:Number):void
		{
			if (firework.finished && !firework.removed) {
				firework.remove();
				firework.removed = true;
				trace("firework removed");
			}
			else {
				Game.frameStep = Game.FRAMES_PER_SECOND * passedTime;
				firework.update();
			}
		}*/
		
		private function onStartTouch():void 
		{
			startBtn.visible = false;
			
			onePlayerLabel.visible = true;
			twoPlayersLabel.visible = true;
			infoBtn.visible = true;
		}
		
		private function onInfoTouch():void 
		{
			creditsLabel.visible = true;
			infoBtn.visible = false;
			backBtn.visible = true;
			
			onePlayerLabel.visible = false;
			twoPlayersLabel.visible = false;
			gameTitle.visible = false;
		}
		
		private function onBackTouch(e:Event):void 
		{
			backToPlayerModes();
		}
		
		private function onCharacterTouch(e:Event, char:Character):void 
		{
			//trace(char.name);
			
			if (startChoose) {
				charLabel1.visible = false;
				charLabel2.visible = true;
				
				startChoose = false;
				choosedChar = char;
				choosedChar.container.alpha = 0.3;
				//choosedChar.container.filter = new BlurFilter();
				
				Game.LEFT_PLAYER_CHARACTER = Game.PLAYER_CHARACTERS[char.id];				
			}
			else if(char != choosedChar){
				
				backToPlayerModes();
				
				Game.RIGHT_PLAYER_CHARACTER = Game.PLAYER_CHARACTERS[char.id];
				
				dispatchEvent(new Event(Game.MODE_TOUCH, false, Game.TWO_PLAYERS_MODE));
			}
			
		}
		
		private function backToPlayerModes():void 
		{
			creditsLabel.visible = false;
			
			charLabel2.visible = false;
			charLabel1.visible = false;
			charsContainer.visible = false;				
			onePlayerLabel.visible = true;
			twoPlayersLabel.visible = true;
			gameTitle.visible = true;
			
			if(choosedChar) choosedChar.container.alpha = 1;
			backBtn.visible = false;
			infoBtn.visible = true;
			startChoose = false;
		}
		
		private function onTwoPlayersTouch():void 
		{
			
			onePlayerLabel.visible = false;
			twoPlayersLabel.visible = false;				
			
			charLabel1.visible = true;
			charsContainer.visible = true;
			
			infoBtn.visible = false;
			backBtn.visible = true;
			
			startChoose = true;
			
		}
		
		private function onOnePlayerTouch():void 
		{
			dispatchEvent(new Event(Game.MODE_TOUCH, false, Game.ONE_PLAYER_MODE));		
		}
		
	}

}