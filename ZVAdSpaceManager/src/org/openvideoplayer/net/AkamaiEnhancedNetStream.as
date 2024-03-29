﻿// AkamaiEnhancedNetStream.as
//
// Copyright (c) 2008, the Open Video Player authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are 
// met:
//
//    * Redistributions of source code must retain the above copyright 
//		notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above 
//		copyright notice, this list of conditions and the following 
//		disclaimer in the documentation and/or other materials provided 
//		with the distribution.
//    * Neither the name of the openvideoplayer.org nor the names of its 
//		contributors may be used to endorse or promote products derived 
//		from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

package org.openvideoplayer.net {
	
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	
	import org.openvideoplayer.utilities.TimeUtil;
	
	/**
	 * Dispatched when the playback state changes.
	 * 
	 * @eventType flash.events.NetStatusEvent
	 */
 	[Event (name="stateChange", type="flash.events.NetStatusEvent")]
 
 	
 	/**
	 * The AkamaiEnhancedNetStream class extends the AkamaiNetStream class for use with the 
	 * Akamai JumpPoint(tm) service. This service provides the ability to instantly seek
	 * progressively delivered FLV files beyond the point at which they have been downloaded. It 
	 * also prevents the FLV segments from being cached in the end-user's browser and can optionally 
	 * stop the background download after a pause, to minimize the bytes transferred.
	 * <p />
	 * This class also provides some useful additional methods beyond the inherited methods, 
	 * such as a "state" maintenance, timecode display, width, height and segmentLoadRatio.
	 * <p />
	 * This class must only be used when playing progressive content through the Akamai JumpPoint(tm) service - 
	 * it will not function correctly when run against a standard HTTP server. 
	 *
	 */
	public class AkamaiEnhancedNetStream extends AkamaiNetStream
	{
		// Declare private vars
		private var _baseUrl:String;
		private var _id:String;
		private var _usingCustomID:Boolean;
		private var _clientProxy:Object;
		private var _duration:Number;
		private var _segmentDuration:Number;
		private var _segmentStartTime:Number;
		private var _state:String;
		private var _stopOnPause:Boolean;
		private var _playState:String;
		private var _lastReferenceTime:Number;
		private var _width:Number;
		private var _height:Number;

		// Declare constants
		private const OFFSET_PARAM:String = "aktimeoffset";
		private const ID_PARAM:String = "aksessionid";
		
		/**
		 * @see #state
		 */
		public const STATE_WAITING:String = "WAITING";
		public const STATE_BUFFERING:String = "BUFFERING";
		public const STATE_PLAYING:String = "PLAYING";
		public const STATE_PAUSED:String = "PAUSED";
		public const STATE_STOPPED:String = "STOPPED";
		public const STATE_ENDED:String = "ENDED";
		public const STATE_SEEKING:String = "SEEKING";
		public const STATE_FAILED:String = "FAILED";
		
		/**
		 *  Constructor. 
		 */
		public function AkamaiEnhancedNetStream(connection:NetConnection)
		{
			super(connection);
			init();
		}
		
		/**
		 * Returns the current playstate of the stream. There are 8 possible 
		 * playstates:
		 * <ul>
		 * <li>WAITING</li>
		 * <li>BUFFERING</li>
		 * <li>PLAYING</li>
		 * <li>PAUSED</li>
		 * <li>STOPPED</li>
		 * <li>ENDED</li>
		 * <li>SEEKING</li>
		 * <li>FAILED</li>
		 * </ul>
		 * These playstates should be referenced via the eponymous public constants. For example
		 * WAITING is STATE_WAITING, PLAYING is STATE_PLAYING etc.
		 * <p />
		 * The STOPPED and ENDED states may appear similar, but they have quite diferent meanings. ENDED
		 * will occur once the stream has completely finished playback. It is analogous to an end-of-stream event.
		 * The STOPPED state occurs after the stream has been paused when stopOnPause is true. In this case the stream
		 * has physically been closed in order to stop any background download from occuring.
		 * <p />
		 * When the state changes, the "stateChange" event will be dispatched.
		 * 
		 * @return a string representing the current state
		 * 
		 */
		public function get state():String {
			return _state;
		}
		
		/**
		 *  The current session ID. Since each seek results in a new request to the Akamai servers,
		 * the "hit" count in the server logs may look artificially high, since each playback session can
		 * result in multiple hits. Therefore, to provide a means of tieing together all the hits (requests) in a 
		 * playback session, a common session ID is added to every request. This session ID should be different for
		 * each play(). The session ID will be automatically generated by the class if it is not set by the user. The 
		 * default session ID is a pseudo-GUID comprised of the the number of milliseconds since epoch plus a random 6-digit number.
		 * An example would be "1200509810019_267042". A user of the class can set their own custom session ID (perhaps relating to their
		 * true application session) by using the <code>customSessionID</code> method.
		 * 
		 * @default a 20 char pseudo-GUID
		 * 
		 * @returns the session ID used in the last request.
		 * 
		 * @see #customSessionID
		 */
		public function get sessionID():String {
			return _id;
		}
		
		/**
		 * The duration in seconds of the stream. This property will only return a valid value after the onMetaData 
		 * event has been received and it relies upon the duration being accurately reported in the stream metadata.
		 * 
		 * @returns the duration of the stream in seconds
		 */
		public function get duration():Number {
			return _duration;
		}
		
		/**
		 * The ratio of the bytes loaded to total bytes of the stream. Only returns a valid value after <code>play()</code>
		 * has been called.
		 * 
		 * @returns the ratio bytesLoaded/bytesTotal of the stream, a number between 0 and 1.
		 */
		public function get bytesLoadRatio():Number {
			return super.bytesLoaded/super.bytesTotal;
		}
		
		/**
		 * The product of two ratios - the bytesLoaded/bytesTotal of the segment mutiplied by the duration of the
		 * segment/duration of the parent. This is a utility ratio that can be used to conveniently render a loading bar for the 
		 * segment. Just multiply this ratio by the total length of your scrub bar and position the loading bar at the x-location
		 * corresponding to the start-time of the segment (retrieved using <code>segmentStartTime</code>).
		 * 
		 * @see #segmentStartTime
		 * 
		 * @returns the ratio (segmentBytesLoaded/segmentBytesTotal) * (segmentDuration/parentDuration)
		 */
		public function get segmentLoadRatio():Number {
			return _state == STATE_STOPPED ? 0: super.bytesLoaded*(_duration - (_segmentStartTime))/(_duration*super.bytesTotal);
		}
		
		/**
		 * The true start time of the last segment loaded, in seconds, with respect to the parent. If a request is made to seek
		 * to 60s in a 130s stream and the server locates the keyframe at 62.578 seconds, then segmentStartTime
		 * will hold 62.578. This property is only available after the onMetaData event has been dispatched
		 * for that segment. Note that the segmentStartTime is usually slightly different from the time requested in a
		 * seek() request since a seek can only be made from the start of the next contiguous keyframe. The maximum variance
		 * between the two will be the keyframe interval of the FLV that is being played. 
		 * 
		 * @see #seek
		 * @see #segmentDuration
		 * 
		 * @returns the start time of a seek segment, in seconds, with respect to its parent.
		 */
		public function get segmentStartTime():Number {
			return _segmentStartTime;
		}
		
		/**
		 * The duration of the segment returned after a seek() request, in seconds. If a request is made to seek
		 * to 60s in a 130s stream and the server locates the keyframe at 62.578 seconds, then segmentDuration
		 * will return 67.422. This property is only available after the onMetaData event has been dispatched
		 * for that segment.
		 * 
		 * @see #segmentStartTime
		 * @see #seek
		 * 
		 * @returns the duration of a seek segment, in seconds.
		 */
		public function get segmentDuration():Number {
			return _segmentDuration;
		}
		
		/**
		 * Allows the setting of a custom session ID. Setting a non-empty string value will override
		 * the default session ID that is generated by the class. To return to using the automatically generated
		 * session ID, pass a "" (empty string) value to this property. If you are using custom session IDs, be
		 * sure to apply a new session ID before each call to the <code>play()</code> method is made. 
		 * 
		 * @see #sessionID
		 * 
		 */
		public function set customSessionID(str:String):void {
			_usingCustomID = str != "";
			_id = str;
		}
		
		/**
		 * The standard behavior for FLV files played progressively is for the download to continue in the background
		 * if the stream is paused. It will continue to download until the entire file has been delivered to the end-users
		 * machine. This is wasteful of bandwidth, since the user may never resume playback or even if they do, may
		 * not watch all the content that has been downloaded. Setting this property to true
		 * will stop the background download occuring the next time <code>pause</code> is called. Setting it false will
		 * cause the default download to occur after the next <code>pause</code>.  Setting it true while the stream is in a
		 * paused state will have no effect. It will only become active the next time <code>pause</code> is called. 
		 * 
		 * @see #pause
		 * 
		 * @default false
		 * 
		 */
		public function get stopOnPause():Boolean {
			return _stopOnPause;
		}
		public function set stopOnPause(bool:Boolean):void {
			_stopOnPause = bool;
		}
		
		/**
		 *  Sets the client property of the NetStream.
		 */
		override public function set client(obj:Object):void {
			_clientProxy = obj;
		}
		
		/**
		 *  Returns the current playhead time of the stream as HH:MM:SS timecode. If the
		 * playhead time is not defined, then it will return "00:00:00".
		 */
		override public function get timeAsTimeCode():String {
			if (_stopOnPause && _state == STATE_STOPPED) {
				return TimeUtil.timeCode(_lastReferenceTime);
			} else {
				return isNaN(super.time) ? TimeUtil.timeCode(0):TimeUtil.timeCode(super.time);
			}
		}
		
		/**
		 * Returns the current duration of the stream as HH:MM:SS timecode. If the 
		 * current duration has not yet been defined, then it will return "00:00:00".
		 */
		public function get durationAsTimeCode():String {
			return isNaN(_duration) ? TimeUtil.timeCode(0):TimeUtil.timeCode(_duration);
		}
		
		/**
		 *  A utility method which converts a time in seconds into HH:MM:SS timecode.
		 */
		public function convertToTimeCode(num:Number):String {
			return TimeUtil.timeCode(num);
		}
		
		/**
		 * The width in pixels of the video stream. This property is only available
		 * after the onMetaData event has been dispatched.
		 * 
		 * @return the width of the video stream
		 */
		public function get width():Number {
			return _width;
		}
		
		/**
		 *  The height in pixels of the video stream. This property is only available
		 * after the onMetaData event has been dispatched.
		 * 
		 * @return the height of the video stream
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 *  Returns the current playhead time of the stream in seconds.
		 */
		override public function get time():Number {
			if (_stopOnPause && _state == STATE_STOPPED) {
				return _lastReferenceTime;
			} else {
				return super.time;
			}
		}
 
	 	/**
		 * Initiates the progressive playback of a new FLV file. The argument to this method must be a URL pointing
		 * at FLV content on the Akamai JumpPoint(tm) service. 
		 */
		override public function play(... args):void {
			_baseUrl = args[0];
			if (!_usingCustomID) {
				_id = generateID();
			}
			args[0] = buildRequest();
			_playState = STATE_PLAYING;
			super.play.apply(this, args);
		}
		
		/**
		 * Pauses a currently playing stream.
		 */
		override public function pause():void {
			if (_stopOnPause) {
				updateState(STATE_STOPPED);
				_playState = STATE_STOPPED;
				_lastReferenceTime = super.time;
				super.close();
			} else {
				_playState = STATE_PAUSED;
				updateState(STATE_PAUSED);
				super.pause();
			}
		}
		
		/**
		 * Resumes a paused stream. 
		 * 
		 */
		override public function resume():void {
			_playState = STATE_PLAYING;
			if (_stopOnPause) {
				super.play(buildRequest(_lastReferenceTime));
			} else {
				updateState(STATE_PLAYING);
				super.resume();
			}
		}
		
		/**
		 * Seeks the playhead to a new location in the stream.
		 */
		override public function seek(seekTime:Number):void {
			
			var _maxCachedTime:Number = ((super.bytesLoaded/super.bytesTotal)*(_duration-_segmentStartTime))+_segmentStartTime;
			if (seekTime < _maxCachedTime && seekTime > _segmentStartTime && _state != STATE_STOPPED) {
					super.seek(seekTime);
			} else {
				super.play(buildRequest(seekTime));
				if (_state == STATE_PAUSED || _state == STATE_STOPPED) {
					_volume = _state == STATE_PAUSED ? super.soundTransform.volume: _volume;
					// We set the stream volume to 0 since the audio starts rendering just before
					// the video does and creates an annoying blip. Once NetStream.Buffer.Full is reached, we pause the stream
					// which leaves the keyframe visible on the screen.
					super.soundTransform = new SoundTransform(0);
				}
			}	
			updateState(STATE_SEEKING);
		}
		
		private function init():void {
			_usingCustomID = false;
			_clientProxy = null;
			_state = STATE_WAITING;
			_volume = 1;
			this.addEventListener(NetStatusEvent.NET_STATUS,handleNetStatus);		
		}
		
		private function handleNetStatus(e:NetStatusEvent):void {
			switch (e.info.code) {
				case "NetStream.Play.StreamNotFound":
					updateState(STATE_FAILED);
					break;
				case "NetStream.Play.Start":
					updateState(STATE_BUFFERING);
					break;
				case "NetStream.Buffer.Empty":
					if (_playState != STATE_PAUSED && _state != STATE_ENDED) {
						updateState(STATE_BUFFERING);
					}
					break;
				case "NetStream.Buffer.Full":
					if (_stopOnPause && (_playState == STATE_PAUSED || _playState == STATE_STOPPED)) {
						_lastReferenceTime = super.time;
						super.close();
					} else if (_playState == STATE_PAUSED) {
						super.pause();
						super.soundTransform = new SoundTransform(_volume);
					} else if (_playState == STATE_PLAYING) {
						super.soundTransform = new SoundTransform(_volume);
					}
					updateState(_playState);
					break;
				case "NetStream.Seek.Notify" :
					updateState(_playState != STATE_PAUSED ? STATE_SEEKING:STATE_PAUSED);
					break;
				case "NetStream.Play.Stop":
					updateState(STATE_ENDED);
			}
		}
		
		private function updateState(newState:String):void {
			if (newState != _state) {
				_state = newState;
				this.dispatchEvent( new NetStatusEvent("stateChange",false,false,_state));
			}
		}

		/**
		 *  @private
		 */
		public function onXMP(... args):void {
			if (_clientProxy.hasOwnProperty("onXMP")) {
				_clientProxy.onXMP.apply(this,args);
			}
		}

		/**
		 *  @private
		 */
		override public function onMetaData(info:Object):void {
			if (!isNaN(Number(info["aktimeoffset"]))) {
				_segmentStartTime = Number(info["aktimeoffset"]);
				_segmentDuration = Number(info["duration"]);
				_duration = Number(info["akparentplaytime"]);
			} else {
				_segmentStartTime = 0;
				_duration = _segmentDuration = Number(info["duration"]);
			}

			if (!isNaN(Number(info["width"]))) {
				_width = Number(info["width"]);
			}
			if (!isNaN(Number(info["height"]))) {
				_height = Number(info["height"]);
			}
			if (_clientProxy.hasOwnProperty("onMetaData")) {
				_clientProxy.onMetaData(info);
			}
		}
		
		/**
		 *  @private
		 */
		override public function onCuePoint(info:Object):void {
			if (_clientProxy.hasOwnProperty("onCuePoint")) {
				_clientProxy.onCuePoint(info);
			}
		}
		
		/**
		 *  @private
		 */
		override public function onImageData(info:Object):void {
			if (_clientProxy.hasOwnProperty("onImageData")) {
				_clientProxy.onImageData(info);
			}
		}
		
		/**
		 *  @private
		 */
		override public function onTextData(info:Object):void {
			if (_clientProxy.hasOwnProperty(".onTextData")) {
				_clientProxy.onTextData(info);
			}
		}
		
		/**
		 *  @private
		 */
		private function buildRequest(offset:Number = 0):String{
			return _baseUrl + (_baseUrl.indexOf("?") == -1 ? "?":"&")+ID_PARAM+"="+_id+(offset !=0 ? "&"+OFFSET_PARAM+"="+offset:"");
		}
		
		/**
		 *  @private
		 */
		private function generateID():String {
			return new Date().time.toString() + "_"+Math.round(Math.random()*1000000).toString();
		}		
	}
}
