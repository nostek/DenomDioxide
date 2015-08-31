package com.tbbgc.denom.sounds {
	import flash.media.SoundTransform;

	/**
	 * @author simonrodriguez
	 */
	public class DenomSoundTransform {
		private var _transform:SoundTransform;

		private var _isAdvanced:Boolean;

		private var _rate:Number;

		public function DenomSoundTransform() {
			_transform = new SoundTransform();

			_rate = 1.0;

			_isAdvanced = false;
		}

		public function get transform():SoundTransform { return _transform; }

		public function set rate(value:Number):void {
			_rate = value;
		}

		public function get rate():Number {
			return _rate;
		}

		public function set volume(value:Number):void {
			_transform.volume = value;
		}

		public function set isAdvanced(value:Boolean):void {
			_isAdvanced = value;
		}

		public function get isAdvanced():Boolean {
			return _isAdvanced;
		}
	}
}
