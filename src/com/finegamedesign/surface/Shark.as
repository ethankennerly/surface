package com.finegamedesign.surface
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Shark
    {
        private var speed:Number = 0.025;

        /**
         * @param shark   Expects shark faces right.
         * 14/4/27 Jaws on NES, that Isa played as kid, expects shark goes offscreen before flipping.
         */
        public function move(shark:DisplayObject, bounds:Rectangle,
                elapsed:Number):void
        {
            var body:Rectangle = shark.getBounds(shark.parent);
            if (body.right < bounds.left) {
                shark.scaleX = 1.0;
            }
            else if (bounds.right < body.left) {
                shark.scaleX = -1.0;
            }
            shark.x += speed * shark.scaleX * elapsed;
        }
    }
}
