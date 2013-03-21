/*****************************************************************************
** ZunaVision Inc.
** Copyright (c) 2009 
**
** FILENAME:    ZVVideoFocus_as.as
** AUTHOR(S):   Sid Batra <sid@zunavision.com>
** DESCRIPTION:
** Used to focus on a particular part on the video
*****************************************************************************/
package components
{
	import enums.ResizeMode;
	import enums.VideoFocusMode;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.managers.CursorManager;

	public class ZVVideoFocus_as extends Canvas
	{
		
		//-------------------------------------------------------------------
		//
		// Variables
		//
		//-------------------------------------------------------------------
		private var _focusPos:Point = new Point(-100,-100);
		private var _focusWidth:int = 85;
		private var _focusHeight:int = 85;
		
		private var _isMouseOnCancel:Boolean = false;
		private var _isMouseDown:Boolean = false;
		private var _isMouseIn:Boolean = false;
		private var _isFocusSet:Boolean = false;
		
		private var _clickPos:Point = new Point(-1,-1);
		
		private var _mode:uint = VideoFocusMode.NONE;
		private var _resizeMode:int = ResizeMode.NONE;
		
		private var _origWidth:int = -1;
		private var _origHeight:int = -1;
		private var _origX:int = -1;
		private var _origY:int = -1;
		
		//-------------------------------------------------------------------
		//
		// Controls
		//
		//-------------------------------------------------------------------
		public var launchFocusTextArea:TextArea;
		public var cancelTextArea:TextArea;
		
		public var leftTopButton:Button;
		public var leftBottomButton:Button;
		public var rightTopButton:Button;
		public var rightBottomButton:Button;
		
		public var debug:Label;
		
		//-------------------------------------------------------------------
		//
		// Resources
		//
		//-------------------------------------------------------------------
		
		[Embed(source="images/resizeCursor.gif")]
		public var resizeCursor:Class;
		
		[Embed(source="images/resizeCursorRot.gif")]
		public var resizeCursorRot:Class;
		
		//-------------------------------------------------------------------
		//
		// Constructor Logic
		//
		//-------------------------------------------------------------------
		
		public function ZVVideoFocus_as()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------
		public function get isSet():Boolean
		{
			return _isFocusSet;
		}
		
		public function get focusArea():Rectangle
		{
			return new Rectangle(_focusPos.x ,_focusPos.y , _focusWidth , _focusHeight);
		}
		
		//-------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------
		private function render():void
		{
			this.graphics.clear();
            
            if( !_isMouseOnCancel )
            {
            this.graphics.beginFill(0x000000,0.65)
            this.graphics.drawRect(0,0,unscaledWidth,_focusPos.y);
            this.graphics.drawRect(0,_focusPos.y,_focusPos.x, _focusHeight);
            this.graphics.drawRect(_focusPos.x + _focusWidth,_focusPos.y,this.width - _focusPos.x - _focusWidth,_focusHeight);
            this.graphics.drawRect(0,_focusPos.y + _focusHeight,unscaledWidth,this.height - _focusPos.y - _focusHeight);            
            this.graphics.endFill();
            
            
            
	            this.graphics.beginFill(0x000000,0.01)
	            this.graphics.lineStyle(2,0xffffff,0.8);
	            this.graphics.drawRect(_focusPos.x,_focusPos.y,_focusWidth,_focusHeight);
	            this.graphics.endFill();
	            
	            this.leftTopButton.x = _focusPos.x - this.leftTopButton.width / 2 
	            this.leftTopButton.y = _focusPos.y - this.leftTopButton.height / 2
	            this.leftBottomButton.x = _focusPos.x - this.leftTopButton.width / 2
	            this.leftBottomButton.y = _focusPos.y + _focusHeight - this.leftTopButton.height / 2
	            this.rightTopButton.x = _focusPos.x + _focusWidth - this.leftTopButton.width / 2
	            this.rightTopButton.y = _focusPos.y - this.leftTopButton.height / 2
	            this.rightBottomButton.x = _focusPos.x + _focusWidth - this.leftTopButton.width / 2
	            this.rightBottomButton.y =_focusPos.y + _focusHeight - this.leftTopButton.height / 2
            }
            else
            {
	            this.graphics.beginFill(0x000000,0.65)
	            this.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
	            this.graphics.endFill();
            }
             
		}
		
		private function updateFocus(newX:int , newY:int , newW:int , newH:int):void
		{
			if( isWithinBounds( newX , newY , newW , newH) )
			{
				this._focusPos.x = newX;
				this._focusPos.y = newY;			 
				this._focusWidth = newW;
				this._focusHeight = newH; 
			}
						
		}
		
		private function resetPosition():void
		{
			_focusPos = new Point( -3 * _focusWidth , -3 * _focusHeight );
		}
		
		private function setResizeButtonVisibility(status:Boolean):void
		{
			this.leftTopButton.visible = status;
			this.leftBottomButton.visible = status;
			this.rightTopButton.visible = status;
			this.rightBottomButton.visible = status;
		}
		
		private function isWithinBounds(newX:int , newY:int , newWidth:int , newHeight:int):Boolean
		{
			return newX > 0 && newX + newWidth < this.width && newY > 0 && newY + newHeight < this.height 
						&& newHeight > 50 && newWidth > 50
		}
		
		//-------------------------------------------------------------------
		//
		// Event Handlers
		//
		//-------------------------------------------------------------------
		
		public function onLeftTopRollOver(event:MouseEvent):void
		{
			CursorManager.setCursor(resizeCursor,2,-8,-8);
		}
		
		public function onLeftBottomRollOver(event:MouseEvent):void
		{
			CursorManager.setCursor(resizeCursorRot,2,-8,-8);
		}
		
		public function onResizeButtonRollOut(event:MouseEvent):void
		{
			if( !_isMouseDown )
				CursorManager.removeAllCursors();
		}
		
		public function onMouseClick(event:MouseEvent):void
		{
			if( _mode == VideoFocusMode.PLACE )
			{
				_mode = VideoFocusMode.RESIZE;
				_isFocusSet = true;
			}
			else if( _mode == VideoFocusMode.NONE )
			{	
				_mode = VideoFocusMode.PLACE
				launchFocusTextArea.visible = false;
				cancelTextArea.visible = true
				
				var pos:Point = this.globalToLocal( this.launchFocusTextArea.localToGlobal(new Point(event.localX,event.localY)) );
				this._focusPos = new Point(pos.x - _focusWidth / 2 , pos.y - _focusHeight / 2 );
				
				this.render();
				
				setResizeButtonVisibility(true);
			}
			
		}
		
		public function onMouseDown(event:MouseEvent):void
		{
			_isMouseDown = true;	
			
			if( event.target == this.leftTopButton )
				_resizeMode = ResizeMode.LEFT_TOP;
			else if( event.target == this.leftBottomButton )
				_resizeMode = ResizeMode.LEFT_BOTTOM
			else if( event.target == this.rightTopButton )
				_resizeMode = ResizeMode.RIGHT_TOP
			else if( event.target == this.rightBottomButton )
				_resizeMode = ResizeMode.RIGHT_BOTTOM
			else if( event.target == this )
				_resizeMode = ResizeMode.GLOBAL;
				
			_origWidth = _focusWidth;
			_origHeight = _focusHeight;
			_origX = this._focusPos.x;
			_origY = this._focusPos.y;
				
			_clickPos = new Point(event.stageX,event.stageY);	
		}
		
		public function onMouseUp(event:MouseEvent):void
		{
			_isMouseDown = false;
			CursorManager.removeAllCursors();			
		}
				
		public function onMouseMove(event:MouseEvent):void
		{	
			
			if( _mode == VideoFocusMode.PLACE || _mode == VideoFocusMode.RESIZE )
				this.setFocus();
			
			if( _mode == VideoFocusMode.PLACE && !_isMouseOnCancel )
			{
				updateFocus(event.stageX  - _focusWidth / 2, event.stageY - _focusHeight / 2 ,_focusWidth ,_focusHeight)
			}
			else if( _mode == VideoFocusMode.RESIZE && _isMouseDown )
			{
				
				var xDiff:int = this._clickPos.x - event.stageX
				var yDiff:int = this._clickPos.y - event.stageY
				
				if( _resizeMode == ResizeMode.GLOBAL )
				{	
					updateFocus(event.stageX  - _focusWidth / 2,event.stageY - _focusHeight / 2 ,_focusWidth ,_focusHeight)
				}
				else if( _resizeMode == ResizeMode.LEFT_TOP )
				{
					updateFocus(_origX - xDiff,_origY - yDiff,_origWidth + xDiff , _origHeight + yDiff )
				}
				else if( _resizeMode == ResizeMode.LEFT_BOTTOM )
				{	
					updateFocus(_origX - xDiff, _origY  ,_origWidth + xDiff , _origHeight - yDiff )
				}
				else if( _resizeMode == ResizeMode.RIGHT_TOP )
				{
					updateFocus(_origX , _origY - yDiff ,_origWidth - xDiff , _origHeight + yDiff )
				}
				else if( _resizeMode == ResizeMode.RIGHT_BOTTOM )
				{
					updateFocus(_origX , _origY  ,_origWidth - xDiff , _origHeight - yDiff )
				}
				
			}
			
			if( _mode != VideoFocusMode.NONE )
			{
				if( event.stageX > _focusPos.x && event.stageY > _focusPos.y 
					 && event.stageX <_focusPos.x + _focusWidth && event.stageY < _focusPos.y + _focusHeight )
				{
					this.useHandCursor = true;
					this.buttonMode = true;
				}
				else
				{
					this.useHandCursor = false;
					this.buttonMode = false;
				}
			}
			
			this.render();
		}	
		
		public function onRollOut(event:MouseEvent):void
		{
			_isMouseIn = false;
			_isMouseDown = false;
			CursorManager.removeAllCursors();
		}
		
		public function onRollOver(event:MouseEvent):void
		{
			_isMouseIn = true;
			
			if( _isMouseOnCancel )
			{
				_isMouseOnCancel = false;
				setResizeButtonVisibility(true);
				this.render();
			}
		}
		
		public function onKeyUp(event:KeyboardEvent):void
		{
			
			var shift:int = 3;
		
			if( event.keyCode == Keyboard.LEFT )
				updateFocus(_focusPos.x - shift , _focusPos.y ,_focusWidth , _focusHeight )
			else if( event.keyCode == Keyboard.RIGHT )
				updateFocus(_focusPos.x + shift , _focusPos.y ,_focusWidth , _focusHeight )
			else if( event.keyCode == Keyboard.DOWN )
				updateFocus(_focusPos.x  , _focusPos.y + shift ,_focusWidth , _focusHeight )
			else if( event.keyCode == Keyboard.UP )
				updateFocus(_focusPos.x  , _focusPos.y  - shift,_focusWidth , _focusHeight )
			else if( event.keyCode == Keyboard.ENTER && _mode == VideoFocusMode.PLACE)
			{
				_mode = VideoFocusMode.RESIZE;
				_isFocusSet = true;
			}
			
			
			this.render();
		}
		
		public function onCancelClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			this._mode = VideoFocusMode.NONE
			
			_isMouseOnCancel = false;
			_isFocusSet = false;
			cancelTextArea.visible = false;
			launchFocusTextArea.visible = true;
			resetPosition();
			
			this.render();
		}
		
		public function onCancelRollOver(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if( _mode == VideoFocusMode.PLACE )
			{
				_isMouseOnCancel = true;
				setResizeButtonVisibility(false);
			}
		}
		
		public function onCancelRollOut(event:MouseEvent):void
		{	
			event.stopImmediatePropagation();
			
			if( _isMouseIn )
			{
				_isMouseOnCancel = false;
				setResizeButtonVisibility(true);
				this.render();
			}
			
			
		}
			
		public function initComponent():void
		{	
			resetPosition();
			
			//Pos the launch text are in the centre of the component
			this.launchFocusTextArea.x = this.width / 2 - this.launchFocusTextArea.width / 2
			this.launchFocusTextArea.y = this.height / 2 - this.launchFocusTextArea.height / 2
			
			this.cancelTextArea.x = this.width - this.cancelTextArea.width -1
		}
		
		//-------------------------------------------------------------------
		//
		// Overrides
		//
		//-------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{   
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			render();            
        }
		
	}
}