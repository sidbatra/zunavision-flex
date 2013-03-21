/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVVideoFocus_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Skin for the resize buttons applied on the focus tool's focus box
*****************************************************************************/
package skins
{
	import mx.skins.halo.ButtonSkin;

	public class ZVResizeSkin extends ButtonSkin
	{
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function ZVResizeSkin()
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
         	this.graphics.clear();
         	
         	this.graphics.beginFill(0xffffff)
            this.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
            this.graphics.endFill();
            this.graphics.lineStyle(1,0xb7babc);
            this.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
 		}
		
	}//class
}//package