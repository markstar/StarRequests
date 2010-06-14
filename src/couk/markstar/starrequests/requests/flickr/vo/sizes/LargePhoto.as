package couk.markstar.starrequests.requests.flickr.vo.sizes
{
	import couk.markstar.starrequests.requests.flickr.vo.Photo;
	
	public final class LargePhoto implements IPhotoSize
	{
		public function getURL(photo:Photo):String
		{
			return "http://farm" + photo.farm + ".static.flickr.com/" + photo.server + "/"
				+ photo.id + "_" + photo.secret + "_b.jpg";
		}
	}
}