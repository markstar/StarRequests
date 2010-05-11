package couk.markstar.starrequests.requests
{
	import org.osflash.signals.ISignal;
	
	public interface IRequest
	{
		function get startedSignal():ISignal;
		function get progressSignal():ISignal;
		function get completedSignal():ISignal;
		function get failedSignal():ISignal;
		function send():void;
	}
}