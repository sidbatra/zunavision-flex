// ActionScript file

package utilities
{
	
	public class UtilityFunctions {
	
		public static function truncateString(s:String, len:int=40):String {
			var tString:String = s;
			if (s.length > len) {
				tString = s.substring(0,len-7) + "..." + s.substring(s.length-5,s.length); 
			}
			return tString;
		}	
		
		//Forms the metadata filename along with a random argument to prevent caching
		public static function formMetaDataFileName(url:String):String
		{
			return url.split('.').slice(0,-1).join('.') + Constants.EXT_FOR_METADATA_FILE  + 
				Constants.DEFAULT_ARG_FOR_METADATA_FILE + 
				Math.floor( Math.random() * Constants.METADATA_FILENAME_SCALEUP );
		}
	}
	
}