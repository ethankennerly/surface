package com.finegamedesign.surface
{
    import flash.geom.Point;

    public class Model
    {
        internal var air:Number;
        internal var onContagion:Function;
        internal var onDeselect:Function;
        internal var onDie:Function;
        internal var highScore:int;
        internal var score:int;
        internal var level:int;
        internal var levelScores:Array;
        internal var diver:Point;
        internal var gravityVector:Number;
        internal var target:Point;
        internal var vector:Point;
        private var diverWidth:Number = 20;
        private var min:Number = 0.0001;
        private var now:int;
        private var elapsed:Number;
        private var previousTime:int;
        private var surfaceY:Number;

        public function Model()
        {
            air = 1.0;
            score = 0;
            highScore = 0;
            levelScores = [];
            diver = new Point();
            target = new Point();
            vector = new Point();
        }

        internal function populate(level:int, diverX:Number, diverY:Number, surfaceY:Number):void
        {
            if (null == levelScores[level]) {
                levelScores[level] = 0;
            }
            diver.x = diverX;
            diver.y = diverY;
            this.surfaceY = surfaceY;
            previousTime = -1;
            now = -1;
            elapsed = 0;
            air = 1.0;
        }

        internal function strokeToward(x:Number, y:Number):void
        {
            target.x = x;
            target.y = y;
            var distance:Number = Point.distance(target, diver);
            var deadZone:Number = 32.0;
            if (deadZone <= distance) {
                var speed:Number = 0.1;
                vector.x = speed * (target.x - diver.x) / distance;
                vector.y = speed * (target.y - diver.y) / distance;
                target.x = vector.x;
                target.y = vector.y;
            }
        }

        internal function clear():void
        {
        }

        internal function update(now:int):int
        {
            previousTime = 0 <= this.now ? this.now : now;
            this.now = now;
            elapsed = this.now - previousTime;
            move();
            sink();
            breathe();
            return win();
        }

        private function move():void
        {
            diver.x += vector.x * elapsed;
            diver.y += vector.y * elapsed;
            var base:Number = 32.0;
            if (0 < elapsed) {
                vector.x *= base / elapsed;
                vector.y *= base / elapsed;
            }
            if (Math.abs(vector.x) < min) {
                vector.x = 0;
            }
            if (Math.abs(vector.y) < min) {
                vector.y = 0;
            }
        }

        /**
         * If above surface, pull down.
         */
        private function sink():void
        {
            var gravity:Number = 0.0001;
            if (diver.y < surfaceY) {
                gravityVector += gravity * elapsed;
            }
            else if (surfaceY < diver.y && min < gravityVector) {
                gravityVector -= gravity * elapsed;
            }
            else {
                gravityVector = 0;
            }
            diver.y += gravityVector * elapsed;
        }

        internal function breathe():void
        {
            var exert:Number = 0.0005;
            var fast:Number = 0.08;
            var still:Point = new Point();
            if (fast <= Point.distance(vector, still)) {
                air -= exert * elapsed;
            }
            var inhale:Number = 0.0005;
            var exhale:Number = 0.00001;
            if (diver.y < surfaceY + diverWidth) {
                air += inhale * elapsed;
            }
            else {
                air -= exhale * elapsed;
            }
            air = Math.max(0.0, Math.min(1.0, air));
        }

        /**
         * @return  0 continue, 1: win, -1: lose.
         */
        private function win():int
        {
            var winning:int = 0 < air ? 0 : -1;
            return winning;
        }
    }
}
