package com.tbbgc.denom.common.sounds {
	import com.tbbgc.denom.common.interfaces.ISoundChannel;

	import org.osflash.signals.OnceSignal;

	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author simonrodriguez
	 */
	public class DenomSoundChannelUnique implements ISoundChannel {
		private static const BUFFER_SIZE:int = 2048;

		private var _sound:DenomSoundAdvanced;

		private var _transform:DenomSoundTransform;

		private var _buffer:Sound;
		private var _channel:SoundChannel;

		private var _onSoundComplete:OnceSignal;

		private var _pos:Number;

		public function DenomSoundChannelUnique( loop:Boolean, transform:DenomSoundTransform, sound:DenomSoundAdvanced ) {
			_sound = sound;
			_transform = transform;

			_pos = 0;

			_buffer = new Sound();

			if( loop ) {
				_buffer.addEventListener(SampleDataEvent.SAMPLE_DATA, onLoop);
			} else {
				_buffer.addEventListener(SampleDataEvent.SAMPLE_DATA, onSingle);
			}

			_channel = _buffer.play(0, 0, transform.transform);
		}

		public function stop() : void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);

			_channel.stop();

			_buffer.removeEventListener(SampleDataEvent.SAMPLE_DATA, onLoop);
			_buffer.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSingle);

			_channel = null;
			_sound = null;
			_buffer = null;
			_transform = null;
			_onSoundComplete = null;
		}

		public function get position() : Number {
			return _channel.position % _sound.length;
		}

		public function get length() : Number {
			return _sound.length;
		}

		public function get onSoundComplete() : OnceSignal {
			if( _onSoundComplete == null ) {
				_onSoundComplete = new OnceSignal(ISoundChannel);

				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);
			}
			return _onSoundComplete;
		}

		private function onSoundCompleteEvent( e:Event ):void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteEvent);

			_onSoundComplete.dispatch(this);
		}

		public function set volume(value : Number) : void {
			_transform.volume = value;
			_channel.soundTransform = _transform.transform;
		}

		public function set rate(rate : Number) : void {
			_transform.rate = rate;
		}

		private function onSingle(e:SampleDataEvent):void {
			const rate:Number = _transform.rate;

			const mul:Number = Math.min( 1, 1 / rate );

			const len:int = Math.min( BUFFER_SIZE*mul, (_sound.numSamples >> 3) - int(_pos) );

			if( len > 0 ) {
				for( var i:int = len; i != 0; i-- ) {
					e.data.writeBytes( _sound.samples, int(_pos) << 3, 8 );

					_pos += rate;
				}
			}
		}

		private function onLoop(e:SampleDataEvent):void {
			const rate:Number = _transform.rate;

			const mul:Number = Math.min( 1, 1 / rate );

			var memleft:int = BUFFER_SIZE;

			while( memleft > 0 ) {
				var len:int = Math.min( BUFFER_SIZE*mul, (_sound.numSamples >> 3) - int(_pos) );

				for( var i:int = len; i != 0; i-- ) {
					e.data.writeBytes( _sound.samples, int(_pos) << 3, 8 );

					_pos += rate;
				}

				if( int(_pos) << 3 >= _sound.numSamples ) {
					_pos -= _sound.numSamples >> 3;
				}

				memleft -= len;
			}
		}
	}
}
