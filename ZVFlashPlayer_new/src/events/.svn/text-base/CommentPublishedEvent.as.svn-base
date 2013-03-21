/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    CommentPublishedEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when a comment has been added
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class CommentPublishedEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const COMMENT_PUBLISHED:String = "CommentPublished";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var commentID:int = -1
		public var tagID:int = -1;
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function CommentPublishedEvent(type:String , commentID_p:int , tagID_p:int)
		{
			super(type,true);
			
			commentID = commentID_p;
			tagID = tagID_p;
		}
		
	}
}