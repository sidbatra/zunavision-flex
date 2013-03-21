/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    VideoInfoEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when video info is retrevied from the server
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class VideoInfoEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const VIDEO_INFO:String = "VideoInfo";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var info:String = "";
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function VideoInfoEvent(type:String , info_p:String)
		{
			super(type,true);
			
			info = info_p;
		}
		
	}
}