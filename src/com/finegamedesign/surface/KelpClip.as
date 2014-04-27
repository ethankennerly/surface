package com.finegamedesign.surface
{
    import flash.display.MovieClip;

    public class KelpClip extends MovieClip
    {
        internal static var instances:Array = [];

        public function KelpClip() 
        {
            instances.push(this);
        }
    }
}
