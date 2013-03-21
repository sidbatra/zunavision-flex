/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVSlider.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Custom slider for the video track bar
*****************************************************************************/
package components
{
	import events.SliderMouseUpdateEvent;
	import events.SliderValueUpdateEvent;
	import events.TickMouseUpdateEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.HSlider;

	[Event(name="sliderValueUpdate", type="events.SliderValueUpdateEvent")]

	public class ZVSlider extends HSlider
	{
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _isMouseDown:Boolean = false;
		private var _startBytes:Number = 0;
		private var _totalBytes:Number = 1;
		private var _bytesLoaded:Number = 0;
		
		private var _ticks:Array = new Array();
		private var _tickIndices:Array = new Array();
		private var _currentConvoIndex:int = -1;
		
		[Bindable]
		public var convos:ArrayCollection ;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		private var tickTimer:Timer = new Timer(Constants.TICK_TIMER_DURATION);
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		public function ZVSlider()
		{
			super();
			
			this.value = 0;
			this.addEventListener(MouseEvent.CLICK,onSliderClick);		
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);	
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		
			this.tickTimer.addEventListener(TimerEvent.TIMER,onTickTimer);
			
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}
		
		public function get currentTime():Number
		{
			return this.value;
		}
		
		public function set currentTime(time:Number):void
		{
			this.value = time;
		}
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{  
            
   			this.graphics.clear();
            
            //Background
            this.graphics.lineStyle(1,0x7083ac);
            this.graphics.beginFill(0xa9b5d0)
            this.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
            this.graphics.endFill();
            
            //Buffer bar            
            this.graphics.lineStyle(1,0xffffff,0); 
            this.graphics.beginFill(0xffffff,0.3);            
            this.graphics.drawRect(0,1,xFromValue(this._bytesLoaded + this._startBytes,this._totalBytes),unscaledHeight-1);
            this.graphics.endFill();                
            
            //Progress bar
            this.graphics.lineStyle(1,0x7083ac);
            this.graphics.beginFill(0x4765b0);
            this.graphics.drawRect(0,0,xFromValue(this.currentTime,this.maximum),unscaledHeight);
            this.graphics.endFill();
            
            
         }
         
         //-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		private function valueFromX(x:Number , max:Number):Number
		{
			return (max * x) / this.width;
		}
		
		private function xFromValue(val:Number , max:Number):Number
		{
			return (val * this.width) / max;
		}
		
		private function dispatchSliderUpdate():void
		{
			dispatchEvent( new SliderValueUpdateEvent(SliderValueUpdateEvent.SLIDER_VALUE_UPDATE,this.currentTime) );
		}
		
		private function dispatchSliderMouseUpdate(mouseDown:Boolean):void
		{
			dispatchEvent( new SliderMouseUpdateEvent(SliderMouseUpdateEvent.SLIDER_MOUSE_UPDATE,mouseDown) );
		}
		
		public function progressLocation():int
		{	
			return this.localToGlobal( new Point(xFromValue(this.currentTime,this.maximum),0) ).x;
		}
		
		public function onBufferProgress(startBytes:Number , bytesLoaded:Number , totalBytes:Number):void
		{
			this._startBytes = startBytes;
			this._bytesLoaded = bytesLoaded;
			this._totalBytes = totalBytes;
			this.invalidateDisplayList();
			
		}
		
		public function addTick(time:Number , index:int):void
		{	
			//Form tick button
			var tick:ZVTick = new ZVTick();
			tick.x = xFromValue(time,this.maximum); tick.y = this.height / 2;
			tick.convoIndex = index; tick.convoTime = time;
			tick.styleName = "zvTick";
			tick.addEventListener(MouseEvent.ROLL_OVER,onTickMouseOver);
			tick.addEventListener(MouseEvent.ROLL_OUT,onTickMouseOut);
			tick.addEventListener(MouseEvent.MOUSE_DOWN,onTickClick);
			
			//Add to various containers
			this.addChild(tick);
			_ticks.push(tick);
			_tickIndices.push(index);			
		}
		
		public function deleteTick(index_p:int):void
		{
			//Find index of tick of the given two
			var index:int = _tickIndices.indexOf(index_p);
			
			this.removeChild(_ticks[index]);
		}
		
         
        //-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		private function onMouseDown(event:MouseEvent):void
		{
			this.mouseChildren = false;
			_isMouseDown = true;
			
			dispatchSliderMouseUpdate(true);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			if (_isMouseDown  )
			{
				this.currentTime = valueFromX(event.localX,this.maximum);								
				dispatchSliderUpdate();
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_isMouseDown = false;		
			this.mouseChildren = true;
			 
			dispatchSliderMouseUpdate(false);
		}
		
		//Tick timer events-----------------------
		private function onTickTimer(event:TimerEvent):void
		{	
			tickTimer.stop();
			dispatchEvent( new TickMouseUpdateEvent(TickMouseUpdateEvent.TICK_MOUSE_UPDATE,false,_currentConvoIndex));
		}
		//--------------------------------------
		
		//Tick events-----------------------
		private function onTickMouseOver(event:MouseEvent):void
		{	
			event.stopImmediatePropagation();
			tickTimer.stop();
			dispatchEvent( new TickMouseUpdateEvent(TickMouseUpdateEvent.TICK_MOUSE_UPDATE,true,(event.currentTarget as ZVTick).convoIndex));
		}
		
		private function onTickMouseOut(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			_currentConvoIndex = (event.currentTarget as ZVTick).convoIndex
			tickTimer.start();
		}
		
		private function onTickClick(event:MouseEvent):void
		{	
			this.currentTime = Math.max( (event.currentTarget as ZVTick).convoTime  - Constants.TICK_SEEK_MARGIN ,0) ;
			dispatchSliderUpdate();
		}
		
		//--------------------------------------
			
         private function onSliderClick(event:MouseEvent):void
         {	
         	this.currentTime = valueFromX(event.localX,this.maximum); 
         	dispatchSliderUpdate();
         }
		
	}//class
}//package