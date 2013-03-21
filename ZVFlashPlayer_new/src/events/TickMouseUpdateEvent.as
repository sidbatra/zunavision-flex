/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    TickMouseUpdateEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Transfers information about mouse events on the slider tick
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class TickMouseUpdateEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------		
		public static const TICK_MOUSE_UPDATE:String = "TickMouseUpdate";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------		
		public var isMouseIn:Boolean = false;
		public var convoIndex:int = -1;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function TickMouseUpdateEvent(type:String , mouseIn:Boolean, convoIndex_p:int)
		{
			super(type,true);
			isMouseIn = mouseIn;
			convoIndex = convoIndex_p;
		}
		
	}
}