/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    FileUpload.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/

package components
{
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.VBox;
	import mx.containers.HBox;		
	import mx.controls.Image;
	import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.controls.ProgressBarMode;	
	import mx.core.BitmapAsset;
	import mx.core.ScrollPolicy;
	
	import events.FileUploadEvent;
	import events.FileUploadProgressChangedEvent;
	
	import utilities.UtilityFunctions;

	public class FileUpload extends VBox
	{
		private var bar:ProgressBar;
		private var _file:FileReference;
		private var nameText:Text;
		private var _uploaded:Boolean;
		private var _uploading:Boolean;
		private var _bytesUploaded:uint;
		private var _uploadUrl:String;
		//private var _zunifyUrl:String;
		
		[Embed(source='images/cancel_upload.png')]
		private var removeImg:Class;
		
		private var removeButton:Image;
		//private var zunifyButton:Button;
		
		
		public var _uploadInd:int=0;
		
		
		public var hbox:HBox;
		public var hboxLeft:HBox;
		public var hboxRight:HBox;
		
		// constructor
		public function FileUpload(file:FileReference,uploadUrl:String, uploadInd:int=0)
		{
			super();
			// initialize variables
			_file = file;
			_uploadInd = uploadInd;
			_uploadUrl = uploadUrl + "&vid=" + _uploadInd.toString();
			
			_uploaded = false;	
			_uploading = false;
			_bytesUploaded = 0;
			
			// set styles
			//setStyle("backgroundColor","#4568b1");
			setStyle("paddingBottom","10");
			setStyle("paddingTop","10");
			setStyle("paddingLeft","10");
			setStyle("color", "0xCCD5E7");
			setStyle("horizontalAlign", "left");
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			// set event listeners
			_file.addEventListener(Event.COMPLETE,OnUploadComplete);
			_file.addEventListener(ProgressEvent.PROGRESS,OnUploadProgressChanged);
			_file.addEventListener(HTTPStatusEvent.HTTP_STATUS,OnHttpError);
			_file.addEventListener(IOErrorEvent.IO_ERROR,OnIOError);
			_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,OnSecurityError);
			
			// add controls
			hbox = new HBox();
			hboxLeft = new HBox();
			hboxRight = new HBox();
			
			nameText = new Text();
			//nameText.setStyle("color", "0xCCD5E7");
			nameText.setStyle("fontWeight", "normal");
			nameText.text = UtilityFunctions.truncateString(_file.name, 40);
			
			hboxLeft.width=220;
			hboxLeft.setStyle("horizontalAlign", "right");
			hboxLeft.addChild(nameText);
			//this.addChild(nameText);
						
								
			bar = new ProgressBar();
			bar.mode = ProgressBarMode.MANUAL;
			bar.label = "Uploading...";
			bar.width = 275;	
			bar.y = 10;
			bar.setStyle("barColor", "0xCCD5E7");
			bar.setStyle("trackColors", "[0x3558a1,0x3558a1]");
			//bar.setStyle("themeColor", "0x3558a1");
			bar.setStyle("borderColor", "0xCCD5E7");	
			bar.setStyle("color", 0xCCD5E7);
			hboxRight.addChild(bar);
			
			
			removeButton = new Image();
			var imgObj:BitmapAsset = new removeImg() as BitmapAsset;
			removeButton.source = imgObj;
			
			hboxRight.addChild(removeButton);
						
			removeButton.addEventListener(MouseEvent.CLICK,OnRemoveButtonClicked);
			
			hbox.addChild(hboxLeft);
			hbox.addChild(hboxRight);
			this.addChild(hbox);		
		}
		
		private function OnRemoveButtonClicked(event:Event):void{
			if(_uploading)
				_file.cancel();
			this.dispatchEvent(new FileUploadEvent(this,"FileRemoved"));
			
		}
		
		public function removeIfComplete():void {
			if( _uploaded )
				this.dispatchEvent(new FileUploadEvent(this,"FileRemoved"));
		}
		
		private function OnZunifyButtonClicked(event:Event):void {
			var request:URLRequest = new URLRequest(); 
			//request.url = _zunifyUrl;
			navigateToURL(request, "_self"); 
		}
		
		private function OnUploadComplete(event:Event):void{
			_uploading = false;
			_uploaded = true;
			removeButton.visible = false;
			//zunifyButton.visible = true;
			this.dispatchEvent(new FileUploadEvent(this,"UploadComplete"));
		}
		
		private function OnHttpError(event:HTTPStatusEvent):void{
			this.dispatchEvent(event);
		}
		
		private function OnIOError(event:IOErrorEvent):void{
			this.dispatchEvent(event);
		}
		
		private function OnSecurityError(event:SecurityErrorEvent):void{
			this.dispatchEvent(event);
		}
		
		// handles the progress change of the upload
		private function OnUploadProgressChanged(event:ProgressEvent):void{
			var bytesUploaded:uint = event.bytesLoaded - _bytesUploaded;
			_bytesUploaded = event.bytesLoaded;
			bar.setProgress(event.bytesLoaded,event.bytesTotal);
			//bar.label = "Uploaded " + FormatPercent(bar.percentComplete) + "%";
			bar.label = FormatSize(event.bytesLoaded) + " of " + FormatSize(event.bytesTotal);
			this.dispatchEvent(new FileUploadProgressChangedEvent(this,bytesUploaded,"UploadProgressChanged"));			
		}
		
		// get whether the file is uploading
		public function get IsUploading():Boolean{
			return _uploading;
		}
		
		// get whether the file has been uploaded
		public function get IsUploaded():Boolean{
			return _uploaded;
		}
		
		// get the number of bytes uploaded
		public function get BytesUploaded():uint{
			return _bytesUploaded;
		}
		
				
		// gets the size of the file
		public function get FileSize():uint{
			var size:uint = 0;
			try{
				size = _file.size;
			}
			catch (err:Error) {
				size = 0;
			}
			return size;
		}
		
		// upload the file
		public function Upload():void{
			_uploading = true;
			_bytesUploaded = 0;
			_file.upload(new URLRequest(_uploadUrl));
		}
		
		// cancels the upload of a file
		public function CancelUpload():void{
			_uploading = false;
			_file.cancel();
		}
		
		// helper function to format the file size
		public static function FormatSize(size:uint):String{
			if(size < 1024)
		        return PadSize(int(size*100)/100) + " bytes";
		    if(size < 1048576)
		        return PadSize(int((size / 1024)*100)/100) + "KB";
		    if(size < 1073741824)
		       return PadSize(int((size / 1048576)*100)/100) + "MB";
		     return PadSize(int((size / 1073741824)*100)/100) + "GB";
		}
		
		// helper function to format the percent
		public static function FormatPercent(percent:Number):String{
			percent = int(percent);
			return String(percent);
		}
		
		// helper function to pad the right side of the file size
		public static function PadSize(size:Number):String{
			var temp:String = String(size);
			var index:int = temp.lastIndexOf(".");
			if(index == -1)
				return temp + ".00";
			else if(index == temp.length - 2)
				return temp + "0";
			else
				return temp;
		}
		
	}
}