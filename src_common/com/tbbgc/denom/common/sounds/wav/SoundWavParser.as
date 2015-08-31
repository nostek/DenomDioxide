package com.tbbgc.denom.common.sounds.wav {
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	/**
	 * @author simonrodriguez
	 */
	public class SoundWavParser {
		public static function parse( ba:ByteArray ):Array {
			var info:WavHeader = WavHeader.read(ba);

			if( info == null ) {
				if( Capabilities.isDebugger ) {
					trace("INVALID WAV");
				}
				return null;
			} else {
				if( Capabilities.isDebugger ) {
					trace("Wave info", "channels", info.channels, "samplerate", info.sameplerate, "bits", info.bits, "float", info.float );
				}
			}

			var data:ByteArray = new ByteArray();

			var f:Number;
			var si:int;
			var sf:Number;
			var i:int;
			
			if( info.float ) {
				if( info.channels == 1 ) {
					for( i = 0; i < info.samples; i += info.align ) {
						sf = ba.readFloat();
	
						data.writeFloat(sf);
						data.writeFloat(sf);
					}
				} else {
					for( i = 0; i < info.samples; i += info.align ) {
						sf = ba.readFloat();
						data.writeFloat(sf);
	
						sf = ba.readFloat();
						data.writeFloat(sf);
					}
				}
			} else {
				if( info.channels == 1 ) {
					for( i = 0; i < info.samples; i += info.align ) {
						si = ba.readInt();
						f = si / int.MAX_VALUE;
	
						data.writeFloat(f);
						data.writeFloat(f);
					}
				} else {
					for( i = 0; i < info.samples; i += info.align ) {
						si = ba.readInt();
						f = si / int.MAX_VALUE;
						data.writeFloat(f);
	
						si = ba.readInt();
						f = si / int.MAX_VALUE;
						data.writeFloat(f);
					}
				}
			}

			data.position = 0;

			return [(info.samples/44.1)/info.align, data];
		}
	}
}



import flash.utils.ByteArray;
import flash.utils.Endian;
internal class WavHeader {
	static public function read( ba:ByteArray ):WavHeader {
		ba.position = 0;

		ba.endian = Endian.LITTLE_ENDIAN;

		if( ba.readUTFBytes(4) != "RIFF" ) return null;

		ba.position += 4;

		if( ba.readUTFBytes(4) != "WAVE" ) return null;
		if( ba.readUTFBytes(4) != "fmt " ) return null;

		var header_size:int = ba.readUnsignedInt();

		var info:WavHeader = new WavHeader();
		
		info.float = (ba.readUnsignedShort() == 3); header_size -= 2;
		
		info.channels = ba.readUnsignedShort(); header_size -= 2;

		info.sameplerate = ba.readUnsignedInt(); header_size -= 4;

		ba.position += 4; header_size -= 4;

		info.align = ba.readUnsignedShort(); header_size -= 2;

		info.bits = ba.readUnsignedShort(); header_size -= 2;

		ba.position += header_size;
		
		//check for padding
		var type:String;
		var size:uint;
		
		while( true ) {
			type = ba.readUTFBytes(4);
			
			if( type == "data" ) {
				info.samples = ba.readUnsignedInt();
				
				break;
			} else {
				size = ba.readUnsignedInt();
				
				ba.position += size; 
			}
		}

		return info;
	}

	public var channels:int;
	public var sameplerate:int;
	public var align:int;
	public var bits:int;
	public var samples:int;
	public var float:Boolean;
}
