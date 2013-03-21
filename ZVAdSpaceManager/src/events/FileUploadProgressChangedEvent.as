/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    FileUploadProgress.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/

package events
{
	
	import flash.events.Event;
	
	public class FileUploadProgressChangedEvent extends FileUploadEvent
	{
		private var _bytesUploaded:uint;
		
		public function FileUploadProgressChangedEvent(sender:Object,bytesUploaded:uint,type:String,
		bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(sender,type,bubbles,cancelable);
			_bytesUploaded = bytesUploaded;
		}

		public function get BytesUploaded():Object
		{
			return _bytesUploaded;
		}
	}
}