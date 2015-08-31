package com.tbbgc.denom.sounds {
	import com.tbbgc.denom.interfaces.ISound;
	import com.tbbgc.denom.interfaces.ISoundChannel;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author simonrodriguez
	 */
	public class DenomMusic implements ISound {
		private var _sound:Sound;

		public function DenomMusic( url:String, buffer:int ) {
			var req:URLRequest = new URLRequest( url );
			var ctx:SoundLoaderContext = new SoundLoaderContext( buffer );

			_sound = new Sound();
			_sound.load( req, ctx );
		}

		public function dispose() : void {
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
