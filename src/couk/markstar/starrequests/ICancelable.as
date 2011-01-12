package couk.markstar.starrequests
{
	import org.osflash.signals.ISignal;
	
	public interface ICancelable
	{
		/**
		 * Call this function to cancel the action.
		 */
		function cancel():void;
		/**
		 * Determines if the action has been cancelled.
		 */
		function get cancelled():ISignal;
	}
}