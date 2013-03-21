/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    User.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Properties for the current user
*****************************************************************************/
package containers
{
	public class User
	{
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _userID:int = 0;
		private var _uniqueName:String = "";
		private var _firstName:String = "";
		private var _lastName:String = "";
		private var _picURL:String = "";
		private var _profileURL:String = "";
		
		//-------------------------------------------------------------------
		//
		// Static Variables
		//
		//-------------------------------------------------------------------
		
		//public static var currentUser:User = new User(2,"swatidube" , "Swati" , "Dube" , "images/gumps.jpg","http://www.facebook.com/swatidube");
		public static var currentUser:User = new User(-1,"","","","","");

		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function User(userID_p:int , uniqueName_p:String ,  firstName_p:String , lastName_p:String 
								, picURL_p:String , profileURL_p:String):void
		{
			_userID = userID_p;
			_uniqueName = uniqueName_p;
			_firstName = firstName_p;
			_lastName = lastName_p;
			_picURL = picURL_p;		
			_profileURL = profileURL_p;
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get userID():int
		{
			return _userID;
		}
		
		public function get uniqueName():String
		{
			return _uniqueName;
		}
		
		public function get fullName():String
		{
			return _firstName + " " + _lastName;
		}
		
		public function get firstName():String
		{
			return _firstName;
		}
		
		public function get picURL():String
		{
			return _picURL;
		}
		
		public function get profileURL():String
		{
			return _profileURL;
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		
		public static function getUserFromServerString(userInfo:String):User
		{
			var result:User = null;
			var info:Array = userInfo.split(Constants.SPACE);
			
			if( info.length > 0 )
				result = new User((int)(info[0]),info[1],info[2],info[3],info[4],info[5]);					
			
			return result;
		}
		
		public static function isLoggedIn():Boolean
		{
			return  User.currentUser.userID != -1
		}
		
		//Extracts server string and populates the current user
		public static function setCurrentUser(userInfo:String):void
		{
			User.currentUser = User.getUserFromServerString(userInfo);
		}
		
	}
}