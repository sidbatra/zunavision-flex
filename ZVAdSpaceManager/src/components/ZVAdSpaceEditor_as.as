/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVAdSpaceEditor_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Manages the creation and editing of ad-spaces within videos
*****************************************************************************/
package components
{		
	//Flash imports
	import containers.AdSpace;
	import containers.AdSpaceHandler;
	
	import eventhandlers.AdSpaceEditingEventHandler;
	import eventhandlers.VideoPlayerEventHandler;
	import eventhandlers.VideoSetupEventHandler;
	
	import events.ImageLoadedEvent;
	
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.containers.Form;
	import mx.containers.Panel;
	import mx.containers.VBox;
	import mx.controls.*;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.ListEvent;
	import mx.events.SliderEvent;
	import mx.states.State;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.net.*;
	
	import utilities.ImageUploader;
	import utilities.UtilityFunctions;
	//--------------------------------------	
	
			
	public class ZVAdSpaceEditor_as extends Form
	{
			
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
			
		public var _graphicsLayer:GraphicsLayer;
		public var _currentAdSpace:AdSpace;
		[Bindable]
		public var _adSpaceHandler:AdSpaceHandler;
					
		public var _video:Video;
		private var _nc:OvpConnection;
		public var _ns:OvpNetStream;
		
		public var _playBtnStatePlaying:Boolean;
		public var _loadMetaData:Boolean = false;
		public var _internalDataEntryMode:int = -1;
		public var _videoStatsLoaded:Boolean = false;
		public var _saveTrackingInfo:Boolean = false;
		
		public var _currentMousePosition:Point ;
		public var _currentTrackPoint:Point ;
		
		
		public var _streamLength:Number;
		public var _fps:Number = 29.97;
		public var _scale:Number = 1.0;
		public var _originalVideoContainerHeight:Number;
		public var _renderedFrames:int = 0;
		public var _contentID:uint = 0;
		
		private var _videoFilename:String;		
		public var _downloadURL:String = "";
		
		public var _downloadRequest:URLRequest ;
		public var _fileReference:FileReference;
		
		
		private var _xmlMetaData:XML;
		public var _xmlOutputMetaData:XML = <video xmlns:ns="www.zunavision.com/ns" />;
		private var _xmlLoaded:Boolean = false;
		private var _adSenseMetaData:XML ;
		private var _adsLoaded:Boolean = false;
				
		
		//Styles-----------------------------
		[Embed("./images/playButton.png")]
        public const playButtonStyle:Class
            
        [Embed("./images/pauseButton.png")]
        public const pauseButtonStyle:Class
        //----------------------------------
        
        private var _playTimer:Timer;
        
        [Bindable]
		public var videoPlayButton:Button;		
		public var doneEditingButton:Button;
		[Bindable]
		public var fullScreenButton:Button;	
		[Bindable]
		public var downloadVideoButton:Button;
		[Bindable]
		public var closeZVEditorButton:Button;
		public var saveXMLButton:Button;
		public var checkAdWords:Button;

		[Bindable]
		public var editorPanel:Panel;	
		[Bindable]	
		public var videoBox:VBox;
		public var videoUIC:UIComponent;
		public var _adOverlay:Canvas;
		public var _annotation:ZVAnnotation;
		public var _trackball:ZVTrackBall;
		
		[Bindable]
		public var bufferProgressBar:ProgressBar;
		[Bindable]
		public var videoProgressSlider:HSlider;
		public var adSpaceDataGrid:DataGrid;
		
		public var videoNameLabel:Label;
		[Bindable]
		public var videoTimerText:Text;
		public var queryText:TextArea;
		
		public var fadeIn:Fade;
		public var fadeOut:Fade;
		
		public var viewMode:State;
		public var editMode:State;
				
		public var creativesTileList:TileList;
				
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVAdSpaceEditor_as()
		{
			super();
			
			//Set reference of class to event handler encapsulations
			AdSpaceEditingEventHandler._zvEditor = this;
			VideoPlayerEventHandler._zvEditor = this;
			VideoSetupEventHandler._zvEditor = this;
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
   		
   		//Returns the time stamp in mlliseconds of the current frame
   		public function get timeStamp():Number
   		{   		
   			return  Math.ceil(videoProgressSlider.value * Constants.TIMESTAMP_SCALE ) / Constants.TIMESTAMP_SCALE ;
   		}
   		
   		public function set loadMetaData(status:Boolean):void
   		{
   			_loadMetaData = status;
   		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		
		// Initialize the ZVADSE
		public function initializeEditor():void 
		{
			
			
			//Initialize data members
			_graphicsLayer = new GraphicsLayer();		
			_currentAdSpace = new AdSpace();
			_adSpaceHandler = new AdSpaceHandler();			
			_nc = new OvpConnection();			 
			_video = new Video(0,0);
			_playTimer = new Timer(Constants.TIMER_TICK);
			var defaultCreativeUploader:ImageUploader = new ImageUploader();
			
			//Setup member variables
			_playBtnStatePlaying = false;
			videoBox.visible = false;
			videoProgressSlider.visible = false;
			_video.x = 0;_video.y = 0;
			_streamLength = 0;			
			_originalVideoContainerHeight = videoBox.height;
			
			
			//Net connection event listeners			
			_nc.addEventListener(OvpEvent.ERROR, VideoPlayerEventHandler.errorHandler);
			_nc.addEventListener(OvpEvent.STREAM_LENGTH, VideoPlayerEventHandler.streamLengthHandler );
			_nc.addEventListener(NetStatusEvent.NET_STATUS, VideoPlayerEventHandler.netStatusHandler);
			
			//Stage event listeners
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenModeHandler);
			
			videoProgressSlider.addEventListener("change",VideoPlayerEventHandler.videoProgressHandler);
			videoProgressSlider.addEventListener(SliderEvent.THUMB_DRAG,VideoPlayerEventHandler.videoProgressDragHandler);
			
			//Timer event listeners 	
			_playTimer.addEventListener("timer", playTimerTick);
						
			//Button event listeners
			videoPlayButton.addEventListener(MouseEvent.CLICK, VideoPlayerEventHandler.playPauseHandler);
			fullScreenButton.addEventListener(MouseEvent.CLICK, toggleFullScreenMode);
			saveXMLButton.addEventListener(MouseEvent.CLICK,saveXML);
			checkAdWords.addEventListener(MouseEvent.CLICK,loadWebpage);
						
			//State listeners
			viewMode.addEventListener("enterState",viewStateEnabled);
			editMode.addEventListener("enterState",editStateEnabled);
			
			//Image uploading listeners
			defaultCreativeUploader.addEventListener("ImageLoadedEvent",defaultCreativeLoaded);
			
			
			//Perform initial operations
			//defaultCreativeUploader.loadImage(Constants.DEFAULT_ZV_CREATIVE_URL,0);
			videoUIC.addChild(_video);
			videoUIC.addChild(_graphicsLayer);	
			
			_adOverlay = new Canvas();			
			videoUIC.addChild(_adOverlay);
			
			_annotation = new ZVAnnotation();			
			editorPanel.addChild(_annotation);
			_annotation.x = 550; _annotation.y = 150;
			_annotation.visible = false;
			
			_trackball = new ZVTrackBall();			
			editorPanel.addChild(_trackball);			
			_trackball.visible = false;
				
			if( currentState == Constants.EDIT_MODE_STRING )
				editStateEnabled(new Event(""));
			else if( currentState == Constants.VIEW_MODE_STRING )
				viewStateEnabled(new Event(""));
		}
		

		
   		//Returns the given time in milliseconds in a nice readable format
		public function getDisplayTime(sec:Number):String 
		{			   			
			var h:Number = Math.floor(sec/3600);
			var m:Number = Math.floor((sec%3600)/60);
			var s:Number = Math.floor((sec%3600)%60);
			
			return (h == 0 ? "":(h<10 ? "0"+h.toString()+":" : h.toString()+":"))+(m<10 ? "0"+m.toString() : m.toString())+":"+(s<10 ? "0"+s.toString() : s.toString() );
		}
		
		//Lodas a fresh video into the UI
		public function loadVideo(filename:String, title:String , tracksXML:String , adSenseXML:String , fps:Number):void 
		{   
			videoProgressSlider.value = 0;			   						
			hideUI();
			videoBox.visible = false;
			
			_videoFilename = filename;
			//_downloadURL = downloadURL;
			_fps = fps;
			
			loadXMLData(tracksXML);
			loadAdData(adSenseXML);
			
			videoNameLabel.text = UtilityFunctions.truncateString(title, Constants.MAX_LENGTH_OF_FILENAME);
			
			if (_nc.netConnection is NetConnection) 
				_nc.close();
			
			_nc.connect(null);
			
			
		}
		
		//Launches the application only after all the constituent events have finished
		public function launchApplication():void
		{
			
			if( _xmlLoaded && _videoStatsLoaded && _adsLoaded)
			{
				
				_ns.addEventListener("render", mainVideoRender);
				_ns.seek(0);
													
				trace(" official player launch");				
				//launchNewVideo(_filename);
				
				playVideo();
				//_playTimer.start();
				//videoContainer.visible = true;
				
			}
		}
		
		private function saveXML(event:MouseEvent):void
		{	
			_fileReference = new FileReference();
			_fileReference.save(_xmlOutputMetaData.toXMLString(),"test.xml");
			
		}
		
		private function loadWebpage(event:MouseEvent):void
		{
			var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, webpageLoadingComplete);

			var query:String =  queryText.text;//"book";
            var request:URLRequest = new URLRequest("http://www.google.com/custom?hl=en&safe=active&client=google-coop&cof=FORID%3A13%3BAH%3Aleft%3BCX%3ATester%3BL%3Ahttp%3A%2F%2Fwww.google.com%2Fcoop%2Fintl%2Fen%2Fimages%2Fcustom_search_sm.gif%3BLH%3A65%3BLP%3A1%3BVLC%3A%23551a8b%3BGFNT%3A%23666666%3BDIV%3A%23cccccc%3B&adkw=AELymgVDU4p6vEckVoYyOghACtc8mO0AOel4NQgv4rhY5TiOOrHzKT_VKmJgxXhc05k8LKqAU-zcFP9UvGoNuQHpto-l2T0Hi3hECr37rhE8AvbIuhCN5to&q=" + query + "&btnG=Search&cx=016548152047214406737%3Acqekh-xh_zy");
            
            loader.load(request);
		}
		
		public function webpageLoadingComplete(event:Event):void
		{			
			var loader:URLLoader = URLLoader(event.target);			
			var source:String = loader.data;			
			var split:Array = source.split(' ');			
			
			var url:String  = "";
			var title:String = "";
			var displayurl:String = "";
			var text:String = "";
			
			for( var i:uint=0 ; i<split.length ; i++)
			{
				if( split[i] == "id=pa1" )
				{
					url = split[i+1];
					url = url.substring(5,url.length);
					url = "http://www.google.com" + url;
					
					for( var j:uint=i+3 ; j<i+3+10 ; j++ )
					{
						if( split[j].toString() == "size=-1><span") 
							break;
						
						title = title + split[j] + " ";
					}
					
					title = title.substring(6,title.length - 14);	 
					displayurl = split[j+1].toString().substring(8,split[j+1].toString().length - 13);
					
					var endIndex:int = -1;
					
					for( var k:uint=j+4 ; k<j+4+13 ; k ++ )
					{	
						endIndex = split[k].toString().indexOf("</font");
						
						if( endIndex != -1 )
						{
							text += split[k].toString().substring(0,endIndex);
							break;
						}
						 
						text += split[k] + " ";	
					} 
					
						
					_annotation.titleLabel.text = title;
					_annotation.urlLabel.text = displayurl;
					_annotation.textLabel.text = text;
					_annotation.setURL(url);
					_annotation.visible = true;
					
				}//if pa1
				
				
			}//for i
		
               
		}
		
		//Loads the XMl meta data for the current video
		private function loadXMLData(xmlFilename:String):void
		{
			var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, trackLoadingComplete);

            var request:URLRequest = new URLRequest(xmlFilename);
            
            loader.load(request);
			
		}
		

		
		//Loads the XMl meta data for the current video
		private function loadAdData(xmlFilename:String):void
		{
			var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, adSenseLoadingComplete);

            var request:URLRequest = new URLRequest(xmlFilename);
            
            loader.load(request);
			
		}
				
 		
		//Seeks to a specific point in the video stream
   		public function seekStream(time:Number , setSliderValue:Boolean=true):void 
   		{			
   			_ns.seek(time);
   			videoTimerText.text = getDisplayTime(time);
   			_adSpaceHandler.drawAdSpaces(_graphicsLayer,time);
   			
   			if( setSliderValue )
   				videoProgressSlider.value = time;
   		}
			
		//Launches a fresh video
   		private function playVideo():void 
   		{   			
   			_graphicsLayer.clean();
   			showUI();
   			_playBtnStatePlaying = true;
   			//this.videoPlayButton.setStyle("skin",playButtonStyle);   			
   			this.videoPlayButton.setStyle("skin",pauseButtonStyle);
   			_ns.play(_videoFilename);
   			
   		}
   		
   		//Stops a video in progress
   		public function stopVideo():void
   		{
   			_ns.close();
   		}
   		
   		//Loops a video back to the start
   		public function refreshVideo():void
   		{
   			if( _playBtnStatePlaying )
   			{	
   				VideoPlayerEventHandler.playPauseHandler(new MouseEvent(""));
   				seekStream(0);			
				_adSpaceHandler.drawAdSpaces(_graphicsLayer,timeStamp);						
				_adOverlay.graphics.clear();
   				_annotation.visible = false;		
   			}
   		}
		
		//Displays the UI of the player when the video is ready
		private function showUI():void 
		{
			//fadeIn.play([editorPanel]);
			editorPanel.alpha = 1.0;
		
		}
		
		//Hides the UI of the player until the video is ready
		private function hideUI():void 
		{
			editorPanel.alpha = 0.0;
			
		}
		

		//Launches the video when a connection is successfully established		
		public function netConnectionFound():void 
		{
			trace("Successfully connected to: " + _nc.netConnection.uri);
			
			// Instantiate an OvpNetStream object
			_ns = new OvpNetStream(_nc);
			
			// Add the necessary listeners
			_ns.addEventListener(NetStatusEvent.NET_STATUS, VideoPlayerEventHandler.streamStatusHandler);			
			_ns.addEventListener(OvpEvent.NETSTREAM_PLAYSTATUS, VideoPlayerEventHandler.streamPlayStatusHandler);
			_ns.addEventListener(OvpEvent.NETSTREAM_METADATA, VideoPlayerEventHandler.metadataHandler);
			_ns.addEventListener(OvpEvent.PROGRESS, VideoPlayerEventHandler.updateHandler);
			_ns.addEventListener(OvpEvent.STREAM_LENGTH, VideoPlayerEventHandler.streamLengthHandler); 

			// Give the video object our net stream object
			_video.attachNetStream(_ns);

			
			//playVideo();
			_ns.play(_videoFilename);
			_ns.pause();
			_adSpaceHandler = new AdSpaceHandler();
		}
		
		//Scales the video to make it fit the availible area
		public function scaleVideo(scale:Number):void
		{		
			_video.width *= scale;
			_video.height *= scale;
			
			videoUIC.height = _video.height ;
			videoUIC.width = _video.width ;	
			
			_adSpaceHandler.scaleAdSpaces(scale);
			_adSpaceHandler.drawAdSpaces(_graphicsLayer,this.timeStamp);
			
			//Fire the scale ready event only if the video has metdata
			if( _loadMetaData )
				VideoSetupEventHandler.adSpaceScaleReady(scale);			
			
		}
		
		//Sets the creative name for the selected index in the grid
		public function setCreativeForSelectedItem(imageID:int , imageName:String , bitmapData:BitmapData):void
		{	
			//Proceed only if an adspace has been selected
			if( adSpaceDataGrid.selectedItem != null )
			{		
				//Buffer selected index
				var selectedIndex:uint = adSpaceDataGrid.selectedIndex;
			
				_adSpaceHandler.setCreativeInformation((AdSpace)(adSpaceDataGrid.selectedItem),imageID,imageName,bitmapData);
				_adSpaceHandler.drawAdSpaces(_graphicsLayer,timeStamp);
				
				//Replae selected index on the grid for further selections
				adSpaceDataGrid.selectedIndex=selectedIndex;					
			}	
					
		}
		
		//Updates the adSpaceHandler to show the new selected adspace
		public function updateSelectedAdSpace():void
		{
			_adSpaceHandler._selectedIndex = adSpaceDataGrid.selectedItem._hashIndex;
 			_adSpaceHandler._selectionTimeStamp = adSpaceDataGrid.selectedItem._startTimeStamp;			
		}

		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		public function mainVideoRender(event:Event):void
		{
				//return;	
			trace(_renderedFrames);
			
			
			if ( _saveTrackingInfo )
			{
				var contentID:String =_contentID.toString() ;
				var frameID:String = _renderedFrames.toString();			
				_xmlOutputMetaData.appendChild(<frame id={frameID}> <contentT id={contentID} cid={contentID}>  <poly x={_currentMousePosition.x} y={_currentMousePosition.y}> </poly> </contentT> </frame>);
			}
			
					
			
			var xmlFrameData:XMLList = _xmlMetaData.frame.(hasOwnProperty("@id") && @id == String(_renderedFrames));
			
			
			
			_adOverlay.graphics.clear();
			
			
			
			//If frame data is found
			if(xmlFrameData.length() > 0  ) 
			{
				var cid:uint = uint(xmlFrameData.contentT[0].@cid);
				
				_annotation.visible = true;
				_trackball.visible = true;
								
				var adSenseData:XMLList = _adSenseMetaData.adsense.(hasOwnProperty("@cid") && @cid == String(cid));
				
						
				/*var x0:Number = Number(xmlFrameData.contentT[0].poly.@x0) * _scale;
				var y0:Number = Number(xmlFrameData.contentT[0].poly.@y0) * _scale;
			
				var x1:Number = Number(xmlFrameData.contentT[0].poly.@x1) * _scale;
				var y1:Number = Number(xmlFrameData.contentT[0].poly.@y1) * _scale;
			
				var x2:Number = Number(xmlFrameData.contentT[0].poly.@x2) * _scale;
				var y2:Number = Number(xmlFrameData.contentT[0].poly.@y2) * _scale;
			
				var x3:Number = Number(xmlFrameData.contentT[0].poly.@x3) * _scale;
				var y3:Number = Number(xmlFrameData.contentT[0].poly.@y3) * _scale;
				
				var x:Number = (x0 + x1 + x2 + x3) / 4;
				var y:Number = (y0 + y1 + y2 + y3) / 4;*/
				
				var x:Number = xmlFrameData.contentT[0].poly.@x;
				var y:Number = xmlFrameData.contentT[0].poly.@y;
				
				_annotation.titleLabel.text = adSenseData.@title;
				_annotation.textLabel.text = adSenseData.@text;
				_annotation.urlLabel.text = adSenseData.@url;
				_annotation.setURL(adSenseData.@url);
								
				
				_adOverlay.graphics.lineStyle(1,0xFB9E15);				
				_adOverlay.graphics.moveTo(0,0);
				_adOverlay.graphics.lineTo(x , y );
			
				_trackball.x = videoUIC.x +  x;_trackball.y = videoBox.y +  y;	
				//_trackball.x = videoUIC.x ;_trackball.y = videoBox.y ;
				
				
				_currentTrackPoint = new Point(x,y);
        	
			}
			else 
			{
				var xmlFrameDataP:XMLList = _xmlMetaData.frame.(hasOwnProperty("@id") && @id == String(_renderedFrames-1));
				var xmlFrameDataN:XMLList = _xmlMetaData.frame.(hasOwnProperty("@id") && @id == String(_renderedFrames+1));
				
				if( xmlFrameDataN.length() > 0 && xmlFrameDataP.length() > 0 )
				{
					_adOverlay.graphics.lineStyle(1,0xFB9E15);
					_adOverlay.graphics.moveTo(0,0);
					_adOverlay.graphics.lineTo(_currentTrackPoint.x , _currentTrackPoint.y );
				
				}
				else 
				{	
					_annotation.visible = false;
					_trackball.visible = false;
				}
				
			}
			
			
			
			_renderedFrames++;
			
			
			
		}
		
		
		
				//XML loading events------------------------------------------------
		public function trackLoadingComplete(event:Event):void
		{			
			trace("XML has been loaded");
			
			var loader:URLLoader = URLLoader(event.target);            
            var vars:URLVariables = new URLVariables(loader.data);
            
             _xmlMetaData = new XML(loader.data);  
             
             _xmlLoaded = true;       
             launchApplication();   
               
		}
		
		public function adSenseLoadingComplete(event:Event):void
		{			
			trace("Ads sense has been loaded");
			
			var loader:URLLoader = URLLoader(event.target);            
            var vars:URLVariables = new URLVariables(loader.data);
            
             _adSenseMetaData = new XML(loader.data);  
             
             _adsLoaded = true;       
             launchApplication();   
               
		}
		
		//Uploading events-------------------------------------------------------
		
		//Loasds the default zunavision creative image
		public function defaultCreativeLoaded(event:ImageLoadedEvent):void
		{
			_currentAdSpace._creativeData = event._bitmapData;				
		}
		//-------------------------------------------------------------------
		
		//State events-------------------------------------------------------
		
		//Modifies the event handlers when UI goes into view state
		public function viewStateEnabled(event:Event):void
		{
			_graphicsLayer.clean();
			videoUIC.addEventListener(MouseEvent.MOUSE_DOWN,AdSpaceEditingEventHandler.videoUIC_mouseDown);
			videoUIC.addEventListener(MouseEvent.MOUSE_UP,AdSpaceEditingEventHandler.videoUIC_mouseUp);
			videoUIC.addEventListener(MouseEvent.MOUSE_MOVE,AdSpaceEditingEventHandler.videoUIC_mouseMove);
			//videoUIC.removeEventListener(MouseEvent.MOUSE_DOWN,AdSpaceEditingEventHandler.videoUIC_mouseDown);
			//videoUIC.removeEventListener(MouseEvent.MOUSE_UP,AdSpaceEditingEventHandler.videoUIC_mouseUp);
			//videoUIC.removeEventListener(MouseEvent.MOUSE_MOVE,AdSpaceEditingEventHandler.videoUIC_mouseMove);
			Application.application.removeEventListener(KeyboardEvent.KEY_DOWN,AdSpaceEditingEventHandler.stage_keyDown);
			downloadVideoButton.addEventListener(MouseEvent.CLICK,VideoPlayerEventHandler.downloadVideoHandler);
			
		}
		
		//Modifies the event handlers when UI goes into edit state
		public function editStateEnabled(event:Event):void
		{			
			videoUIC.addEventListener(MouseEvent.MOUSE_DOWN,AdSpaceEditingEventHandler.videoUIC_mouseDown);
			videoUIC.addEventListener(MouseEvent.MOUSE_UP,AdSpaceEditingEventHandler.videoUIC_mouseUp);
			videoUIC.addEventListener(MouseEvent.MOUSE_MOVE,AdSpaceEditingEventHandler.videoUIC_mouseMove);
			Application.application.addEventListener(KeyboardEvent.KEY_DOWN,AdSpaceEditingEventHandler.stage_keyDown);
			adSpaceDataGrid.addEventListener(mx.events.ListEvent.ITEM_CLICK,navigateToAdSpace);						
			_adSpaceHandler.drawAdSpaces(_graphicsLayer,this.timeStamp);
			
		}		
		//-------------------------------------------------------------------
		
		//Fullscreen events-------------------------------------------------
		
		//Toggles between fullscreen and normal modes
		public function toggleFullScreenMode(event:MouseEvent):void
		{
			
			switch (this.stage.displayState) 
			{
               case StageDisplayState.FULL_SCREEN:
               		this.stage.displayState = StageDisplayState.NORMAL;
                    break;
				default:
				 stage.fullScreenSourceRect = new Rectangle(0,0,editorPanel.width,editorPanel.height);                   
                    this.stage.displayState = StageDisplayState.FULL_SCREEN;
                   
                break;
		   }
						
		}
		
		//Handles changes to UI when application goes full screen
		public function fullScreenModeHandler(event:FullScreenEvent):void
		{
			
									
		}		
		//------------------------------------------------------------------
		
		
		
		//Timer events------------------------------------------------------	
			
		//Handles the tick event of the play timer
		public function playTimerTick(event:TimerEvent):void
		{
			VideoPlayerEventHandler.playPauseHandler(new MouseEvent(""));
			_playTimer.stop();			
		}
		
		//-------------------------------------------------------------------

		//AdSpace data grid events--------------------------------------------
		
		//Handles mouse click on the adSpaceDataGrid
 		public function navigateToAdSpace(event:mx.events.ListEvent):void
 		{	
 			updateSelectedAdSpace();
 			seekStream(adSpaceDataGrid.selectedItem._startTimeStamp);
 			
 			  			
 		} 		
 		//-------------------------------------------------------------------
 		
	}//class
	
}//package