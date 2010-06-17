package couk.markstar.starrequests.requests.desktop
{
	import couk.markstar.starrequests.requests.AbstractRequest;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	public final class ReadByteArrayFromFileRequest extends AbstractRequest
	{
		protected var _file:File;
		protected var _fileStream:FileStream;
		
		public function ReadByteArrayFromFileRequest( file:File )
		{
			super();
			
			_file = file;
			_completedSignal = new Signal( ByteArray );
			
			_fileStream = new FileStream();
			_fileStream.addEventListener( ProgressEvent.PROGRESS, progressListener );
			_fileStream.addEventListener( Event.COMPLETE, completeListener );
			_fileStream.addEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
		}
		
		override public function send():void
		{
			super.send();
			
			_fileStream.openAsync( _file, FileMode.READ );
		}
		
		protected function progressListener( e:ProgressEvent ):void
		{
			_progressSignal.dispatch( e.bytesLoaded / e.bytesTotal );
		}
		
		protected function completeListener( e:Event ):void
		{
			_progressSignal.dispatch( 1 );
			
			var data:ByteArray = new ByteArray();
			_fileStream.readBytes( data );
			
			_completedSignal.dispatch( data );
			
			cleanup();
		}
		
		protected function ioErrorListener( e:IOErrorEvent ):void
		{
			_failedSignal.dispatch( e.text );
			cleanup();
		}
		
		override protected function cleanup():void
		{
			super.cleanup();
			
			_fileStream.removeEventListener( ProgressEvent.PROGRESS, progressListener );
			_fileStream.removeEventListener( Event.COMPLETE, completeListener );
			_fileStream.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
			_fileStream = null;
			_file = null;
		}
	}
}