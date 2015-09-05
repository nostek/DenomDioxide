package com.tbbgc.denom.common.interfaces {
	import com.tbbgc.denom.common.sounds.DenomSoundTransform;
	/**
	 * @author simonrodriguez
	 */
	public interface ISound {
		function dispose():void;

		function play(loop:Boolean, transform:DenomSoundTransform):ISoundChannel;

		function get length():Number;
	}
}
