package couk.markstar.starrequests.utils
{
	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.markstar.starrequests.requests.IRequest;
	
	import flash.utils.setTimeout;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public final class RequestBatchAsyncUtil extends AbstractRequest implements IRequest
	{
		protected var _numRequestsPerCycle:uint;
		protected var _requestsExecutedThisCyle:uint;
		
		protected var _cycleDelay:uint;
		
		protected var _isExecuting:Boolean;
		protected var _requests:Vector.<IRequest>;
		protected var _currentRequest:IRequest;
		protected var _totalRequests:uint;
		
		public function RequestBatchAsyncUtil( numRequestsPerCycle:uint, cycleDelay:uint = 100 )
		{
			super();
			
			_numRequestsPerCycle = numRequestsPerCycle;
			_requestsExecutedThisCyle = 0;
			_cycleDelay = cycleDelay;
			_isExecuting = false;
			_totalRequests = 0;
			_requests = new Vector.<IRequest>();
			
			_completedSignal = new Signal();
		}
		
		public function addRequest( request:IRequest ):void
		{
			if( !_isExecuting )
			{
				addListeners( request.completedSignal );
				addListeners( request.failedSignal );
				_requests[ _requests.length ] = request;
			}
		}
		
		override public function send():void
		{
			super.send();
			
			_totalRequests = _requests.length;
			
			sendNextRequest();
		}
		
		override protected function cleanup():void
		{
			super.cleanup();
			
			_requests.length = 0;
			_requests = null;
			
			_currentRequest = null;
		}
		
		public function clear():void
		{
			var request:IRequest;
			
			while( _requests.length )
			{
				request = _requests.shift();
				removeListeners( request.completedSignal );
				removeListeners( request.failedSignal );
			}
			request = null;
			_totalRequests = 0;
			
			cleanup();
		}
		
		protected function sendNextRequest():void
		{
			if( !_requests.length )
			{
				_progressSignal.dispatch( 1 );
				_completedSignal.dispatch();
				_totalRequests = 0;
				return;
			}
			
			if( !_isExecuting && _requests.length )
			{
				_isExecuting = true;
				_currentRequest = _requests.shift();
				_currentRequest.progressSignal.add( requestProgressListener );
				
				if( _requestsExecutedThisCyle == _numRequestsPerCycle )
				{
					_requestsExecutedThisCyle = 0;
					setTimeout( sendCurrentRequest, _cycleDelay );
				}
				else
				{
					sendCurrentRequest();
				}
			}
		}
		
		protected function sendCurrentRequest():void
		{
			_requestsExecutedThisCyle++;
			_currentRequest.send();
		}
		
		protected function requestProgressListener( progress:Number ):void
		{
			var totalProgress:Number = ( ( _totalRequests - _requests.length - 1 ) + progress ) / _totalRequests;
			_progressSignal.dispatch( totalProgress );
		}
		
		protected function requestCompleted():void
		{
			removeListeners( _currentRequest.completedSignal );
			removeListeners( _currentRequest.failedSignal );
			_currentRequest.progressSignal.remove( requestProgressListener );
			_currentRequest = null;
			_isExecuting = false;
			sendNextRequest();
		}
		
		/*
		* Some dirty hacks to get around http://github.com/robertpenner/as3-signals/issues/closed#issue/17
		*/
		protected function requestCompletedListenerNone():void
		{
			requestCompleted();
		}
		
		protected function requestCompletedListenerOne( paramOne:* ):void
		{
			requestCompleted();
		}
		
		protected function requestCompletedListenerTwo( paramOne:*, paramTwo:* ):void
		{
			requestCompleted();
		}
		
		protected function addListeners( signal:ISignal ):void
		{
			switch( signal.valueClasses.length )
			{
				case 0:
					signal.add( requestCompletedListenerNone );
					break;
				case 1:
					signal.add( requestCompletedListenerOne );
					break;
				case 2:
					signal.add( requestCompletedListenerTwo );
					break;
				default:
					trace( "Could not add listener to a signal in this request, it requires more than 2 parameters" );
			}
		}
		
		protected function removeListeners( signal:ISignal ):void
		{
			switch( signal.valueClasses.length )
			{
				case 0:
					signal.remove( requestCompletedListenerNone );
					break;
				case 1:
					signal.remove( requestCompletedListenerOne );
					break;
				case 2:
					signal.remove( requestCompletedListenerTwo );
					break;
			}
		}
	}
}