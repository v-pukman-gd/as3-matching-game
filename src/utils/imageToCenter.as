package utils 
{
	import starling.display.Image;
	/**
	 * ...
	 * @author [V.I.C]
	 */
			
	public function imageToCenter(image:Image) :void
	{
		image.pivotX = Math.ceil(image.width  * 0.5);
		image.pivotY = Math.ceil(image.height * 0.5);
	}
	
}
