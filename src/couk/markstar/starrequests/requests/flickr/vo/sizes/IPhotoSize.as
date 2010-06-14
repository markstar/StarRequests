package couk.markstar.starrequests.requests.flickr.vo.sizes
{
	import couk.markstar.starrequests.requests.flickr.vo.Photo;

	public interface IPhotoSize
	{
		function getURL( photo:Photo ):String;
	}
}