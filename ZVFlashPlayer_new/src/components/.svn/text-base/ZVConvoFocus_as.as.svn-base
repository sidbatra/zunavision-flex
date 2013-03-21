/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVConvoFocus.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Display component for highlighting the focus of a conversation component
*****************************************************************************/
package components
{
	import mx.containers.Canvas;
	
	import utilities.Utilities;

	public class ZVConvoFocus_as extends Canvas
	{
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVConvoFocus_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			this.graphics.lineStyle(5,0xffffff,0.65)
            this.graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,10);
            this.graphics.endFill();
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		public function getServerString(xOffset:int):String
		{
			var requestData:String = ""
			
			requestData = "x=" +  Utilities.normalize(this.x-xOffset,HouseKeeping.VIDEO_WIDTH-2*xOffset,Constants.SERVER_VIDEO_DIM) + Constants.SERVER_JOIN_CHAR +
						  "y=" +  Utilities.normalize(this.y,HouseKeeping.VIDEO_HEIGHT,Constants.SERVER_VIDEO_DIM) + Constants.SERVER_JOIN_CHAR +
						  "w=" +  Utilities.normalize(this.width,HouseKeeping.VIDEO_WIDTH-2*xOffset,Constants.SERVER_VIDEO_DIM) + Constants.SERVER_JOIN_CHAR +
						  "h=" +  Utilities.normalize(this.height,HouseKeeping.VIDEO_HEIGHT,Constants.SERVER_VIDEO_DIM) + Constants.SERVER_JOIN_CHAR +
						  "b=false"
								  
			
			return requestData;
		}
		
	}
}