/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ConversationManager.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Maintains data structure & server communication for the ZVConversation.as class
*****************************************************************************/
package containers
{
	import components.ZVConversation;
	
	import events.CommentAddedEvent;
	import events.CommentAddingEvent;
	import events.CommentDeletedEvent;
	import events.ConvoAddedEvent;
	import events.ConvoAddingEvent;
	import events.SliderValueUpdateEvent;
	import events.VideoStatusUpdateEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	
	import utilities.Utilities;
	
	
	public class ConversationManager implements IEventDispatcher
	{
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _dispatcher:EventDispatcher;

		
		private var _convos:Array = new Array();
		private var _hash:Array = new Array();
		
		private var _visibleConvoIndex:int = -1;
		private var _isForceVisible:Boolean = false;
		
		private var _lastStatusUpdate:int = -1;
		
		private var _isWidescreen:Boolean = false;
		private var _fps:Number = 0.0;
		private var _duration:int = 0;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ConversationManager()
		{
			 _dispatcher = new EventDispatcher(this);
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		private function get isConvoVisible():Boolean
		{
			return !(_visibleConvoIndex == -1)
		}
		
		private function get visibleConvoHashTime():uint
		{
			return ( _convos[_visibleConvoIndex] as Conversation ).hashTime;
		}
		
		private function get isForceVisibleConvo():Boolean
		{
			return ( _convos[_visibleConvoIndex] as Conversation ).isMouseInConvo;
		}
		
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		
		public function addConversation(time:Number,location:int,prefix:String , isInput:Boolean=false):int
		{	
			var convo:Conversation = new Conversation(time,location,prefix , isInput);
			 	
			var hashTime:uint = Utilities.toHashTimeStamp(time);
			var index:int = _convos.length;
			
			//Push entry into hash
			if( _hash[hashTime] == null )
				_hash[hashTime] = [index];
			else	
				_hash[hashTime].push(index);
			
			//Push entry into array	
			_convos.push(convo);
			
			convo.displayElement.addEventListener(CommentAddingEvent.COMMENT_ADDING,onCommentAdding);
			convo.displayElement.addEventListener(CommentAddedEvent.COMMENT_ADDED,onCommentAdded);
			convo.displayElement.addEventListener(CommentDeletedEvent.COMMENT_DELETED,onCommentDeleted);
			
			dispatchEvent( new ConvoAddedEvent(ConvoAddedEvent.CONVO_ADDED,convo.displayElement
									,convo.focusElement,time,index,isInput));
			
			if( isInput )
				setVisibleConvo(index);
			
			return index;
		}
		
		public function deleteConversation(index:int , hashTime:uint):void
		{
			var hashArray:Array = _hash[hashTime] as Array;
			hashArray.splice(hashArray.indexOf(index));			
		}
		
		private function computeBestConvoIndex(hashIndex:int):uint
		{
			//Work with only the first convo on that timestamp
			return _hash[hashIndex][0];
		}
		
		private function setBestConvoAsVisible(hashTime:int):void
		{
			for( var i:int=-1 ; i<=Constants.CONVO_DURATION ; i++)
			{ 
				var index:int = hashTime + i;
			
				if( _hash[ index ] != null )
				{	
					setVisibleConvo(computeBestConvoIndex(index));
					break; 
				}
				
			}
		}
		
		private function setVisibleConvo(index:int):void
		{
			if( index == -1 )
				(_convos[_visibleConvoIndex] as Conversation).updateConvoVisibility(false);
			else
				(_convos[index] as Conversation).updateConvoVisibility(true);
			
			_visibleConvoIndex = index;	
		}
		
		private function updateConversationStatus(hashTime:uint):void
		{	
			if( isConvoVisible && Math.abs(hashTime - visibleConvoHashTime) > Constants.CONVO_DURATION && !isForceVisibleConvo
					&& !_isForceVisible)
			{	
				setVisibleConvo(-1);
			}
			else if( !isConvoVisible )
			{	
				setBestConvoAsVisible(hashTime);
			}
		}
		
		private function updateFocusStatus(time:Number):void
		{
			(_convos[ _visibleConvoIndex ] as Conversation).updateFocusPos(time);
		}
		
		//Returns index to which given display element belongs
		private function getIndexOfConversation(convo:ZVConversation):int
		{
			var index:int = -1;
			
			for( var i:uint=0 ; i<_convos.length ; i++)
				if( (_convos[i] as Conversation ).displayElement == convo )
				{
					index = i;
					break;
				}
			
			return index;
		}
		
		public function forceHideConversation():void
		{
			if( isConvoVisible && !isForceVisibleConvo )
				setVisibleConvo(-1);
				
				_isForceVisible = false;
		}
		
		public function forceDisplayConversation(index:int):void
		{
			if( _visibleConvoIndex != index )
			{ 
				if( isConvoVisible )
					setVisibleConvo(-1);
			
				setVisibleConvo(index);
				
				_isForceVisible = true;
			}
			
		}
		
		public function setFocusForVisibleConvo(rect:Rectangle):void
		{	
			if( _visibleConvoIndex != - 1)
			{	
				(_convos[_visibleConvoIndex] as Conversation).setFocusRect(rect,true);	
			}
		}
		
		//Gets the server string for the convo focus if availible
		public function getVisibleFocusServerString():String
		{	
			var convo:Conversation = _convos[_visibleConvoIndex] as Conversation
			var serverString:String = ""
			
			if( convo.isFocusSet )
				serverString += Constants.SERVER_JOIN_CHAR 
									+ convo.focusElement.getServerString( _isWidescreen ? 0 : Constants.WIDESCREEN_X_OFFSET )
			else
				serverString += Constants.SERVER_JOIN_CHAR + "x=-1&y=-1&w=-1&h=-1&b=true" 
				
			return serverString
		}
		
		public function setCommentIDForVisibleConvo(commentID:int,tagID:int):void
		{
			(_convos[_visibleConvoIndex] as Conversation).displayElement.setIDForLastComment(commentID,tagID)
		}
		
		public function videoTimeUpdate(time:Number):void
		{
			if( time != -1)
			{	
				var hashTime:uint = Utilities.toHashTimeStamp(time);
				
				//Update convo status only at the convo update rate, avoids millisec updates
				if( Math.abs( _lastStatusUpdate - hashTime ) >= Constants.CONVO_UPDATE_RATE )
				{
					updateConversationStatus( hashTime );
					_lastStatusUpdate = hashTime;
				}
				
				if( isConvoVisible )
				{
					updateFocusStatus(time);
				}
			}
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		public function onConvoAdding(event:ConvoAddingEvent):void
		{	
			this.forceHideConversation();
			this.addConversation(event.time,event.location,"",true);		
		}
		
		private function onCommentAdding(event:CommentAddingEvent):void
		{
			dispatchEvent( new CommentAddingEvent(CommentAddingEvent.COMMENT_ADDING,-1,-1,-1) );	
		}
		
		private function onCommentAdded(event:CommentAddedEvent):void
		{	
			dispatchEvent( new CommentAddedEvent(CommentAddedEvent.COMMENT_ADDED,event.serverString, event.isSplash) );
		}
		
		private function onCommentDeleted(event:CommentDeletedEvent):void
		{
			var convo:ZVConversation =  (event.currentTarget as ZVConversation);
			var index:int = getIndexOfConversation(convo);
			
			//Remove convo is comment was the last one
			if( convo.isEmpty )
				deleteConversation(index,convo.hashTime);
			
			dispatchEvent( new CommentDeletedEvent(CommentDeletedEvent.COMMENT_DELETED,null,convo
							,(_convos[index] as Conversation).focusElement,convo.isEmpty,index) );
		}
		
		public function onVideoStatusUpdate(event:VideoStatusUpdateEvent):void
		{			
			videoTimeUpdate(event.currentTime);
		}
		
		public function onSliderValueChanged(event:SliderValueUpdateEvent):void
		{	
			videoTimeUpdate(event.value);
		}
		
		//Parses the video information from the server to populate variables & controls
		public function extractVideoInfo(info:String):void
		{			
			var data:Array = info.split(Constants.LINE);
			
			if( data.length > 0 )
			{
				var videoInfo:Array = data[0].toString().split(Constants.SPACE);
				_isWidescreen = videoInfo[0].toString() == "true";
				_fps = (Number)(videoInfo[1]);
				_duration = (int)(videoInfo[2])
				var totalVideoComments:int = (int)(videoInfo[3])
				HouseKeeping.VIDEO_URL = videoInfo[4].toString();
				HouseKeeping.VIDEO_TITLE_SHORT = videoInfo[6].toString();				
				HouseKeeping.VIDEO_THUMB_URL = videoInfo[7].toString();
				var totalConvos:int = (int)(videoInfo[8]);
				
								
				for( var i:uint=1 ; i< data.length - 1  ;   )
				{	
					
				
					var convoInfo:Array = data[i].toString().split(Constants.SPACE);
					var totalComments:int = (int)(convoInfo[0]);
					var time:Number = (Number)(convoInfo[1]);
				
					var convoIndex:int = addConversation(time,HouseKeeping.sliderXFromTime(time,_duration),"");
					var convo:Conversation = (_convos[convoIndex] as Conversation)
					
					var isTagDone:Boolean = false;
					
					//Add every comment
					for( var c:uint=1  ; c<= totalComments * 3 ; c+= 3)
					{	
				
						if( !isTagDone )
						{
							isTagDone = true;
							convo.addFocusElement(data[i+c+1].toString().split(Constants.SPACE) ,  _isWidescreen ? 0 : Constants.WIDESCREEN_X_OFFSET);
						}
						
						var commentInfo:Array = data[i+c].toString().split(Constants.SPACE);
						var user:User = User.getUserFromServerString(data[i+c+2].toString());
						
						convo.addComment(user,(int)(commentInfo[0]),commentInfo[1].toString(),commentInfo[2].toString());
						
					}//comments
					
					convo.displayElement.resetUI();
					
					i += totalComments * 3 + 1;
				
				}//convos 
					
					
		
			}//if data > 0
		}
				
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