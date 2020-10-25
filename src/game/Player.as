package game 
{
	import core.SpriteManager;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import utils.imageToCenter;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	/**
	 * use this class for two players mode
	 */
	public class Player extends SpriteManager
	{
		public static const LEFT:String = "leftPlayer";
		public static const RIGHT:String = "rightPlayer";
		
		public var score:int = 0;
		public var scoreValLabel:TextField;
		public var character:PlayerCharacter;
		private var charImage:Image;
		public function Player(character:PlayerCharacter) 
		{
			super();
			
			this.character = character;
			
			var nameLabel:TextField = new TextField(256, 60, character.name, Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//nameLabel.border = true;
			nameLabel.filter = Game.FONT_SHADOW_FILTER;
			nameLabel.x = 0;
			nameLabel.y = 0;
			nameLabel.hAlign = HAlign.CENTER;
			container.addChild(nameLabel);
			
			charImage = new Image(Game.getTexture("shared", character.txtName + "small"));
			imageToCenter(charImage);
			//trace("hero image size is " + charImage.width + "X" + charImage.height);
			charImage.x = 128; //128
			charImage.y = 140;	//140
			container.addChild(charImage);
			
			scoreValLabel = new TextField(256, 60, score.toString(),Game.DEFAULT_FONT, 56, 0xFFFFFF);
			//scoreValLabel.border = true;
			scoreValLabel.filter = Game.FONT_SHADOW_FILTER;
			scoreValLabel.x = 0;
			scoreValLabel.y = 220;
			scoreValLabel.hAlign = HAlign.CENTER;
			container.addChild(scoreValLabel);
		}
		public function updateScore(value:int):void 
		{
			score += value;
			if (score < 0) score = 0;
			scoreValLabel.text = score.toString();
		}
		public function wait():void 
		{
			charImage.alpha = 0.4;
		}
		public function run():void 
		{
			charImage.alpha = 1;
		}
		
	}

}