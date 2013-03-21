/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    MathUtilities.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Basic utilities for the application
*****************************************************************************/
package utilities
{
	import containers.User;
	
	import mx.controls.Alert;
	
	
		
	public class Utilities
	{
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
				
		//Returns the given time in milliseconds in a nice readable format
		public static function getDisplayTime(sec:Number):String 
		{			   			
			var h:Number = Math.floor(sec/3600);
			var m:Number = Math.floor((sec%3600)/60);
			var s:Number = Math.floor((sec%3600)%60);
			
			return (h == 0 ? "":(h<10 ? "0"+h.toString()+":" : h.toString()+":"))+(m<10 ? "0"+m.toString() : m.toString())+":"+(s<10 ? "0"+s.toString() : s.toString() );
		}
		
		//Converts a given time stamp to its hashed version
		public static function toHashTimeStamp(timeStamp:Number):uint
		{			
			return (uint)(Math.floor(timeStamp));
		}
		
		//Clips the given number to 3 decimal places
		public static function clipToThreeDecimals(data:Number):Number
		{
			return ((int)(data * 1000.0)) / 1000.0
		}
		
		//Normalizes the given number
		public static function normalize(num:Number , oldScale:Number , newScale:Number):int 
		{
			return (int)( (num * newScale) / oldScale);
		}
		
			
	}//class
	
}//package