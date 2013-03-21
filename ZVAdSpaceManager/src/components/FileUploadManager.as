/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    FileUploadManager.as
** AUTHOR(S):   Ashutosh Saxena <ashutosh@zunavision.com>
** DESCRIPTION:
** Object to handle a specific type of file Upload
*****************************************************************************/

package components
{
	import eventhandlers.FileUploadEventHandler;
	import eventhandlers.ServerCommunicationEventHandler;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReferenceList;
	
	import mx.containers.VBox;
	
	public class FileUploadManager
	{
		public var _currentUpload:FileUpload;
		public var _uploadedBytes:Number;
		
		public var _totalSize:Number;
		public var _uploadFileSize:Number;
		public var _totalUploadSize:Number;

		public var _uploadInd:int = 0;
		
		public function FileUploadManager(temp1:String="", temp2:String="")
		{
			_totalSize = 0;
			_uploadedBytes = 0;
			
			if(temp1 != null && temp1 != "")
			    _totalUploadSize = new Number(temp1);
			else
			    _totalUploadSize = 0;
			    
			if(temp2 != null && temp2 != "")
			    _uploadFileSize = new Number(temp2);
			else
			    _uploadFileSize = 0;		
		}

		public function UploadFiles(fileUploadArray:Array):void{
			// get all the files to upload
			//var fileUploadArray:Array = fileUploadBox.getChildren();
			// initialize a helper boolean variable
			var fileUploading:Boolean = false;			
			_currentUpload = null;
			
			// go through the files to check if they have been uploaded and get the first that hasn't
			for(var x:uint=0;x<fileUploadArray.length;x++)
			{
				//Alert.show(FileUpload(fileUploadArray[x])._file.name);
				// find a file that hasn't been uploaded and start it
				if(!FileUpload(fileUploadArray[x]).IsUploaded) {
					fileUploading = true;
					// set the current upload and start the upload
					_currentUpload = FileUpload(fileUploadArray[x]);
					_currentUpload.Upload();
					break;
				}
			}	
			// if all files have been uploaded
			if(!fileUploading) {
				resetUpload();
			}
		}

		// fired when the cancel button is clicked
		public function resetUpload():void{
			// if there is a file being uploaded then cancel it and adjust the uploaded bytes variable to reflect the cancel
			if(_currentUpload != null)
			{
				_currentUpload.CancelUpload();
				_uploadedBytes -= _currentUpload.BytesUploaded;
				_currentUpload = null;					
			}
			
		}
		
		// fired when files have been selected in the file browse dialog
		public function OnSelect(listName:FileReferenceList, boxName:VBox, uploadPage:String):void{
			var tempSize:Number = _totalSize;
			
			// add each file that was selected
			for(var i:uint=0;i<listName.fileList.length;i++)
			{
				_uploadInd++;
				
				// create new FileUpload and add handlers then add it to the fileuploadbox
				if(_uploadFileSize > 0 && listName.fileList[i].size > _uploadFileSize)
				    ServerCommunicationEventHandler.OnFileSizeLimitReached(listName.fileList[i].name);
				if(_totalUploadSize > 0 && tempSize + listName.fileList[i].size > _totalUploadSize) {
				    ServerCommunicationEventHandler.OnTotalFileSizeLimitReached();
				    break;
				}
				
				if((_uploadFileSize == 0 || listName.fileList[i].size < _uploadFileSize) && 
							(_totalUploadSize == 0 || tempSize + listName.fileList[i].size < _totalUploadSize))
				{
				    var fu:FileUpload = new FileUpload(listName.fileList[i], uploadPage, _uploadInd);					
				    fu.percentWidth = 100;				
				    fu.addEventListener("FileRemoved", FileUploadEventHandler.OnFileRemoved);	
				    fu.addEventListener("UploadComplete", FileUploadEventHandler.OnFileUploadComplete);
				    fu.addEventListener("UploadProgressChanged", FileUploadEventHandler.OnFileUploadProgressChanged);
				    fu.addEventListener(HTTPStatusEvent.HTTP_STATUS, ServerCommunicationEventHandler.OnHttpError);
				    fu.addEventListener(IOErrorEvent.IO_ERROR, ServerCommunicationEventHandler.OnIOError);
				    fu.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ServerCommunicationEventHandler.OnSecurityError);
				    boxName.addChild(fu);	
				    tempSize += listName.fileList[i].size;	
				}			
			}
			
			
		}
		
		// sets the labels
		public function ComputeTotalFileSize(fileUploadBox:VBox):void
		{
			var fileUploadArray:Array = fileUploadBox.getChildren();
			
			if(fileUploadArray.length > 0)	{
				_totalSize = 0;
				for(var x:uint=0;x<fileUploadArray.length;x++)
					_totalSize += FileUpload(fileUploadArray[x]).FileSize;
			}
		}	

	}
}