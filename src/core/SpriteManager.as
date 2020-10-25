package core
{
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class SpriteManager extends EventDispatcher
	{
		public var container:Sprite;
		public function SpriteManager() 
		{
			super();
			
			container = new Sprite();
			
			container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			container.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			clean();
		}
		
		public function clean():void 
		{
			//override by children
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		public function init():void 
		{
			//override by children
		}
		public function add(target:DisplayObjectContainer, pos:Vec = null):void 
		{
			if(pos!=null){
				container.x = pos.x;
				container.y = pos.y;
			}
			target.addChild(container);
		}
		public function remove(dispose:Boolean = true):void 
		{
			container.removeFromParent(dispose);
		}
		
		
	}

}