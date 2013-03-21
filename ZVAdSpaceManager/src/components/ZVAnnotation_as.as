/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVAnnotation_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Manages the creation and editing of ad-spaces within videos
*****************************************************************************/
package components
{		
	//Flash imports

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Panel;
	import mx.controls.*;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.net.*;
	//--------------------------------------	
	
			
	public class ZVAnnotation_as extends Panel
	{
			
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
		public var mainButton:Button ;
		public var titleLabel:Text;
		public var textLabel:Text;
		public var urlLabel:Text;
		
		private var _urlRequest:URLRequest ;
		
				
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVAnnotation_as()
		{
			super();
			
		}
		
		public function initializeAnnotation():void
		{
			mainButton.addEventListener(MouseEvent.CLICK,clickHandler);
			titleLabel.addEventListener(MouseEvent.CLICK,clickHandler);
			textLabel.addEventListener(MouseEvent.CLICK,clickHandler);
			urlLabel.addEventListener(MouseEvent.CLICK,clickHandler);
			mainButton.useHandCursor = true;
			titleLabel.useHandCursor = true;
			textLabel.useHandCursor = true;
			urlLabel.useHandCursor = true;
		}
		
		public function setURL(url:String):void
		{
			_urlRequest = new URLRequest(url);
		}
		
		public function clickHandler(event:MouseEvent):void
		{
			    
               navigateToURL(_urlRequest ,"_blank");
		}
 		
	}//class
	
}//package