/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVTrackSkin.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Custom track skin for the ZVSlider
*****************************************************************************/
package skins
{
	import mx.skins.halo.ProgressTrackSkin;

	public class ZVTrackSkin extends ProgressTrackSkin
	{
		public function ZVTrackSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{  
            super.updateDisplayList(unscaledWidth, unscaledHeight);  
   
   			this.graphics.clear();
             
          
             
             
             
         }  
		
	}
}