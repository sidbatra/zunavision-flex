/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVConversation_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Component for video conversations
*****************************************************************************/
package components
{
	import containers.User;
	
	import enums.ConversationState;
	
	import events.CommentAddedEvent;
	import events.CommentAddingEvent;
	import events.CommentDeletedEvent;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.events.StateChangeEvent;
	
	import utilities.Utilities;
	
	

	public class ZVConversation_as extends Canvas
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		private const BEAK_WIDTH:uint = 7;
		private const BEAK_HEIGHT:uint = 14;
		private const MARGIN_FOR_TOTAL_COMMENTS:uint = 20;
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _beakPosition:int = -1;
		
		private var _time:Number = -1;
		
		private var _defaultX:int = -1;
		private var _defaultY:int = -1;
		private var _defaultWidth:int = -1;
		private var _defaultCommentHeight:int = -1;
		
		private var _isMouseIn:Boolean = false;
		private var _isInputMode:Boolean = false;
		
		private var _preAddState:String = "";
				
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var commentsCanvas:Canvas;
		[Bindable]public var expandContractButton:Button;
		public var totalCommentsLabel:Label;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVConversation_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get beakPosition():int
		{
			return _beakPosition ;
		}
		
		public function get isEmpty():Boolean
		{
			return this.commentsCanvas.numChildren == 0
		}
		
		public function get isMouseIn():Boolean
		{
			return _isMouseIn;
		}
		
		public function get hashTime():uint
		{
			return Utilities.toHashTimeStamp(_time);
		}
		
		private function get isFull():Boolean
		{
			return this.currentState == ConversationState.FULL;
		}
		
		private function get totalComments():int
		{
			return isFull ? this.commentsCanvas.numChildren : 1
		}
		
		private function get actualComments():int
		{
			return this.commentsCanvas.numChildren
		}
			
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		
		public function addInputComment(commentID:int,prefix:String):void
		{	
			var inputComment:ZVComment  = new ZVComment();
			inputComment.currentState = ConversationState.INPUT;
			inputComment.x = 0; inputComment.y = this.commentsCanvas.numChildren * inputComment.height;
			inputComment.addEventListener(CommentDeletedEvent.COMMENT_DELETED,onCommentDeleted);
			inputComment.addEventListener(CommentAddedEvent.COMMENT_ADDED,onCommentAdded);
			inputComment.addEventListener(CommentAddingEvent.COMMENT_ADDING,onCommentAdding);
			
			this.commentsCanvas.addChild(inputComment);
			resetUI();
				
			inputComment.setCommentProperties(User.currentUser,_time,commentID,prefix,true,"");
		}
		
		public function addComment(user:User, commentID:int,text:String , thumbURL:String):void
		{	
			var comment:ZVComment  = new ZVComment();
			comment.x = 0; comment.y = this.commentsCanvas.numChildren * comment.height;
			comment.addEventListener(CommentDeletedEvent.COMMENT_DELETED,onCommentDeleted);
			comment.addEventListener(CommentAddedEvent.COMMENT_ADDED,onCommentAdded);
			comment.addEventListener(CommentAddingEvent.COMMENT_ADDING,onCommentAdding);
			
			this.commentsCanvas.addChild(comment);
			resetUI();
				
			comment.setCommentProperties(user,_time,commentID,text,false ,thumbURL);
		}
		

		private function maxCommentWidth():int 
		{
			var maxWidth:int = -1;
				
			for( var i:uint=0 ; i<this.totalComments ; i++)
			{
				var tempWidth:int = this.commentsCanvas.getChildAt(i).width;
				tempWidth > maxWidth ? maxWidth = tempWidth : "";
			}
			
			return maxWidth == -1 ? _defaultWidth : maxWidth; 
		}
		
		private function resetY():void
		{	
			this.y = _defaultY - (this.totalComments-1) * _defaultCommentHeight;
		}
		
		private function resetHeight():void
		{	
			this.height = (this.totalComments) * _defaultCommentHeight;
		}
		
		private function resetX():void
		{
			var beakGlobal:int = this.localToGlobal( new Point(_beakPosition,0) ).x;
			
			if( this.width < _beakPosition )
				this.x = this.x + _beakPosition - this.width + Constants.COMMENT_RESIZE_BEAK_OFFSET;
			else if( this.x + this.width > Application.application.width )
				this.x = _defaultX;
				
			_beakPosition = this.globalToLocal( new Point(beakGlobal,0) ).x
			
		}
		
		private function resetWidth():void
		{	
			this.width = maxCommentWidth() +  (this.actualComments > 1 ? MARGIN_FOR_TOTAL_COMMENTS : 0)
		}
		
		private function resetCommentsY(index:int):void
		{
			for(var i:int=index ; i<this.commentsCanvas.numChildren ; i++)
				this.commentsCanvas.getChildAt(i).y -= _defaultCommentHeight;
		}
		
		 
		
		public function resetUI():void
		{
			resetExpandControls();
			
			resetWidth(); resetHeight() ; resetY();	resetX();
		}
		
		private function resetExpandControls():void
		{
			var status:Boolean = (this.actualComments > 1 && !_isInputMode);
			
			this.expandContractButton.visible = status;
			this.totalCommentsLabel.visible = status;
			
			this.totalCommentsLabel.text = this.actualComments.toString();
		}
		
		private function removeComments():void
		{
			this.commentsCanvas.removeAllChildren();
		}
		
		private function setFocusToLastComment():void
		{
			(this.commentsCanvas.getChildAt(this.commentsCanvas.numChildren-1) as ZVComment).setFocusToInput();
		}
		
		public function setupComment(isInput:Boolean, location:int , time:Number ):void
		{
			if( location != -1 )
				this._beakPosition = this.globalToLocal( new Point(location,0) ).x;
			if( time != -1 )
				this._time = time;
					
				
			this.visible = isInput;
		}
		
		public function finishCreation():void
		{	
			setFocusToLastComment();
		}
		
		public function setIDForLastComment(commentID:int,tagID:int):void
		{
			var comment:ZVComment =  (this.commentsCanvas.getChildAt(this.commentsCanvas.numChildren-1) as ZVComment)
			
			comment.commentID = commentID;
			comment.tagID = tagID;
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		public function initComponent():void
		{	
			if( _time == -1 )
			{
				_defaultX = this.x;
				_defaultY = this.y;
				_defaultWidth = this.width;		
				_defaultCommentHeight = (new ZVComment()).height;
			}
			
			this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,onStateEntered);
		}
		
		public function onCommentAdding(event:CommentAddingEvent):void
		{	
			startInputState();
			
			setupComment(true,event.location,event.time);
			addInputComment(event.commentID,event.prefix);
			setFocusToLastComment();
		}
		
		public function onCommentAdded(event:CommentAddedEvent):void
		{
			endInputState();
			
			if( !event.isSplash )
				resetUI();
		}
		
		private function onCommentDeleted(event:CommentDeletedEvent):void
		{	
			endInputState();
			
			var index:int = this.commentsCanvas.getChildIndex(event.comment);
			this.commentsCanvas.removeChild(event.comment);
			
			if( !this.isEmpty )
			{
				resetCommentsY(index);				
				resetUI();
			}
			
		}
		
		public function onStateEntered(event:StateChangeEvent):void
		{
			resetUI();
		}
		
		public function onExpandContractClick(event:MouseEvent):void
		{
			if( this.currentState == ConversationState.PARTIAL )
				this.currentState = ConversationState.FULL
			else if( this.currentState == ConversationState.FULL )
				this.currentState = ConversationState.PARTIAL 
		}
		
		public function onRollOver(event:MouseEvent):void
		{
			_isMouseIn = true;
		}
		
		public function onRollOut(event:MouseEvent):void
		{
			_isMouseIn = false;
		}
		
		public function startInputState():void
		{
			_preAddState = this.currentState;
			this.currentState = ConversationState.FULL
			_isInputMode = true;
		}
		
		public function endInputState():void
		{
			this.currentState = _preAddState;
			_isInputMode = false;
		}
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			graphics.clear();
			
			if( _beakPosition == -1 )
				return;
			
			//Base rectangle
			graphics.lineStyle(1,0x7083ac);
			graphics.beginFill(0x3558a1,0.9);
			graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,10,10);
			
			//Right break part
			graphics.moveTo(_beakPosition+BEAK_WIDTH,unscaledHeight);			
			graphics.lineTo(_beakPosition,unscaledHeight+BEAK_HEIGHT);			
			
			//Beak to line to avoid white border from rectangle
			graphics.lineStyle(1,0x3558a1);
			graphics.moveTo(_beakPosition - BEAK_WIDTH,unscaledHeight);
			graphics.lineTo(_beakPosition + BEAK_WIDTH,unscaledHeight);
			
			//Left break part
			graphics.lineStyle(1,0x7083ac);
			graphics.lineTo(_beakPosition,unscaledHeight+BEAK_HEIGHT);
			
			graphics.endFill();
			
		}
	
	
		
	}//class
}//package