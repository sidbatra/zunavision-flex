/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    UserInfoEvent.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Called when user info is retrevied from the server
*****************************************************************************/
package events
{
	import flash.events.Event;

	public class UserInfoEvent extends Event
	{
		//-------------------------------------------------------------------
		//
		// Constants
		//
		//-------------------------------------------------------------------
		
		
		public static const USER_INFO:String = "UserInfo";
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		public var info:String = "";
		
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function UserInfoEvent(type:String , info_p:String)
		{
			super(type,true);
			
			info = info_p;
		}
		
	}
}