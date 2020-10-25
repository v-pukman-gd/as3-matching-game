package utils 
{
	/**
	* ...
	* @author [V.I.C]
	*/	
	public function randRange(min:Number,max:Number, round:Boolean = false):Number
	{
		var randomNum:Number = (Math.random() * (max - min)) + min;			
		if (round)
			randomNum = Math.round(randomNum);
		return randomNum;
	}	
	

}