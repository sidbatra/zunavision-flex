/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVAdSpaceEditorTest_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Custom application for testing the ZVAdSpaceEditor
*****************************************************************************/
package components
{
	//mx imports
	import mx.core.Application;
	//-------------------------------------
			
	public class ZVAdSpaceEditorTest_as extends Application
	{
		
		//-------------------------------------------------------------------
		//
		// Data Members
		//
		//-------------------------------------------------------------------
		public var _zvAdSpaceEditor:ZVAdSpaceEditor;
		
				
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		
		public function ZVAdSpaceEditorTest_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		    			
   		public function initializeApplication():void
        {
        
        	//http://products.edgeboss.net/download/products/content/demo/video/oomt/big_buck_bunny_700k.flv
        	//_zunifyTool.loadPDL("http://products.edgeboss.net/download/products/content/demo/video/oomt/big_buck_bunny_700k.flv","tesy");
        	
        	var serverLocation:String = "http://zunavision.stanford.edu/videodata/adServer";
        	
        	var videoURL:String = serverLocation + "//" +  "300_1.flv";
        	var videoName:String = "300";
        	//var tracksXML:String = serverLocation + "//" + "300_1.xml";
        	var tracksXML:String = "300_1.xml";        	
			var adSenseXML:String = "adsense.xml";
        		
        	_zvAdSpaceEditor.initializeEditor();        	
        	_zvAdSpaceEditor.loadVideo(videoURL,videoName,tracksXML,adSenseXML,29.97);
        	
        
        }
		 		
	}//class
	
}//package