package couk.markstar.starrequests.requests
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * A request to load an XML file.
	 * @author markstar
	 */
	public class LoadXMLRequest extends AbstractRequest
	{
		protected var _loader:URLLoader;
		protected var _url:String;
		
		/**
		 * @param url The URL of the XML file to load.
		 */
		public function LoadXMLRequest( url:String )
		{
			_url = url;
			
			super();
			
			_completed = new Signal( XML );
			
			_loader = new URLLoader();
			_loader.addEventListener( ProgressEvent.PROGRESS, progressListener );
			_loader.addEventListener( Event.COMPLETE, completeListener );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorListener );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
		}
		
		/**
		 * The instance of the completed signal for this request
		 * @return An implementation of ISignal. Listeners to the completed signal require an XML as a parameter.
		 * @example The following code demonstrates a listener for the completed signal:
		 * <listing version="3.0">
		   protected function completedListener( xml:XML ):void
		   {
		   // function implementation
		   }
		   </listing>
		 */
		override public function get completed():ISignal
		{
			return super.completed;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function send():void
		{
			super.send();
			
			_loader.load( new URLRequest( _url ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function cancel():void
		{
			_loader.close();
			
			super.cancel();
		}
		
		/**
		 * @private
		 */
		override protected function cleanup():void
		{
			super.cleanup();
			
			_loader.removeEventListener( ProgressEvent.PROGRESS, progressListener );
			_loader.removeEventListener( Event.COMPLETE, completeListener );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorListener );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorListener );
			_loader = null;
			_url = null;
		
		}
		
		/**
		 * @private
		 */
		protected function progressListener( e:ProgressEvent ):void
		{
			_progress.dispatch( e.bytesLoaded / e.bytesTotal );
		}
		
		/**
		 * @private
		 */
		protected function completeListener( e:Event ):void
		{
			_progress.dispatch( 1 );
			
			// try..catch needed to check for valid XML.
			try
			{
				var xml:XML = new XML( e.currentTarget.data );
			}
			catch( e:Error )
			{
				dispatchFailed( e.message.toString() );
				return;
			}
			
			_completed.dispatch( xml );
			
			cleanup();
		}
		
		/**
		 * @private
		 */
		protected function securityErrorListener( e:SecurityErrorEvent ):void
		{
			dispatchFailed( e.text );
		}
		
		/**
		 * @private
		 */
		protected function ioErrorListener( e:IOErrorEvent ):void
		{
			dispatchFailed( e.text );
		}
	}
}