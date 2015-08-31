package com.tbbgc.denom.common.sounds {
	import com.tbbgc.denom.common.interfaces.ISound;
	import com.tbbgc.denom.common.interfaces.ISoundChannel;

	import org.osflash.signals.OnceSignal;

	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author simonrodriguez
	 */
	public class DenomSoundChannel implements ISoundChannel {
		private var _sound:ISound;

		private var _channel:SoundChannel;

		private var _onSoundComplete:OnceSignal;

		public function DenomSoundChannel() {
			_onSoundComplete = new OnceSignal(ISoundChannel);
		}

		public function stop() : void {
			_channel.stop();

			if( _channel.hasEventListener(Event.SOUND_COMPLETE) ) {
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);
			}

			_sound = null;
			_channel = null;

			_onSoundComplete.removeAll();

			sPool[ sPool.length ] = this;
		}

		public function get position() : Number {
			return _channel.position % _sound.length;
		}

		public function get length() : Number {
			return _sound.length;
		}

		private function setup( channel:SoundChannel, sound:ISound ):void {
			_channel = channel;

			_sound = sound;
		}

		public function get onSoundComplete() : OnceSignal {
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);

			return _onSoundComplete;
		}

		private function onSoundCompleteEvent( e:Event ):void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);

			_onSoundComplete.dispatch(this);
			_onSoundComplete.removeAll();

			_sound = null;
			_channel = null;

			sPool[ sPool.length ] = this;
		}

		public function set volume(value : Number) : void {
			var trans:SoundTransform = _channel.soundTransform;
			trans.volume = value;
			_channel.soundTransform = trans;
		}

		public function set rate(rate:Number):void {
			//empty
		}

		/////////////////////
		// Pool

		private static var sPool:Vector.<DenomSoundChannel> = new Vector.<DenomSoundChannel>();

		public static function newChannel( channel:SoundChannel, sound:ISound ):DenomSoundChannel {
			var ret:DenomSoundChannel;

			if( sPool.length == 0 ) {
				ret = new DenomSoundChannel();
			} else {
				ret = sPool[ sPool.length - 1 ];
				sPool.length = sPool.length - 1;
			}

			ret.setup( channel, sound );

			return ret;
		}
	}
}
