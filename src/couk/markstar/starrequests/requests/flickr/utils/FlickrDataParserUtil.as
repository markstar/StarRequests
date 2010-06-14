package couk.markstar.starrequests.requests.flickr.utils
{
	import couk.markstar.starrequests.requests.flickr.vo.Photo;
	import couk.markstar.starrequests.requests.flickr.vo.Photos;

	public final class FlickrDataParserUtil
	{
		public function parsePhotos( result:Object ):Photos
		{
			var photos:Photos = new Photos();
			photos.page = result.page;
			photos.pages = result.pages;
			photos.numPerPage = result.perpage;
			photos.total = result.total;
			
			var i:uint;
			var photo:Photo;
			var length:uint = result.photo.length;
			
			for( i = 0; i < length; i++ )
			{
				photo = new Photo();
				photo.id = result.photo[i].id;
				photo.farm = result.photo[i].farm;
				photo.isFamily= result.photo[i].isfamily;
				photo.isFriend= result.photo[i].isfriend;
				photo.isPublic= result.photo[i].ispublic;
				photo.owner = result.photo[i].owner;
				photo.secret = result.photo[i].secret;
				photo.server = result.photo[i].server;
				photo.title = result.photo[i].title;
				
				photos.addPhoto( photo );
			}
			
			return photos;
		}
	}
}