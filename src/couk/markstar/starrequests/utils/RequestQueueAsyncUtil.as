package couk.markstar.starrequests.utils
{
	import couk.markstar.starrequests.ICancelable;
	import couk.markstar.starrequests.requests.IRequest;
	
	import flash.utils.setTimeout;
	
	import org.osflash.signals.ISignal;
	
	public final class RequestQueueAsyncUtil implements ICancelable
	{
		protected var _numRequestsPerCycle:uint;
		protected var _requestsExecutedThisCyle:uint;
		
		protected var _cycleDelay:uint;
		
		protected var _isExecuting:Boolean;
		protected var _requests:Vector.<IRequest>;
		protected var _currentRequest:IRequest;
		
		public function RequestQueueAsyncUtil( numRequestsPerCycle:uint, cycleDelay:uint = 100 )
		{
			_numRequestsPerCycle = numRequestsPerCycle;
			_requestsExecutedThisCyle = _numRequestsPerCycle;
			_cycleDelay = cycleDelay;
			_isExecuting = false;
			_requests = new Vector.<IRequest>();
		}
		
		public function addRequest( request:IRequest ):void
		{
			addListeners( request.completedSignal );
			addListeners( request.failedSignal );
			_requests[ _requests.length ] = request;
			sendNextRequest();
		}
		
		public function cancel():void
		{
			if( _currentRequest )
			{
				_currentRequest.cancel();
				_currentRequest = null;
			}
			
			if( _requests )
			{
				while( _requests.length )
				{
					_requests.shift().cancel();
				}
			}
			_requests.length = 0;
			
			_isExecuting = false;
		}
		
		protected function sendNextRequest():void
		{
			if( !_isExecuting && _requests.length )
			{
				_isExecuting = true;
				_currentRequest = _requests.shift();
				
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
		
		protected function requestCompleted():void
		{
			removeListeners( _currentRequest.completedSignal );
			removeListeners( _currentRequest.failedSignal );
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