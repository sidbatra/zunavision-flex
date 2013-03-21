/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    AdSpaceHandler.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Handles adspace related storage and editing operations
*****************************************************************************/
package containers
{
	
	//Flash imports
	import components.GraphicsLayer;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	//----------------------------------
			
	
	public class AdSpaceHandler extends Object
	{	
		
		[Bindable]
		public var _adSpaceBindableData:ArrayCollection;		//Array collection for _adSpaceData used for binding to datagrid
		public var _adSpaceData:Array;		//Array of type AdSpace		
		public var _adSpaceHash:Array; 		//Hash that point to indices in adSpaceData
		
		public var _selectedIndex:int;		//Selected index of an adspace within the hash table
		public var _selectedDataIndex:int;		//Selected index of an adspace within the actual array
		public var _selectionTimeStamp:Number;	//Time stamp of the selected adspace
		public var _selectedCoordinateIndex:int;	//Selected coordinate of the selected adspace			
		public var _scale:Number;				//Amount by which all the adspaces have been scaled
		
		public var _isRenderJob:Boolean;		//Indicates whether a rendering or tracking job is needed to process the video
		
		//Constructor Logic
		public function AdSpaceHandler() 
		{			
			_adSpaceHash = new Array();
			_adSpaceData = new Array();
			
			_isRenderJob = true;
						
			resetSelection();
									
			_scale = 1.0;
		}
				
		//Returns status of an adspace being selected
		public function get selectedStatus():Boolean
		{
			return (_selectedIndex != -1);
			
		}
		
		//Resets all selection related data members
		public function resetSelection():void
		{
			_selectedCoordinateIndex = -1;
			_selectedIndex = -1;			
			_selectionTimeStamp = -1;
			_selectedDataIndex = -1;
		}
		
		//Marks an end frame forward in time based on the given time stamp 
		public function markEndFrame(endTimeStamp:Number):void
		{	
			//Holds frame time stamp for which given endTimeStamp is valid
			var finalTimeStamp:Number = Number.MIN_VALUE;	
		
			//Search for adspace for which endTimeStamp is valid
			for( var i:uint=0 ; i<_adSpaceData.length ; i++ )
			{
				if( endTimeStamp > _adSpaceData[i]._startTimeStamp && _adSpaceData[i]._startTimeStamp > finalTimeStamp )
					finalTimeStamp = _adSpaceData[i]._startTimeStamp;
			}
			
			//If valid adspace was found
			if( finalTimeStamp != -1 )
			{
				//Mark end forward frame for all adspaces associated with that time stamp
				for( i=0 ; i<_adSpaceHash[finalTimeStamp].length ; i++)
					_adSpaceData[_adSpaceHash[finalTimeStamp][i]]._endFTimeStamp = endTimeStamp;
			}
			
			_isRenderJob = false;
			
		}
		
		//Marks an end frame backward in time based on the given time stamp 
		public function markBackwardEndFrame(endTimeStamp:Number):void
		{	
			//Holds frame time stamp for which given endTimeStamp is valid
			var finalTimeStamp:Number = Number.MAX_VALUE;	
		
			//Search for adspace for which endTimeStamp is valid
			for( var i:uint=0 ; i<_adSpaceData.length ; i++ )
			{
				if( endTimeStamp < _adSpaceData[i]._startTimeStamp && _adSpaceData[i]._startTimeStamp < finalTimeStamp )
					finalTimeStamp = _adSpaceData[i]._startTimeStamp;
			}
			
			//If valid adspace was found
			if( finalTimeStamp != -1 )
			{
				//Mark end backward frame for all adspaces associated with that time stamp
				for( i=0 ; i<_adSpaceHash[finalTimeStamp].length ; i++)
					_adSpaceData[_adSpaceHash[finalTimeStamp][i]]._endBTimeStamp = endTimeStamp;
			}
		
			_isRenderJob = false;
			
		}

		
		//Scales the ad-spaces based on the given scale factor 
		public function scaleAdSpaces(scaleDelta:Number):void
		{
			//Update total scaling applied to adspaces
			_scale *= scaleDelta;
			
			//Update the adspace coordinates of each adspace
			for( var i:uint=0 ; i<_adSpaceData.length ; i++ )
				for( var j:uint=0 ; j<_adSpaceData[i]._coordinates.length ; j++ )
				{
					_adSpaceData[i]._coordinates[j].x *= scaleDelta;
					_adSpaceData[i]._coordinates[j].y *= scaleDelta;
				}
			
		}
		
		
		//Inserts the given frame meta data into the video meta data object		 
		public function insertAdSpace(adSpaceData:AdSpace , creativesFeed:ArrayCollection):void
		{	
			
			adSpaceData._index = _adSpaceData.length + 1;
			
			//Create new hash for the fresh ad-space
			if( _adSpaceHash[adSpaceData._startTimeStamp] == null )
			{
				_adSpaceHash[adSpaceData._startTimeStamp] = [_adSpaceData.length];
				adSpaceData._hashIndex = 0;
			}			
			else	
			{
				_adSpaceHash[adSpaceData._startTimeStamp].push(_adSpaceData.length);
				adSpaceData._hashIndex = _adSpaceHash[adSpaceData._startTimeStamp].length -1;
			}
				
			
			//If assigned creative is not a default one, search for corresponding bitmapdata
			if( adSpaceData._creativeID != Constants.DEFAULT_CREATIVE_ID )
			{
				//Iterate over each creative in the creative feed given
				for( var i:uint=0 ; i<creativesFeed.length ; i++)	
				{
					if( creativesFeed[i].databaseID == adSpaceData._creativeID )
						adSpaceData._creativeData = creativesFeed[i].bitmapData.clone();
				}
			}
				
				
			_adSpaceData.push( adSpaceData.copy() );
			
			_adSpaceBindableData = new ArrayCollection(_adSpaceData);
			
			_isRenderJob = false;
		}
		
		//Deletes the selected adspace
		public function deleteAdSpace():void
		{	
			var index:uint = _adSpaceHash[_selectionTimeStamp][_selectedIndex];
			
			//Update index in the hash table for every adspace after the one to be deleted
			for( var i:uint=index+1 ; i<_adSpaceData.length ; i++ )
			{
				_adSpaceHash[_adSpaceData[i]._startTimeStamp][_adSpaceData[i]._hashIndex] -= 1;
				_adSpaceData[i]._index -= 1;
			}
				
			//Remove adspace
			_adSpaceData.splice(index,1);
			
			//Update index in the hash table for every adspace in the selected row after the one to be deleted
			for( i=_selectedIndex+1 ; i<_adSpaceHash[_selectionTimeStamp].length ; i++ )
				_adSpaceData[ _adSpaceHash[_selectionTimeStamp][i] ]._hashIndex -= 1;
				
			_adSpaceHash[_selectionTimeStamp].splice(_selectedIndex,1);
						
			resetSelection();
			
			_adSpaceBindableData = new ArrayCollection(_adSpaceData);
			
			_isRenderJob = false;
		}
		
		
		//Sets the creative information for the given adspace
		public function setCreativeInformation(adSpace:AdSpace , imageID:int , imageName:String , bitmapData:BitmapData):void 
		{
			var index:uint = _adSpaceHash[adSpace._startTimeStamp][adSpace._hashIndex];
			
			_adSpaceData[index]._creativeName = imageName;
			_adSpaceData[index]._creativeID = imageID;
			_adSpaceData[index]._creativeData = bitmapData.clone();
			
			_adSpaceBindableData = new ArrayCollection(_adSpaceData);
			
		}
		
		//Updates the processing parameters for the selected ad-space
		public function updateProcessingParameters(parameterIndex:uint , value:uint):void
		{
			_adSpaceData[ _adSpaceHash[_selectionTimeStamp][_selectedIndex] ]._processingParameters[parameterIndex] = value;												
		}
					

		
		//Updates the location of the entire selected adspace
		public function updateAdSpacePosition(xDiff:Number , yDiff:Number):void
		{	
			var index:uint = _adSpaceHash[_selectionTimeStamp][_selectedIndex];
			
			for( var j:uint=0 ; j<_adSpaceData[index]._coordinates.length ; j++ )
			{
				_adSpaceData[ index ]._coordinates[j].x += xDiff;
				_adSpaceData[ index ]._coordinates[j].y += yDiff;
			}		
			
			_isRenderJob = false;
		}
		
		//Updates the location of the selected coordinate of the adspace
		public function updateAdSpaceCoordinate(x:Number , y:Number):void
		{	
			_adSpaceData[ _adSpaceHash[_selectionTimeStamp][_selectedIndex] ]._coordinates[_selectedCoordinateIndex].x = x;
			_adSpaceData[ _adSpaceHash[_selectionTimeStamp][_selectedIndex] ]._coordinates[_selectedCoordinateIndex].y = y;
			
			_isRenderJob = false;
			
		}
		
		//Checks whether an entire adspace or an adspace coordinate has been selected
		public function selectAdSpace(x:Number , y:Number , frameTimeStamp:Number):void
		{
			resetSelection();
			
			//If there are adspaces at this time stamp
			if( _adSpaceHash[frameTimeStamp] != null )
			{
				//Test all spaces at this time stamp
				for( var i:uint=0 ; i<_adSpaceHash[frameTimeStamp].length ; i++)
				{
					//Index in the adSpaceData array
					var index:uint = _adSpaceHash[frameTimeStamp][i];
					
					for( var j:uint=0 ; j<_adSpaceData[index]._coordinates.length ; j++)
					{
						if(	Math.abs(_adSpaceData[index]._coordinates[j].x - x ) < Constants.SELECTION_RADIUS &&
							Math.abs(_adSpaceData[index]._coordinates[j].y - y ) < Constants.SELECTION_RADIUS )
							{					
								_selectedIndex = i;
								_selectedCoordinateIndex = j;
								_selectedDataIndex = index;
								_selectionTimeStamp = frameTimeStamp;
								break;
							} //if found						
					}//j
										
				}//i
				
				if( _selectedIndex == -1 )
				{
					//Test all spaces at this time stamp
					for( i=0 ; i<_adSpaceHash[frameTimeStamp].length ; i++)
					{
						//Index in the adSpaceData array
						index = _adSpaceHash[frameTimeStamp][i];
						
						var p1:Point = _adSpaceData[index]._coordinates[0];
						var p2:Point;
						var totalIntercepts:uint = 0;
						
						for( j=1 ; j<=_adSpaceData[index]._coordinates.length ; j++ )
						{
							p2 = _adSpaceData[index]._coordinates[ j % _adSpaceData[index]._coordinates.length];
							
							if ( y > Math.min(p1.y,p2.y)) 
							{
				  				if (y <= Math.max(p1.y,p2.y)) 
				  				{
									if (x <= Math.max(p1.x,p2.x)) 
									{
										if (p1.y != p2.y) 
										{
											var xinters:Number = (y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
											if (p1.x == p2.x || x <= xinters)
												totalIntercepts++;
										}
									}
								}
							}
	
							p1 = p2;
							 
						}//j
						
							//If intercepts are not even
						if( totalIntercepts % 2 == 1 )
						{
							_selectedIndex = i;							
							_selectionTimeStamp = frameTimeStamp;
							_selectedDataIndex = index;
							break;								
						}											
											
					}//i
					
				}//if coordinates has not been selected
				
			}//if spaces availible
									
			
		}
		
		//Draws all availbile ap spaces based on the timestamp and graphics layer
		public function drawAdSpaces(graphicsLayer:GraphicsLayer , frameTimeStamp:Number):void
		{	
			//Clean any existing graphics on the layer
			graphicsLayer.clean();
			
			//If adspace information on the given timestamp
			if( _adSpaceHash[frameTimeStamp] != null )
			{				 
				for( var i:uint=0 ; i<_adSpaceHash[frameTimeStamp].length ; i++)
					graphicsLayer.renderAdSpace(_adSpaceData[_adSpaceHash[frameTimeStamp][i]],i == _selectedIndex);							
			}
		}
		
	}//class
	
}//package
	