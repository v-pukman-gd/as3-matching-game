package game 
{
	import core.Actor;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import utils.imageToCenter;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Character extends Actor
	{
		private var txt:Texture;
		public var id:int;
		public function Character(id:int, txt:Texture) 
		{
			this.id = id;
			this.txt = txt;
			
			var image:Image = new Image(txt);
			imageToCenter(image);
			image.x = 75;
			image.y = 75;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xFFFFFF, 0);
			bg.graphics.drawRect(0, 0, 150, 150);
			bg.graphics.endFill();
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(bg);
			sprite.addChild(image);
			
			super(sprite);
			
			container.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(container);
			if (touch != null && touch.phase == TouchPhase.ENDED) {
				dispatchEvent(new Event(Game.CHARACTER_TOUCH, false, this));
			}
		}
		
	}

}