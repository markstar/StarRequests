package couk.markstar.starrequests.requests
{
	import org.osflash.signals.ISignal;
	
	public interface IRequest
	{
		function get startedSignal():ISignal;
		function get progressSignal():ISignal;
		function get completedSignal():ISignal;
		function get failedSignal():ISignal;
		function set autoCleanup( value:Boolean ):void;
		function send():void;
		function cleanup():void;
	}
}