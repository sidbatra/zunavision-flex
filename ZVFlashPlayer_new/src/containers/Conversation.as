/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    Conversation.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Encapsulation for a conversation which is a set of comments
*****************************************************************************/
package containers
{
	import components.ZVConversation;
	import components.ZVConvoFocus;
	
	import flash.geom.Rectangle;
	
	import utilities.Utilities;
	
	
	public class Conversation
	{
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _time:Number = 0.0;
		private var _isFocusSet:Boolean = false;
		private var _isTimeWithinTrack:Boolean = false;
		
		private var _displayElement:ZVConversation ;
		private var _focusElement:ZVConvoFocus ;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function Conversation(time:Number , location:int , prefix:String , isInput:Boolean)
		{	
			_displayElement = new ZVConversation();
			_displayElement.initialize();
			_displayElement.initComponent();
			
			
			_displayElement.setupComment(isInput,location,time);
			
			if( isInput )
				_displayElement.addInputComment(-1,prefix);
			
			_focusElement = new ZVConvoFocus();
			_focusElement.visible = false;
			
			_time = time;
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get time():Number
		{
			return _time;
		}
		
		public function get displayElement():ZVConversation
		{
			return _displayElement;
		}
		
		public function get focusElement():ZVConvoFocus
		{
			return _focusElement;
		}

		public function get hashTime():uint
		{
			return Utilities.toHashTimeStamp(_time);
		}
		
		public function get isMouseInConvo():Boolean
		{
			return displayElement.isMouseIn;
		}
		
		public function get isFocusSet():Boolean
		{
			return _isFocusSet;
		}
		
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public function addComment(user:User , commentID:int , text:String , thumbURL:String):void
		{
			this.displayElement.addComment(user,commentID,text, thumbURL);
		}
		
		public function addFocusElement(info:Array , xOffset:int):void
		{
			if( info[5] == "false" )
			{
				setFocusRect( new Rectangle( 
							Utilities.normalize((int)(info[1]),Constants.SERVER_VIDEO_DIM,HouseKeeping.VIDEO_WIDTH-2*xOffset)+xOffset,
							Utilities.normalize((int)(info[2]),Constants.SERVER_VIDEO_DIM,HouseKeeping.VIDEO_HEIGHT),
							Utilities.normalize((int)(info[3]),Constants.SERVER_VIDEO_DIM,HouseKeeping.VIDEO_WIDTH-2*xOffset),
							Utilities.normalize((int)(info[4]),Constants.SERVER_VIDEO_DIM,HouseKeeping.VIDEO_HEIGHT)
											) , false)
			}
		}
		
		public function setFocusRect(rect:Rectangle , isVisible:Boolean):void
		{	
			_isFocusSet = true;
			
			_focusElement.x = rect.x ; _focusElement.y = rect.y;
			_focusElement.width = rect.width ; _focusElement.height = rect.height;
			
			this._focusElement.visible = isVisible;
		}
		
		public function updateFocusPos(time:Number):void
		{
			if( _isFocusSet )
			{
				_isTimeWithinTrack = Math.abs(time - _time) < Constants.CONVO_DURATION
				//_focusElement.x -= 1
				
				if( _isTimeWithinTrack )
					this._focusElement.visible = true;
				
			}
		}
		
		public function updateConvoVisibility(status:Boolean):void
		{	
			this._displayElement.visible = status;
			
			if( _isFocusSet )
			{
				 if( status && _isTimeWithinTrack )
					this._focusElement.visible = status;
				else if( !status )
					this._focusElement.visible = status;
			}
			
		}

	}
}