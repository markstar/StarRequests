package couk.markstar.starrequests.requests
{
	import cmodule.jpegencoder.CLibInit;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	public final class EncodeJPGRequest extends AbstractRequest
	{
		protected var _bitmapData:BitmapData;
		protected var _quality:Number;
		
		public function EncodeJPGRequest( bitmapData:BitmapData, quality:Number = 100 )
		{
			_bitmapData = bitmapData;
			_quality = quality;
			
			super();
			
			_completedSignal = new Signal( ByteArray );
		}
		
		override public function send():void
		{
			super.send();
			
			encodeJPG();
		}
		
		override protected function cleanup():void
		{
			super.cleanup();
			_bitmapData.dispose();
			_bitmapData = null;
		}
		
		protected function encodeJPG():void
		{
			var encoder:Object = new CLibInit().init();
			var byteArray:ByteArray = new ByteArray();
			byteArray = _bitmapData.getPixels( _bitmapData.rect );
			byteArray.position = 0;
			encoder.encodeAsync( encodingCompleteListener, byteArray, new ByteArray(), _bitmapData.width, _bitmapData.height, _quality );
		}
		
		private function encodingCompleteListener( byteArray:ByteArray ):void
		{
			_progressSignal.dispatch( 1 );
			_completedSignal.dispatch( byteArray );
			cleanup();
		}
	}
}