package couk.markstar.starrequests.utils
{
	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.markstar.starrequests.requests.IRequest;
	
	import flash.utils.setTimeout;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public final class RequestBatchAsyncUtil extends AbstractRequest
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
			_numRequestsPerCycle = numRequestsPerCycle;
			_requestsExecutedThisCyle = _numRequestsPerCycle;
			_cycleDelay = cycleDelay;
			_isExecuting = false;
			_totalRequests = 0;
			_requests = new Vector.<IRequest>();
			
			super();
			
			_completed = new Signal();
		}
		
		public function addRequest( request:IRequest ):void
		{
			if( !_isExecuting )
			{
				addListeners( request.completed );
				addListeners( request.failed );
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
			_requests.length = 0;
			_requests = null;
			
			_currentRequest = null;
			
			super.cleanup();
		}
		
		override public function cancel():void
		{
			if( _currentRequest )
			{
				_currentRequest.cancel();
			}
			
			if( _requests )
			{
				while( _requests.length )
				{
					_requests.shift().cancel();
				}
			}
			
			_isExecuting = false;
			_totalRequests = 0;
			
			super.cancel();
		}
		
		protected function sendNextRequest():void
		{
			if( !_requests.length )
			{
				_progress.dispatch( 1 );
				_completed.dispatch();
				_totalRequests = 0;
				cleanup();
				return;
			}
			
			if( !_isExecuting && _requests.length )
			{
				_isExecuting = true;
				_currentRequest = _requests.shift();
				_currentRequest.progress.add( requestProgressListener );
				
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
			if( _totalRequests )
			{
				_requestsExecutedThisCyle++;
				_currentRequest.send();
			}
		}
		
		protected function requestProgressListener( progress:Number ):void
		{
			var totalProgress:Number = ( ( _totalRequests - _requests.length - 1 ) + progress ) / _totalRequests;
			_progress.dispatch( totalProgress );
		}
		
		protected function requestCompleted():void
		{
			removeListeners( _currentRequest.completed );
			removeListeners( _currentRequest.failed );
			_currentRequest.progress.remove( requestProgressListener );
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