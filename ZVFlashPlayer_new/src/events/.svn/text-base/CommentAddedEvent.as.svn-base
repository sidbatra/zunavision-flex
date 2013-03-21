/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    CommentAddedEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when a comment has been added
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class CommentAddedEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const COMMENT_ADDED:String = "CommentAdded";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var serverString:String = ""
		public var isSplash:Boolean = false
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function CommentAddedEvent(type:String , serverString_p:String , isSplash_p:Boolean)
		{
			super(type,true);
			
			serverString = serverString_p;
			isSplash = isSplash_p;
		}
		
	}
}