package com.finegamedesign.surface
{
    import flash.display.MovieClip;

    public class AirPocketClip extends MovieClip
    {
        internal static var instances:Array = [];

        public function AirPocketClip() 
        {
            instances.push(this);
            gotoAndStop(1);
        }
    }
}
