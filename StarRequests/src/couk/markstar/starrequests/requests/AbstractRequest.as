package couk.markstar.starrequests.requests
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class AbstractRequest implements IRequest
	{
		protected var _startedSignal:Signal;
		protected var _progressSignal:Signal;
		protected var _completedSignal:Signal;
		protected var _failedSignal:Signal;
		
		public function AbstractRequest()
		{
			_startedSignal = new Signal();
			_progressSignal = new Signal( Number );
			_failedSignal = new Signal( String );
		}
		/**
		 * The instance of the started signal for this request
		 * @return An implementation of ISignal. Listeners to the started signal do not require any parameters.
		 * @example The following code demonstrates a listener for the started signal:
		 * <listing version="3.0">
		 * protected function startedListener():void
		 * {
		 * 		// function implementation
		 * }
		 * </listing> 
		 */		
		public function get startedSignal():ISignal
		{
			return _startedSignal;
		}
		/**
		 * The instance of the progress signal for this request
		 * @return An implementation of ISignal. Listeners to the progress signal require a Number as a parameter.
		 * @example The following code demonstrates a listener for the progress signal:
		 * <listing version="3.0">
		 * protected function progressListener( progress:Number ):void
		 * {
		 * 		// function implementation
		 * }
		 * </listing> 
		 */	
		public function get progressSignal():ISignal
		{
			return _progressSignal;
		}
		/**
		 * The instance of the completed signal for this request. This should be implemented in subclasses.
		 * @return An implementation of ISignal. 
		 */	
		public function get completedSignal():ISignal
		{
			return _completedSignal;
		}
		/**
		 * The instance of the failed signal for this request
		 * @return An implementation of ISignal. Listeners to the failed signal require a String as a parameter.
		 * @example The following code demonstrates a listener for the failed signal:
		 * <listing version="3.0">
		 * protected function failedListener( message:String ):void
		 * {
		 * 		// function implementation
		 * }
		 * </listing> 
		 */		
		public function get failedSignal():ISignal
		{
			return _failedSignal;
		}
		/**
		 * @inheritDoc
		 */		
		public function send():void
		{
			_startedSignal.dispatch();
			_progressSignal.dispatch( 0 );
		}
		/**
		 * A cleanup function. Should be overridden in subclasses, but ensure to call super.cleanup(); when overriding.
		 */		
		protected function cleanup():void
		{
			_startedSignal.removeAll();
			_progressSignal.removeAll();
			_completedSignal.removeAll();
			_failedSignal.removeAll();
			
			_startedSignal = null;
			_progressSignal = null;
			_completedSignal = null;
			_failedSignal = null;
		}
	}
}