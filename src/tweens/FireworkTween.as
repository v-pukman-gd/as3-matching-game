package tweens 
{
	import core.Particle;
	import core.SpriteManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import utils.randRange;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class FireworkTween extends SpriteManager
	{
		private var particles:Array = [];
		private var colors:Array = [Color.YELLOW, Color.RED, Color.GREEN, Color.BLUE];
		private var timer:Timer;
		private var count:int;
		public var finished:Boolean = false;
		public var removed:Boolean = false;
		private var timelife:int;
		
		private var lastRandom:Number;
		private var params:Object;
		public function FireworkTween(txt:Texture, count:int, x:Number, y:Number, timelife:int, randomColor:Boolean = false, params:Object = null) 
		{
			super();
			
			this.count = count;
			this.timelife = timelife;
			
			if (params == null) params = { };			
			params.xVel = params.xVel ? params.xVel : [-12, 13];
			params.yVel = params.yVel ? params.yVel : [-12, 13];
			params.spin = params.spin ? params.spin : [-9, 11];
			params.drag = params.drag != null ? params.drag : 0.9;
			params.fade = params.fade != null ? params.fade : 0.07;
			params.shrink = params.shrink != null ? params.shrink : 1;
			
			
			var p:Particle;
			for (var i:int = 0; i < count; i++) 
			{
				
				p = new Particle(txt);
				if (randomColor)  p.costume.color = colors[randRange(0, colors.length - 0.6, true)];
				
				p.setVel(getRandRange(params.xVel[0], params.xVel[1]), getRandRange(params.yVel[0], params.yVel[1]));
				p.x = x;
				p.y = y;
				p.shrink = params.shrink;
				p.spin = getRandRange(params.spin[0], params.spin[1]);
				p.drag = params.drag;
				p.fade = params.fade;
				
				p.add(container);				
				particles.push(p);			
				
			}
			
			
			
		}
		public override function init():void 
		{
			timer = new Timer(timelife);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function update():void 
		{
			for (var i:int = 0; i < count; i++) 
			{
				particles[i].update();
			}
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			finished = true;
		}
		
		private function getRandRange(min:Number, max:Number):Number {
			var value:Number = randRange(min, max);
			if (lastRandom) {
				if (Math.ceil(value) == Math.ceil(lastRandom)) getRandRange(min, max);
				else lastRandom = value;
				
			}
			else lastRandom = value;
			
			return value;
		}
		
	}

}