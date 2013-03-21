/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVAdSpaceManager.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle all info about any thumbnail in the UI
*****************************************************************************/

package components 
{

	//Code behind for F0lashFileUpload.mxml
	import containers.AdSpace;
	import containers.AdSpaceHandler;
	import containers.VideoThumbnail;
	
	import enums.MediaEntityType;
	
	import eventhandlers.FileUploadEventHandler;
	import eventhandlers.ServerCommunicationEventHandler;
	import eventhandlers.VideoSetupEventHandler;
	
	import events.*;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.*;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	
	import utilities.ImageUploader;
	import utilities.ServerCommunication;
	import utilities.UtilityFunctions;
	
	public class ZVAdSpaceManager_as extends Application
	{
		private var fileRefList:FileReferenceList;
		public var _creativeFileRefList:FileReferenceList;
		private var fileRefListener:Object;
		private var _fileTypeDescription:String;
		private var _fileTypes:String;
		public var _creativeFileTypeDescription:String;
		public var _creativeFileTypes:String;
		
		public var _videoUploadManager:FileUploadManager;
		public var _imageUploadManager:FileUploadManager;
		
		private var _videoUploadPage:String;
		private var _imageUploadPage:String;

		//private var _totalUserVideos:int = 0;
		public var _serverComm:ServerCommunication;
		
		public var _currentZnaFilename:String;
		
		private var _refreshOverRide:Boolean=false;				// used to force refresh on server message
						
		public var imageFileUpload:VBox;			
		
		public var _uploadOnlyUser:Boolean = false;			
						
		// all controls in the mxml file must be public variables in the code behind
		public var fileContainer:VBox;
		public var fileUploadBox:VBox;
		public var fileUploadSpacer:Spacer;
		public var mainUploadBox:HBox;
		public var totalProgressBar:ProgressBar;
		public var browseButton:Button;
		public var uploadText:Text;
		public var progressText:Text;
		public var invokeButton:Button;
		public var debugText:Text;
		public var thumbnailList:TileList;
		public var outputList:TileList;
		public var videoThumbnail:Image;
		public var uploadContainer:VBox;
		public var zvASEBox:VBox;
		public var fileUploadContainer:HBox;
		public var thumbnailContainer:VBox;
		
		
		// zunify Tool 
		public var _zvAdSpaceEditor:ZVAdSpaceEditor;
		public var ToolLayer:Canvas;
		
		[Bindable]
		public var thumbnailFeed:ArrayCollection;
		
		[Bindable]
		public var outputFeed:ArrayCollection;
		
		[Bindable]
		public var _creativesFeed:ArrayCollection;
		
		
		// delay timers
		public var uploadTimer:Timer;
		public var imageUploadTimer:Timer;
		public var refreshTimer:Timer;
		
		
		//Sid's intermediate variables
		public var _currentVideoID:int;
		
		// constructor
		public function ZVAdSpaceManager_as()
		{
			super();
			addEventListener (FlexEvent.CREATION_COMPLETE, OnLoad);	
			
			VideoSetupEventHandler._zvManager = this;
			ServerCommunicationEventHandler._zvManager = this;
			FileUploadEventHandler._zvManager = this;
		}
		
		public function init():void {
			_zvAdSpaceEditor.initializeEditor();
		}
		
		private function OnLoad(event:Event):void{
			// instantiate and initialize variables
			fileRefList = new FileReferenceList();
			_creativeFileRefList = new FileReferenceList();
			
			var temp1:String = Application.application.parameters.totalUploadSize;
			var temp2:String = Application.application.parameters.fileSizeLimit;
			
			_videoUploadManager = new FileUploadManager(temp1, temp2);
			_imageUploadManager = new FileUploadManager(temp1, temp2);
			
			_videoUploadManager._uploadInd = new Number(Application.application.parameters.num_videos);
			_imageUploadManager._uploadInd = new Number(Application.application.parameters.num_videos);
					
			// hook up our event listeners
			fileRefList.addEventListener(Event.SELECT,OnSelectVideo);
			//fileRefList.addEventListener(Event.DEACTIVATE,OnUploadFilesClicked);
			_creativeFileRefList.addEventListener(Event.SELECT,OnSelectCreatives);
			imageFileUpload = new VBox();
			
			uploadTimer = new Timer(750);
			uploadTimer.addEventListener(TimerEvent.TIMER, UploadOnFilesSelected); //UploadFiles();
			imageUploadTimer = new Timer(750);
			imageUploadTimer.addEventListener(TimerEvent.TIMER, UploadOnImageFilesSelected); //UploadFiles();
			refreshTimer = new Timer(4000);
			refreshTimer.addEventListener(TimerEvent.TIMER, refreshThumbnailList);
						
			browseButton.addEventListener(MouseEvent.CLICK,OnAddFilesClicked);
			
			_fileTypeDescription = Application.application.parameters.fileTypeDescription;
			_fileTypes = Application.application.parameters.fileTypes;
			
			_creativeFileTypeDescription = Application.application.parameters.creativeFileTypeDescription;
			_creativeFileTypes = Application.application.parameters.creativeFileTypes;
			
			//website communication
			_serverComm = new ServerCommunication(Application.application.parameters);
			_serverComm._remoteObject.getComputerInfo.addEventListener("result", onResult);
						
			_videoUploadPage = _serverComm._websiteRoot + "/a/flashresponse?" + _serverComm._authenticateString;
			_imageUploadPage = _serverComm._websiteRoot + "/a/flashcreativeresponse?" + _serverComm._authenticateString;
			
			_uploadOnlyUser = (Application.application.parameters.uploadonly == "true");
			
			if (Application.application.parameters.upload_enabled == "false" ) {
				browseButton.enabled = false;
				uploadText.text = "You have reached your upload limit.";
			}
					
			_serverComm.requestThumbnailList();
					
		}
		
	
		// brings up file browse dialog when add file button is pressed
		private function OnAddFilesClicked(event:Event):void{
		
			if(_fileTypes != null && _fileTypes != "")	
			{
			    if(_fileTypeDescription == null || _fileTypeDescription == "")
			        _fileTypeDescription = _fileTypes;
			        
			    var filter:FileFilter = new FileFilter(_fileTypeDescription, _fileTypes);
                
                fileRefList.browse([filter]);
			}
			else
			    fileRefList.browse();
	
		}
		
		// fires when the upload upload button is clicked
		private function UploadOnFilesSelected(event:TimerEvent):void {
			UploadVideoFiles();
			uploadTimer.stop();
		}
		
		private function UploadOnImageFilesSelected(event:TimerEvent):void {
			UploadCreativeFiles();
			imageUploadTimer.stop();
		}
		
		
		private function UploadCreativeFiles():void 
		{
			// get all the files to upload
			var fileUploadArray:Array = imageFileUpload.getChildren();
			_imageUploadManager.UploadFiles(fileUploadArray);
		}
		
		public function UploadVideoFiles():void {
			// get all the files to upload
			var fileUploadArray:Array = fileUploadBox.getChildren();
			_videoUploadManager.UploadFiles(fileUploadArray);
		}
		
		private function OnCancelClicked(event:Event):void{
			_videoUploadManager.resetUpload();
			
			// reset the labels and set the button visibility
			_videoUploadManager.ComputeTotalFileSize(fileUploadBox);
		}
		
		private function OnSelectCreatives(event:Event):void {
			var tempSize:Number = _videoUploadManager._totalSize;
			
			_imageUploadManager.OnSelect(_creativeFileRefList, imageFileUpload, _imageUploadPage);
			
			// start uploading files
			imageUploadTimer.start();
			refreshTimer.start();
		}
		
			// fired when files have been selected in the file browse dialog
		private function OnSelectVideo(event:Event):void{
			fileContainer.visible = true;
			//progressText.visible = true;
			fileUploadSpacer.height = 25;
			
			_videoUploadManager.OnSelect(fileRefList, fileUploadBox, _videoUploadPage);
			
			// reset labels
			_videoUploadManager.ComputeTotalFileSize(fileUploadBox);
			
			// start uploading files
			uploadTimer.start();
			refreshTimer.start();
		}
		
		
		private function refreshThumbnailList(event:TimerEvent):void {
			_serverComm.requestThumbnailList();
		}		
		
		private function uploadClickVideoThumbnail():VideoThumbnail 
		{
			var vid:VideoThumbnail = new VideoThumbnail();
						
			vid.thumbnail = _serverComm._websiteRoot + Constants.URL_FOR_UPLOAD_IMAGE;
			vid.databaseID = -1;
			vid.flexID = -1;
			vid.label = Constants.DEFAULT_CREATIVE_NAME;
			vid.data = Constants.DEFAULT_CREATIVE_NAME;
			vid.type = MediaEntityType.CREATIVE;
			
			return vid;
		}
		
		public function sendMetaDataToServer():void 
		{
			_serverComm.convertMetaDataToServerString(_zvAdSpaceEditor._adSpaceHandler);									
			_serverComm.sendServerRequest(MediaEntityType.META_DATA,_currentVideoID);			
		}		
	
		public function requestServerFileMetaData(filename:String):void 
		{				
			var request:URLRequest = new URLRequest(filename);
			
			var metaLoader:URLLoader = new URLLoader();
			request.contentType = "text";
			metaLoader.addEventListener(Event.COMPLETE, metaFileLoadComplete);
			metaLoader.load(request);		
		
		}
		
			
		private function onResult(event:ResultEvent):void 
		{
  			var computerInfo:Object = event.result;  	  		
  	  		var isChange:Boolean = false;
  	  			
  	  		if ( ( _refreshOverRide==true || computerInfo.imageCount != _zvAdSpaceEditor._creativesFeed.length-1)  ) 
  	  		{
  	  			//Alert.show('Updating images from server message: ' + computerInfo.imageCount + ' ' + _zvAdSpaceEditor._creativesFeed.length);
  	  			
  				var imageList:ArrayCollection = _serverComm.unpackServerMessage(computerInfo.imageList, MediaEntityType.CREATIVE);
  				var tempArray:ArrayCollection = new ArrayCollection();
  				tempArray.addItem(uploadClickVideoThumbnail());
  				
  				
  				for(var x:uint=0; x<imageList.length; x++)  {
  					var imageUploader:ImageUploader = new ImageUploader();
  					imageUploader.addEventListener("ImageLoadedEvent",creativeImagesLoadingComplete);
  					imageUploader.loadImage(imageList[x].thumbnail,tempArray.length);
  					 
  					tempArray.addItem( imageList[x] );
  				}  					
  				
  				_zvAdSpaceEditor._creativesFeed = tempArray;
  				
  				adjustTileList(_zvAdSpaceEditor.creativesTileList, _zvAdSpaceEditor._creativesFeed.length);
				isChange = true;
				
  			}
  			
  			if (computerInfo.videoCount > 0 && (_refreshOverRide || computerInfo.videoCount != thumbnailFeed.length)  ) {
  				thumbnailFeed = _serverComm.unpackServerMessage(computerInfo.videoList, MediaEntityType.VIDEO); 
  				adjustTileList(thumbnailList, thumbnailFeed.length); 
  				isChange = true;

  				UpdateFileList();
  			}
  			
  			if (computerInfo.outputvideoCount > 0 && (_refreshOverRide || computerInfo.outputvideoCount != outputFeed.length)  ) {
  				outputFeed = _serverComm.unpackServerMessage(computerInfo.outputvideoList, MediaEntityType.OUTPUT_VIDEO); 
  				adjustTileList(outputList, outputFeed.length);  				
  				isChange = true;
  			}
  			
  			if ( isChange ) {
  				refreshTimer.start();
  				_refreshOverRide = false;
  			}	
  			else
  				refreshTimer.stop();
  				
  			
		}
		
		private function adjustTileList(list:TileList, len:uint):void {
			// the bottom line is hacky: it scales the thumbnailList properly
			var totHeight:uint = Constants.TILE_MARGIN + Constants.THUMBNAIL_HEIGHT;
			list.height = Constants.TILE_MARGIN + Math.ceil(len/4) * totHeight; 
  			list.visible = true;	
		}
		
		private function creativeImagesLoadingComplete(event:ImageLoadedEvent):void
		{	
			_zvAdSpaceEditor._creativesFeed[event._index].bitmapData = event._bitmapData;			
		}
		
		private function UpdateFileList():void 
		{
			// remove the upload box when the thumbnail has arrived.			
			for(var z:uint=0; z<thumbnailFeed.length; z++)  {
				for(var y:uint=0; y<fileUploadBox.numChildren; y++) {
					var fu:FileUpload = fileUploadBox.getChildAt(y) as FileUpload;
					
					if( fu._uploadInd == thumbnailFeed[z].flexID) 
						fu.removeIfComplete();
				}
			}
			
			if( fileUploadBox.numChildren == 0) {
				fileContainer.visible = false;
				fileUploadSpacer.height = 0;
			}
		}
		
	
		public function removeThumbnailFromUI(vidid:uint, boxType:int=0):void 
		{
			var feedArray:Object;
			if (boxType == MediaEntityType.VIDEO)
				feedArray = thumbnailFeed;
			else if (boxType == MediaEntityType.OUTPUT_VIDEO)
				feedArray = outputFeed;
			else if (boxType == MediaEntityType.CREATIVE)
				feedArray = _zvAdSpaceEditor._creativesFeed;
				
				
			// remove the upload box when the thumbnail has arrived.
			for(var z:uint=0; z<feedArray.length; z++) {
				if( feedArray[z].databaseID == vidid) 
					feedArray.removeItemAt(z);
			}
			
			if( fileUploadBox.numChildren == 0) {
				fileContainer.visible = false;
				fileUploadSpacer.height = 0;
			}
			
		}
		
		//Launches the adspace editor UI
		public function launchAdSpaceEditor(url:String, label:String, loadMetaData:Boolean=false, 
										isViewMode:Boolean=false):void 
		{
			
			//Toggle visibility of components
			zvASEBox.visible = true; 
			uploadContainer.visible = false;
			_zvAdSpaceEditor._adSpaceHandler = new AdSpaceHandler();
			
			if( isViewMode ) 
			{
				_zvAdSpaceEditor.currentState = Constants.VIEW_MODE_STRING;			
				//_zvAdSpaceEditor.loadVideo(url, label, url);
			}
			else 
			{
				_zvAdSpaceEditor.currentState = Constants.EDIT_MODE_STRING;
				
				_zvAdSpaceEditor.loadMetaData = loadMetaData;
				_currentZnaFilename = UtilityFunctions.formMetaDataFileName(url);
								
				//_zvAdSpaceEditor.loadVideo(url,label);
			}
			
		} 
		
		//Closes the ZVAdSpaceEditor UI
		public function closeZVAdSpaceEditor():void
		{
			zvASEBox.visible = false;
			uploadContainer.visible = true;
			_refreshOverRide = true;
			refreshTimer.start();		
		}
		
		public function metaFileLoadComplete(event:Event):void 
		{
			
			var textData:String = new String(event.currentTarget.data);
			
			textData = textData.replace(/\n/g, ' ').replace(/\r/g, ' ');
			var tokens:Array = textData.split(/ /);
			
			var pos:uint = 0;
			var metaDataLength:uint = uint( tokens[0] );
			
			pos+=2;
			
			
			for(var n:uint=0; n<metaDataLength; n++) 
			{
				var quad:AdSpace = new AdSpace();
				var nSpaces:uint = uint( tokens[pos++] );
								
				quad._endBTimeStamp = Number( tokens[pos++] );				
				quad._startTimeStamp = Number( tokens[pos++] );
				quad._endFTimeStamp = Number( tokens[pos++] );
				
				quad._creativeID = uint( tokens[pos++] );
				quad._creativeName = tokens[pos++];
				
				if( quad._creativeID == Constants.DEFAULT_CREATIVE_ID )
					quad._creativeData = _zvAdSpaceEditor._currentAdSpace._creativeData.clone();
				
				pos++;
				quad._processingParameters[0] = tokens[pos++];
				quad._processingParameters[1] = tokens[pos++];
				quad._processingParameters[2] = tokens[pos++];
				quad._processingParameters[3] = tokens[pos++];
				quad._processingParameters[4] = tokens[pos++];
				
			
				quad._displayTime = _zvAdSpaceEditor.getDisplayTime(quad._startTimeStamp);
									
				for(var p:uint=0; p<nSpaces; p++) 
				{
					var x:Number = tokens[pos++] * _zvAdSpaceEditor._adSpaceHandler._scale;
					var y:Number = tokens[pos++] * _zvAdSpaceEditor._adSpaceHandler._scale;
					var pnt:Point = new Point(x,y);	
					quad.addCoordinate( pnt );
				}
				
				_zvAdSpaceEditor._adSpaceHandler.insertAdSpace(quad , _zvAdSpaceEditor._creativesFeed);				
				
			}		
		
		}	
		
				
				
	}//class
}//package