/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVToolTip_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Implementation of a ZVToolTip
*****************************************************************************/
package components
{
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class ZVToolTip_as extends Canvas
	{
		
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		private const BEAK_WIDTH:uint = 10;
		private const BEAK_HEIGHT:uint = 8;
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		//  Implement required methods of the IToolTip interface; these 
        //  methods are not used in this example, though.
        public var _text:String;
        
        //-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var toolTipTextArea:TextArea;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function ZVToolTip_as()
		{
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get actualHeight():int
		{
			return this.height + BEAK_HEIGHT + 3
		}
		
		public function set toolTipText(text:String):void
		{
			toolTipTextArea.text = text;
        	
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			graphics.clear();
			
			var beakPosition:int = unscaledWidth  / 2; 
			
			
			//Base rectangle
			graphics.lineStyle(1,0x7083ac);
			graphics.beginFill(0x1C3F88);
			graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,10,10);
			
			//Right break part
			graphics.moveTo(beakPosition+BEAK_WIDTH,unscaledHeight);			
			graphics.lineTo(beakPosition,unscaledHeight+BEAK_HEIGHT);			
			
			//Beak to line to avoid white border from rectangle
			graphics.lineStyle(1,0x1C3F88);
			graphics.moveTo(beakPosition - BEAK_WIDTH,unscaledHeight);
			graphics.lineTo(beakPosition + BEAK_WIDTH,unscaledHeight);
			
			//Left break part
			graphics.lineStyle(1,0x7083ac);
			graphics.lineTo(beakPosition,unscaledHeight+BEAK_HEIGHT);
			
			graphics.endFill();
			
		}
	
		
		//-------------------------------------------------------------------
		//
		// Implements
		//
		//-------------------------------------------------------------------
		public function get text():String 
        { 
            return _text; 
        } 
        public function set text(value:String):void 
        {	
        } 


	}
}