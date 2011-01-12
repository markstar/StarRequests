package couk.markstar.starrequests.requests
{
	import couk.markstar.starrequests.ICancelable;
	
	import org.osflash.signals.ISignal;
	
	/**
	 * The interface that defines the core methods that are required for any request.
	 * @author Sharky
	 */
	public interface IRequest extends ICancelable
	{
		/**
		 * The instance of the started signal for this request
		 * @return An implementation of ISignal.
		 */
		function get started():ISignal;
		/**
		 * The instance of the progress signal for this request
		 * @return An implementation of ISignal.
		 */
		function get progress():ISignal;
		/**
		 * The instance of the completed signal for this request
		 * @return An implementation of ISignal.
		 */
		function get completed():ISignal;
		/**
		 * The instance of the failed signal for this request
		 * @return An implementation of ISignal.
		 */
		function get failed():ISignal;
		/**
		 * Call this function to execute the request.
		 */
		function send():void;
	}
}