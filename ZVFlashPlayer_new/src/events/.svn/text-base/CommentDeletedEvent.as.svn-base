/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    CommentDeletedEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when a comment has been deleted
*****************************************************************************/
package events
{
	import components.ZVComment_as;
	import components.ZVConversation;
	import components.ZVConvoFocus;
	
	import flash.events.Event;

	public class CommentDeletedEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------		
		
		public static const COMMENT_DELETED:String = "CommentDeleted";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var comment:ZVComment_as = null;
		public var convo:ZVConversation = null;
		public var convoFocus:ZVConvoFocus = null
		
		public var wasLast:Boolean = false;
		public var index:int = -1;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function CommentDeletedEvent(type:String , comment_p:ZVComment_as , convo_p:ZVConversation=null, 
												convoFocus_p:ZVConvoFocus=null , wasLast_p:Boolean=false , index_p:int=-1)
		{
			super(type,true);
			comment = comment_p;
			convo = convo_p;
			convoFocus = convoFocus_p;
			wasLast = wasLast_p;
			index = index_p;
		}
		
		
		
	}//class
}//package