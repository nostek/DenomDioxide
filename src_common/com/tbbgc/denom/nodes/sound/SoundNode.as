package com.tbbgc.denom.nodes.sound {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.sounds.DenomSound;
	import com.tbbgc.denom.sounds.wav.SoundWavParser;

	import flash.utils.ByteArray;

	/**
	 * @author simonrodriguez
	 */
	public class SoundNode extends BaseNode implements INode {
		private var _get:NodeInput;
		private var _length:NodeInput;

		private var _url:NodeParameter;

		///////

		private var _sound:DenomSound;

		public function SoundNode() {
			_get = new NodeInput(this, "GET", onGet);
			_length = new NodeInput(this, "LENGTH", onLength);

			_url = new NodeParameter("URL", "", onURLChange);

			left( _get, _length );

			parameters( _url );

			super();
		}

		public function get nodeName() : String {
			return "SIMPLE SOUND";
		}

		override public function test() : void {
			if( _sound != null ) {
				_sound.play(false, null);
			} else {
				this.logText("No sound available");
			}
		}

		override public function reset():void {
			if( _sound != null ) {
				_sound.dispose();
				_sound = null;
			}
		}

		private function onGet(...args):* {
			return _sound;
		}

		private function onLength(...args):* {
			return _sound.length;
		}

		private function onURLChange():void {
			if( _sound != null ) {
				_sound.dispose();
				_sound = null;
			}

			const url:String = _url.value as String;

			if( url == null || url == "" ) return;

			shared.incLoad();

			shared.fileManager.onLoad.add( onFileLoaded );
			shared.fileManager.getFile( url );
		}

		private function onFileLoaded( file:String, ba:ByteArray ):void {
			const url:String = _url.value as String;

			if( file == url ) {
				shared.fileManager.onLoad.remove( onFileLoaded );

				const fileending:String = url.substr( url.length-4 ).toLowerCase();

				switch( fileending ) {
					case ".wav":
						var data:Array = SoundWavParser.parse(ba);

						if( data == null ) {
							this.logText("Could not load file: " + file);
							_url.value = "";
							return;
						}

						_sound = new DenomSound( data[1], true );
					break;

					case ".mp3":
						_sound = new DenomSound( ba, false );
					break;

					default:
						this.logText("Invalid file: " + file);
						_url.value = "";
					return;
				}

				shared.decLoad();
			}
		}
	}
}
