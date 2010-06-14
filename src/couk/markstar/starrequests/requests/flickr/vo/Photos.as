package couk.markstar.starrequests.requests.flickr.vo
{
	public final class Photos
	{
		public var page:uint;
		public var pages:uint;
		public var numPerPage:uint;
		public var total:uint;
		protected var _photos:Vector.<Photo>;
		
		public function Photos()
		{
			_photos = new Vector.<Photo>();
		}
		
		public function addPhoto( photo:Photo ):void
		{
			_photos[ _photos.length ] = photo;
		}
		
		public function get numPhotos():uint
		{
			return _photos.length;
		}
		
		public function getPhoto( position:uint ):Photo
		{
			return position < _photos.length ? _photos[ position ] : null;
		}
	}
}