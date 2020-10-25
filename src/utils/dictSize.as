package utils 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public function dictSize(dict:Dictionary):int 
	{
		var count:int = 0;
		for each (var f:Object in dict) 
		{
			count++
		}
		
		return count;
	}

}