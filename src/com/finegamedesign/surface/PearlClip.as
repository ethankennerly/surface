package com.finegamedesign.surface
{
    import flash.display.MovieClip;

    public class PearlClip extends MovieClip
    {
        internal static var instances:Array = [];

        /**
         * Add to list of pearls.
         */
        public function PearlClip() 
        {
            instances.push(this);
        }
    }
}
