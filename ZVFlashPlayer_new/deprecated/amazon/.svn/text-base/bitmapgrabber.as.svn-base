package amazon
{
	public class bitmapgrabber
	{
			private function onClick(event:MouseEvent):void
		{
			
             
            // var imageSnap:ImageSnapshot = ImageSnapshot.captureImage(event.currentTarget as DisplayObject);
             //var imageByteArray:ByteArray = imageSnap.data as ByteArray;
             //swfLoader.load(imageByteArray);


			//Security.allowDomain("youtube.com")
			var source:DisplayObject = (event.currentTarget as DisplayObject);
			var bmd:BitmapData = new BitmapData(source.width, source.height);
            bmd.draw(source);
            //var bm:Bitmap = new Bitmap(bmd);
			
			//var cropped:BitmapData = new BitmapData(350,350);
			//cropped.copyPixels(bmd, new Rectangle(0,0,350,350),new Point(0,0));
			
			//var j:JPEGEncoder = new JPEGEncoder();
			//var bytes:ByteArray = j.encode(cropped);
			//var p:PolicyGenerator = new PolicyGenerator();
			//p.upload(cropped);
			
						
			var image:Image = new Image();
			
			image.width = 100;
			image.height = 100;
			image.source =  new Bitmap(ImageSnapshot.captureBitmapData( event.currentTarget as DisplayObject) ) //new Bitmap(cropped);
			//image.load("images/gumps.jpg");
			this.addChild(image);
		}
		
		public function bitmapgrabber()
		{
		}

	}
}