package eventhandlers
{
	import components.ZVAdSpaceManager_as;
	import events.*;
	import components.FileUpload;
	
	public class FileUploadEventHandler
	{
		public static var _zvManager:ZVAdSpaceManager_as ;
		
		// fired when a the remove file button is clicked
		public static function OnFileRemoved(event:FileUploadEvent):void
		{
			_zvManager._videoUploadManager._uploadedBytes -= FileUpload(event.Sender).BytesUploaded;
			_zvManager.fileUploadBox.removeChild(FileUpload(event.Sender));				
			_zvManager._videoUploadManager.ComputeTotalFileSize(_zvManager.fileUploadBox);
			if(_zvManager._videoUploadManager._currentUpload == FileUpload(event.Sender))
				_zvManager.UploadVideoFiles();
				//OnUploadFilesClicked(null);
			
		}
		
		// fired when a file has finished uploading
		public static function OnFileUploadComplete(event:FileUploadEvent):void
		{
			_zvManager._videoUploadManager._currentUpload == null;
			//OnUploadFilesClicked(null);
			_zvManager.UploadVideoFiles();
			_zvManager._serverComm.requestThumbnailList();
		}
		
		// fired when upload progress changes
		public static function OnFileUploadProgressChanged(event:FileUploadProgressChangedEvent):void
		{
			_zvManager._videoUploadManager._uploadedBytes += event.BytesUploaded;	
		}

	}
}