/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVFlashPlayer_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Main mxml for the Flash Player
*****************************************************************************/
package
{
	
	import components.ZVToolTip;
	import components.ZVVideoBar;
	import components.ZVVideoFocus;
	import components.ZVVideoPlayer;
	
	import containers.ConversationManager;
	import containers.User;
	
	import events.CommentAddedEvent;
	import events.CommentAddingEvent;
	import events.CommentDeletedEvent;
	import events.CommentPublishedEvent;
	import events.ConvoAddedEvent;
	import events.ConvoAddingEvent;
	import events.SliderMouseUpdateEvent;
	import events.SliderValueUpdateEvent;
	import events.TickMouseUpdateEvent;
	import events.UserInfoEvent;
	import events.VideoInfoEvent;
	import events.VideoStatusUpdateEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.managers.ToolTipManager;
	
	import utilities.ServerCommunication;
		
	public class ZVFlashPlayer_as extends Application
	{		
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _convoManager:ConversationManager = new ConversationManager();
		private var _serverComm:ServerCommunication = null;
		
		private var _isVideoFocus:Boolean = false;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var videoPlayer:ZVVideoPlayer;
		public var videoBar:ZVVideoBar;
		public var videoFocus:ZVVideoFocus;
		
		public var hideButton:Button;
		
		public var globalMessageTextArea:TextArea;
		
		public var convoContainer:Canvas;
		public var focusContainer:Canvas;
		
		public var globalToolTip:ZVToolTip ;
		public var globalTipTimer:Timer = new Timer(Constants.GLOBAL_TOOL_TIP_DUR);
			
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVFlashPlayer_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		private function videoBarStatus(enable:Boolean):void
		{
			this.videoBar.enabled = enable;
		}
		
		private function launchVideoFocus():void
		{
			videoFocus = new ZVVideoFocus();
			videoFocus.verticalScrollPolicy = "false"; videoFocus.horizontalScrollPolicy = "false";
			videoFocus.width = this.videoPlayer.width ; videoFocus.height = this.videoPlayer.height;
			
			this.addChildAt(videoFocus,this.numChildren - Constants.FOCUS_LIST_OFFSET);
			
			_isVideoFocus = true;
		}
		
		private function removeVideoFocus():void
		{
			if( _isVideoFocus )
			{
				this.removeChild(videoFocus);
				_isVideoFocus = false;
			}
				
		}
		
		private function transferVideoFocus():void
		{
			if( _isVideoFocus && videoFocus.isSet )
			{
				_convoManager.setFocusForVisibleConvo(videoFocus.focusArea);
			}
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		// Initialize the Application
		public function initApplication():void 
		{
			
			var videoHostingID:String = Application.application.parameters.hosting_id;
			var videoID:int = Application.application.parameters.video_id
			var userID:int = Application.application.parameters.user_id
			var startTime:Number = Application.application.parameters.time
			var embed:Boolean = Application.application.parameters.embed == "true"
			HouseKeeping.COMMENT_ID = Application.application.parameters.comment_id
			HouseKeeping.OBJ_ID = Application.application.parameters.o_id
			
			_serverComm = new ServerCommunication(videoID,userID);
			_serverComm.getUserInfo();
			_serverComm.getVideoInfo();
			_serverComm.addView();
			_serverComm.addEventListener(UserInfoEvent.USER_INFO,onUserInfo);
			_serverComm.addEventListener(VideoInfoEvent.VIDEO_INFO,onVideoInfo);
			_serverComm.addEventListener(CommentPublishedEvent.COMMENT_PUBLISHED,onCommentPublished);
			
			hideButton.visible = embed;
			
			//Video player event listeners & functions
			videoPlayer.setupComponent(videoHostingID,startTime);			
			videoPlayer.addEventListener(VideoStatusUpdateEvent.VIDEO_STATUS_UPDATE,onVideoStatusUpdate);			
			//---------------------------
			
			//Video bar event listeners & functions
			videoBar.addEventListener(SliderValueUpdateEvent.SLIDER_VALUE_UPDATE,onSliderValueChanged);
			videoBar.addEventListener(SliderMouseUpdateEvent.SLIDER_MOUSE_UPDATE,onSliderMouseUpdate);
			videoBar.addEventListener(ConvoAddingEvent.CONVO_ADDING,onConvoAdding);
			videoBar.addEventListener(TickMouseUpdateEvent.TICK_MOUSE_UPDATE,onTickMouseUpdate);
			videoBar.playPauseButton.addEventListener(MouseEvent.CLICK,onPlayPauseButtonClicked);
			
			//if( embed )	
			//	videoBar.setStyle("backgroundColor","#595959");
				
			
			//---------------------------
			
			//Conversation manager event listeners
			_convoManager.addEventListener(CommentAddingEvent.COMMENT_ADDING , onCommentAdding);
			_convoManager.addEventListener(CommentAddedEvent.COMMENT_ADDED , onCommentAdded);
			_convoManager.addEventListener(CommentDeletedEvent.COMMENT_DELETED,onCommentDeleted);
			_convoManager.addEventListener(ConvoAddedEvent.CONVO_ADDED , onConvoAdded);
			//---------------------------
			
			//Javascript event listeners
			ExternalInterface.addCallback("seekTo",javascriptSeekTo)
			//---------------------------
			
			//ToolTip settings
			ToolTipManager.showDelay = Constants.TOOL_TIP_DELAY;
			//globalToolTip.toolTipText = "Add a droplet, share your insight"
			//globalTipTimer.addEventListener(TimerEvent.TIMER,globalTipTimerTick);
			//globalTipTimer.start();
			//---------------------------			
			
			//Housekeeping inits
			HouseKeeping.globalMessageTextArea = globalMessageTextArea;
			//---------------------------
			
		}
		
		
		
		//VideoPlayer events----------------------
		private function onVideoStatusUpdate(event:VideoStatusUpdateEvent):void
		{
			this.videoBar.onVideoStatusUpdate(event);
			_convoManager.onVideoStatusUpdate(event);	
		}
		//-----------------------------------------
		
		
		//VideoBar events--------------------------
		private function onSliderValueChanged(event:SliderValueUpdateEvent):void
		{
			this.videoPlayer.onSliderValueChanged(event);
			_convoManager.onSliderValueChanged(event);
		}
		
		private function onSliderMouseUpdate(event:SliderMouseUpdateEvent):void
		{
			this.videoPlayer.onSliderMouseUpdate(event);
		}
		
		private function onConvoAdding(event:ConvoAddingEvent):void
		{	
			this.videoPlayer.onConvoAdding(event);
			this._convoManager.onConvoAdding(event);
			videoBarStatus(false);
			ExternalInterface.call("message_finish_droplet");
		}
		
		private function onPlayPauseButtonClicked(event:MouseEvent):void
		{
			this.videoPlayer.onPlayPauseButtonClicked(event);
		}
		
		private function onTickMouseUpdate(event:TickMouseUpdateEvent):void
		{			
			if( event.isMouseIn )
			{	
				_convoManager.forceDisplayConversation(event.convoIndex);
			}
			else
			{
				_convoManager.forceHideConversation();
				videoBarStatus(true);
			}
		}
		
		//-----------------------------------------
		
		//Conversation Manager events--------------------------
		private function onConvoAdded(event:ConvoAddedEvent):void
		{	
			
			this.convoContainer.addChild(event.displayElement);
			this.focusContainer.addChild(event.focusElement);
						
			this.videoBar.addTick(event.time , event.index);
						
			if( event.isInput )
			{
				event.displayElement.finishCreation();
				this.launchVideoFocus();
			}		
		}
		
		private function onCommentAdding(event:CommentAddingEvent):void
		{
			videoPlayer.onCommentAdding(event);
			videoBarStatus(false);
			ExternalInterface.call("message_finish_droplet");
		}
		
		private function onCommentAdded(event:CommentAddedEvent):void
		{
			if( !event.isSplash )
			{
				videoPlayer.onCommentAdded(event);
				videoBarStatus(true);
			
				transferVideoFocus();			
				removeVideoFocus();
			}
			
			_serverComm.addComment(event.serverString + _convoManager.getVisibleFocusServerString());
			
		}
		
		private function onCommentDeleted(event:CommentDeletedEvent):void
		{
			if( event.wasLast )
			{
				this.convoContainer.removeChild(event.convo);
				this.focusContainer.removeChild(event.convoFocus);
				this.videoBar.deleteTick(event.index);
				
				removeVideoFocus();
			}
			
			videoPlayer.onCommentDeleted(event);
			videoBarStatus(true);
			ExternalInterface.call("message_add_droplet");
		}
		//-----------------------------------------
		
		//ServerCommunication events--------------------------
		private function onUserInfo(event:UserInfoEvent):void
		{
			User.setCurrentUser(event.info);
		}
		
		private function onVideoInfo(event:VideoInfoEvent):void
		{	
			var duration:int = (int)((event.info.split(Constants.LINE)[0] as String).split(Constants.SPACE)[2] as String)
			this.videoBar.setDuration(duration);
			
			_convoManager.extractVideoInfo(event.info);		
		}
		
		private function onCommentPublished(event:CommentPublishedEvent):void
		{
			_convoManager.setCommentIDForVisibleConvo(event.commentID,event.tagID);
			ExternalInterface.call("message_share_droplet",event.commentID);
		}
		//-----------------------------------------
		
		//Timer events--------------------------
		private function globalTipTimerTick(event:TimerEvent):void
		{	
			globalTipTimer.stop();
			globalToolTip.visible = false;
		}
		//-----------------------------------------
		
		//Javascript events--------------------------
		private  function javascriptSeekTo(time:String):void
		{
			videoPlayer.seekTo( Math.max( (Number)(time) - Constants.MARGIN_FOR_START ,0));
		}
		//-----------------------------------------
				
	  }//Class
		
	}//Package

	
	