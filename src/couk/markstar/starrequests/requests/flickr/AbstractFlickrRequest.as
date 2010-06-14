package couk.markstar.starrequests.requests.flickr
{
	import couk.markstar.starrequests.requests.AbstractRequest;
	
	import flash.net.URLVariables;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	internal class AbstractFlickrRequest extends AbstractRequest
	{
		protected var _service:HTTPService;
		protected var _params:URLVariables;
		
		public function AbstractFlickrRequest( API_KEY:String )
		{
			super();
			
			_service = new HTTPService( "http://api.flickr.com/" );
			_service.url = "services/rest/";
			_service.addEventListener( FaultEvent.FAULT, serviceFaultListener );
			_service.addEventListener( ResultEvent.RESULT, serviceResultListener );
			
			_params = new URLVariables();
			_params.api_key = API_KEY;
		}
		
		override public function send():void
		{
			super.send();
			_service.send( _params );
		}
		
		override protected function cleanup():void
		{
			_service.removeEventListener( FaultEvent.FAULT, serviceFaultListener );
			_service = null;
			
			_params = null;
			
			super.cleanup();
		}
		
		protected function serviceResultListener( e:ResultEvent ):void
		{
			if( e.result.rsp.stat == "fail" )
			{
				failed( e.result.rsp.err.msg );
			}
			if( e.result.rsp.stat == "ok" )
			{
				_progressSignal.dispatch( 1 );
				parseResponse( e.result.rsp );
				cleanup();
			}
		}
		
		protected function parseResponse( response:Object ):void
		{
			// leave blank - to be overridden in subclasses
		}
		
		protected function serviceFaultListener( e:FaultEvent ):void
		{
			failed( e.message.toString() );
		}
	}
}