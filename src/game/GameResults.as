package game 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class GameResults 
	{
		public var onePlayer:Dictionary; // key - level number, value - object with information
		public var twoPlayers:Dictionary;
		public var sound:Boolean;
		private var storage:DataStorage;
		private var data:Object;
		public function GameResults() 
		{
			storage = new DataStorage("gameResults.txt");
		}
		
		public function save():void 
		{
			data = { onePlayer: onePlayer, twoPlayers: twoPlayers, sound: sound };
			storage.save(data);
		}
		
		public function load():void 
		{
			data = storage.load();
			
			if (data == null) {
				onePlayer = new Dictionary();
				twoPlayers = new Dictionary();
				sound = true;
			}
			else {			
				onePlayer = data.onePlayer;
				twoPlayers = data.twoPlayers;
				sound = data.sound;
			}
		}
		public function reset():void 
		{
			onePlayer = new Dictionary();
			twoPlayers = new Dictionary();
			sound = true;
		}
		
	}

}