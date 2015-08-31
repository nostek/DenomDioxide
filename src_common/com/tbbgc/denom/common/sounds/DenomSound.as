package com.tbbgc.denom.common.sounds {
	import com.tbbgc.denom.common.interfaces.ISound;
	import com.tbbgc.denom.common.interfaces.ISoundChannel;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	/**
	 * @author simonrodriguez
	 */
	public class DenomSound implements ISound {
		private var _sound:Sound;

		public function DenomSound( ba:ByteArray, isWav:Boolean ) {
			ba.position = 0;

			_sound = new Sound();

			if( isWav ) {
				_sound.loadPCMFromByteArray(ba, ba.length/8); //Expects a stereo, float bytearray (future: load as should be)
			} else {
				_sound.loadCompressedDataFromByteArray(ba, ba.length);
			}
		}

		public function dispose():void {

		}

		public function play(loop : Boolean, transform : DenomSoundTransform) : ISoundChannel {
			var sc:SoundChannel = _sound.play(0, (loop ? 32768 : 0), ((transform!=null) ? transform.transform : null));
			if( sc == null ) {
				return null;
			}
			return DenomSoundChannel.newChannel( sc, this );
		}

		public function get length() : Number {
			return _sound.length;
		}
	}
}
