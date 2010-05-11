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
			_progressSignal = new Signal( Number );
			_startedSignal = new Signal();
			_failedSignal = new Signal( String );
		}
		
		public function get startedSignal():ISignal
		{
			return _startedSignal;
		}
		
		public function get progressSignal():ISignal
		{
			return _progressSignal;
		}
		
		public function get completedSignal():ISignal
		{
			return _completedSignal;
		}
		
		public function get failedSignal():ISignal
		{
			return _failedSignal;
		}
		
		public function send():void
		{
			_startedSignal.dispatch();
			_progressSignal.dispatch( 0 );
		}
		
		public function cleanup():void
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