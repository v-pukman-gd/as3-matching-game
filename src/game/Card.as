package game 
{
	import core.Actor;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
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
	public class Card extends Actor
	{
		public static const FLIP_TIME:Number = 0.1;
		public static const REMOVE_TIME:Number = 0.5;
		
		public var index:uint;
		private var locked:Boolean = false;
		public function Card(cover:Texture, picture:Texture, index:uint) 
		{
			this.index = index;
			
			var mc:MovieClip = new MovieClip(new <Texture>[cover, picture]);		
			super(mc);
			mc.pivotX = mc.width / 2;
			mc.pivotY = mc.height / 2;
			
			mc.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(costume);
			if (touch != null && touch.phase == TouchPhase.ENDED) {
				
				dispatchEvent(new Event("cardTouched", true, this));
			}
		}
		
		public function flip():void 
		{
			flipTween(0.1, FLIP_TIME, switchFrame);
		}
	
		private function flipTween(scaleX:Number, time:Number, callback:Function = null):void 
		{
			var tween:Tween = new Tween(costume, time, Transitions.EASE_IN_OUT); //EASE_OUT_IN_BOUNCE
			tween.animate("scaleX", scaleX);
			if (callback != null) tween.onComplete = callback;
			
			Starling.juggler.add(tween);			
		}
		
		private function switchFrame():void 
		{
			costume.currentFrame = costume.currentFrame == 0 ? 1 : 0;
			flipTween(1, FLIP_TIME);
		}
		
		public override function remove(dispose:Boolean = true):void 
		{
			costume.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeTween(REMOVE_TIME, function():void { container.removeFromParent(dispose); } );
		}
		private function removeTween(time:Number,callback:Function):void 
		{
			var tween:Tween = new Tween(costume, time, Transitions.EASE_IN_OUT); 
			tween.scaleTo(0);
			tween.animate("alpha", 0);
			tween.animate("rotation", 10);
			tween.onComplete = callback;
			
			Starling.juggler.add(tween);
		}
		
		
		
		public function get Opened():Boolean { return costume.currentFrame == 1; }
		
		
		
	}

}