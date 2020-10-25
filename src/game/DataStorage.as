package game 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author ...
	 */
	public class DataStorage 
	{
	
		private var name:String;
		public function DataStorage(name:String) 
		{
			this.name = name;
		}
		private function getSaveStream(write:Boolean, sync:Boolean = true):FileStream
		{
			
			var f:File = File.applicationStorageDirectory.resolvePath(name);
			var fs:FileStream = new FileStream();
			try
			{
				// If we are writing asynchronously, openAsync.
				if(write && !sync)
					fs.openAsync(f, FileMode.WRITE);
				else
				{
				 // For synchronous write, or all reads, open synchronously.
				 fs.open(f, write ? FileMode.WRITE : FileMode.READ);
				}
			}
			catch(e:Error)
			{
				// On error, simply return null.
				return null;
			}
			return fs;
		}
	  
		public function load():Object
		{
			var fs:FileStream = getSaveStream(false);
			var data:Object = null;
			if(fs)
			{
				try
				{
					data = fs.readObject();
					fs.close();
					trace("Results Loaded!");
				}
				catch(e:Error)
				{
					trace("Couldn't load due to error: " + e.toString());
				}
			}
		  
			return data;
		}
	  
		public function save(data:Object):void
		{
		  // Get stream and write to it – asynchronously, to avoid hitching.
		  var fs:FileStream = getSaveStream(true, true);
		  if (fs) {
			  
			try {
			  fs.writeObject(data);
			  fs.close();			  
			  trace("Saved!");
			}
			catch (e:Error) 
			{
				trace("Couldn't save due to error: " + e.toString());
			}
			
		  }
		}
		
	}

}