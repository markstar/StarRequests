package couk.markstar.starrequests.requests
{
	import org.osflash.signals.ISignal;
	/**
	 * The interface that defines the core methods that are required for any request.
	 * @author Sharky
	 */	
	public interface IRequest
	{
		/**
		 * The instance of the started signal for this request
		 * @return An implementation of ISignal.
		 */
		function get startedSignal():ISignal;
		/**
		 * The instance of the progress signal for this request
		 * @return An implementation of ISignal.
		 */		
		function get progressSignal():ISignal;
		/**
		 * The instance of the completed signal for this request
		 * @return An implementation of ISignal.
		 */
		function get completedSignal():ISignal;
		/**
		 * The instance of the failed signal for this request
		 * @return An implementation of ISignal.
		 */
		function get failedSignal():ISignal;
		/**
		 * Call this function to execute the request.
		 */
		function send():void;
	}
}