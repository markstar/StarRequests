package couk.psyked.utils
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	/**
	 * @author Maxime Cousinou
	 */
	public class BitmapManager
	{

		public static function reduceBitmapData(bmp:BitmapData, ratio:Number):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(Math.round(bmp.width * ratio), Math.round(bmp.height * ratio));
			var scaleMatrix:Matrix = new Matrix(bmpData.width / bmp.width, 0, 0, bmpData.height / bmp.height, 0, 0);
			bmpData.draw(bmp, scaleMatrix);

			return (bmpData);
		}

		public static function resizeBitmapData(bmp:BitmapData, ratio:Number):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(Math.round(bmp.width * ratio), Math.round(bmp.height * ratio));
			var scaleMatrix:Matrix = new Matrix(bmpData.width / bmp.width, 0, 0, bmpData.height / bmp.height, 0, 0);
			var colorTransform:ColorTransform = new ColorTransform();
			bmpData.draw(bmp, scaleMatrix, colorTransform, null, null, true);

			return (bmpData);
		}

		public static function resampleBitmapData(bmp:BitmapData, ratio:Number):BitmapData
		{
			if (ratio >= 1)
			{
				return (BitmapManager.resizeBitmapData(bmp, ratio));
			}
			else
			{
				var bmpData:BitmapData = bmp.clone();
				var appliedRatio:Number = 1;

				do
				{
					if (ratio < 0.5 * appliedRatio)
					{
						bmpData = BitmapManager.resizeBitmapData(bmpData, 0.5);
						appliedRatio = 0.5 * appliedRatio;
					}
					else
					{
						bmpData = BitmapManager.resizeBitmapData(bmpData, ratio / appliedRatio);
						appliedRatio = ratio;
					}
				} while (appliedRatio != ratio);

				return (bmpData);
			}
		}
	}
}
