package couk.markstar.starrequests.requests
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import org.osflash.signals.Signal;
	
	public final class ResizeBitmapDataRequest extends AbstractRequest
	{
		protected var _bitmapData:BitmapData;
		protected var _ratio:Number;
		
		public function ResizeBitmapDataRequest( bitmapData:BitmapData, ratio:Number )
		{
			_bitmapData = bitmapData;
			_ratio = ratio;
			
			super();
			
			_completedSignal = new Signal( BitmapData );
		}
		
		override public function send():void
		{
			super.send();
			
			resampleBitmapData();
		}
		
		override protected function cleanup():void
		{
			_bitmapData.dispose();
			_bitmapData = null;
			
			super.cleanup();
		}
		
		protected function resampleBitmapData():void
		{
			_progressSignal.dispatch( 1 );
			
			if( _ratio >= 1 )
			{
				_completedSignal.dispatch( resizeBitmapData( _bitmapData, _ratio ) );
			}
			else
			{
				var bitmapData:BitmapData = _bitmapData.clone();
				var appliedRatio:Number = 1;
				
				do
				{
					if( _ratio < 0.5 * appliedRatio )
					{
						bitmapData = resizeBitmapData( bitmapData, 0.5 );
						appliedRatio = 0.5 * appliedRatio;
					}
					else
					{
						bitmapData = resizeBitmapData( bitmapData, _ratio / appliedRatio );
						appliedRatio = _ratio;
					}
				} while( appliedRatio != _ratio );
				
				_completedSignal.dispatch( bitmapData );
			}
			
			cleanup();
		}
		
		protected function resizeBitmapData( bmp:BitmapData, ratio:Number ):BitmapData
		{
			var bmpData:BitmapData = new BitmapData( Math.round( bmp.width * ratio ), Math.round( bmp.height * ratio ) );
			var scaleMatrix:Matrix = new Matrix( bmpData.width / bmp.width, 0, 0, bmpData.height / bmp.height, 0, 0 );
			var colorTransform:ColorTransform = new ColorTransform();
			bmpData.draw( bmp, scaleMatrix, colorTransform, null, null, true );
			
			return ( bmpData );
		}
	}
}