/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    SliderMouseUpdateEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Transfers information about mouse events on the slider
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class SliderMouseUpdateEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------		
		public static const SLIDER_MOUSE_UPDATE:String = "SliderMouseUpdate";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------		
		public var isMouseDown:Boolean = false;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function SliderMouseUpdateEvent(type:String , mouseDown:Boolean)
		{
			super(type,true);
			isMouseDown = mouseDown;
		}
		
	}
}