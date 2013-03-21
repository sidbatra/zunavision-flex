/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ServerCommunication.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com> , Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Handles communication with the main server
*****************************************************************************/
package utilities
{
	
	import containers.AdSpaceHandler;
	import containers.VideoThumbnail;
	import eventhandlers.ServerCommunicationEventHandler;
	
	import enums.MediaEntityType;
	
	
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	//---------------------------------
	
	
	public class ServerCommunication
	{
		
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
		
		
		private var _serverNonce:String;
		private var _userID:int;
		
		public var _websiteRoot:String;
		public var _authenticateString:String;
				
		public var _str:String="";
		public var _remoteObject:RemoteObject;
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
				
		public function ServerCommunication(parameters:Object) 
		{
			//_str = s;
			_remoteObject = new RemoteObject();			
			_remoteObject.destination = Constants.FEED_URL;
			_remoteObject.addEventListener("fault", ServerCommunicationEventHandler.onFault);
			
			_websiteRoot = unescape(parameters.webroot); //"http://www.zunavision.com/";
			setAuthenticateString(parameters.server_nonce, parameters.uid);
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		
		public function requestThumbnailList(): void 
		{
			_remoteObject.getComputerInfo(_userID);
		}
		
		//Sets the authentication string needed for server communication
		public function setAuthenticateString(sn:String, uid:String):void 
		{
			_serverNonce = sn;
			_userID = new Number(uid);
			_authenticateString = "sn=" + _serverNonce + "&uid=" + _userID;
		}

		//Converts the given adspace meta data information to a server string
		public function convertMetaDataToServerString(ash:AdSpaceHandler):void 
		{
			//Start with info common to all spaces
			_str = ash._adSpaceData.length.toString() + Constants.SPACE + Constants.DEFAULT_FRAME_EXT + Constants.LINE;
			
			//Iterate over each adspace
			for( var r:uint=0 ; r<ash._adSpaceData.length ;r++)
			{
				
				_str += ash._adSpaceData[r]._coordinates.length + Constants.SPACE + ash._adSpaceData[r]._endBTimeStamp + Constants.SPACE;
				_str += ash._adSpaceData[r]._startTimeStamp + Constants.SPACE + ash._adSpaceData[r]._endFTimeStamp + Constants.SPACE;
				_str += ash._adSpaceData[r]._creativeID + Constants.SPACE + ash._adSpaceData[r]._creativeName + Constants.SPACE + Constants.DEFAULT_CREATIVE_EXT + Constants.SPACE;
				_str += ash._adSpaceData[r]._processingParameters[0] + Constants.SPACE + ash._adSpaceData[r]._processingParameters[1] + Constants.SPACE; 
				_str +=	ash._adSpaceData[r]._processingParameters[2] + Constants.SPACE + ash._adSpaceData[r]._processingParameters[3] +
						Constants.SPACE + ash._adSpaceData[r]._processingParameters[4] + Constants.LINE;
				
				//Iterate over each coordinate in the adspace
				for( var j:Number=0 ; j<ash._adSpaceData[r].coordinateSize; j++ ) 
				{
					_str += ash._adSpaceData[r]._coordinates[j].x / ash._scale + Constants.SPACE;
					_str += ash._adSpaceData[r]._coordinates[j].y / ash._scale + Constants.LINE;
				}//j

			}//i
			
			//Finish up
			_str += Constants.END;
		}
		
				
		public function unpackServerMessage(str:String, type:uint=0):ArrayCollection 
		{
			var msg:Array = unescape(str).split("AND");
			var vidArray:ArrayCollection = new ArrayCollection();
			
			var packetLength:uint = new uint(msg[0]);
			
			for(var x:uint=1; x<msg.length-1; x+=packetLength) 
			{
					var vid:VideoThumbnail = new VideoThumbnail();
					
					vid.databaseID = int(msg[x]);
					vid.flexID = int(msg[x+1]);
					vid.thumbnail = _websiteRoot + msg[x+2];
					vid.url = _websiteRoot + msg[x+3];
					vid.label = UtilityFunctions.truncateString(msg[x+4], 20);
					vid.data = vid.label;
					vid.type = type;
					
					if(packetLength>=6) 
					{
						vid.numSpots = int(msg[x+5]);
						if(vid.numSpots>0)
							vid.label += "   (" + vid.numSpots + ")";
					}
					else {
						vid.numSpots = 0;
					}
					
					vidArray.addItem(vid);
			}
			
			return vidArray;
		}
		
		
		//Handles requests to the server
		public function sendServerRequest( requestType:uint , uniqueID:uint ):void
		{
			//Initialize request
			var request:URLRequest = new URLRequest(); 
	    	
	    	//Form request data based on request type
	    	if ( requestType == MediaEntityType.META_DATA )
	    	{
	    		request.data = _authenticateString + Constants.SERVER_VIDEO_PARAM + uniqueID 
	    		+ Constants.SERVER_REQ_ID_NAME[requestType] + _str;
	    	}
	    	else
        		request.data = _authenticateString + Constants.SERVER_REQ_ID_NAME[requestType] + uniqueID;
        		
			request.url = _websiteRoot + Constants.SERVER_REQ_URL[requestType]; 
			request.method = Constants.SERVER_REQ_METHOD[requestType];
			
    		sendToURL(request);
    		
			
		}
		
		
		
	}//class
	
}//package