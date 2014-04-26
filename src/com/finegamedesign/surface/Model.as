package com.finegamedesign.surface
{
    import flash.geom.Point;

    public class Model
    {
        internal var onContagion:Function;
        internal var onDeselect:Function;
        internal var onDie:Function;
        internal var highScore:int;
        internal var score:int;
        internal var level:int;
        internal var levelScores:Array;
        internal var diver:Point;
        internal var target:Point;
        internal var vector:Point;
        private var now:int;
        private var elapsed:Number;
        private var previousTime:int;

        public function Model()
        {
            score = 0;
            highScore = 0;
            levelScores = [];
            diver = new Point();
            target = new Point();
            vector = new Point();
        }

        internal function populate(level:int, diverX:Number, diverY:Number):void
        {
            if (null == levelScores[level]) {
                levelScores[level] = 0;
            }
            diver.x = diverX;
            diver.y = diverY;
            previousTime = -1;
            now = -1;
            elapsed = 0;
        }

        internal function strokeToward(x:Number, y:Number):void
        {
            target.x = x;
            target.y = y;
            var distance:Number = Point.distance(target, diver);
            var deadZone:Number = 32.0;
            var speed:Number = 0.1;
            if (deadZone <= distance) {
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
            return win();
        }

        internal function move():void
        {
            diver.x += vector.x * elapsed;
            diver.y += vector.y * elapsed;
            var base:Number = 32.0;
            if (0 < elapsed) {
                vector.x *= base / elapsed;
                vector.y *= base / elapsed;
            }
            var min:Number = 0.0001;
            if (Math.abs(vector.x) < min) {
                vector.x = 0;
            }
            if (Math.abs(vector.y) < min) {
                vector.y = 0;
            }
        }

        /**
         * @return  0 continue, 1: win, -1: lose.
         */
        private function win():int
        {
            var winning:int = 0;
            return winning;
        }
    }
}
