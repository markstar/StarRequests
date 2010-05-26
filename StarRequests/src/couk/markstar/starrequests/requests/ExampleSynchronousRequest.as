package couk.markstar.starrequests.requests
{
	import org.osflash.signals.Signal;

	public final class ExampleSynchronousRequest extends AbstractRequest implements IRequest
	{
		protected var _id:uint;
		
		public function ExampleSynchronousRequest( id:uint )
		{
			super();
			
			_id = id;
			
			_completedSignal = new Signal( uint );
		}
		override public function send():void
		{
			super.send();
			
			_completedSignal.dispatch( _id );
			
			cleanup();
		}
	}
}