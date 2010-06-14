package couk.markstar.starrequests.requests.flickr
{
	import couk.markstar.starrequests.requests.flickr.utils.FlickrDataParserUtil;
	import couk.markstar.starrequests.requests.flickr.vo.Photos;
	
	import org.osflash.signals.Signal;

	public final class FlickrPhotosByUserRequest extends AbstractFlickrRequest
	{
		public function FlickrPhotosByUserRequest( API_KEY:String, userID:String, numPerPage:uint = 20, page:uint = 1 )
		{
			super(API_KEY);
			
			_params.method = "flickr.people.getPublicPhotos";
			_params.user_id = userID;
			_params.per_page = numPerPage;
			_params.page = page;
			
			_completedSignal = new Signal( Photos );
		}
		
		override protected function parseResponse(response:Object):void
		{
			_completedSignal.dispatch( new FlickrDataParserUtil().parsePhotos( response.photos ) );
		}
	}
}