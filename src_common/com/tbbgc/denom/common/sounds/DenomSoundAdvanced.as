package com.tbbgc.denom.common.sounds {
	import com.tbbgc.denom.common.interfaces.ISound;
	import com.tbbgc.denom.common.interfaces.ISoundChannel;

	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author simonrodriguez
	 */
	public class DenomSoundAdvanced implements ISound {
		private static const BUFFER_SIZE:int = 8192*8;

		private var _length:Number;

		private var _samples:ByteArray;
		private var _numSamples:int;

		private var _single:Sound;
		private var _loop:Sound;

		public function DenomSoundAdvanced( length:Number, samples:ByteArray ) {
			_length = length;

			_numSamples = samples.length;

			_samples = samples;
			_samples.position = _numSamples;
			_samples.writeBytes(_samples, 0, _numSamples);
		}

		public function get samples():ByteArray { return _samples; }
		public function get numSamples():int { return _numSamples; }

		public function play(loop : Boolean, transform : DenomSoundTransform) : ISoundChannel {
			if( transform.isAdvanced ) {
				return new DenomSoundChannelUnique(loop, transform, this);
			}

			return DenomSoundChannel.newChannel( (loop ? loopSound : singleSound).play(0, 0, transform.transform), this );
		}

		public function dispose():void {

		}

		public function get length() : Number {
			return _length;
		}

		private function get singleSound():Sound {
			if( _single == null ) {
				_single = new Sound();
				_single.addEventListener(SampleDataEvent.SAMPLE_DATA, onSingle);
			}

			return _single;
		}

		private function get loopSound():Sound {
			if( _loop == null ) {
				_loop = new Sound();
				_loop.addEventListener(SampleDataEvent.SAMPLE_DATA, onLoop);
			}

			return _loop;
		}

		private function onSingle(e:SampleDataEvent):void {
			const offset:int = (e.position << 3);

			var memsize:int = _numSamples-offset;
			if( memsize > BUFFER_SIZE ) memsize = BUFFER_SIZE;

			if( memsize > 0 ) {
				e.data.writeBytes( _samples, offset, memsize );
			}
		}

		private function onLoop(e:SampleDataEvent):void {
			var offset:int = (e.position << 3) % _numSamples;

			var memleft:int = BUFFER_SIZE;

			var memsize:int;

			while( memleft > 0 ) {
				memsize = _numSamples - offset;
				if( memsize > BUFFER_SIZE ) memsize = BUFFER_SIZE;
				if( memleft < memsize ) memsize = memleft;

				e.data.writeBytes( _samples, offset, memsize );

				memleft -= memsize;

				offset = (offset+memsize) % _numSamples;
			}
		}
	}
}
