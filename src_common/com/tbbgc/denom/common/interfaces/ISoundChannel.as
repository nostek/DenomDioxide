package com.tbbgc.denom.common.interfaces {
	import org.osflash.signals.OnceSignal;
	/**
	 * @author simonrodriguez
	 */
	public interface ISoundChannel {
		function stop():void;

		function get position():Number;
		function get length():Number;

		function set volume(value:Number):void;

		function set rate(rate:Number):void;

		function get onSoundComplete():OnceSignal;
	}
}
