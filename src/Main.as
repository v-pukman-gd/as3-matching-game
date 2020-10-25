package 
{
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import game.DebugGrid;
	import game.Game;
	import game.GameResults;
	import game.I18n;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	import starling.utils.RectangleUtil;
	import states.StateManager;
	
	/**
	 * ...
	 * @author [V.I.C]
	 */
	[SWF(frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite 
	{
		private var starling:Starling;
		private var assets:AssetManager;
		private var scaleFactor:uint = 1;
		
		//start screen image from media folder
		[Embed(source = "../media/start_bg.png")]
		private static var StartBitmap:Class;
		private var startBitmap:Bitmap;
		
		//ttf font from media folder
		//[Embed(source = "../media/Franks.ttf",  fontFamily = "Franks", embedAsCFF = "false")]
		//private static var FranksFont:Class;
		
		public function Main():void 
		{
			var viewPort:Rectangle = RectangleUtil.fit(Game.screen, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			trace(viewPort);
			
			//calcualte game scale factor
			
			
			var appDir:File = File.applicationDirectory;
			
            
			assets = new AssetManager(scaleFactor);			
			assets.verbose = Capabilities.isDebugger;
            assets.enqueue(
				appDir.resolvePath("audio/sounds"),
                appDir.resolvePath("fonts"),
				
                appDir.resolvePath("audio/music/main_theme.mp3"),				
                appDir.resolvePath(formatString("textures/{0}x/shared.png", scaleFactor)),
				appDir.resolvePath(formatString("textures/{0}x/shared.xml", scaleFactor))
            );
			
			//add start screen
			startBitmap = new StartBitmap();
			StartBitmap = null;
			startBitmap.smoothing = true;
			startBitmap.x = viewPort.x;
			startBitmap.y = viewPort.y;
			startBitmap.width = viewPort.width;
			startBitmap.height = viewPort.height;
			
			addChild(startBitmap);
			
			
			//load results
			//Game.results.reset();
			//Game.results.save();
			Game.results.load();
			
			//set language
			//Game.I18N = new I18n("en");	 //new I18n(Capabilities.language);
			
			//init game center
			//GameCenter.init();
			
			//init starling
			Starling.handleLostContext = false; //because it is iOS
			starling = new Starling(StateManager, stage, viewPort);
			starling.stage.stageWidth = Game.screen.width;
			starling.stage.stageHeight = Game.screen.height;
			starling.simulateMultitouch = false;
			starling.enableErrorChecking = Capabilities.isDebugger;			
			starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
			
			//some debug stuff
			//var grid:DebugGrid = new DebugGrid(100, 100, 7.68, 10.24);
			//grid.add(stage);
			
			stage.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(flash.events.Event.ACTIVATE, onActivate);
			
			
		}
		
		
		
		
		private function onRootCreated(e:Event, app:StateManager):void 
		{
			starling.removeEventListener(Event.ROOT_CREATED, onRootCreated);
			removeChild(startBitmap);			
			
			var startTxt:Texture = Texture.fromBitmap(startBitmap, false, false, scaleFactor);			
			app.start(startTxt, assets);
			starling.start();
			
		}
		
		private function onDeactivate(e:*):void 
		{
			starling.stop();
		}
		
		private function onActivate(e:*):void 
		{
			starling.start();
		}
		
		
	}
	
}