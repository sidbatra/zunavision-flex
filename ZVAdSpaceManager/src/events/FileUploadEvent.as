/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    FileUploadEvent.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/

package events
{
	// custom event
	import flash.events.Event;
	public class FileUploadEvent extends Event{
		private var _sender:Object;
		public function FileUploadEvent(sender:Object,type:String,bubbles:Boolean=false,cancelable:Boolean=false){
			super(type,bubbles,cancelable);
			_sender = sender;
		}
		public function get Sender():Object{
			return _sender;
		}
	}
}