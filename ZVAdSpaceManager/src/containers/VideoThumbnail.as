/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    VideoThumbnail.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/
package containers
{
	import flash.display.BitmapData;
	
	public class VideoThumbnail
	{
		public var thumbnail:String;
		public var databaseID:int;
		public var flexID:int;
		public var numSpots:uint;
		public var url:String;
		public var label:String;
		public var data:String;
		public var bitmapData:BitmapData;
		public var type:uint;
				
		
		public function VideoThumbnail(s:String="", id:int=0, nspots:uint=0, u:String="")
		{
			thumbnail = s;
			databaseID = id;
			numSpots = nspots;
			url= u;
		}

	}
}