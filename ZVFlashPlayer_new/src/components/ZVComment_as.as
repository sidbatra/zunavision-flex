/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:   ZVComment_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Component for user comments in a conversation
*****************************************************************************/
package components
{
	import containers.User;
	
	import enums.ConversationState;
	
	import events.CommentAddedEvent;
	import events.CommentAddingEvent;
	import events.CommentDeletedEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.events.StateChangeEvent;
	
	import utilities.Utilities;
	
	use namespace mx_internal;
	

	public class ZVComment_as extends Canvas
	{
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _creator:User ;
		private var _comment:String = "";
		private var _time:Number ;
		private var _commentID:int = -1;
		private var _tagID:int = -1;
		private var _thumbURL:String = "";
		
		private var _defaultTextAreaWidth:int = 0;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		[Bindable] public var userImage:Image;
		[Bindable] public var displayTextArea:TextArea;
		[Bindable] public var inputTextArea:TextArea;	
		[Bindable] public var deleteButton:Button;	
		[Bindable] public var replyDoneButton:Button;
		[Bindable] public var splashButton:Button;
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function ZVComment_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function set commentID(commentID_p:int):void
		{
		 	_commentID = commentID_p;
		}
		
		public function set tagID(tagID_p:int):void
		{
			_tagID = tagID_p;
		}
			

		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public function initComponent():void
		{
			this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,onStateEntered);
			
		}
		
		
		public function setCommentProperties(creator:User, time:Number , commentID:int 
						, text:String , isInput:Boolean , thumbURL:String):void
		{
			_defaultTextAreaWidth = this.displayTextArea.width;
			
			_time = time;
			_commentID = commentID
			_creator = creator;
			_thumbURL =  thumbURL;
			userImage.load(_creator.picURL);
			
			if( isInput )	
				this.inputTextArea.text = text;
			else
				setDisplayHTML(text);
				
			//this.deleteButton.visible = _creator.userID == User.currentUser.userID;
			if( currentState != ConversationState.INPUT)
				this.deleteButton.visible = false;
			else if( this.inputTextArea.text.length == 0 )
				this.replyDoneButton.enabled = false;
			
		}
				
		private function setDisplayHTML(data:String , dispatch:Boolean = false):void
		{	
			_comment = data;
			displayTextArea.htmlText = "<b><u><a href=\"" + _creator.profileURL + "\" target=\"_blank\">" +  _creator.fullName + "</a></u></b>: " 
					+ replaceHashWithHTML( replaceUserWithHTML(replaceURLWithHTML(data)) );
			resizeComment();
			
			if( dispatch )
				dispatchEvent( new CommentAddedEvent(CommentAddedEvent.COMMENT_ADDED , getServerString(false),false));
		}
		
		private function resizeComment():void
		{
			this.displayTextArea.validateNow();
			
			if( displayTextArea.mx_internal::getTextField().numLines == 1 )
				this.displayTextArea.width = displayTextArea.mx_internal::getTextField().getLineMetrics(0).width + Constants.COMMENT_RESIZE_OFFSET;
			else
				this.displayTextArea.width = Math.max(
											displayTextArea.mx_internal::getTextField().getLineMetrics(0).width,
											displayTextArea.mx_internal::getTextField().getLineMetrics(1).width ) + + Constants.COMMENT_RESIZE_OFFSET;
			
				
															
			this.width = this.width - _defaultTextAreaWidth + this.displayTextArea.width;
										
		}
		
		private function replaceUserWithHTML(data:String):String
		{
			
			var users:Array =  data.match(Constants.USER_REGEX);
			var result:String = data;
			
			for( var i:uint=0; i<users.length ; i++)
			{
				var user:String = users[i].toString();
				result = result.replace(user , "<u><a href=\"" + Constants.WEBSITE_ROOT + "/"  
				 + user.slice(1,user.length) + "\" target=\"_blank\">" + user + "</a></u>");
			}
				
			return result;
		}
		
		private function replaceURLWithHTML(data:String):String
		{
			
			return data.replace(Constants.URL_REGEX ,"<u><a href=\"" + Constants.WEBSITE_ROOT + 
									"/click?w=$&&c=" + _commentID +
									 (User.isLoggedIn() ? "&u=" + User.currentUser.userID : "" ) +	
									"\" target=\"_blank\">$&</a></u>")
		}
		
		private function replaceHashWithHTML(data:String):String
		{	
			return data.replace(Constants.TAG_REGEX ,"<u><a href=\"" + Constants.WEBSITE_ROOT + 
									"/ocean?q=$&" + "\" target=\"_blank\">$&</a></u>").replace(Constants.HASH_REGEX,">#"); 
			
		}
		
		
		private function commentAdded():void
		{
			this.currentState = ConversationState.DISPLAY;
		}
		
		public function setFocusToInput():void
		{
			focusManager.setFocus(this.inputTextArea);
			this.inputTextArea.selectionBeginIndex = this.inputTextArea.text.length;
			this.inputTextArea.selectionEndIndex = this.inputTextArea.text.length;
		}
		
			
		private function replyPrefix():String
		{
			return "@" + _creator.uniqueName + " ";
		}
		
		//Returns a server string for adding a new comment
		public function getServerString(isSplash:Boolean):String
		{
				
			var requestData:String = "u=" + _creator.userID + Constants.SERVER_JOIN_CHAR
								   + "d=" + _comment + Constants.SERVER_JOIN_CHAR
								   + "t=" + Utilities.clipToThreeDecimals(_time)	+ Constants.SERVER_JOIN_CHAR
								   + "s=" + isSplash + Constants.SERVER_JOIN_CHAR
								   + "c=" + _commentID
								   
			
			return requestData;
		}
		
				
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		public function onReplyDoneClick(event:MouseEvent):void
		{
			if( this.currentState == ConversationState.INPUT )
				commentAdded();
			else
			{	
				if( User.isLoggedIn() )
					dispatchEvent( new CommentAddingEvent(CommentAddingEvent.COMMENT_ADDING,-1,-1,_commentID,replyPrefix()) );
				else
					HouseKeeping.fb_login();
			}
			
		}
		
		public function onShareClick(event:MouseEvent):void
		{
			if( User.isLoggedIn() )
			{
				ExternalInterface.call("message_share_droplet",_commentID);
			}
			else
			{
				HouseKeeping.fb_login();
			}
		}
		
		public function onFacebookShare(event:MouseEvent):void
		{
			var commentURL:String = Constants.WEBSITE_ROOT +  "/w?c=" + _commentID;
			
			if( _creator.userID == User.currentUser.userID )
			{
				ExternalInterface.call("fb_share_self_droplet",_creator.firstName , _comment , _creator.profileURL , 
			 _creator.userID == User.currentUser.userID ? "himself" : _creator.firstName  , User.currentUser.profileURL
			  , commentURL , HouseKeeping.VIDEO_TITLE_SHORT ,
			  _thumbURL == "" ? HouseKeeping.VIDEO_THUMB_URL : _thumbURL);
			}
			else
			{
			ExternalInterface.call("fb_share_droplet",_creator.firstName , _comment , _creator.profileURL , 
			 _creator.userID == User.currentUser.userID ? "himself" : _creator.firstName  , User.currentUser.profileURL
			  , commentURL , HouseKeeping.VIDEO_TITLE_SHORT ,
			  _thumbURL == "" ? HouseKeeping.VIDEO_THUMB_URL : _thumbURL);
			}
		}
		
		public function onTwitterShare(event:MouseEvent):void
		{
			var twitterLink:String = "http://twitter.com/home?status=" + _comment + " @ " + HouseKeeping.VIDEO_URL
			 navigateToURL( new URLRequest(twitterLink) , "_blank");
		}
		
		public function onSplashClick(event:MouseEvent):void
		{
			if( User.isLoggedIn() )
			{
				this.splashButton.visible = false;
				dispatchEvent( new CommentAddedEvent(CommentAddedEvent.COMMENT_ADDED , getServerString(true),true));
				HouseKeeping.message("Thanks for the splash!",3000);
			}
			else
			{
				HouseKeeping.message("Login via Facebook Connect to add & share dropletz");
			}
		}
		
		public function onDeleteClick(event:MouseEvent):void
		{
			dispatchEvent( new CommentDeletedEvent(CommentDeletedEvent.COMMENT_DELETED,this)  );
		}
		
		
		public function onStateEntered(event:StateChangeEvent):void
		{	
			if( event.oldState == ConversationState.INPUT && event.newState == ConversationState.DISPLAY )
			{	
				setDisplayHTML(this.inputTextArea.text,true);
			}
						
		}
		
		public function onUserImageClicked(event:MouseEvent):void
		{
			navigateToURL( new URLRequest(_creator.profileURL) , "_blank");
		}
		
		public function onInputTextKeyUp(event:KeyboardEvent):void
		{
			if( inputTextArea.text.length > 1 )
			{				
				this.replyDoneButton.enabled = true;
				
				
				if( event.keyCode == Keyboard.ENTER )
				{
					inputTextArea.text = inputTextArea.text.slice(0,inputTextArea.text.length-1); 
					commentAdded();
				}
			}
			else
				this.replyDoneButton.enabled = false;
		}
		
		
	}//class
}//package