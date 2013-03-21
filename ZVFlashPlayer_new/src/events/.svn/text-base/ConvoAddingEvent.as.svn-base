/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ConvoAddingEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Fired when an event is about to be added
*****************************************************************************/
package events
{
	import flash.events.Event;
	
	import utilities.Utilities;

	public class ConvoAddingEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const CONVO_ADDING:String = "ConvoAdding";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		
		public var location:int = -1;
		public var time:Number = -1;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ConvoAddingEvent(type:String , location_p:int , time_p:Number )
		{
			super(type,true);
			location = location_p;
			time = time_p;
		}
		

		
	}
}