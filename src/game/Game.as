package game 
{
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import core.Vec;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import starling.core.Starling;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class Game 
	{
		//frames per second
		public static const FRAMES_PER_SECOND:uint = 30;
		
		//modes
		public static const ONE_PLAYER_MODE:uint = 1;
		public static const TWO_PLAYERS_MODE:uint = 2;
		
		//chars
		public static var LEFT_PLAYER_CHARACTER:PlayerCharacter;
		public static var RIGHT_PLAYER_CHARACTER:PlayerCharacter;
		
		//events
		public static const BACK_TOUCH:String = "backTouch";
		public static const LEVEL_TOUCH:String = "levelTouch";
		public static const MODE_TOUCH:String = "modeTouch";
		public static const PLAY_TOUCH:String = "playTouch";
		public static const REPLAY_TOUCH:String = "replayTouch";
		public static const LIST_TOUCH:String = "listTouch";
		public static const SOUND_TOUCH:String = "soundTouch";
		public static const NEXT_TOUCH:String = "nextTouch";
		
		public static const CHARACTER_TOUCH:String = "characterTouch";
		
		//levels
		public static const ONE_PLAYER_LEVELS:Array =  [
			{number: 1, name: "cowboy", heroPos: new Vec(280, 420), time: 50, opened: false, keys: [] },
			{number: 2, name: "mechanic", heroPos: new Vec(282, 408), time: 50, opened: false, keys:[] },
			{number: 3, name: "clown", heroPos: new Vec(298, 416), time: 50, opened: false, keys:[] },
			{number: 4, name: "mechanic", heroPos: new Vec(282, 408), time: 100, opened: true, keys: [1,2,3] },
			
			{number: 5, name: "driopitek", heroPos: new Vec(256, 418), time: 40, opened: false, keys: [4] },			
			{number: 6, name: "artist", heroPos: new Vec(292, 384), time: 40, opened: false, keys: [4] },		
			{number: 7, name: "programmer", heroPos: new Vec(296, 406), time: 40, opened: false, keys: [4] },
			{number: 8, name: "artist", heroPos: new Vec(292, 384), time: 9, opened: true, keys: [5,6,7] },	
			
			{number: 9, name: "girl", heroPos: new Vec(233, 413), time: 35, opened: false, keys:[8] },
			{number: 10, name: "gardner", heroPos: new Vec(262, 432), time: 35, opened: false, keys:[8] },
			{number: 11, name: "carlito", heroPos: new Vec(282, 423), time: 35, opened: false, keys:[8] },
			{number: 12, name: "gardner", heroPos: new Vec(262, 432), time: 8, opened: true, keys:[9,10,11] },	
				
			{number: 13, name: "robot", heroPos: new Vec(228, 396), time: 30, opened: false, keys:[12] },
			{number: 14, name: "scientist", heroPos: new Vec(262, 406), time: 30, opened: false, keys:[12] },
			{number: 15, name: "pirate", heroPos: new Vec(272, 415), time: 30, opened: false, keys:[12] },
			{number: 16, name: "scientist", heroPos: new Vec(262, 406), time: 7, opened: true, keys:[13,14,15] },
		];
		//two player level is unlocked if one player key exists
		public static const TWO_PLAYERS_LEVELS:Array = [
			{number: 1, name: "cowboy", opened: false, keys: [] },
			{number: 2, name: "mechanic", opened: false, keys: [] },
			{number: 3, name: "clown", opened: false, keys: [] },
			
			{number: 4, name: "driopitek", opened: false, keys: [4] },			
			{number: 5, name: "artist", opened: false, keys:[4] },		
			{number: 6, name: "programmer", opened: false, keys:[4] },	
			
			{number: 7, name: "girl", opened: false, keys:[8] },
			{number: 8, name: "gardner", opened: false, keys:[8] },
			{number: 9, name: "carlito", opened: false, keys:[8] },
				
			{number: 10, name: "robot", opened: false, keys:[12] },
			{number: 11, name: "scientist", opened: false, keys:[12] },
			{number: 12, name: "pirate", opened: false, keys:[12] },
		];
		
		//player characters
		public static const PLAYER_CHARACTERS:Vector.<PlayerCharacter> = new <PlayerCharacter>[
			new PlayerCharacter("boy_char_", "Leonard"),	
			new PlayerCharacter("alien_char_", "Joobee"),
			new PlayerCharacter("cat_char_", "Princess"),	
			new PlayerCharacter("robot_char_", "R-9"),
			new PlayerCharacter("girl_char_", "Daisy"),			
			new PlayerCharacter("dog_char_", "Sparky"),
		];
		
		//fonts
		public static const DEFAULT_FONT:String = "Franks";
		
		//assets
		public static const screen:Rectangle = new Rectangle(0, 0, 1024, 768);		
		public static var assets:AssetManager;
		public static var frameStep:Number;
		
		//gamer results 
		public static var results:GameResults = new GameResults();
		
		//translates
		public static var I18N:I18n;
		
		//music and fx
		public static var music:SoundManager = SoundManager.getInstance();
		public static var fx:SoundManager = SoundManager.getInstance();
		public static var lastPlayedMusic:String = null;
		public static const MUSIC_VOLUME:Number = 0.3;
		public static const FX_VOLUME:Number = 0.7;
		
		//texture atlas helpers
		public static function getTexture(atlasName:String, textureName:String):Texture 
		{
			return assets.getTextureAtlas(atlasName).getTexture(textureName);
		}
		public static function getTextures(atlasName:String, texturesPrefix:String):Vector.<Texture>
		{
			return assets.getTextureAtlas(atlasName).getTextures(texturesPrefix);
		}
		public static function get FONT_SHADOW_FILTER():BlurFilter {
			
			return null;
			//return BlurFilter.createDropShadow(2, 0.785, 0x0, 0.8, 2, 1);
		}
		public static function get BOX_SHADOW_FILTER():BlurFilter { 
			return null; 
			//return BlurFilter.createGlow(0x0,0.5,15,1);
			//return BlurFilter.createDropShadow(4, 0.785, 0x0, 0.8, 4, 1);
		}
		
		public static function showStats(show:Boolean):void 
		{
			Starling.current.showStats = show;
			if(show) Starling.current.showStatsAt("right", "top",1.5);
		}
	
		
		public static const CREDITS:String = "Match Right 2 Game, 2013 \n" +
											 "To the memory of best friend, dog named Gianny\n\n" +
											 
											 "Programming: Victor Pukman\n" +
											 "Drawing: Lesha Babay\n" +
											 "Font: Franks by Edward Leach\n\n" + 
											 
											 "Music: \n" + 
											 "Main Theme - Private Eye by Kevin MacLeod (http://incompetech.com)\n" +
											 "Cowboy - PLANTATION by Jason Shaw (http://audionautix.com/index.html)\n" +
											 "Plumber - Aces High by Kevin MacLeod (http://incompetech.com)\n" +
											 "Clown - As I Figure by Kevin MacLeod (http://incompetech.com)\n" +
											 "Caveman - Rite of Passage by Kevin MacLeod (http://incompetech.com)\n" + 
											 "Artist - Parisian by Kevin MacLeod (http://incompetech.com)\n" +
											 "Computer Guy - Inside the Zithro Mountains by Welcome Wizard (http://freemusicarchive.org/music/Welcome_Wizard/Lunachild/Inside_the_Zithro_Mountains)\n" +
											 "Girl - Big Car Theft by Jason Shaw (http://audionautix.com/index.html)\n" +
											 "Gardner - BIRD IN HAND by Jason Shaw (http://audionautix.com/index.html)\n" + 
											 "Gangster - Off to Osaka by Kevin MacLeod (http://incompetech.com)\n" +
											 "Robot - Barbarian by Pierlo (http://www.upitup.com)\n" +
											 "Scientist - J. S. Bach: Toccata and Fugue in D Minor by Kevin MacLeod (http://incompetech.com)\n" +
											 "Pirate - A Little Faith by Kevin MacLeod (http://incompetech.com)\n\n" +
											 
											 "Sounds:\n" + 
											 "windingTimer by webGeek (http://www.freesound.org/people/webGeek)\n" + 
											 "Music Box (http://www.soundjay.com/toy-sounds-1.html)\n" + 
											 "Click (http://gamua.com/starling/download/)\n" + 
											 "other sounds from http://www.freesfx.co.uk\n\n" + 
											 
											 "Powered by Starling Framework (http://gamua.com/starling/)";
											 
											 
											 

		
		
	}

}