
package utilities
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import events.ImageLoadedEvent;
	
	 
	//Handles upload
	public class ImageUploader extends Sprite
	{		
		
		private var _url:String = ""; 	//location of the file being loaded
		private var _index:Number = -1; //Position in the array of the buldk uploader
		
		//Constructor Logic
		public function ImageUploader():void
		{
				
		}
		
		//Starts the image loading process
		public function loadImage(url:String , index:Number):void
		{
			_url = url;
			_index = index;
			
			//Setup URL request for adImage
			var request:URLRequest = new URLRequest(url); 
			
			//Launch image loader
			var imageLoader:Loader = new Loader();			
 			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadingComplete);
 			imageLoader.load(request ,new LoaderContext(false));
		}
		
		//Event handler for when the image finished loading
		public function imageLoadingComplete(event:Event):void
		{	
			var bmpData:BitmapData= Bitmap(event.currentTarget.content).bitmapData;
			var bmp:Bitmap = new Bitmap(bmpData);
			
			var imageLoaded:ImageLoadedEvent = new ImageLoadedEvent("ImageLoadedEvent",bmpData,bmp,_index);
			dispatchEvent(imageLoaded);		
			
		}
		
		
	}//class	
	
}//package