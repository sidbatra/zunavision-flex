/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    VideoSetupEventHandler.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>, Sid Batra <sid@zunavision.com> (seems to contain pieces of code written earlier in: ApplicationClass) 
** DESCRIPTION:
** Encapsulates all the adspace editing related event handlers
*****************************************************************************/

package eventhandlers
{
	import components.ZVAdSpaceEditor_as;
	import components.ZVAdSpaceManager_as;
	
	import enums.MediaEntityType;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	
	public class VideoSetupEventHandler
	{
		
		//Pointer to the main ZVAdSpaceManager_as object on the heap
		public static var _zvManager:ZVAdSpaceManager_as ;
		public static var _zvEditor:ZVAdSpaceEditor_as ;
			
			
		//-------------------------------------------------------------------
		//
		// Input/Output Video Handlers
		//
		//-------------------------------------------------------------------
			
		//Handles UI shift when a user clicks on an video	
		public static function thumbnailSelected(event:MouseEvent, data:Object):void
		{	
			if (data.type == MediaEntityType.VIDEO) 
			{
				if (_zvManager._uploadOnlyUser==false)
				{
					_zvManager._currentVideoID = data.databaseID;				
					_zvManager.launchAdSpaceEditor(data.url,data.label,data.numSpots > 0);
				}
			}
			else if (data.type==MediaEntityType.OUTPUT_VIDEO) 
			{
				_zvManager.launchAdSpaceEditor(data.url,data.label,false,true);
			}		
			else if (data.type==MediaEntityType.CREATIVE) 
			{
				creativeSelected(data.flexID,data.databaseID,data.label,data.bitmapData);
			}	
		}
			
		//Handles video deletion when a user clicks on an  video	
		public static function thumbnailDeleted(event:MouseEvent,data:Object):void
		{	
			_zvManager.removeThumbnailFromUI(data.databaseID, data.type);	
			_zvManager._serverComm.sendServerRequest(data.type, data.databaseID);
			
		}
		
		//-------------------------------------------------------------------
		//
		// Creative Handler
		//
		//-------------------------------------------------------------------
		
		
		//Handles creative creation
		public static function creativeCreated(event:FlexEvent, data:Object):void
		{	
			//Set thumbnail control as invisible for the first thumbnail
			if (data.type==MediaEntityType.CREATIVE) 
			{
				if( data.flexID == -1 )
					event.currentTarget.visible = false;
			}
		}
		
		//Handles user click on a creative	
		public static function creativeSelected(internalID:int, databaseID:int, 
				label:String, bitmapData:BitmapData):void
		{	
			//Launch upload box only when first creative is clicked
			if( internalID == -1 )
			{	
				if(_zvManager._creativeFileTypes != null && _zvManager._creativeFileTypes != "")	
				{
				    if(_zvManager._creativeFileTypeDescription == null || _zvManager._creativeFileTypeDescription == "")
				       _zvManager._creativeFileTypeDescription = _zvManager._creativeFileTypes;
				        
				    var filter:FileFilter = new FileFilter(_zvManager._creativeFileTypeDescription,_zvManager. _creativeFileTypes);
	                
	                _zvManager._creativeFileRefList.browse([filter]);
				}
				else
				    _zvManager._creativeFileRefList.browse();
			}
			else
			{
				_zvEditor.setCreativeForSelectedItem(databaseID,label,bitmapData);				
			}
						
		}
		
			
		//-------------------------------------------------------------------
		//
		// ZVAdSpaceEditor Handlers
		//
		//-------------------------------------------------------------------
		
		//Handles the confirmation of adspace data being saved by the user
		public static function adSpaceDataSaved(event:MouseEvent):void
		{
			_zvEditor.stopVideo();
			_zvManager.closeZVAdSpaceEditor();			
			_zvManager.sendMetaDataToServer();
						
		}
		
		//Handles the cancels of a adspace editing session
		public static function adSpaceEditingCancelled():void
		{
			_zvEditor.stopVideo();
			_zvManager.closeZVAdSpaceEditor();			
			
		}
		
		//Called when the scale has been computed by the adspace editor
		public static function adSpaceScaleReady(scale:Number):void
		{
			_zvManager.requestServerFileMetaData(_zvManager._currentZnaFilename);
		}
			
		
				
	}//class

	
}//package
