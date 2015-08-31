package com.tbbgc.denom.interfaces {
	import com.tbbgc.denom.sounds.DenomSoundTransform;
	/**
	 * @author simonrodriguez
	 */
	public interface ISound {
		function dispose():void;

		function play(loop:Boolean, transform:DenomSoundTransform):ISoundChannel;

		function get length():Number;
	}
}
