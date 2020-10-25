package game 
{
	import core.Particle;
	import core.SpriteManager;
	import core.Vec;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import tweens.FireworkTween;
	import utils.randRange;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Desc extends SpriteManager
	{
		public static const ENTER_FROM_RIGHT:String = "enterFromRight";
		public static const ENTER_FROM_TOP:String = "enterFromTop";
		
		public static const CARDS_DISTANCE:Number = 124; //114 is card size, 10 is offset
		
		private var width:uint;
		private var height:uint;
		private var pictures:Vector.<Texture>;
		private var cover:Texture;
		private var enterTween:String;
		private var opened:Boolean;
		
		private var firstCard:Card = null;
		private var secondCard:Card = null;
		
		public var cardsCount:int = 0;
		private var locked:Boolean = false;
		
		private var fireworkTxt:Texture;
		public var tweensArr:Vector.<FireworkTween> = new Vector.<FireworkTween>();
		public function Desc(picturesTxt:Vector.<Texture>, coverTxt:Texture, fireworkTxt:Texture, width:uint, height:uint,enterTween:String, opened:Boolean) 
		{
			this.width = width;
			this.height = height;
			this.fireworkTxt = fireworkTxt;
			this.enterTween = enterTween;
			this.opened = opened;
			
			pictures = picturesTxt;
			cover = coverTxt;
			
			//sounds
			if(!Game.fx.soundIsAdded("click")) Game.fx.addSound("click", Game.assets.getSound("click"));
			
		}
		public override function init():void 
		{
			trace(pictures.length);
			var list:Array = [];
			for (var i:uint = 0; i < width * height / 2; i++ ) {
				list.push(i);
				list.push(i);
			}
			trace(list);
			var index:uint;
			var pIndex:uint;
			var card:Card;
			for (var x:uint = 0; x < width; x++ ) {
				for (var y:uint = 0; y < height; y++ ) {
					index = randRange(0, list.length - 1, true);
					pIndex = list[index];
					
					card = new Card(cover, pictures[pIndex], pIndex);
					card.add(container);
					card.x = x * CARDS_DISTANCE;
					card.y = y * CARDS_DISTANCE;
					card.addEventListener("cardTouched", onCardTouched);
					if(opened) card.flip();
					cardsCount++;
					
					list.splice(index, 1);
				}
			}
		}
		private function onCardTouched(e:Event):void 
		{
		  if (!locked) {
			if (firstCard == null ) {
				firstCard = e.data as Card;
				firstCard.flip();				
				locked = true;
				Starling.juggler.delayCall(unlock, Card.FLIP_TIME);
				Game.fx.playSound("click");
			}
			else if (firstCard == e.data) { /* nothing */}
			else if (secondCard == null) {
				secondCard = e.data as Card;
				secondCard.flip();				
				locked = true;
				Starling.juggler.delayCall(checkCards, (Card.FLIP_TIME * 2 + (opened ? 0 : 0.4)));	
				Game.fx.playSound("click");
			}
			else { /* close all */ }
		  }
			
		}
		
		private function checkCards():void 
		{
			if (secondCard.index == firstCard.index) {
				starsTween(firstCard.x, firstCard.y);
				firstCard.remove();
				
				starsTween(secondCard.x, secondCard.y);
				secondCard.remove();
				
				cardsCount -= 2;
				Starling.juggler.delayCall(unlockWithEvent,0, new Event("cardsMatched"));
			}
			else {
				firstCard.flip();
				secondCard.flip();	
				Starling.juggler.delayCall(unlockWithEvent, Card.FLIP_TIME, new Event("cardsMissed"));
			}
				
			firstCard = null;
			secondCard = null;	
		}
		
		private function unlockWithEvent(e:Event):void 
		{
			unlock();
			dispatchEvent(e);
		}
		
		private function unlock():void 
		{
			locked = false;
		}
		private function starsTween(x:Number, y:Number):void 
		{
			var t:FireworkTween = new FireworkTween(fireworkTxt, 5,x,y, 500);
			t.add(container);
			tweensArr.push(t);
		}
		public function update():void 
		{
			var t:FireworkTween;
			for (var i:int = tweensArr.length - 1; i >= 0; i--) 
			{	
				t = tweensArr[i];
				if (t.finished) {
					t.remove();
					tweensArr.splice(i, 1);
					trace("tween removed ", tweensArr.length); 
				}
				else 
					t.update();
			}
		}
		override public function add(target:DisplayObjectContainer, pos:Vec = null):void {
			if (pos != null)
			{
				var tween:Tween;
				
				switch (enterTween) 
				{
					case ENTER_FROM_RIGHT: 
					{
						container.x = Game.screen.width + container.width;
						container.y = pos.y;
						
						tween = new Tween(container, 1, Transitions.EASE_OUT);
						tween.animate("x", pos.x);
						Starling.juggler.add(tween);
						
						break;
					}
					case ENTER_FROM_TOP:
					{
						container.x = pos.x;
						container.y = - container.height;
						
						tween = new Tween(container, 1, Transitions.EASE_OUT);
						tween.animate("y", pos.y);
						Starling.juggler.add(tween);
						
						break;
					}
				}
				
			}
			target.addChild(container);			
		}
		
		
	}

}