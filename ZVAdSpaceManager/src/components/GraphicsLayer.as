/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    GraphicsLayer.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>, Ashutosh Saxena <ashutosh@zunavision.com> (this came originally from Line Drawing right?)
** DESCRIPTION:
** Graphics component layer for rendering images & graphics 
*****************************************************************************/
package components
{
	//Flash imports
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	//-------------------------------------
	
	//Custom container imports
	import containers.AdSpace;
	//-------------------------------------
	
	//Custom utility imports
	import utilities.BitmapTransformer;
	//-------------------------------------
	
				
	public class GraphicsLayer extends Sprite
	{			
		public var _adOverlay:Sprite;	//Ad layer added to the main component for rendering images
		
		public var _bitmapTransformer:BitmapTransformer;	//Transforms bitmap before rendering
		
		//Constructor Logic
		 function GraphicsLayer() 
		 {
		 	_adOverlay = new Sprite();	
		 	_adOverlay.alpha = Constants.ALPHA_FOR_AD_LAYER;	 	
			this.addChild(_adOverlay);		
			
			clean();	
		}
		
		//Clears the graphics layer
		public function clean():void 
		{
			this.graphics.clear();
			this._adOverlay.graphics.clear();			
			this.graphics.lineStyle(Constants.LINE_THICKNESS,Constants.LINE_COLOR);			
		}
		
		
		//Renders an ad-space within the graphics layer
		public function renderAdSpace(adSpaceData:AdSpace , isSelected:Boolean=false):void 
		{					
			//Setup bitmap transformer based on the new bitmap
			_bitmapTransformer = new BitmapTransformer(adSpaceData._creativeData.width, adSpaceData._creativeData.height,Constants.BITMAP_TRANS_DIV, Constants.BITMAP_TRANS_DIV);
				
			var totalPoints:uint = adSpaceData._coordinates.length;
						
			//Render image if adspace has been completed
			if( totalPoints == Constants.DEFAULT_POINTS_IN_ADSPACE )
			{	
				_bitmapTransformer.mapBitmapData(adSpaceData._creativeData,
				new Point(adSpaceData._coordinates[0].x,adSpaceData._coordinates[0].y), 
				new Point(adSpaceData._coordinates[1].x,adSpaceData._coordinates[1].y),
				new Point(adSpaceData._coordinates[2].x,adSpaceData._coordinates[2].y),
				new Point(adSpaceData._coordinates[3].x,adSpaceData._coordinates[3].y),  _adOverlay);
			}
			
			//Set graphics style based on selection status
			if( isSelected )
				this.graphics.lineStyle(Constants.LINE_THICKNES_SELECTED,Constants.LINE_COLOR_SELECTED);
			else
				this.graphics.lineStyle(Constants.LINE_THICKNESS,Constants.LINE_COLOR);
			
			//Draw edges and circles on points
			for(var i:uint=0; i<totalPoints; i++) 
			{								
				var p1:Point = adSpaceData._coordinates[i];
				var p2:Point = (i==totalPoints-1) ? adSpaceData._coordinates[0] : adSpaceData._coordinates[i+1];
				
				this.graphics.drawCircle(p1.x, p1.y, Constants.RADIUS_FOR_CIRCLE);
				
				if (i<totalPoints-1 || totalPoints==Constants.DEFAULT_POINTS_IN_ADSPACE ) 
				{ 
					this.graphics.moveTo(p1.x, p1.y);
					this.graphics.lineTo(p2.x, p2.y);
				}
			}//i
			
			
		}
		
		
	}//class
	
}//package
	