package amazon.s3
{
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import cryto.*;
	
	public class PolicyGenerator
	{
		 public var  encodedPolicy:String;
		 public var  signature:String;
		 
		public function PolicyGenerator()
		{
		}
		
		   private function indent(buffer:Array):void {
                buffer.indents++;
            }
            
            private function outdent(buffer:Array):void 
            {
                buffer.indents = Math.max(0, buffer.indents-1);
            }
            
           private function writeIndents(buffer:Array):void 
           {
                for(var i:int=0;i<buffer.indents;i++) 
                {
                    buffer.push("    ");
                }
            }
            
                        private function write(buffer:Array, value:String):void {
                if(buffer.length > 0) {
                    var lastPush:String =  String(buffer[buffer.length-1]);
                    if(lastPush.length && lastPush.charAt(lastPush.length - 1) == "\n") {
                        writeIndents(buffer);
                    }
                }
                buffer.push(value);
            }
            
                private function writeCondition(buffer:Array, type:String, name:String, value:String, commaNewLine:Boolean):void {
                write(buffer, "['");
                    write(buffer, type);
                write(buffer, "', '");
                    write(buffer, name);
                write(buffer, "', '");
                    write(buffer, value);
                write(buffer, "'");
                write(buffer, "]");
                if(commaNewLine) {
                    write(buffer, ",\n");
                }
                
            }
            
            private function writeSimpleCondition(buffer:Array, name:String, value:String, commaNewLine:Boolean):void {
                write(buffer, "{'");
                    write(buffer, name);
                write(buffer, "': ");
                write(buffer, "'");
                    write(buffer, value);
                write(buffer, "'");
                write(buffer, "}");
                if(commaNewLine) {
                    write(buffer, ",\n");
                }
            }
		
		public function generatePolicy():String
		{	
			// expiration
             var mm:String = "12";
             var dd:String = "31";
             var yyyy:String = "2009";
             var bucket:String = "zunavision_node_tag_image";
             var key:String = "test9.jpg";
             var mode:String = "public-read"
             var contenttype:String =  "image/jpeg";
			
			 var buffer:Array = new Array();
             buffer.indents = 0;
                
             write(buffer, "{\n");
             indent(buffer);
                
             
             
             write(buffer, "'expiration': '");
             write(buffer, yyyy);
             write(buffer, "-");
             write(buffer, mm);
             write(buffer, "-");
             write(buffer, dd);
             write(buffer, "T12:00:00.000Z'");
             write(buffer, ",\n");
                    
             // conditions
             write(buffer, "'conditions': [\n");
             indent(buffer);
                    
             writeSimpleCondition(buffer, "bucket",bucket , true);
    		 writeSimpleCondition(buffer, "key", key, true);
			 writeSimpleCondition(buffer, "acl", mode, true);
			 writeSimpleCondition(buffer, "Content-Type",contenttype, true);
             writeCondition(buffer, "starts-with", "$Filename", "", true);
             writeCondition(buffer, "eq", "$success_action_status", "201", false);
             write(buffer, "\n");
             outdent(buffer);
             write(buffer, "]");
                    
             write(buffer, "\n");
             outdent(buffer);
             write(buffer, "}");
                
             return buffer.join("");
		}
		
		     public function signPolicy(policy:String):void 
		     {
                var secretKey:String = "aE5/H3/0FF5Yf7S3lY4bUxefhLY1ay+RhIKzf6TW";
                
                var unsignedPolicy:String = policy;
                
                var base64policy:String = Base64.encode(unsignedPolicy);
                
               encodedPolicy = base64policy;
				signature = generateSignature(base64policy, secretKey);
                 
            }
            
             private function generateSignature(data:String, secretKey:String):String 
             {
                
                var secretKeyByteArray:ByteArray = new ByteArray();
                secretKeyByteArray.writeUTFBytes(secretKey);
                secretKeyByteArray.position = 0;
                
                var dataByteArray:ByteArray = new ByteArray();
                dataByteArray.writeUTFBytes(data);
                dataByteArray.position = 0;
                
                var hmac:HMAC = new HMAC(new SHA1());            
                var signatureByteArray:ByteArray = hmac.compute(secretKeyByteArray, dataByteArray);
                return Base64.encodeByteArray(signatureByteArray);
            }
            
            public function upload(bmd:BitmapData):void
            {
            	
            	signPolicy(generatePolicy());
            	
            	var options:URLVariables = new URLVariables();
            	options.acl = "public-read";
            	
                options.policy =  encodedPolicy;
                options.signature =  signature;
                options.AWSAccessKeyId = "1MJ7RYPTX6D9XEPRGC82";
                options.success_action_status = "201";
                options.key = "test9.jpg"
                options["Content-Type"] = "image/jpeg";
                     
            	var postUrl:String =   "http://zunavision_node_tag_image.s3.amazonaws.com";
            	
            
            	var urlRequest:URLRequest = new URLRequest(postUrl);
            	urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
            	urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
            	urlRequest.method = URLRequestMethod.POST;
             	
            
			var j:JPEGEncoder = new JPEGEncoder();
			var bytes:ByteArray = j.encode(bmd);
            urlRequest.data = UploadPostHelper.getPostData("source.jpg",bytes,"file",options);
            
            
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE,onServerRequestComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onServerRequestError);
    		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onServerRequestError);
    		
			 
			 try   	
			 {
            	loader.load(urlRequest);
            	
    		}
    		catch(e:Error)
    		{
    			Alert.show("IN HERE" + " " + e.message + " " + e.name);
    		}
      
            
            Alert.show("HERE E");
        }
        
        private function onServerRequestError(event:ErrorEvent):void
		{
			Alert.show("Error in sending server request " +  event.text + " " + event.type  + " " );
			//Alert.show("Error - please specify the keywords for your tag, thanks.");
		}
		
		
		private function onServerRequestComplete(event:Event):void
		{			
			Alert.show("DONE");
		}
            
            

	}//class
}//package