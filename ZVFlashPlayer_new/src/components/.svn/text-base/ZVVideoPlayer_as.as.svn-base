/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVVideoPlayer_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Abstraction for the various supported video players
*****************************************************************************/
package components
{

	import com.enefekt.tubeloc.Movie;
	import com.enefekt.tubeloc.event.MovieProgressEvent;
	import com.enefekt.tubeloc.event.MovieStateChangeEvent;
	import com.enefekt.tubeloc.event.MovieStateUpdateEvent;
	
	import enums.VideoPlayerType;
	import enums.VideoState;
	
	import events.CommentAddedEvent;
	import events.CommentAddingEvent;
	import events.CommentDeletedEvent;
	import events.ConvoAddingEvent;
	import events.SliderMouseUpdateEvent;
	import events.SliderValueUpdateEvent;
	import events.VideoStatusUpdateEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	
		
	public class ZVVideoPlayer_as extends Canvas
	{		
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _videoPlayerType:uint = 0;
		private var _videoState:int = -1;
		private var _preClickState:uint = VideoState.ENDED;
		private var _preCommentAddState:uint = VideoState.ENDED;
		private var _blockStateChangedEvent:Boolean = false;
		private var _startTime:Number = -1;


		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		private var _youtubePlayer:Movie = new Movie();
		public var tubelocMovie:Movie;
		public var hideTimer:Timer = new Timer(Constants.HIDE_DELAY_AFTER_STOP);

		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVVideoPlayer_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function set videoPlayerType(type:uint):void
		{
			_videoPlayerType = type;
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public function initComponent():void
		{
			hideTimer.addEventListener(TimerEvent.TIMER,onHidePlayer);
		}
			
		public function setupComponent(videoID:String , startTime:Number):void
		{
			if( _videoPlayerType == VideoPlayerType.YOUTUBE )
			{	
				_youtubePlayer.addEventListener(MovieStateUpdateEvent.MOVIE_STATE_UPDATE,videoStateUpdated);
				_youtubePlayer.addEventListener(MovieProgressEvent.MOVIE_PROGRESS,videoProgressUpdated);			
				_youtubePlayer.addEventListener(MovieStateChangeEvent.ON_STATE_CHANGE,videoStateChanged);
				
				_youtubePlayer.x = 0; _youtubePlayer.y = 0;				
				_youtubePlayer.chromeless = true;
				this.addChild(_youtubePlayer);
				
				//_youtubePlayer.videoId= "m8QVg2TWLo8";
				//_youtubePlayer.videoId= "vqQT2yneZOs";
				//_youtubePlayer.videoId = "DnrFhd5DN8E";
				//_youtubePlayer.videoId = "EuAVgWJ28Hw";
				
				_youtubePlayer.videoId = videoID;
				_youtubePlayer.width = this.width; _youtubePlayer.height = this.height;
				
				HouseKeeping.VIDEO_WIDTH = _youtubePlayer.width 
				HouseKeeping.VIDEO_HEIGHT = _youtubePlayer.height 
				
				_startTime = startTime;
			}
	
		}
		
		private function playVideo():void
		{
			
			if( _videoPlayerType == VideoPlayerType.YOUTUBE)
				_youtubePlayer.playVideo();
		}
		
		private function pauseVideo():void
		{
			if( _videoPlayerType == VideoPlayerType.YOUTUBE)
				_youtubePlayer.pauseVideo();
		}
		
		public function pauseIfPlaying():void
		{
			if( _videoState == VideoState.PLAYING )
				pauseVideo();
		}
		
		private function inputCommentAdded():void
		{
			if(  _videoState == VideoState.PLAYING )
			{	
				pauseVideo();
				_preCommentAddState = VideoState.PLAYING;
			}	
		}
		
		private function inputCommentDone():void
		{
			if(  _preCommentAddState == VideoState.PLAYING )
			{	
				playVideo();
				_preCommentAddState = VideoState.ENDED;
			}
		}
		
		public function seekTo(time:Number):void
		{
			this._youtubePlayer.currentTime = time;
		}
		
				
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		//videobar events------------------
		public function onSliderMouseUpdate(event:SliderMouseUpdateEvent):void
		{
			if( event.isMouseDown && _videoState == VideoState.PLAYING )
			{
				_blockStateChangedEvent = true;
				pauseVideo();
				_preClickState = VideoState.PLAYING;
			}
			else if( !event.isMouseDown && _preClickState == VideoState.PLAYING)
			{
				_blockStateChangedEvent = false;
				_preClickState = VideoState.ENDED;
				playVideo();
			}
		}
		
		public function onSliderValueChanged(event:SliderValueUpdateEvent):void
		{	
			seekTo(event.value);
		}
		
		public function onPlayPauseButtonClicked(event:MouseEvent):void
		{
			if( _videoState == VideoState.PLAYING )
				pauseVideo();				
			else if(_videoState == VideoState.PAUSED )
				playVideo();	
			else if( _videoState == VideoState.ENDED )
				seekTo(0);
		}
		
		public function onConvoAdding(event:ConvoAddingEvent):void
		{	
			inputCommentAdded();
		}
		
		public function onCommentAdding(event:CommentAddingEvent):void
		{
			inputCommentAdded();							
		}
		
		public function onCommentAdded(event:CommentAddedEvent):void
		{
			inputCommentDone();	
		}
		
		public function onCommentDeleted(event:CommentDeletedEvent):void
		{
			inputCommentDone();
		}
		
		
		public function onHidePlayer(event:TimerEvent):void
		{
			hideTimer.stop();			
			HouseKeeping.hideFlashPlayer();
		}

		
		
		//----------------------------------
		
		
		//youtube player events------------------
		
		//Records whenever the state of the video changes
		private function videoStateChanged(event:MovieStateChangeEvent):void
		{			
			if( _startTime != -1 && event.stateCode == VideoState.PLAYING )
			{
				seekTo( Math.max( _startTime - Constants.MARGIN_FOR_START , 0));
				_startTime = -1;	
			}
						
			if( !_blockStateChangedEvent )
			{
				var v:VideoStatusUpdateEvent =  new VideoStatusUpdateEvent(VideoStatusUpdateEvent.VIDEO_STATUS_UPDATE);
				v.videoState = _videoState = event.stateCode;
				dispatchEvent(v);
			}
			
			//if( _videoState == VideoState.ENDED )
			//{
			//	hideTimer.start();
			//}
		}
		
		
		//Handles constants video progress updates
		private function videoProgressUpdated(event:MovieProgressEvent):void
		{
			var v:VideoStatusUpdateEvent =  new VideoStatusUpdateEvent(VideoStatusUpdateEvent.VIDEO_STATUS_UPDATE);
			v.currentTime = event.currentTime;
			dispatchEvent(v);				
		}
		
		
		//Handles constants video status updates
		private function videoStateUpdated(event:MovieStateUpdateEvent):void
		{
			
			if( !isNaN(event.duration) && event.duration >= 0)
			{			
				var v:VideoStatusUpdateEvent =  new VideoStatusUpdateEvent(VideoStatusUpdateEvent.VIDEO_STATUS_UPDATE);
				v.duration = event.duration;
				v.startBytes = event.videoStartBytes;
				v.bytesLoaded = event.videoBytesLoaded;
				v.totalBytes = event.videoBytesTotal;				
				dispatchEvent(v) ;
			}
			
		}
		
		//----------------------------------
		
		
				
	  }//Class
		
}//Package

	