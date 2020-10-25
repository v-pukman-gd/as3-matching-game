package states 
{
	import core.SpriteManager;
	import core.Vec;
	import game.Desc;
	import game.Game;
	import game.Level;
	import game.OnePlayer;
	import game.TwoPlayers;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class GameState extends SpriteManager
	{
		private var mode:uint;
		private var level:Level;
		public function GameState(mode:uint, level:Level) 
		{
			this.mode = mode;
			this.level = level;
		}
		override public function init():void 
		{
			switch (mode) 
			{
				case Game.ONE_PLAYER_MODE:
					var onePlayerGame:OnePlayer = new OnePlayer(level);
					onePlayerGame.add(container);
				break;
				
				case Game.TWO_PLAYERS_MODE:
					var twoPlayersGame:TwoPlayers = new TwoPlayers(level);
					twoPlayersGame.add(container);
				break;
			}
			
		}
		
	}

}