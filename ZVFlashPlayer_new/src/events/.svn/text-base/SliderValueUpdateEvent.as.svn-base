/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    SliderValueUpdateEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Used to transfer updates about the video slider value
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class SliderValueUpdateEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------		
		public static const SLIDER_VALUE_UPDATE:String = "SliderValueUpdate";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------		
		public var value:Number = -1;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function SliderValueUpdateEvent(type:String , value_p:Number)
		{
			super(type,true);
			value = value_p;
		}
		
	}
}