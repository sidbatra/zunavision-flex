/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ConvoAddedEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when a conversation has been added
*****************************************************************************/
package events
{
	import components.ZVConversation;
	import components.ZVConvoFocus;
	
	import flash.events.Event;

	public class ConvoAddedEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const CONVO_ADDED:String = "ConvoAdded";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var displayElement:ZVConversation;
		public var focusElement:ZVConvoFocus
		public var time:Number = -1;
		public var index:int = -1;
		public var isInput:Boolean = false;
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ConvoAddedEvent(type:String , displayElement_p:ZVConversation
						 , focusElement_p:ZVConvoFocus , time_p:Number , index_p:int , isInput_p:Boolean )
		{
			super(type,true);
			this.displayElement = displayElement_p;
			this.focusElement = focusElement_p;
			this.time = time_p;
			this.index = index_p;
			this.isInput = isInput_p;
		}

	}
}