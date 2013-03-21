/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    AdSpace.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>, Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Encapsulates all the data & methods associated with an adspace within the video
*****************************************************************************/
package containers
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
		
	public class AdSpace extends Object 
	{	
		public var _index:uint;		//Index of the adspace amongst all the video adspaces
		public var _hashIndex:uint;		//Index of the adspace amongst all the video adspaces in the adSpaceHash row
		public var _coordinates:Array;	//Coordinates of the adspace	
		
		public var _endBTimeStamp:Number;	//End time stamp backward in time
		public var _startTimeStamp:Number;	//Start time stamp
		public var _endFTimeStamp:Number;	//End time stamp forward in time
		
		public var _displayTime:String;		//String used to display time
		
		public var _creativeName:String;	//Name of the assigned creative
		public var _creativeID:uint;		//ID of the assigned creative
				
		public var _processingParameters:Array;		//Additional parameters defining the processing of the ad-space
		
		public var _creativeData:BitmapData;		//The ad creative data associated with the adspace
		
		
		//Default constructor, sets up default values for data members
		public function AdSpace()
		{
			//Initialize arrays
			_coordinates = new Array();
			_processingParameters = new Array(Constants.ADSPACE_PARAMETER_DEFAULTS.length);
			
			//Set default values for parameters
			for( var i:uint=0 ; i<Constants.ADSPACE_PARAMETER_DEFAULTS.length ; i++) 
				_processingParameters[i] = Constants.ADSPACE_PARAMETER_DEFAULTS[i];
			
			_endFTimeStamp = -1; _endBTimeStamp = -1;
			
		}
		
		
		//Creates a shallow copy of the adspace
		public function copy():AdSpace
		{
			//Initialize adspace objects and its arrays
			var copy:AdSpace = new AdSpace();
			
			//Copy the coordinates
			for(var i:uint=0; i<_coordinates.length; i++) 
				copy._coordinates[i] = _coordinates[i];
				
			//Copy the processing parameteres
			for(i=0; i<_processingParameters.length; i++) 
				copy._processingParameters[i] = _processingParameters[i];
			
			copy._endBTimeStamp = _endBTimeStamp;
			copy._startTimeStamp = _startTimeStamp;
			copy._displayTime = _displayTime;			
			copy._endFTimeStamp = _endFTimeStamp;
			
			copy._creativeID = _creativeID
			copy._creativeName = _creativeName;
			copy._index = _index;
			copy._hashIndex = _hashIndex;
			
			copy._creativeData = _creativeData.clone();
				
			return copy;
		}
		
		//Returns the total number of coordinates added to the space
		public function get coordinateSize():uint
		{
			return _coordinates.length;
		}
		
		//Inserts a new coordinate into the coordinate array
		public function addCoordinate(coordinate:Point):void
		{
			_coordinates.push(coordinate);
		}
		
		
	}//class
	
}//package
	
	