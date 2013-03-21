/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVTickSkin.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Custom tick skin for the ZVSlider
*****************************************************************************/
package skins
{
	import mx.effects.easing.Back;
	import mx.skins.halo.ButtonSkin;

	public class ZVTickSkin extends ButtonSkin
	{
		public function ZVTickSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{  
             super.updateDisplayList(unscaledWidth, unscaledHeight);
             
             this.graphics.clear();
             
             var backgroundFillColor:uint = 0x4eb776; 
             
             switch(name)
             {
             	case "overSkin":
             		backgroundFillColor = 0x71c691;
             		break;
             	case "downSkin":
             		backgroundFillColor = 0x71c691;
             		break;
             }
             
             this.graphics.beginFill(backgroundFillColor);
             this.graphics.drawEllipse(-5,-4,10,10);
             this.graphics.endFill();
   
   			
        }  
		
	}
}