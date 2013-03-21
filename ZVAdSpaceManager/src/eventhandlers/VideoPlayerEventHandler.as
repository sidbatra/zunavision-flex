/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    VideoPlayerEventHandler.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Encapsulates all the videeo player related event handlers
*****************************************************************************/

package eventhandlers
{
	import components.ZVAdSpaceEditor_as;
	
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.events.SliderEvent;
	import mx.controls.Alert;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.net.*;
	
	public class VideoPlayerEventHandler
	{
		
		public static var _zvEditor:ZVAdSpaceEditor_as ;
		
		// Handles the stream length response after a call to requestStreamLength
		public static function streamLengthHandler(e:OvpEvent):void 
		{
			trace("Stream length is " + e.data.streamLength);
			
			_zvEditor.videoProgressSlider.enabled = true;
			_zvEditor.videoProgressSlider.maximum = e.data.streamLength;			
			_zvEditor._streamLength = e.data.streamLength;
			
			_zvEditor.videoProgressSlider.visible = true;				
			
		}
		
		// Handles the OvpEvent.PROGRESS event fired by the OvpNetStream class
   		public static function updateHandler(e:OvpEvent):void
   		{   
   			if( _zvEditor._playBtnStatePlaying )
   			{			
   				_zvEditor.videoTimerText.text =  _zvEditor._ns.timeAsTimeCode;   			
   				_zvEditor.videoProgressSlider.value=_zvEditor._ns.time;
   			}   				
   			
   			  			
   			_zvEditor.bufferProgressBar.setProgress(_zvEditor._ns.bytesLoaded,_zvEditor._ns.bytesTotal);
   			_zvEditor._renderedFrames = Math.floor(_zvEditor._ns.time * _zvEditor._fps);
   				
   		}
		
		// Handles all OvpEvent.ERROR events
		public static function errorHandler(e:OvpEvent):void 
		{
			trace("Error #" + e.data.errorNumber+": " + e.data.errorDescription, "ERROR");
		}
		
		// Handles NetStatusEvent.NET_STATUS events fired by the OvpConnection class
		public static function netStatusHandler(e:NetStatusEvent):void 
		{
			trace(e.info.code);
			
			switch (e.info.code) 
			{
				case "NetConnection.Connect.Rejected":
					trace("Rejected by server. Reason is " + e.info.description);
					break;
				case "NetConnection.Connect.Success":
					_zvEditor.netConnectionFound();
					break;
			}
		}

		// Handles the NetStatusEvent.NET_STATUS events fired by the OvpNetStream class			
		public static function streamStatusHandler(e:NetStatusEvent):void 
		{
			trace("streamStatusHandler() - event.info.code="+e.info.code);
			
			switch(e.info.code) 
			{
				case "NetStream.Buffer.Full":
					// _waitForSeek is used to stop the videoProgressSlider from updating
					// while the stream transtions after a seek
					break;			
				case "NetStream.Play.Stop":		
					_zvEditor.refreshVideo();
				break;		
			}
		}
		
		// Handles the OvpEvent.NETSTREAM_PLAYSTATUS events fired by the OvpNetStream class
		public static function streamPlayStatusHandler(e:OvpEvent):void 
		{		
			trace(e.data.code);
		}
			
		// Handles the OvpEvent.NETSTREAM_METADATA events fired by the OvpNetStream class	
		public static function metadataHandler(e:OvpEvent):void 
		{
			 
			for (var propName:String in e.data) 
				trace("metadata: "+propName+" = "+e.data[propName]);				
			
			
			if ( !_zvEditor.videoBox.visible )
			{ 
				_zvEditor.videoPlayButton.enabled = true;
				_zvEditor._video.x = 0;
				_zvEditor._video.y = 0;
				_zvEditor._video.width = e.data.width;
				_zvEditor._video.height = e.data.height;
				
				_zvEditor._scale = (_zvEditor._originalVideoContainerHeight) / (_zvEditor._video.height + 0.0);		
							
				_zvEditor.scaleVideo(_zvEditor._scale);				
				_zvEditor.videoBox.visible = true;
				
				_zvEditor._videoStatsLoaded = true;
				
				_zvEditor.launchApplication();
				
			}
							
		}

		//Sets up the download of the movie file
		public static function downloadVideoHandler(event:MouseEvent):void
		{	
			_zvEditor._downloadRequest = new URLRequest(_zvEditor._downloadURL);
			
			_zvEditor._fileReference = new FileReference();
			_zvEditor._fileReference.download(_zvEditor._downloadRequest);
						
		}
		
		
		// Handles video player play  & pause events
		public static function playPauseHandler(event:MouseEvent):void 
		{			
			if (_zvEditor._playBtnStatePlaying) 
			{
				_zvEditor._ns.pause();			 
				_zvEditor.videoPlayButton.setStyle("skin",_zvEditor.playButtonStyle);
			}
			else 
			{
				_zvEditor._graphicsLayer.clean();
				_zvEditor._ns.resume();
				_zvEditor.videoPlayButton.setStyle("skin",_zvEditor.pauseButtonStyle);
			}
			
			_zvEditor._playBtnStatePlaying = !_zvEditor._playBtnStatePlaying;			
		}
		
		//Handles change in the value of the slider
		public static function videoProgressHandler(event:SliderEvent):void
		{				 		
			_zvEditor.seekStream(event.value,false);						
		}
		
		//Handles change in the value of the slider via dragging the thumb
		public static function videoProgressDragHandler(event:SliderEvent):void
		{	
			if( _zvEditor._playBtnStatePlaying )
				VideoPlayerEventHandler.playPauseHandler(new MouseEvent(""));
				
			_zvEditor.seekStream(event.value,false);						
		}
		
		//-----------------------------------------------------------------------------
		
	}//class

	
}//package
