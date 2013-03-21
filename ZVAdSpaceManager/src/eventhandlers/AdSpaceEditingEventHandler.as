/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    AdSpaceEditingEventHandler.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Encapsulates all the adspace editing related event handlers
*****************************************************************************/

package eventhandlers
{
	import components.ZVAdSpaceEditor_as;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	
	public class AdSpaceEditingEventHandler
	{
		
		public static var _zvEditor:ZVAdSpaceEditor_as ;
			
		//Mouse move on the videoUIC component of the ZVASE	
		public static function videoUIC_mouseMove(event:MouseEvent):void
		{	
			_zvEditor._currentMousePosition = new Point(event.localX,event.localY);
			//Update coordinates as mouse moves
		 	//if(_zvEditor._adSpaceHandler.selectedStatus && _zvEditor._adSpaceHandler._selectedCoordinateIndex != -1 )
 			//{	
 			//	_zvEditor._adSpaceHandler.updateAdSpaceCoordinate(event.localX,event.localY);
 			//	_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer, _zvEditor.timeStamp);
 			//}
		}	
		
		//Mouse up on the videoUIC component of the ZVASE
		public static function videoUIC_mouseUp(event:MouseEvent):void 
		{			
			_zvEditor._saveTrackingInfo = false;
			_zvEditor._contentID++;
			
			/*_zvEditor._graphicsLayer.renderAdSpace(_zvEditor._currentAdSpace);
				
				if (_zvEditor._currentAdSpace._coordinates.length == Constants.DEFAULT_POINTS_IN_ADSPACE) 
				{
					_zvEditor._currentAdSpace._startTimeStamp = _zvEditor.timeStamp; 
					_zvEditor._currentAdSpace._displayTime = _zvEditor.getDisplayTime(_zvEditor.videoProgressSlider.value);
					_zvEditor._currentAdSpace._creativeName = Constants.DEFAULT_CREATIVE_NAME;
					_zvEditor._currentAdSpace._creativeID = Constants.DEFAULT_CREATIVE_ID;
					
					_zvEditor._adSpaceHandler.insertAdSpace(_zvEditor._currentAdSpace , null);
					
					_zvEditor.adSpaceDataGrid.selectedIndex = _zvEditor._adSpaceHandler._adSpaceData.length-1;
					_zvEditor.updateSelectedAdSpace();
					_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
															
					_zvEditor._currentAdSpace._coordinates = new Array();				
				}
				else if( _zvEditor._currentAdSpace._coordinates.length == 0 && _zvEditor._adSpaceHandler.selectedStatus)
				{
					if( _zvEditor._adSpaceHandler._selectedCoordinateIndex != -1 )
					{
						//_zvEditor._adSpaceHandler.resetSelection();
						_zvEditor._adSpaceHandler._selectedCoordinateIndex = -1;// .resetSelection();
						_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
					}
					
				}
				
				_zvEditor.stage.focus = _zvEditor.videoUIC;*/
		}
		
		//Mouse down on the videoUIC component of the ZVASE
 		public static function videoUIC_mouseDown(event:MouseEvent):void 
 		{	
 			_zvEditor._saveTrackingInfo = true;
 			/*
			//Flags whether the user initiated a reset selection 	
			var wasReset:Boolean = false;
				
				//If user is not in process of creating an adpspace			
				if ( _zvEditor._currentAdSpace.coordinateSize == 0 )
				{
					
					_zvEditor._adSpaceHandler.selectAdSpace(event.localX,event.localY,_zvEditor.timeStamp);
						
					//Set the selected index in the datagrid
					if ( _zvEditor._adSpaceHandler.selectedStatus )
						_zvEditor.adSpaceDataGrid.selectedIndex = _zvEditor._adSpaceHandler._selectedDataIndex;
					
				}
						
						
				if ( !_zvEditor._adSpaceHandler.selectedStatus  )//&& !wasReset )
					_zvEditor._currentAdSpace.addCoordinate( new Point(event.localX,event.localY) );
				else
					_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
					*/
											
		}
		
		 //Handles keystrokes on the stage of the ZVASE
 		public static function stage_keyDown(event:KeyboardEvent):void
 		{
 			 				
 				if ( _zvEditor._adSpaceHandler.selectedStatus )
				{
					if( _zvEditor._internalDataEntryMode != -1 )
					{							
						_zvEditor._adSpaceHandler.updateProcessingParameters(_zvEditor._internalDataEntryMode,(int)(event.keyCode - 48));							
						_zvEditor._internalDataEntryMode++;
						
						if( _zvEditor._internalDataEntryMode == Constants.ADSPACE_PARAMETER_DEFAULTS.length )
							_zvEditor._internalDataEntryMode = -1;							
					}
					else
					{						 				
		 				switch (event.keyCode) 
		 				{	 	
		 							
			 				case 13: //Enter			 				
								_zvEditor._adSpaceHandler.resetSelection();
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);						
							
			 				break
							case 46://Delete
								_zvEditor._adSpaceHandler.deleteAdSpace();
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
								
							break;
							case 38://up 
								_zvEditor._adSpaceHandler.updateAdSpacePosition(0,-Constants.YSHIFT_ADSPACE);
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
								
							break;
							case 40://down
								_zvEditor._adSpaceHandler.updateAdSpacePosition(0,Constants.YSHIFT_ADSPACE);
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
								
							break;
							case 37://left
								_zvEditor._adSpaceHandler.updateAdSpacePosition(-Constants.XSHIFT_ADSPACE,0);
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
								
							break;
							case 39://right
								_zvEditor._adSpaceHandler.updateAdSpacePosition(Constants.XSHIFT_ADSPACE,0);
								_zvEditor._adSpaceHandler.drawAdSpaces(_zvEditor._graphicsLayer,_zvEditor.timeStamp);
								
							break;
							
							case 77: //m
								_zvEditor._internalDataEntryMode = 0;								
							break
	 
						}//switch
					
					}//if internal mode
				}//if selected
			
			switch (event.keyCode) 
	 		{
 				case 69: //e
					_zvEditor._adSpaceHandler.markEndFrame(_zvEditor.timeStamp);
				break
				case 82: //r
					_zvEditor._adSpaceHandler.markBackwardEndFrame(_zvEditor.timeStamp);
				break 
			}//switch
		
			
 		}
 		
 		
		
		
	}//class

	
}//package
