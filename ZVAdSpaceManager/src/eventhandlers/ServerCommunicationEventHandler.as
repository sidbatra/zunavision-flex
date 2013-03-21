/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ServerCommunication.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com> 
** DESCRIPTION:
** Handles communication with the main server
*****************************************************************************/

package eventhandlers
{
	import components.ZVAdSpaceManager_as;
	import mx.rpc.events.FaultEvent;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.controls.*;
	
	public class ServerCommunicationEventHandler
	{
		public static var _zvManager:ZVAdSpaceManager_as;
		
		public static function onFault(event:FaultEvent):void {
		
		}

		public static function OnTotalFileSizeLimitReached():void{
		    Alert.show("The total file size limit has been reached.");
		}
		
		public static function OnFileSizeLimitReached(fileName:String):void{
		    Alert.show("The file '" + fileName + "' is too large and will not be added.");
		}

		//  error handlers
		public static function OnHttpError(event:HTTPStatusEvent):void{
			Alert.show("There has been an HTTP Error: status code " + event.status);
		}
		public static function OnIOError(event:IOErrorEvent):void{
			Alert.show("There has been an I/O Error: " + event.text);
		}
		
		public static function OnSecurityError(event:SecurityErrorEvent):void{
			Alert.show("There has been a Security Error: " + event.text);
		}
	}
}