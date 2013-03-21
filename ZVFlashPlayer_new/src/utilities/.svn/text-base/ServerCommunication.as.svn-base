/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ServerCommunication.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Handles communication with the main server
*****************************************************************************/
package utilities
{
	
	import enums.RequestType;
	
	import events.CommentPublishedEvent;
	import events.UserInfoEvent;
	import events.VideoInfoEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	
	public class ServerCommunication implements IEventDispatcher
	{
		
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
		private var _dispatcher:EventDispatcher;
		
		private var _remoteObject:RemoteObject;
		
		
		private var _videoID:int = -1;		
		private var _userID:int = -1;
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get videoID():int
		{
			return _videoID;
		}
		
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
				
		public function ServerCommunication(videoID_p:int , userID_p:int) 
		{
			_dispatcher = new EventDispatcher(this);
			
			_videoID = videoID_p;
			_userID = userID_p;
			
			_remoteObject = new RemoteObject();
			_remoteObject.destination = Constants.DATABASE_INFO_URL; 
			_remoteObject.addEventListener(FaultEvent.FAULT , onReadInfoFault);
			_remoteObject.getUserInfo.addEventListener(ResultEvent.RESULT, onUserInfo);
			_remoteObject.getVideoInfo.addEventListener(ResultEvent.RESULT, onVideoInfo);
		}
		
		//Checks the server for any info about the current video
		public function getVideoInfo():void
		{	
			_remoteObject.getVideoInfo(_videoID);		
		}
		
		public function getUserInfo():void
		{	
			if( _userID != -1 )
				_remoteObject.getUserInfo(_userID);
		}
		

  		
  		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		

		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
	
		public function addComment( requestData:String):void
		{
			requestData += Constants.SERVER_JOIN_CHAR + "v=" + _videoID
			
			sendServerRequest( RequestType.ADD_COMMENT , requestData);
		}
		
		public function addView():void
		{
			var requestData:String = "v=" + _videoID ;
			
			if ( _userID != -1 )
				requestData += Constants.SERVER_JOIN_CHAR + "u=" + _userID;
				
			sendServerRequest(RequestType.VIEW_VIDEO,requestData);				
		}
		
		public function sendServerRequest( requestType:uint , data:String ):void
		{	
			//Initialize request
			var request:URLRequest = new URLRequest(); 
	    	
	    	request.data = data;
			request.url = Constants.WEBSITE_ROOT + Constants.SERVER_REQ_URL[requestType];
			request.method = Constants.SERVER_REQ_METHOD;
			
			//navigateToURL(new URLRequest(request.url + "?" + request.data),"_blank");
			
			var loader:URLLoader = new URLLoader();
			
			if( requestType == RequestType.ADD_COMMENT )
    			loader.addEventListener(Event.COMPLETE,onAddCommentRequestComplete);
    			
    		loader.addEventListener(IOErrorEvent.IO_ERROR,onServerRequestError);
    		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onServerRequestError);
    		loader.load(request);
		}
		
						
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		private function onServerRequestError(event:ErrorEvent):void
		{
			Alert.show("Error in sending server request " +  event.text + " " + event.type  );
		}
		
		
		private function onAddCommentRequestComplete(event:Event):void
		{			
			var loader:URLLoader = URLLoader(event.target);
			var vars:URLVariables = new URLVariables(loader.data);
			
			dispatchEvent(new CommentPublishedEvent(CommentPublishedEvent.COMMENT_PUBLISHED,(int)(vars.comment_id)
																							,(int)(vars.tag_id)));
		}
				
		
		//Weborb read events---------
				
		//Handles when the video information is recieved from the server
		private function onVideoInfo(event:ResultEvent):void
		{
			var videoInfo:Object = event.result;
			dispatchEvent(new VideoInfoEvent(VideoInfoEvent.VIDEO_INFO,videoInfo.videoInfo));
  		}
  		
  		//Handles the user information sent by the server
		private function onUserInfo(event:ResultEvent):void
		{
			var userInfo:Object = event.result;
			dispatchEvent(new UserInfoEvent(UserInfoEvent.USER_INFO,userInfo.userInfo));
  		}
		
		private function onReadInfoFault(event:FaultEvent):void
		{
			Alert.show("Weborb Read Info Error " + event.message.toString() );
		}
		
		//-------------------------------
		
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		
		       
	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
	        _dispatcher.addEventListener(type, listener, useCapture, priority);
	    }
	           
	    public function dispatchEvent(evt:Event):Boolean{
	        return _dispatcher.dispatchEvent(evt);
	    }
	    
	    public function hasEventListener(type:String):Boolean{
	        return _dispatcher.hasEventListener(type);
	    }
	    
	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        _dispatcher.removeEventListener(type, listener, useCapture);
	    }
	                   
	    public function willTrigger(type:String):Boolean {
	        return _dispatcher.willTrigger(type);
	    }
		
	}//class
	
}//package

