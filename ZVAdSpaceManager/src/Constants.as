/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    Constants.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>, Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Encapsulates all the constants needed by the application
*****************************************************************************/
package
{
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	
	
	public class Constants
	{
		
		//AdSpace.as constants		
		public static const ADSPACE_PARAMETER_DEFAULTS:Array = new Array(0,3,1,1,1);
		//---------------------------------------------------
		
		//AdSpaceHandler.as constants
		public static const SELECTION_RADIUS:uint = 10;
		//---------------------------------------------------
		
		//ZVAdSpaceEditor_as.as constants
		public static const XSHIFT_ADSPACE:Number = 1;
		public static const YSHIFT_ADSPACE:Number = 1;
		public static const DEFAULT_ZV_CREATIVE_URL:String = "/zuna_insert_nsq.png";		
		public static const TIMER_TICK:uint = 300;
		public static const MAX_LENGTH_OF_FILENAME:uint = 50;
		public static const EDIT_MODE_STRING:String =  "editMode";
		public static const VIEW_MODE_STRING:String  = "viewMode";
		public static const TIMESTAMP_SCALE:Number = 10000000;
		//---------------------------------------------------
		
		//ZVAdSpaceManager_as.as constants
		public static const EXT_FOR_METADATA_FILE:String=".zna";
		public static const URL_FOR_UPLOAD_IMAGE:String="/images/upload_creative.png";
		public static const DEFAULT_ARG_FOR_METADATA_FILE:String="?noCache=";
		public static const METADATA_FILENAME_SCALEUP:int=1000000;
		//---------------------------------------------------
		
		// ZVTileList UI Constants
		public static const TILE_MARGIN:uint = 26;
		public static const THUMBNAIL_HEIGHT:uint = 135;
		
		
		//GraphicsLayer.as constants		
		public static const LINE_THICKNESS:uint = 1;
		public static const LINE_COLOR:uint = 0xff6600;
		public static const LINE_THICKNES_SELECTED:uint = 1;
		public static const LINE_COLOR_SELECTED:uint = 0x00ffff;
		public static const RADIUS_FOR_CIRCLE:Number = 7.5;
		public static const ALPHA_FOR_AD_LAYER:Number = 0.6;		
		public static const BITMAP_TRANS_DIV:uint = 5;
		public static const DEFAULT_POINTS_IN_ADSPACE:uint = 4;
		public static const DEFAULT_CREATIVE_NAME:String = "SelectCreative";
		public static const DEFAULT_CREATIVE_ID:uint = 0;		
		//---------------------------------------------------
		
		//ServerCommunication.as constants
		public static const SERVER_REQ_ID_NAME:Array = new Array("&id=", "&id=", "&id=", "&meta=");
		public static const SERVER_VIDEO_PARAM:String = '&vid=';
		public static const SERVER_REQ_URL:Array = new Array("/a/flash_delvideo" , "/a/flash_deloutputvideo" ,"/a/flash_delimage" ,"/a/flashmetadata");
		public static const SERVER_REQ_METHOD:Array = new Array("POST" , "POST" ,"POST" ,"POST");
		public static const SPACE:String = "SPACE";
		public static const LINE:String = "LINE";
		public static const END:String = "END";
		public static const DEFAULT_FRAME_EXT:String = ".jpg";
		public static const DEFAULT_CREATIVE_EXT:String = ".jpg";
		public static const FEED_URL:String = "InfoService";
		//---------------------------------------------------
		
		
	}
}