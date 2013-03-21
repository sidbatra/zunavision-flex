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

	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
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
	
			
	public class ZVTrackBall_as extends Panel
	{
			
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
			
		
				
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVTrackBall_as()
		{
			super();

		}
		
		
 		
	}//class
	
}//package