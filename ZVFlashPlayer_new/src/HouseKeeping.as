/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    User.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Global functions and methods for the application
*****************************************************************************/
package
{
	import components.ZVSlider;
	import components.ZVToolTip;
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.controls.TextArea;
	import mx.events.ToolTipEvent;
	
	public class HouseKeeping
	{
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public static var VIDEO_WIDTH:int = -1; 
		public static var VIDEO_HEIGHT:int = -1;
		public static var VIDEO_URL:String = "";
		public static var VIDEO_TITLE_SHORT:String = "";
		public static var VIDEO_THUMB_URL:String = "";
		public static var COMMENT_ID:int = -1;
		public static var OBJ_ID:int = 0;
		
		public static var slider:ZVSlider = null;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public static var timer:Timer ;
		public static var globalMessageTextArea:TextArea;
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function HouseKeeping()
		{
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public static function sliderXFromTime( time:Number , duration:Number ):Number
		{	
			return HouseKeeping.slider.localToGlobal( new Point((time * HouseKeeping.slider.width) / duration,0) ).x
		}
		
		public static function fb_login():void
		{
			//HouseKeeping
			HouseKeeping.message("Login via Facebook Connect to add & share dropletz");
			ExternalInterface.call("fb_login");
		}
		
		public static function message( text:String , duration:uint = 4000 ):void
		{
			
			globalMessageTextArea.visible = false;
			
			globalMessageTextArea.text = text;
			globalMessageTextArea.visible = true;
			
			HouseKeeping.timer = new Timer(duration);
			HouseKeeping.timer.start();			
			timer.addEventListener(TimerEvent.TIMER,HouseKeeping.onTimerTick);			
		}
		
		public static function hideFlashPlayer():void
		{
			ExternalInterface.call("hide_player",HouseKeeping.COMMENT_ID , HouseKeeping.OBJ_ID);
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		public static function onTimerTick(event:TimerEvent):void
		{
			HouseKeeping.timer.stop();			
			globalMessageTextArea.visible = false;
		}
		
		public static function onToolTipCreate(text:String , tipWidth:int , event:ToolTipEvent):void
		{	
		   var toolTip:ZVToolTip = new ZVToolTip();
		   toolTip.initialize();
		   toolTip.width = tipWidth;
		   toolTip.toolTipText = text;
		   
           event.toolTip = toolTip;
        }
		
		public static function onToolTipShow(event:ToolTipEvent , offset:int):void
		{	
           	var loc:Point = event.currentTarget.parent.localToGlobal( new Point(event.currentTarget.x,event.currentTarget.y) )
           	event.toolTip.x = loc.x + event.currentTarget.width / 2 - event.toolTip.width / 2;
		   	event.toolTip.y = loc.y - event.toolTip.height - offset
           
		}
	}
}