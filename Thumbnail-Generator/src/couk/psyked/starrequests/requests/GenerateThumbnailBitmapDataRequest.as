package couk.psyked.starrequests.requests
{
	import cmodule.jpegencoder.CLibInit;

	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.markstar.starrequests.requests.IRequest;
	import couk.psyked.utils.BitmapManager;

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	import mx.collections.ArrayCollection;
	import mx.graphics.ImageSnapshot;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * The idea behind this class is that it would be more efficient to display a
	 * thumbnail version of an image (like, 120x120 pixels) rather than a full-on 3000x3000
	 * pixel image.  This request will load a specified file and generate a thumbnail version
	 * of the image to use.  The ByteArray it returns is the JPEG-encoded bitmap data for the
	 * thumbnail.
	 * 
	 * Ideally you'd store the thumbnail in a cache file somewhere, to save having to generate
	 * the thumbnail over and over again.  This class Request makes use of an Alchemy JPEG encoder
	 * class to do its encoding faster, but makes use of some pure AS3 classes that leverage the
	 * guts of the Flash Player to resample the bitmap data to the requested size.
	 * 
	 * If you pass a string of these commands in a syncronous queue it's a real shit for
	 * memory consumption, but it does clean up after itself when it's done.
	 */
	public class GenerateThumbnailBitmapDataRequest extends AbstractRequest
	{
		protected var _loader:Loader;

		protected var _file:File;

		public function GenerateThumbnailBitmapDataRequest( file:File )
		{
			var alchemyEncoder:CLibInit = new CLibInit();
			lib = alchemyEncoder.init();

			baout = new ByteArray();

			_file = file;
			_completedSignal = new Signal( ByteArray );

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressListener );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, completeListener );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
		}

		override public function send():void
		{
			super.send();

			var checkArrayCollection:ArrayCollection = new ArrayCollection( ALLOWED_FILE_TYPES );
			//trace( "_file.extension", _file.extension );
			//trace( "checkArrayCollection.contains( _file.extension )", checkArrayCollection.contains( _file.extension ));

			if ( _file.extension && checkArrayCollection.contains( _file.extension.toLowerCase()))
			{
				_loader.load( new URLRequest( _file.url ));
			}
			else
			{
				alchemyEncodingCompleteFunction( new ByteArray());
			}
		}

		protected var ALLOWED_FILE_TYPES:Array = [ "jpg", "gif", "png" ];

		protected var lib:Object;

		protected var baout:ByteArray;

		override protected function cleanup():void
		{
			super.cleanup();

			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressListener );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, completeListener );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
			_loader = null;
		}

		override public function get completedSignal():ISignal
		{
			return super.completedSignal;
		}

		/**
		 * @private
		 */
		protected function progressListener( e:ProgressEvent ):void
		{
			trace( "progressListener", e );
			_progressSignal.dispatch( e.bytesLoaded / e.bytesTotal );
		}

		/**
		 * @private
		 */
		protected function completeListener( e:Event ):void
		{
			trace( "completeListener", e );
			var loaderInfo:LoaderInfo = LoaderInfo( e.currentTarget );

			baout = new ByteArray();

			var widthRatio:Number;
			var heightRatio:Number;
			var ratio:Number;

			widthRatio = 120 / loaderInfo.content.width;
			heightRatio = 120 / loaderInfo.content.height;
			ratio = ( widthRatio < heightRatio ) ? widthRatio : heightRatio;

			var bmd:BitmapData = BitmapManager.resampleBitmapData( ImageSnapshot.captureBitmapData( loaderInfo.content ), ratio );
			var ba:ByteArray = new ByteArray();
			ba = bmd.getPixels( bmd.rect );
			ba.position = 0;
			lib.encodeAsync( alchemyEncodingCompleteFunction, ba, baout, bmd.width, bmd.height, 100 );
		}

		private function alchemyEncodingCompleteFunction( ba:ByteArray ):void
		{
			trace( "alchemyEncodingCompleteFunction", ba );
			_progressSignal.dispatch( 1 );

			_completedSignal.dispatch( ba );
			cleanup();
		}

		/**
		 * @private
		 */
		protected function ioErrorListener( e:IOErrorEvent ):void
		{
			trace( "ioErrorListener", e );
			_failedSignal.dispatch( e.text );
			cleanup();
		}
	}
}