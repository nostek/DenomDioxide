package com.tbbgc.denom.common.nodes.sound {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.interfaces.ISound;
	import com.tbbgc.denom.common.interfaces.ISoundChannel;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.common.sounds.DenomSoundTransform;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class PlaySoundNode extends BaseNode implements INode {
		private var _play:NodeInput;
		private var _stop:NodeInput;
//		private var _setRate:NodeInput;

		private var _sound:NodeInput;
		private var _volume:NodeInput;
//		private var _rate:NodeInput;
		private var _onPlay:NodeInput;
		private var _onStop:NodeInput;

		private var _loop:NodeParameter;
		private var _maxInstances:NodeParameter;
		private var _stopOldestSound:NodeParameter;

		////

		private var _transform:DenomSoundTransform;

		private var _instances:Vector.<ISoundChannel>;

		public function PlaySoundNode() {
			_play = new NodeInput(this, "PLAY", onPlay);
			_stop = new NodeInput(this, "STOP", onStop);
//			_setRate = new NodeInput(this, "SET_RATE", onSetRate);

			_sound = new NodeInput(this, "SOUND", null, true);
			_volume = new NodeInput(this, "VOLUME", null, true);
//			_rate = new NodeInput(this, "RATE", null, true);
			_onPlay = new NodeInput(this, "ON_PLAY", null);
			_onStop = new NodeInput(this, "ON_STOP", null);

			_loop = new NodeParameter("LOOP", false);
			_maxInstances = new NodeParameter("MAX_INSTANCES", 1, onInstancesChanged);
			_stopOldestSound = new NodeParameter("STOP_OLDEST_SOUND", false);

			left( _play, _stop/*, _setRate*/ );

			right( _sound, _volume, /*_rate,*/ _onPlay, _onStop );

			parameters( _loop, _maxInstances, _stopOldestSound );

			_transform = new DenomSoundTransform();

			onInstancesChanged();

			super();
		}

		public function get nodeName() : String {
			return "PLAY SOUND";
		}

		override public function test() : void {
			onStop();
			onPlay();
		}

		override public function reset():void {
			onStop();
		}

		private function onPlay():* {
			var index:int = availableIndex;

			if( index == -1 && _stopOldestSound.value as Boolean ) {
				index = stopOldestSound;
			}

			if( index == -1 ) {
				return null;
			}

			var volume:Number = _volume.haveConnections ? _volume.runFirst() : 1;

			var sound:ISound = _sound.haveConnections ? _sound.runFirst() as ISound : null;

			if( sound != null ) {
				_transform.volume = volume;

				_transform.isAdvanced = false; //(_setRate.haveConnections || _rate.haveConnections);

//				if( _rate.haveConnections ) {
//					_transform.rate = _rate.runFirst() as Number;
//				}

				//Check for out of channels
				var channel:ISoundChannel = sound.play( _loop.value as Boolean, _transform );

				if( channel != null ) {
					_instances[index] = channel;

					if( !(_loop.value as Boolean) ) {
						_instances[index].onSoundComplete.addOnce( onSoundComplete );
					}

					_onPlay.runConnections();
				}
			}
		}

		private function onStop():* {
			var instance:ISoundChannel;

			var len:int = _instances.length;
			for( var i:int = 0; i < len; i++ ) {
				instance = _instances[i];

				if( instance != null ) {
					instance.stop();

					_instances[i] = null;
				}
			}
		}

//		private function onSetRate(...args):* {
//			if( args.length != 1 ) return null;
//
//			const rate:Number = args[0] as Number;
//
//			const len:int = _instances.length;
//
//			for( var i:int = 0; i < len; i++ ) {
//				if( _instances[i] != null ) {
//					_instances[i].rate = rate;
//				}
//			}
//		}

		private function onInstancesChanged():void {
			_instances = new Vector.<ISoundChannel>( _maxInstances.value as int, true );
		}

		private function onSoundComplete( instance:ISoundChannel ):void {
			const len:int = _instances.length;

			for( var i:int = 0; i < len; i++ ) {
				if( _instances[i] == instance ) {
					_instances[i] = null;
					break;
				}
			}

			_onStop.runConnections();
		}

		private function get availableIndex():int {
			const len:int = _instances.length;

			for( var i:int = 0; i < len; i++ ) {
				if( _instances[i] == null || _instances[i].position >= _instances[i].length ) {
					return i;
				}
			}

			return -1;
		}

		private function get stopOldestSound():int {
			const len:int = _instances.length;

			var index:int = -1;
			var pos:Number = -1;
			var p:Number;

			for( var i:int = 0; i < len; i++ ) {
				p = _instances[i].position / _instances[i].length;
				if( p >= pos ) {
					pos = p;
					index = i;
				}
			}

			if( index != -1 ) {
				_instances[index].stop();
				_instances[index] = null;
				return index;
			}

			return -1;
		}
	}
}
