package com.tbbgc.denom.common.sounds.mp3 {
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * @author simonrodriguez
	 */
	public class SoundMp3Parser {
		public static function parse( ba:ByteArray ):Array {
			ba.position = 0;

			var sound:Sound = new Sound();
			sound.loadCompressedDataFromByteArray(ba, ba.length);

			var data:ByteArray = new ByteArray();
			sound.extract(data, sound.length*44.1);
			data.position = 0;

			return [sound.length, data];
		}
	}
}
