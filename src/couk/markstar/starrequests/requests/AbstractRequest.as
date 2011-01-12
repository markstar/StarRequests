package couk.markstar.starrequests.requests
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class AbstractRequest implements IRequest
	{
		/**
		 * @private
		 * @see #send()
		 * @example The following code demonstrates dispatching the started signal
		 * <listing version="3.0">
		   _started.dispatch();
		   </listing>
		 */
		protected var _started:Signal;
		/**
		 * @private
		 * @example The following code demonstrates dispatching the progress signal
		 * <listing version="3.0">
		   _progress.dispatch( 0.5 );
		   </listing>
		 */
		protected var _progress:Signal;
		/**
		 * @private
		 * Needs to be defined in subclasses as the abstract class can't be sure of the type of object it will dispatch.
		 * This signal is dispatched when request is complete.
		 */
		protected var _completed:Signal;
		/**
		 * @private
		 * @see #failed()
		 * @example The following code demonstrates dispatching the failed signal
		 * <listing version="3.0">
		   _failed.dispatch( "Error" );
		   </listing>
		 */
		protected var _failed:Signal;
		/**
		 * @private
		 * @see #cancel()
		 */
		protected var _cancelled:Signal;
		
		/**
		 * The constructor instantiates the started, progress and failed signals.
		 * When subclassing ensure to call super().
		 */
		public function AbstractRequest()
		{
			_started = new Signal();
			_progress = new Signal( Number );
			_failed = new Signal( String );
			_cancelled = new Signal();
		}
		
		/**
		 * The instance of the started signal for this request
		 * @return An implementation of ISignal. Listeners to the started signal do not require any parameters.
		 * @example The following code demonstrates a listener for the started signal:
		 * <listing version="3.0">
		   protected function startedListener():void
		   {
		   // function implementation
		   }
		   </listing>
		 */
		public function get started():ISignal
		{
			return _started;
		}
		
		/**
		 * The instance of the progress signal for this request
		 * @return An implementation of ISignal. Listeners to the progress signal require a Number as a parameter.
		 * @example The following code demonstrates a listener for the progress signal:
		 * <listing version="3.0">
		   protected function progressListener( progress:Number ):void
		   {
		   // function implementation
		   }
		   </listing>
		 */
		public function get progress():ISignal
		{
			return _progress;
		}
		
		/**
		 * The instance of the completed signal for this request. This should be implemented in subclasses.
		 * @return An implementation of ISignal.
		 */
		public function get completed():ISignal
		{
			return _completed;
		}
		
		/**
		 * The instance of the failed signal for this request
		 * @return An implementation of ISignal. Listeners to the failed signal require a String as a parameter.
		 * @example The following code demonstrates a listener for the failed signal:
		 * <listing version="3.0">
		   protected function failedListener( message:String ):void
		   {
		   // function implementation
		   }
		   </listing>
		 */
		public function get failed():ISignal
		{
			return _failed;
		}
		
		/**
		 * The instance of the failed signal for this request
		 * @return An implementation of ISignal. Listeners to the cancelled signal do not require any parameters.
		 * @example The following code demonstrates a listener for the cancelled signal:
		 * <listing version="3.0">
		   protected function cancelledListener():void
		   {
		   // function implementation
		   }
		   </listing>
		 */
		public function get cancelled():ISignal
		{
			return _cancelled;
		}
		
		/**
		 * Helper function for sending the failed signal. It dispatches the failed signal using the message supplied then runs the cleanup method.
		 * @param message The failed message to dispatch
		 */
		protected function dispatchFailed( message:String ):void
		{
			_failed.dispatch( message );
			cleanup();
		}
		
		/**
		 * Call this function to execute the request. The started and progress signals are both dispatched.
		 * This method should be overridden in subclasses, but ensure to call super.send() when overriding.
		 */
		public function send():void
		{
			_started.dispatch();
			_progress.dispatch( 0 );
		}
		
		/**
		 * Call this function to cancel the request. The cleanup method is then executed.
		 * This method should be overridden in subclasses, but ensure to call super.cancel() when overriding.
		 * Note that it is recommended to call super.cancel at the end of the method in the subclass.
		 */
		public function cancel():void
		{
			_cancelled.dispatch();
			cleanup();
		}
		
		/**
		 * A cleanup function. All four signals have their listeners removed and are set to null.
		 * This method should be overridden in subclasses, but ensure to call super.cleanup() when overriding.
		 * Note that it is recommended to call super.cancel at the end of the method in the subclass.
		 */
		protected function cleanup():void
		{
			_cancelled.removeAll();
			_started.removeAll();
			_progress.removeAll();
			_completed.removeAll();
			_failed.removeAll();
			
			_cancelled = null;
			_started = null;
			_progress = null;
			_completed = null;
			_failed = null;
		}
	}
}