/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    VideoStatusUpdateEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Used to transfer video status updates
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class VideoStatusUpdateEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		public static const VIDEO_STATUS_UPDATE:String = "VideoStatusUpdate";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var duration:Number = -1;
		public var startBytes:Number = -1;
		public var bytesLoaded:Number = -1;
		public var totalBytes:Number = -1;
		public var currentTime:Number = -1;
		public var videoState:Number = -1;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function VideoStatusUpdateEvent(type:String)
		{
			super(type,true);
		}
		
	}
}