package couk.markstar.starrequests.requests
{
	import cmodule.jpegencoder.CLibInit;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * A request to encode BitmapData into a ByteArray that represents a JPG file.
	 * @author markstar
	 */	
	public final class EncodeJPGRequest extends AbstractRequest
	{
		/**
		 * @private
		 */
		protected var _bitmapData:BitmapData;
		/**
		 * @private
		 */
		protected var _quality:Number;
		
		/**
		 * @param bitmapData The BitmapData to encode
		 * @param quality The JPG quality ( min: 0, max: 100 )
		 */		
		public function EncodeJPGRequest( bitmapData:BitmapData, quality:Number = 100 )
		{
			_bitmapData = bitmapData;
			_quality = quality;
			
			super();
			
			_completedSignal = new Signal( ByteArray );
		}
		
		/**
		 * The instance of the completed signal for this request
		 * @return An implementation of ISignal. Listeners to the completed signal require a ByteArray as a parameter.
		 * @example The following code demonstrates a listener for the completed signal:
		 * <listing version="3.0">
 protected function completedListener( byteArray:ByteArray ):void
 {
 	// function implementation
 }
 </listing> 
		 */
		override public function get completedSignal():ISignal
		{
			return super.completedSignal;
		}
		/**
		 * @inheritDoc
		 */
		override public function send():void
		{
			super.send();
			
			encodeJPG();
		}
		
		/**
		 * @inheritDoc
		 */		
		public override function cancel():void
		{
			super.cancel();
		}
		/**
		 * @private
		 */
		override protected function cleanup():void
		{
			super.cleanup();
		}
		
		/**
		 * @private
		 */
		protected function encodeJPG():void
		{
			var encoder:Object = new CLibInit().init();
			var byteArray:ByteArray = new ByteArray();
			byteArray = _bitmapData.getPixels( _bitmapData.rect );
			byteArray.position = 0;
			encoder.encodeAsync( encodingCompleteListener, byteArray, new ByteArray(), _bitmapData.width, _bitmapData.height, _quality );
		}
		
		/**
		 * @private
		 */
		private function encodingCompleteListener( byteArray:ByteArray ):void
		{
			_progressSignal.dispatch( 1 );
			_completedSignal.dispatch( byteArray );
			
			cleanup();
		}
	}
}