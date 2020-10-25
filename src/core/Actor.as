package core 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Actor extends SpriteManager
	{
		public var costume:*;
		public function Actor(costume:*) 
		{
			super();
			this.costume = costume;
			
		}
		public function update():void 
		{
			//override by children
		}
		override public function init():void 
		{
			container.addChild(costume);
		}
		
		public function get globalPos():Point { return container.localToGlobal(new Point(costume.x, costume.y)); }
		public function get x():Number { return costume.x; }
		public function set x(value:Number):void { costume.x = value; }
		
		public function get y():Number { return costume.y; }
		public function set y(value:Number):void { costume.y = value; }
		
		public function get globalX():Number { return globalPos.x; }
		public function get globalY():Number { return globalPos.y; }
		
	}

}