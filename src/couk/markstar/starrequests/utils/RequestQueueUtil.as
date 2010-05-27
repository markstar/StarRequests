package couk.markstar.starrequests.utils
{
	import couk.markstar.starrequests.requests.IRequest;
	
	import org.osflash.signals.ISignal;
	
	public final class RequestQueueUtil
	{
		protected var _isExecuting:Boolean;
		protected var _requests:Vector.<IRequest>;
		protected var _currentRequest:IRequest;
		
		public function RequestQueueUtil()
		{
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
		}
		
		protected function sendNextRequest():void
		{
			if( !_isExecuting && _requests.length )
			{
				_isExecuting = true;
				_currentRequest = _requests.shift();
				_currentRequest.send();
			}
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