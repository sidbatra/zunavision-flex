/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    Constants.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Constants for the application
*****************************************************************************/
package
{
	
	public class Constants
	{
		
		//ZVFlashPlayer.as
		public static const FOCUS_LIST_OFFSET:int = 3;
		public static const TOOL_TIP_DELAY:int = 700;
		public static const GLOBAL_TOOL_TIP_DUR:int = 9000;
		//---------------------------------------------------
		
		//ConversationManager.as
		public static const SERVER_REQ_URL:Array = new Array("/videos/view" ,"/comment/add");
		public static const SERVER_REQ_METHOD:String = "POST";
		public static const WEBSITE_ROOT:String = "http://dropletz.com";
		//public static const WEBSITE_ROOT:String = "http://test.dropletz.com";
		public static const AMAZON_FLASH_ROOT:String = "http://zunavision_node_flash.s3.amazonaws.com";
		public static const DATABASE_INFO_URL:String = "DatabaseInfo"; 
		public static const SPACE:String = "Z*SPACE*Z";
		public static const LINE:String = "Z*LINE*Z";
		public static const SERVER_JOIN_CHAR:String = "&";
		public static const TUBELOC_URL:String = "/flash/as2_tubeloc.swf";
		//---------------------------------------------------
		
		//ConversationManager.as
		public static const CONVO_DURATION:Number = 2;
		public static const CONVO_UPDATE_RATE:uint = 1;
		public static const WIDESCREEN_X_OFFSET:uint = 80;
		public static const SERVER_VIDEO_DIM:uint = 10000;
		//---------------------------------------------------
		
		//ZVVideoPlayer.as
		public static const MARGIN_FOR_START:Number = 4;
		public static const HIDE_DELAY_AFTER_STOP:uint = 6000;
		//---------------------------------------------------
		
		//ZVConversation.as
		//---------------------------------------------------
		
		//ZVVideoFocus.as
		public static const FOCUS_MIN_HEIGHT:int = 10;
		public static const FOCUS_MIN_WIDTH:int = 10;
		//---------------------------------------------------
		
		//ZVSlider.as
		public static const TICK_TIMER_DURATION:int = 1100;
		public static const TICK_SEEK_MARGIN:Number = 1.5;
		//---------------------------------------------------	
			
		//ZVComment.as
		public static const COMMENT_RESIZE_OFFSET:uint = 5;
		public static const COMMENT_RESIZE_BEAK_OFFSET:uint = 50;
		
		public static const URL_REGEX:RegExp = new RegExp(/(((http|ftp|https):\/\/){1}([a-zA-Z0-9_-]+)(\.[a-zA-Z0-9_-]+)+([\S,:\/\.\?=a-zA-Z0-9_-]+))/igs);
		public static const USER_REGEX:RegExp = new RegExp(/@[a-zA-Z0-9]+/igs);
		public static const HASH_REGEX:RegExp = new RegExp(/[>][%][2][3]+/igs);
		public static const TAG_REGEX:RegExp = new RegExp(/[%][2][3][a-zA-Z0-9]+/igs);
		//public static const USER_REGEX:RegExp = new RegExp(/^@[a-zA-Z0-9.-]+$/);
		//---------------------------------------------------
		
	}//Class
}//Package
