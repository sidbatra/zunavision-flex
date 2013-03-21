/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVVideoBar_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Implementation of a video track bar
*****************************************************************************/
package components
{
	

	import containers.User;
	
	import enums.VideoState;
	
	import events.ConvoAddingEvent;
	import events.SliderValueUpdateEvent;
	import events.VideoStatusUpdateEvent;
	
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	
	import utilities.Utilities;
	
	
		
	public class ZVVideoBar_as extends Canvas
	{		
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _videoPlayerType:uint = 0;
		private var _videoState:int = -1;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var zvSlider:ZVSlider;		
		public var playPauseButton:Button;
		public var addReplyButton:Button;
		public var videoTimerLabel:Label;
		
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
		
		public function ZVVideoBar_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		private function get currentTime():Number
		{
			return this.zvSlider.currentTime;
		}
		
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public function initComponent():void
		{
			setSkin(VideoState.PAUSED);
			
			zvSlider.addEventListener(SliderValueUpdateEvent.SLIDER_VALUE_UPDATE,onSliderValueUpdate);
		}
		
		private function updatePlayPauseSkin():void
		{
			if( _videoState == VideoState.PLAYING )
				setSkin(VideoState.PAUSED);
			else
				setSkin(VideoState.PLAYING);
				
		}
		private function setSkin(type:int):void
		{
			if( type == VideoState.PLAYING )
				this.playPauseButton.setStyle("skin",playButtonSkin);
			else if( type == VideoState.PAUSED )
				this.playPauseButton.setStyle("skin",pauseButtonSkin);
				
		}
		
		private function updateTimer(value:Number):void
		{
			videoTimerLabel.text = Utilities.getDisplayTime(value);
		}
		
		public function addTick(time:Number , index:int):void
		{
			zvSlider.addTick(time,index);
		}
		
		public function deleteTick(index:int):void
		{
			zvSlider.deleteTick(index);
		}
		
		public function setDuration(duration:int):void
		{
			if( zvSlider.maximum < 0 )
				zvSlider.maximum = duration; 
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		
		public function onSliderValueUpdate(event:SliderValueUpdateEvent):void
		{	
			if ( event.value != -1 )
				updateTimer(event.value);
			
		}
		
		public function onFullScreenButtonClicked(event:MouseEvent):void
		{			
			switch (this.stage.displayState) 
			{
               case StageDisplayState.FULL_SCREEN:
               		this.stage.displayState = StageDisplayState.NORMAL;
                    break;
				default:				
				 	stage.fullScreenSourceRect = new Rectangle(0,0,this.parent.width,this.parent.height);                   
                    this.stage.displayState = StageDisplayState.FULL_SCREEN;
                   
                break;
		   }
		}
		
		//addReplyButton events---------
		public function onAddReplyClicked(event:MouseEvent):void
		{	
			if( User.isLoggedIn() )
				dispatchEvent( new ConvoAddingEvent(ConvoAddingEvent.CONVO_ADDING,zvSlider.progressLocation(),this.currentTime));
			else
				HouseKeeping.fb_login();
				
		}
		
		
			
		//------------------
		
		//slider events---------
		public function onSliderCreated():void
		{
			HouseKeeping.slider = this.zvSlider;
		}
		//------------------
		
		//videoPlayer events--------------------------
		
		public function onVideoStatusUpdate(event:VideoStatusUpdateEvent):void
		{
			if( zvSlider.maximum < 0 )
				zvSlider.maximum = event.duration; 
				
			if( event.bytesLoaded != -1 )
				zvSlider.onBufferProgress(event.startBytes,event.bytesLoaded,event.totalBytes);
			
			if( event.currentTime != -1)
			{	
				if( !zvSlider.isMouseDown )
					zvSlider.value = event.currentTime;
						
				updateTimer(event.currentTime);
			}
			
			if( event.videoState != -1 && _videoState != event.videoState)
			{
				_videoState = event.videoState;
				updatePlayPauseSkin();
			}
		}
		//------------------------------------------------------------
		
		
						
	  }//Class
		
		
}//Package

			
