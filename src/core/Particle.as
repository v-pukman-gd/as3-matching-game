package core 
{
	import game.Game;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import utils.imageToCenter;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Particle extends Actor
	{
		public var xVel:Number = 0;  //x & y velocity of the particle
		public var yVel:Number = 0;//вектор движения шарика
		
		public var drag:Number = 1;//the drag factor between 0 and 1//сопротивление		
		public var fade:Number = 0;//исчезновение 0.03		
		public var shrink:Number = 1;//увеличивается если >1
		public var gravity:Number = 0;//гравитация
		public var wind:Number = 0;//ветер
		public var spin:Number = 0;
		
		private var frameStep:Number;
		public function Particle(txt:Texture) 
		{
			var img:Image = new Image(txt);
			imageToCenter(img);
			/*var s:Sprite = new Sprite();
			s.addChild(img);*/
			
			super(img);				
		}
		public function setVel(xVel:Number, yVel:Number):void 
		{
			this.xVel = xVel;
			this.yVel = yVel;
	    }
		public override function update():void
		{
			frameStep = Game.frameStep;
			
			//add the velocity to the particle s position
			costume.x += xVel * frameStep;
			costume.y += yVel * frameStep;
			
			//apply drag
			xVel *= Math.pow(drag, frameStep); //drag;
			yVel *= Math.pow(drag, frameStep);  //drag;
			
			//fade out
			costume.alpha -= fade * frameStep;
			
			//scale
			costume.scaleX = costume.scaleY *= shrink;
			
			//rotate
			costume.rotation += deg2rad(spin*frameStep);
			
			//gravity
			yVel += gravity * frameStep;
			//wind
			xVel += wind * frameStep;
		}
	}

}