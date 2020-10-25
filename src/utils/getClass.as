package utils 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public function getClass(obj:Object):Class 
	{
		return Class(getDefinitionByName(getQualifiedClassName(obj)));
	}	
	

}