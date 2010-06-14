package couk.markstar.starrequests.requests.flickr.vo.sizes
{
	import couk.markstar.starrequests.requests.flickr.vo.Photo;
	
	public final class MediumPhoto implements IPhotoSize
	{
		public function getURL(photo:Photo):String
		{
			return "http://farm" + photo.farm + ".static.flickr.com/" + photo.server + "/"
				+ photo.id + "_" + photo.secret + ".jpg";
		}
	}
}