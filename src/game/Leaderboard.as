package game 
{
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import flash.utils.Dictionary;
	import starling.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class Leaderboard 
	{
		private var boardId:String;
		private var score:int;
		
		private var debugLabel:TextField;
		public function Leaderboard() 
		{
			boardId = "Leaderboard";
		}
		
		public function reportScore(debugLabel:TextField = null):void 
		{
			this.debugLabel = debugLabel;
			
			//calculate total player score
			score = 0;
			var completedLevels:Dictionary = Game.results.onePlayer;
			for each (var level:Object in completedLevels) 
			{
				score += level.score;
			}
			
			//deal with game center
			try {				
				if (GameCenter.isSupported) {					
					GameCenter.localPlayerAuthenticated.add(authSuccess);
					GameCenter.localPlayerNotAuthenticated.add(authFailed);
					GameCenter.authenticateLocalPlayer();
				}
			}
			catch (e:Error) { log("game center error " + e.message); }
		}
		
		private function authFailed():void 
		{
			log("auth failed");
			GameCenter.localPlayerAuthenticated.remove(authSuccess);
			GameCenter.localPlayerNotAuthenticated.remove(authFailed);
		}
		
		private function authSuccess():void 
		{
			log("auth success");
			
			GameCenter.localPlayerAuthenticated.remove(authSuccess);
			GameCenter.localPlayerNotAuthenticated.remove(authFailed);
			
			//report score to leaderboard
			GameCenter.localPlayerScoreReported.add(reportSuccess);
			GameCenter.localPlayerScoreReportFailed.add(reportFailed);
			GameCenter.reportScore(boardId, score);
		}
	
		private function reportFailed():void 
		{
			log("report failed");
			GameCenter.localPlayerScoreReported.remove(reportSuccess);
			GameCenter.localPlayerScoreReportFailed.remove(reportFailed);			
		}
		
		private function reportSuccess():void 
		{
			log("report success");
			
			GameCenter.localPlayerScoreReported.remove(reportSuccess);
			GameCenter.localPlayerScoreReportFailed.remove(reportFailed);
			
			//show leaderboard
			GameCenter.showStandardLeaderboard(boardId);
		}
		
		private function log(txt:String):void {
			//if(debugLabel) debugLabel.text = txt;
		}
		
	}

}