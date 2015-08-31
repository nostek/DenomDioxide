package com.tbbgc.denom.common.nodes.sound {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.common.sounds.DenomMusic;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class MusicNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _url:NodeParameter;
		private var _buffer:NodeParameter;

		///////

		private var _music:DenomMusic;

		public function MusicNode() {
			_get = new NodeInput(this, "GET", onGet);

			_url = new NodeParameter("URL", "", createMusic);
			_buffer = new NodeParameter("BUFFER LENGTH(ms)", 1000, createMusic);

			left( _get );

			parameters( _url, _buffer );

			super();
		}

		public function get nodeName() : String {
			return "MUSIC NODE";
		}

		override public function test() : void {
			this.logText("No test available");
		}

		override public function reset():void {
			if( _music != null ) {
				_music.dispose();
				_music = null;
			}
		}

		private function onGet(...args):* {
			return _music;
		}

		private function createMusic():void {
			if( _music != null ) {
				_music.dispose();
				_music = null;
			}

			const url:String = _url.value as String;

			if( url == null || url == "" ) return;

			const fileending:String = url.substr( url.length-4 ).toLowerCase();

			if( fileending != ".mp3" ) {
				this.logText("Invalid file: " + url);
				_url.value = "";
				return;
			}

			const buffer:int = _buffer.value as int;

			_music = new DenomMusic( shared.fileManager.getFullURL(url), buffer > 0 ? buffer : 1000 );
		}
	}
}
