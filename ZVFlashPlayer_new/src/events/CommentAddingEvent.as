/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    CommentAddingEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Fired when a comment is about to be added
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class CommentAddingEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const COMMENT_ADDING:String = "CommentAdding";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		
		public var location:int = -1;
		public var time:Number = -1;
		public var commentID:int = -1;
		public var prefix:String = "";
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function CommentAddingEvent(type:String , location_p:int , time_p:Number , commentID_p:int ,prefix_p:String = "")
		{
			super(type,true);
			location = location_p;
			time = time_p;
			commentID = commentID_p;
			prefix = prefix_p;
			
		}
		
	}
}