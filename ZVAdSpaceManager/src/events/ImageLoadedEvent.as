/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ImageLoadedEvent.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>, Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/

package events
{	
	 import flash.display.*;
	 import flash.events.Event;
	 

		//Event called when as image is loaded from a remote source
        public class ImageLoadedEvent extends Event
        {        	
        	public var _bitmapData:BitmapData = null;
        	public var _bitmap:Bitmap = null;
        	public var _index:Number = -1;
                
            // Public constructor. 
            public function ImageLoadedEvent(type:String,bmpData:BitmapData , bmp:Bitmap , index:Number)             
            {
                // Call the constructor of the superclass.
                super(type);
                
             	_bitmapData = bmpData;
             	_bitmap = bmp;
             	_index = index;
            }

            // Override the inherited clone() method. 
            override public function clone():Event 
            {
                return new ImageLoadedEvent(type, _bitmapData, _bitmap,_index);
            }
    }//class

	
}//package