/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVPreviewPlayer_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Main mxml for the Preview Player
*****************************************************************************/
package
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.VideoDisplay;
	import mx.core.Application;
	import mx.events.VideoEvent;

	public class ZVPreviewPlayer_as extends Application
	{
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _commentID:String =  "";
		private var _hostingID:String =  "";
		private var _videoID:String =  "";
		private var _userID:String =  "";
		private var _time:String =  "";
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var videoPlayer:VideoDisplay;
		public var testLabel:Label;		
		public var playPauseButton:Button;
		public var globalTimer:Timer = new Timer(150);
		public var playTimer:Timer = new Timer(600);
		
		
		
		//-------------------------------------------------------------------
		//
		// Skins
		//
		//-------------------------------------------------------------------
		[Embed("./images/playButtonSkin.png")]
        public const playButtonSkin:Class
            
        [Embed("./images/pauseButtonSkin.png")]
        public const pauseButtonSkin:Class
			
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function ZVPreviewPlayer_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		private function play():void
		{
			videoPlayer.play();
			this.playPauseButton.setStyle("skin",pauseButtonSkin);
		}
		
		private function pause():void
		{
			videoPlayer.pause();
			this.playPauseButton.setStyle("skin",playButtonSkin);
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		public function initApplication():void
		{	
			playTimer.addEventListener(TimerEvent.TIMER,onPlayTimer);
			globalTimer.addEventListener(TimerEvent.TIMER,onTimer);
			videoPlayer.addEventListener(VideoEvent.COMPLETE,onComplete);
			
			var videoURL:String = Application.application.parameters.v_url
			
			_commentID = Application.application.parameters.c_id.toString();
			_hostingID = Application.application.parameters.h_id.toString();
			_videoID = Application.application.parameters.v_id.toString();
			_userID = Application.application.parameters.u_id.toString();
			_time = Application.application.parameters.t.toString();
			
			//videoURL = "http://zunavision_node_tag_video.s3.amazonaws.com/3.flv";
			
			videoPlayer.source = videoURL;
			
			globalTimer.start();
			
			
		}
		
		public function onPlayTimer(event:TimerEvent):void
		{
			playTimer.stop();
			play();
		}
		
		public function onTimer(event:TimerEvent):void
		{	
			globalTimer.stop();
			
			
			if( ExternalInterface.call("getValue","mouse_" + _commentID) == "false" )
				pause();
			else
				alpha=1.0
		}
		
		
		public function onClick(event:MouseEvent):void
		{
			
			pause();
			
			if( ExternalInterface.call("current_browser" ) != "Netscape" || ExternalInterface.call("current_os" ) == "Linux" )
				ExternalInterface.call("embed_player", 0, _commentID , _videoID,_hostingID,_userID,_time )
		
		}
		
		public function onRollOver(event:MouseEvent):void
		{	
			playTimer.start();
			//play();
		}
		
		public function onRollOut(event:MouseEvent):void
		{
			playTimer.stop();
			pause();
		}
		
		public function onComplete(event:VideoEvent):void
		{
			this.playPauseButton.setStyle("skin",playButtonSkin);
		}
		
	}
	
}

