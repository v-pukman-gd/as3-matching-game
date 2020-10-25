package game 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class I18n 
	{
		private var locale:String;
		private var translations:Dictionary;
		private var translate:String;
		public function I18n(locale:String) 
		{
			this.locale = locale;
			translations = new Dictionary();
			init();
		}
		
		private function init():void 
		{
			var currTranslations:Object;
			
			if (locale == "ru")
				currTranslations = translationsRU;
			else
				currTranslations = translationsEN;
			
			for (var key:String in currTranslations) 
			{
				translations[key] = currTranslations[key];
			}
		}
		
		public function t(labelName:String):String
		{
			translate = translations[labelName];
			if (translate == null) translate = "no_translate";
			return translate;
		}
		
		private function get translationsRU():Object 
		{
			return {
				levelCompleted: "Все получилось!",
				levelFailed: "Время кончилось!"
			};
		}
		
		private function get translationsEN():Object 
		{
			return {
				levelCompleted: "Level completed!",
				levelFailed: "Level failed!"
			};
		}
		
	}

}